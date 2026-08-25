-- BulakSu: Gel-Al dönüşümü
-- Siparisler tablosundan adres sütununu kaldır
-- (Artık teslimat yok, sadece Gel-Al ve Toptan)

ALTER TABLE siparisler DROP COLUMN adres;
