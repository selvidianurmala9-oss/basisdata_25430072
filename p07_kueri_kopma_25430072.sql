-- =========================================================
-- Modul 7: Menjawab Pertanyaan dengan SELECT dan Fungsi Skalar
-- Nama : Selvi Dia Nurmala
-- NIM  : 25430072
-- Kelas: C
-- Database: kopma_072
-- Asumsi data: hasil p06_data_kopma_25430072.sql (stok sudah dikurangi)
-- =========================================================

USE kopma_072;

-- 01 | KI-03: barang yang perlu dipesan ulang (stok < minimum)
-- Diharapkan: 0 baris (stok 112, 79, 21, 57 semuanya di atas minimum)
SELECT kode_barang, nama_barang, stok_barang, stok_minimum_barang,
       stok_minimum_barang - stok_barang AS kurang
FROM barang
WHERE stok_barang < stok_minimum_barang
ORDER BY kurang DESC;

-- 02 | KI-03: status stok setiap barang (CASE)
-- Diharapkan: 4 baris, semuanya 'Aman'
SELECT nama_barang, stok_barang,
       CASE WHEN stok_barang < stok_minimum_barang THEN 'Pesan ulang'
            WHEN stok_barang < 2 * stok_minimum_barang THEN 'Waspada'
            ELSE 'Aman' END AS status_stok
FROM barang
ORDER BY nama_barang;

-- 03 | KI-03 (pendukung): barang kategori ATK atau minuman (IN)
-- Diharapkan: 3 baris (ATK-001, ATK-002, MNM-001)
SELECT kode_barang, nama_barang, kategori_barang
FROM barang
WHERE kategori_barang IN ('ATK', 'minuman');

-- 04 | KI-03 (pendukung): barang berharga 4000 sampai 5000 (BETWEEN)
-- Diharapkan: 3 baris (ATK-001, MNM-001, MKN-001)
SELECT kode_barang, nama_barang, harga_jual_barang
FROM barang
WHERE harga_jual_barang BETWEEN 4000 AND 5000;

-- 05 | Daftar harga untuk label: nama huruf kapital, harga format Rp (UPPER, CONCAT, FORMAT)
-- Diharapkan: 4 baris, mis. 'PULPEN GEL 0.5' - 'Rp4.000' ... 'BUKU TULIS 58' - 'Rp6.500'
SELECT UPPER(nama_barang) AS nama,
       CONCAT('Rp', FORMAT(harga_jual_barang, 0, 'id_ID')) AS harga
FROM barang;

-- 06 | Simulasi kenaikan harga 5% dibulatkan ke ratusan (ROUND)
-- Diharapkan: 4 baris dengan harga baru 4200, 6800, 4200, 5300
SELECT nama_barang, harga_jual_barang,
       ROUND(harga_jual_barang * 1.05, -2) AS harga_baru
FROM barang;

-- 07 | KI-01 (pendukung): nota pada rentang 24-26 September 2026
-- Batas akhir memakai < '2026-09-27' karena kolom DATETIME
-- Diharapkan: 3 baris (PJ-2609-0142, 0143, 0144)
SELECT no_nota_penjualan, tgl_penjualan
FROM penjualan
WHERE tgl_penjualan >= '2026-09-24'
  AND tgl_penjualan <  '2026-09-27';

-- 08 | KI-01 (pendukung): nota tanpa anggota (IS NULL)
-- Diharapkan: 1 baris (PJ-2609-0143)
SELECT no_nota_penjualan, tgl_penjualan
FROM penjualan
WHERE id_anggota IS NULL;

-- 09 | KI-01 (pendukung): tanggal nota format Indonesia (DATE_FORMAT)
-- Diharapkan: 3 baris dengan tanggal 24-09-2026, 25-09-2026, 26-09-2026
SELECT no_nota_penjualan,
       DATE_FORMAT(tgl_penjualan, '%d-%m-%Y %H:%i') AS waktu_nota
FROM penjualan
ORDER BY tgl_penjualan;

-- 10 | KI-04 (pendukung): label anggota (CONCAT, DATE_FORMAT, IFNULL, CASE)
-- Diharapkan: 3 baris; Andi 'Diskon 5%', Budi 'Diskon 5%', Citra 'Tanpa diskon'
SELECT CONCAT(nama_anggota, ' (', no_anggota, ')') AS anggota,
       DATE_FORMAT(tgl_daftar_anggota, '%d-%m-%Y') AS tgl_daftar,
       IFNULL(no_hp_anggota, '-') AS hp,
       CASE status_anggota WHEN 'aktif' THEN 'Diskon 5%'
            ELSE 'Tanpa diskon' END AS keterangan
FROM anggota;

-- 11 | Lama keanggotaan dalam hari, kategori baru (< 180 hari) atau lama (DATEDIFF, CURDATE, CASE)
-- Diharapkan: 3 baris; Andi dan Budi 'baru', Citra 'lama' (bila dijalankan sebelum Feb 2027)
SELECT nama_anggota,
       DATEDIFF(CURDATE(), tgl_daftar_anggota) AS lama_hari,
       CASE WHEN DATEDIFF(CURDATE(), tgl_daftar_anggota) < 180
            THEN 'baru' ELSE 'lama' END AS kategori
FROM anggota;

-- 12 | KI-02/KI-01 (pendukung): subtotal per baris detail (perkalian per baris)
-- Diharapkan: 7 baris; subtotal 12000, 6500, 8000, 4000, 10000, 20000, 5000
-- Catatan: jumlah per nota/total belum bisa dengan satu tabel tanpa fungsi agregat (Pertemuan 9)
SELECT id_penjualan, id_barang,
       qty_detail_penjualan * harga_satuan_detail_penjualan AS subtotal
FROM detail_penjualan
ORDER BY id_penjualan, id_barang;

-- KI yang belum dapat dijawab dengan satu tabel (dijawab di Pertemuan 9-12):
-- KI-01 omzet per hari/bulan, KI-02 lima barang terlaris, KI-04 sepuluh anggota
-- terbesar: butuh JOIN dan fungsi agregat (SUM, GROUP BY).

-- 13 | KI-04: mencari anggota yang namanya mengandung huruf 'a' (LIKE)
-- Diharapkan: 2 baris, yaitu Andi dan Citra
SELECT no_anggota, nama_anggota
FROM anggota
WHERE nama_anggota LIKE '%a%'
ORDER BY nama_anggota;