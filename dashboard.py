import streamlit as st
import pandas as pd
import numpy as np

# Judul Dashboard
st.title("Talent Match Intelligence System")
st.write("Sistem untuk mencocokkan profil karyawan terbaik dengan kandidat lainnya.")

# 1. Sidebar: Input User
st.sidebar.header("Konfigurasi")
role_input = st.sidebar.text_input("Masukkan Posisi Pekerjaan", "Data Analyst")
benchmark_ids = st.sidebar.text_input("ID Karyawan Benchmark (pisahkan koma)", "EMP001, EMP005")

if st.sidebar.button("Cari Kandidat"):
    st.sidebar.success(f"Mencari kandidat mirip dengan benchmark: {benchmark_ids}")

# 2. Main Content: Hasil Analisis
st.header(f"Hasil Pencocokan untuk: {role_input}")

# Dummy Data (Pura-pura hasil SQL)
data = {
    'Employee ID': ['EMP101', 'EMP102', 'EMP103', 'EMP104', 'EMP105'],
    'Nama': ['Budi Santoso', 'Siti Aminah', 'Rudi Hartono', 'Dewi Lestari', 'Andi Wijaya'],
    'Match Score': [98.5, 95.2, 88.0, 85.4, 82.1],
    'Kekuatan Utama': ['Social Empathy', 'Curiosity', 'Leadership', 'Technical SQL', 'Visionary']
}
df = pd.DataFrame(data)

# Tampilkan Tabel
st.subheader("Top 5 Kandidat")
st.dataframe(df)

# Tampilkan Grafik Sederhana
st.subheader("Distribusi Skor Kandidat")
chart_data = pd.DataFrame(
    np.random.randn(20, 3),
    columns=['A', 'B', 'C'])
st.bar_chart(df.set_index('Nama')['Match Score'])

# 3. AI Job Description (Simulasi)
st.header("AI Generated Job Profile")
st.info("Berdasarkan profil benchmark, berikut kriteria ideal:")
st.markdown("""
- **Soft Skills:** High Empathy, Visionary Thinking.
- **Hard Skills:** SQL Expert, Python Intermediate.
- **Work Style:** Directive Leadership but Collaborative.
""")

