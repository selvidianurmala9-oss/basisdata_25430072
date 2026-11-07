-- =====================================================
-- PROYEK TOKO DARING SERBA DIGITAL SDN
-- MODUL 7: MILESTONE PROYEK 7 (SELECT DAN FUNGSI SKALAR)
-- Nama  : Selvi Dia Nurmala
-- NIM   : 25430072
-- Kelas : C
-- Database: toko_072
-- =====================================================

USE toko_072;

-- 01 | KI-03 (sebagian): pembayaran yang belum lunas (IN)
-- Diharapkan: 2 baris
--   PSN-P06-0005 | Menunggu Konfirmasi | 625000
--   PSN-P06-0009 | Belum Dibayar       | 460000
SELECT no_pesanan, status_pembayaran, jumlah_pembayaran
FROM pembayaran
WHERE status_pembayaran IN ('Belum Dibayar', 'Menunggu Konfirmasi')
ORDER BY no_pesanan;

-- 02 | KI-04 (sebagian): pengiriman yang belum punya nomor resi (IS NULL)
-- Diharapkan: 2 baris
--   KRM-P06-05 | PSN-P06-0005 | Belum Dikirim
--   KRM-P06-09 | PSN-P06-0009 | Belum Dikirim
SELECT id_pengiriman, no_pesanan, status_pengiriman
FROM pengiriman
WHERE nomor_resi IS NULL
ORDER BY id_pengiriman;

-- 03 | KI-04 (sebagian): status pengiriman dalam bahasa sehari-hari (CASE)
-- Diharapkan: 10 baris
--   Terkirim -> 'Selesai' (KRM-01, 02, 04, 07, 08 = 5 baris)
--   Dalam Pengiriman -> 'Sedang di jalan' (KRM-03, 06, 10 = 3 baris)
--   Belum Dikirim -> 'Menunggu dikirim' (KRM-05, 09 = 2 baris)
SELECT id_pengiriman, no_pesanan, status_pengiriman,
       CASE status_pengiriman
            WHEN 'Terkirim' THEN 'Selesai'
            WHEN 'Dalam Pengiriman' THEN 'Sedang di jalan'
            ELSE 'Menunggu dikirim' END AS keterangan
FROM pengiriman
ORDER BY id_pengiriman;

-- 04 | KI-01 (pendukung): pesanan tanggal 10 sampai 11 Oktober 2026 (BETWEEN)
-- tanggal_pesanan bertipe DATE, jadi batas akhir aman tanpa jam
-- Diharapkan: 6 baris (PSN-P06-0001 sampai 0006)
--   0001, 0002, 0003 tanggal 2026-10-10; 0004, 0005, 0006 tanggal 2026-10-11
SELECT no_pesanan, tanggal_pesanan, id_pelanggan
FROM pesanan
WHERE tanggal_pesanan BETWEEN '2026-10-10' AND '2026-10-11'
ORDER BY no_pesanan;

-- 05 | KI-01 (pendukung): pesanan 12 Oktober, tanggal format Indonesia (DATE_FORMAT)
-- Diharapkan: 4 baris, tanggal tampil 12-10-2026
--   PSN-P06-0007 | 15000.00
--   PSN-P06-0008 | 20000.00
--   PSN-P06-0009 | 15000.00
--   PSN-P06-0010 | 20000.00
SELECT no_pesanan,
       DATE_FORMAT(tanggal_pesanan, '%d-%m-%Y') AS tgl_pesanan,
       ongkos_kirim
FROM pesanan
WHERE tanggal_pesanan = '2026-10-12'
ORDER BY no_pesanan;

-- 06 | KI-05 (pendukung): mencari pelanggan yang namanya mengandung 'pu' (LIKE, UPPER, CONCAT, IFNULL)
-- Diharapkan: 2 baris
--   PLG-P06-01 | ANDI SAPUTRA | Telp: 081234567801
--   PLG-P06-05 | EKA PUTRI    | Telp: 081234567805
SELECT id_pelanggan,
       UPPER(nama_pelanggan) AS nama,
       CONCAT('Telp: ', IFNULL(no_hp_pelanggan, '-')) AS kontak
FROM pelanggan
WHERE nama_pelanggan LIKE '%pu%'
ORDER BY id_pelanggan;

-- 07 | KI-02 (pendukung): tiga produk Elektronik/Aksesoris termahal (IN, ORDER BY, LIMIT, FORMAT)
-- Diharapkan: 3 baris
--   Laptop ASUS VivoBook | Rp7.500.000
--   Keyboard Mechanical  | Rp350.000
--   Headset Bluetooth    | Rp275.000
SELECT nama_produk,
       CONCAT('Rp', FORMAT(harga_produk, 0, 'id_ID')) AS harga
FROM produk
WHERE kategori_produk IN ('Elektronik', 'Aksesoris')
ORDER BY harga_produk DESC
LIMIT 3;

-- 08 | KI-01 (pendukung): subtotal per baris pesanan PSN-P06-0001 (perkalian per baris)
-- Diharapkan: 2 baris
--   PRD-P06-02 | 2 | 150000.00 | 300000.00
--   PRD-P06-05 | 1 |  85000.00 |  85000.00
-- (jumlah manual 385000; total per pesanan butuh SUM, belum dipelajari)
SELECT kode_produk, jumlah_produk, harga_saat_transaksi,
       jumlah_produk * harga_saat_transaksi AS subtotal
FROM detail_pesanan
WHERE no_pesanan = 'PSN-P06-0001'
ORDER BY kode_produk;

-- 09 | KI-05 (pendukung): riwayat pesanan pelanggan PLG-P06-01
-- Diharapkan: 2 baris
--   PSN-P06-0001 | 2026-10-10 | 15000.00
--   PSN-P06-0006 | 2026-10-11 | 15000.00
SELECT no_pesanan, tanggal_pesanan, ongkos_kirim
FROM pesanan
WHERE id_pelanggan = 'PLG-P06-01'
ORDER BY tanggal_pesanan;

-- 10 | KI-01 (pendukung): pembayaran lunas bernilai di atas Rp1.000.000
-- Diharapkan: 3 baris, urut dari terbesar
--   PSN-P06-0010 | 7870000.00
--   PSN-P06-0003 | 7670000.00
--   PSN-P06-0007 | 7600000.00
SELECT no_pesanan, jumlah_pembayaran
FROM pembayaran
WHERE status_pembayaran = 'Lunas'
  AND jumlah_pembayaran >= 1000000
ORDER BY jumlah_pembayaran DESC;

-- =====================================================
-- KI yang belum dapat dijawab penuh dengan satu tabel
-- (akan dijawab di Pertemuan 9-12):
-- KI-01 nilai penjualan per hari/bulan : butuh JOIN pesanan-detail_pesanan dan SUM/GROUP BY
-- KI-02 produk paling banyak terjual   : butuh JOIN produk-detail_pesanan dan SUM/GROUP BY
-- KI-03 daftar pesanan belum dibayar   : butuh JOIN pesanan-pembayaran agar data pesanan ikut tampil
-- KI-04 status pengiriman per pesanan  : butuh JOIN pesanan-pengiriman agar data pesanan ikut tampil
-- KI-05 riwayat pembelian pelanggan    : butuh JOIN pelanggan-pesanan-detail_pesanan
-- =====================================================