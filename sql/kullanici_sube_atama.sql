-- Kullanıcılara şube ataması için sube_id kolonu ekleme
-- Admin kullanıcılar için NULL olabilir (tüm şubeleri görür)
-- MUSTERI kullanıcılar için bir şube atanmalıdır

ALTER TABLE kullanicilar ADD COLUMN sube_id INT NULL;

ALTER TABLE kullanicilar ADD CONSTRAINT fk_kullanici_sube 
    FOREIGN KEY (sube_id) REFERENCES subeler(sube_id) ON DELETE SET NULL;
