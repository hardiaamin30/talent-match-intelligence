# talent-match-intelligence

# Talent Match Intelligence System 

Repository ini berisi solusi teknis untuk studi kasus **Talent Match Intelligence**. Proyek ini bertujuan untuk membantu perusahaan mengidentifikasi pola sukses karyawan berkinerja tinggi (*High Performers*) dan membangun sistem algoritma untuk menemukan kandidat suksesor yang paling cocok secara data.

## Tujuan Proyek
1.  **Menemukan Pola Sukses:** Menganalisis data karyawan untuk mengetahui faktor penentu kinerja tinggi (Rating 5).
2.  **Membangun Algoritma Pencocokan:** Membuat logika SQL dinamis untuk meranking kandidat berdasarkan kemiripan dengan *benchmark*.
3.  **Visualisasi:** Merancang konsep dashboard untuk HR.

## Isi Repository

* **`matching_logic.sql`**:
    Script SQL utama yang berisi algoritma pencocokan karyawan. Menggunakan metode *Dynamic Benchmarking* dengan CTE untuk membandingkan kandidat terhadap profil karyawan teladan.

* **`Case_Study_Report.pdf`**:
    Laporan lengkap yang mencakup:
    1.  Analisis pola sukses (*Success Formula*).
    2.  Penjelasan logika SQL.
    3.  Desain konsep Dashboard AI.

* **`dashboard.py`** *(Optional)*:
    Source code untuk prototipe dashboard interaktif menggunakan Streamlit.

## Methodology

### 1. Success Formula Discovery
Berdasarkan analisis data, ditemukan bahwa *High Performer* (Rating 5) memiliki karakteristik unik yang berbeda dari karyawan biasa:
* **High Social Empathy (SEA):** Kemampuan memahami dinamika tim.
* **High Curiosity (CEX):** Dorongan kuat untuk belajar hal baru.
* **Directive Leadership Style (Papi P):** Keinginan memimpin yang kuat.

> **Rumus Sukses:** (40% Empati) + (30% Keingintahuan) + (20% Kepemimpinan) + (10% Visi)

### 2. Matching Algorithm (SQL Logic)
Algoritma SQL dirancang untuk menghitung `final_match_rate` (0-100%) dengan membandingkan selisih skor kandidat terhadap nilai median dari *Benchmark Employees* yang dipilih user.

---
*Submission for Data Analyst Case Study - Abdul Hardia Amin*
