PRAGMA foreign_keys = ON;

-- 1. Tabel users
CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    telegram_id INTEGER UNIQUE,
    email TEXT UNIQUE,
    nama TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2. Tabel profiles
CREATE TABLE IF NOT EXISTS profiles (
    user_id INTEGER PRIMARY KEY,
    ipk REAL CHECK (ipk >= 0.0 AND ipk <= 4.0),
    jurusan TEXT,
    semester INTEGER CHECK (semester >= 1 AND semester <= 14),
    usia INTEGER CHECK (usia >= 15 AND usia <= 60),
    preferensi_uang_saku BOOLEAN DEFAULT 0,
    preferensi_asrama BOOLEAN DEFAULT 0,
    preferensi_lokasi TEXT,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 3. Tabel documents
CREATE TABLE IF NOT EXISTS documents (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nama TEXT NOT NULL UNIQUE,
    kategori TEXT NOT NULL,
    deskripsi TEXT
);

-- 4. Tabel user_documents
CREATE TABLE IF NOT EXISTS user_documents (
    user_id INTEGER NOT NULL,
    document_id INTEGER NOT NULL,
    dimiliki BOOLEAN NOT NULL DEFAULT 0,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, document_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (document_id) REFERENCES documents(id) ON DELETE CASCADE
);

-- 5. Tabel user_custom_documents
CREATE TABLE IF NOT EXISTS user_custom_documents (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    nama_dokumen TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 6. Tabel scholarships
CREATE TABLE IF NOT EXISTS scholarships (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nama TEXT NOT NULL,
    penyelenggara TEXT NOT NULL,
    deskripsi TEXT,
    min_ipk REAL DEFAULT 0.0,
    jurusan_allowed TEXT,
    semester_min INTEGER DEFAULT 1,
    semester_max INTEGER DEFAULT 8,
    max_usia INTEGER DEFAULT 35,
    deadline DATE NOT NULL,
    sumber_url TEXT,
    benefit_uang_saku BOOLEAN DEFAULT 0,
    benefit_asrama BOOLEAN DEFAULT 0,
    benefit_lokasi TEXT,
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'closed', 'draft')),
    konten_hash TEXT,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 7. Tabel scholarship_documents
CREATE TABLE IF NOT EXISTS scholarship_documents (
    scholarship_id INTEGER NOT NULL,
    document_id INTEGER NOT NULL,
    wajib BOOLEAN DEFAULT 1,
    PRIMARY KEY (scholarship_id, document_id),
    FOREIGN KEY (scholarship_id) REFERENCES scholarships(id) ON DELETE CASCADE,
    FOREIGN KEY (document_id) REFERENCES documents(id) ON DELETE CASCADE
);

-- 8. Tabel applications
CREATE TABLE IF NOT EXISTS applications (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    scholarship_id INTEGER NOT NULL,
    status TEXT DEFAULT 'tertarik' CHECK (status IN ('tertarik', 'menyiapkan_berkas', 'sudah_submit', 'lolos', 'gagal')),
    catatan TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (user_id, scholarship_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (scholarship_id) REFERENCES scholarships(id) ON DELETE CASCADE
);

-- 9. Tabel reminders
CREATE TABLE IF NOT EXISTS reminders (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    scholarship_id INTEGER NOT NULL,
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'paused', 'completed')),
    last_sent_at DATETIME,
    send_count INTEGER DEFAULT 0,
    h24_sent BOOLEAN DEFAULT 0,
    penutupan_sent BOOLEAN DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (user_id, scholarship_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (scholarship_id) REFERENCES scholarships(id) ON DELETE CASCADE
);

-- 10. Tabel notifications_log
CREATE TABLE IF NOT EXISTS notifications_log (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    scholarship_id INTEGER,
    tipe TEXT NOT NULL,
    judul TEXT NOT NULL,
    pesan TEXT NOT NULL,
    kanal TEXT DEFAULT 'telegram' CHECK (kanal IN ('telegram', 'web')),
    sent_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (scholarship_id) REFERENCES scholarships(id) ON DELETE SET NULL
);

-- 11. Tabel policy_changes
CREATE TABLE IF NOT EXISTS policy_changes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    scholarship_id INTEGER NOT NULL,
    ringkasan TEXT NOT NULL,
    konten_lama TEXT,
    konten_baru TEXT,
    sumber TEXT,
    detected_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    verified BOOLEAN DEFAULT 0,
    FOREIGN KEY (scholarship_id) REFERENCES scholarships(id) ON DELETE CASCADE
);

-- Index untuk performa
CREATE INDEX IF NOT EXISTS idx_users_telegram ON users(telegram_id);
CREATE INDEX IF NOT EXISTS idx_scholarships_status_deadline ON scholarships(status, deadline);
CREATE INDEX IF NOT EXISTS idx_scholarships_ipk ON scholarships(min_ipk);
CREATE INDEX IF NOT EXISTS idx_reminders_status ON reminders(status, h24_sent);
CREATE INDEX IF NOT EXISTS idx_applications_user ON applications(user_id, status);
CREATE INDEX IF NOT EXISTS idx_user_documents_user ON user_documents(user_id, dimiliki);
CREATE INDEX IF NOT EXISTS idx_notifications_user_time ON notifications_log(user_id, sent_at);
CREATE INDEX IF NOT EXISTS idx_policy_changes_sch ON policy_changes(scholarship_id, detected_at);
CREATE INDEX IF NOT EXISTS idx_sch_docs_req ON scholarship_documents(scholarship_id, wajib);
