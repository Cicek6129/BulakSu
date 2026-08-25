-- =====================================================
-- BulakSu - Admin Kullanıcı Tablosu
-- =====================================================

CREATE TABLE IF NOT EXISTS admin_kullanici (
    id INT AUTO_INCREMENT PRIMARY KEY,
    kullanici_adi VARCHAR(50) NOT NULL UNIQUE,
    sifre_hash VARCHAR(255) NOT NULL,
    ad_soyad VARCHAR(100),
    aktif BOOLEAN DEFAULT TRUE,
    olusturma_tarihi TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Varsayılan admin kullanıcısı
-- Kullanıcı adı: admin
-- Şifre: admin123
INSERT INTO admin_kullanici (kullanici_adi, sifre_hash, ad_soyad, aktif)
VALUES ('admin', SHA2('admin123', 256), 'Sistem Yöneticisi', true)
ON DUPLICATE KEY UPDATE kullanici_adi = kullanici_adi;
