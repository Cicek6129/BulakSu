-- Siparisler tablosundan gereksiz sütunları kaldır
-- Bu sütunlar artık kullanılmıyor:
-- musteri_ad, musteri_telefon: müşteri bilgileri gerekli değil
-- siparis_tipi: zaten siparis_detaylari tablosunda mevcut
-- kullanici_id: kullanıcı-sipariş ilişkisi kaldırıldı

-- Önce foreign key constraint'i kaldır (varsa)
-- Constraint adını öğrenmek için: SHOW CREATE TABLE siparisler;
-- ALTER TABLE siparisler DROP FOREIGN KEY fk_siparis_kullanici;

SET SQL_SAFE_UPDATES = 0;

ALTER TABLE siparisler
    DROP COLUMN musteri_ad,
    DROP COLUMN musteri_telefon,
    DROP COLUMN siparis_tipi,
    DROP COLUMN kullanici_id;

SET SQL_SAFE_UPDATES = 1;
