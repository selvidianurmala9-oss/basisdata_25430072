-- =====================================================
-- INSTALL UTS BASIS DATA
-- Nama     : Selvi Dia Nurmala
-- NIM      : 25430072
-- Kelas    : C
-- Proyek   : Toko Daring Serba Digital
-- Database : toko_072_uji
-- =====================================================
-- install_uts_25430072.sql (dijalankan dari folder repositori)
-- Perintah: mysql -u root -p < install_uts_25430072.sql

-- 1. Membuat database pengujian
DROP DATABASE IF EXISTS toko_072_uji;

CREATE DATABASE toko_072_uji
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE toko_072_uji;

-- 2. Membuat struktur tabel
SOURCE p05_ddl_25430072.sql;

-- 3. Memasukkan data
SOURCE p06_data_25430072.sql;

-- 4. Verifikasi tabel (diharapkan 9 tabel)
SHOW TABLES;

-- 5. Verifikasi jumlah data (diharapkan 5, 5, 5, 5, 10, 10, 20, 10, 10)
SELECT 'pelanggan' AS nama_tabel, COUNT(*) AS jumlah_data FROM pelanggan
UNION ALL
SELECT 'produk', COUNT(*) FROM produk
UNION ALL
SELECT 'admin', COUNT(*) FROM admin
UNION ALL
SELECT 'keranjang', COUNT(*) FROM keranjang
UNION ALL
SELECT 'detail_keranjang', COUNT(*) FROM detail_keranjang
UNION ALL
SELECT 'pesanan', COUNT(*) FROM pesanan
UNION ALL
SELECT 'detail_pesanan', COUNT(*) FROM detail_pesanan
UNION ALL
SELECT 'pembayaran', COUNT(*) FROM pembayaran
UNION ALL
SELECT 'pengiriman', COUNT(*) FROM pengiriman;