-- ================================================================
-- TALENT MATCH INTELLIGENCE ALGORITHM
-- Case Study: Company X
-- Objective: Find successors matching the High Performer profile
-- ================================================================

-- LANGKAH 1: Siapkan Data Setiap Karyawan (Data Prep CTE)
-- Menggabungkan data dari berbagai tabel menjadi satu baris per karyawan
WITH employee_features AS (
    SELECT
        e.employee_id,
        e.fullname,
        p.name as role,
        
        -- A. Kompetensi (Ambil tahun terbaru 2025)
        -- Kita ambil skor SEA (Social Empathy) dan CEX (Curiosity)
        MAX(CASE WHEN c.pillar_code = 'SEA' THEN c.score ELSE 0 END) as score_sea,
        MAX(CASE WHEN c.pillar_code = 'CEX' THEN c.score ELSE 0 END) as score_cex,
        
        -- B. PAPI Kostick (Gaya Kerja)
        -- Kita ambil skor P (Need for Control / Directive Leadership)
        MAX(CASE WHEN ps.scale_code = 'Papi_P' THEN ps.score ELSE 0 END) as score_papi_p,
        
        -- C. Strengths (Kekuatan Visioner)
        -- Cek apakah karyawan punya 'Futuristic' atau 'Strategic' di Top 5 bakatnya
        -- Output: 1 jika punya, 0 jika tidak
        MAX(CASE 
            WHEN s.theme IN ('Futuristic', 'Strategic') AND s.rank <= 5 THEN 1 
            ELSE 0 
        END) as has_visionary_trait

    FROM employees e
    LEFT JOIN dim_positions p ON e.position_id = p.position_id
    LEFT JOIN competencies_yearly c ON e.employee_id = c.employee_id AND c.year = 2025
    LEFT JOIN papi_scores ps ON e.employee_id = ps.employee_id
    LEFT JOIN strengths s ON e.employee_id = s.employee_id
    GROUP BY e.employee_id, e.fullname, p.name
),

-- LANGKAH 2: Tentukan Benchmark (Standar Karyawan Terbaik)
-- Ini mensimulasikan input User. Misal User memilih 3 karyawan terbaik sebagai acuan.
benchmark_stats AS (
    SELECT
        -- Menggunakan MEDIAN agar tidak bias oleh outlier
        PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY score_sea) as base_sea,
        PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY score_cex) as base_cex,
        PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY score_papi_p) as base_papi_p,
        -- Jika salah satu benchmark punya visi, maka visi jadi syarat (Max = 1)
        MAX(has_visionary_trait) as base_visionary
    FROM employee_features
    WHERE employee_id IN ('EMP101148', 'EMP100050', 'EMP101479') -- [INPUT]: ID ini diganti sesuai pilihan User
),

-- LANGKAH 3: Hitung Skor Kecocokan (Match Calculation)
match_calculation AS (
    SELECT
        e.employee_id,
        e.fullname,
        e.role,

        -- Rumus Match Rate untuk Angka (Numeric):
        -- 100% dikurangi persentase selisih dari benchmark.
        -- Contoh: Benchmark 4, Siswa 3. Selisih 1. (1/4) = 25%. Match = 75%.
        GREATEST(0, 100 - (ABS(e.score_sea - b.base_sea)::DECIMAL / NULLIF(b.base_sea, 0) * 100)) as match_sea,
        GREATEST(0, 100 - (ABS(e.score_cex - b.base_cex)::DECIMAL / NULLIF(b.base_cex, 0) * 100)) as match_cex,
        GREATEST(0, 100 - (ABS(e.score_papi_p - b.base_papi_p)::DECIMAL / NULLIF(b.base_papi_p, 0) * 100)) as match_papi,

        -- Rumus Match Rate untuk Kategori (Boolean):
        -- Jika Benchmark butuh Visi (1) dan Karyawan punya (1) -> 100%
        -- Jika Benchmark butuh Visi (1) tapi Karyawan tidak punya (0) -> 0%
        CASE
            WHEN b.base_visionary = 1 AND e.has_visionary_trait = 1 THEN 100
            WHEN b.base_visionary = 1 AND e.has_visionary_trait = 0 THEN 0
            ELSE 100 -- Jika benchmark tidak mewajibkan, semua dianggap cocok
        END as match_visionary

    FROM employee_features e
    CROSS JOIN benchmark_stats b
)

-- LANGKAH 4: Skor Akhir (Final Weighted Score)
SELECT
    employee_id,
    fullname,
    role,
    -- Penerapan Rumus Sukses (Success Formula)
    ROUND(
        (match_sea * 0.40) +      -- 40% Bobot untuk Empati (Paling Penting)
        (match_cex * 0.30) +      -- 30% Bobot untuk Keingintahuan
        (match_papi * 0.20) +     -- 20% Bobot untuk Leadership
        (match_visionary * 0.10)  -- 10% Bobot untuk Visi
    , 1) as final_match_rate
FROM match_calculation
ORDER BY final_match_rate DESC
LIMIT 10;