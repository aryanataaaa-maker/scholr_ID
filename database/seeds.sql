INSERT OR IGNORE INTO documents (id, nama, kategori, deskripsi) VALUES
(1, 'KTP', 'Identitas', 'Kartu Tanda Penduduk'),
(2, 'Transkrip Nilai', 'Akademik', 'Transkrip nilai terakhir'),
(3, 'Ijazah/SKL', 'Akademik', 'Ijazah atau Surat Keterangan Lulus'),
(4, 'Sertifikat Bahasa', 'Akademik', 'TOEFL/IELTS/TOEIC'),
(5, 'Surat Rekomendasi', 'Akademik', 'Surat rekomendasi dari dosen/kampus'),
(6, 'SKTM', 'Finansial', 'Surat Keterangan Tidak Mampu'),
(7, 'Essay Motivasi', 'Prestasi', 'Esai motivasi pendaftaran'),
(8, 'Portofolio Prestasi', 'Prestasi', 'Sertifikat lomba & penghargaan');

INSERT OR IGNORE INTO scholarships 
(id, nama, penyelenggara, deskripsi, min_ipk, jurusan_allowed, semester_min, semester_max, max_usia, deadline, benefit_uang_saku, benefit_asrama, benefit_lokasi, status)
VALUES
(1, 'Dummy Test Beasiswa', 'Scholr Test', 'Beasiswa testing Hari 1', 3.0, 'ALL', 1, 8, 25, '2026-12-31', 1, 0, 'Dalam Negeri', 'active');
