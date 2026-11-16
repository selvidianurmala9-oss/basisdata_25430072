-- =========================================================
-- Milestone Proyek 9: Laporan Ringkasan dengan Agregasi
-- Proyek   : Toko Daring Serba Digital SDN
-- Nama     : Selvi Dia Nurmala
-- NIM      : 25430072
-- Kelas    : C
-- Database : toko_072
-- Berkas   : p09_agregasi_25430072.sql
-- =========================================================
-- Catatan:
-- Omzet dihitung dari detail_pesanan (jumlah_produk *
-- harga_saat_transaksi), sesuai AB-03.
-- Ongkos kirim tidak dijumlahkan agar tidak terhitung
-- berulang saat JOIN ke detail_pesanan.
-- =========================================================

USE toko_072;

-- Aktifkan mode ketat pengelompokan untuk sesi ini
SET SESSION sql_mode = CONCAT(@@sql_mode, ',ONLY_FULL_GROUP_BY');


-- ---------------------------------------------------------
-- Laporan 1 (KI-01): Jumlah pesanan dan omzet per hari
-- Hanya pesanan berstatus Lunas.
-- WITH ROLLUP menambahkan baris total keseluruhan (tanggal NULL).
-- COUNT(DISTINCT ...) mencegah pesanan dihitung berulang
-- karena satu pesanan dapat memiliki beberapa detail produk.
--
-- Hasil diharapkan:
-- Satu baris per tanggal dan satu baris total keseluruhan.
--
-- Hasil nyata:
-- 2026-10-10: 3 pesanan, omzet Rp8.660.000.
-- 2026-10-11: 2 pesanan, omzet Rp1.145.000.
-- 2026-10-12: 3 pesanan, omzet Rp16.285.000.
-- Total (NULL): 8 pesanan, omzet Rp26.090.000.
-- ---------------------------------------------------------

SELECT
    ps.tanggal_pesanan AS tanggal,
    COUNT(DISTINCT ps.no_pesanan) AS jumlah_pesanan,
    SUM(dp.jumlah_produk * dp.harga_saat_transaksi) AS omzet
FROM pesanan AS ps
JOIN detail_pesanan AS dp
    ON dp.no_pesanan = ps.no_pesanan
JOIN pembayaran AS pb
    ON pb.no_pesanan = ps.no_pesanan
WHERE pb.status_pembayaran = 'Lunas'
GROUP BY ps.tanggal_pesanan WITH ROLLUP;


-- ---------------------------------------------------------
-- Laporan 2 (KI-02): Lima produk paling banyak terjual
-- SUM menjumlahkan jumlah_produk per produk.
-- ORDER BY DESC mengurutkan dari penjualan terbanyak.
--
-- Hasil diharapkan:
-- Maksimal 5 produk dengan total penjualan terbesar.
--
-- Hasil nyata:
-- 1. Flashdisk 64GB: 9 unit.
-- 2. Headset Bluetooth: 5 unit.
-- 3. Keyboard Mechanical: 5 unit.
-- 4. Mouse Wireless: 5 unit.
-- 5. Laptop ASUS VivoBook: 3 unit.
-- ---------------------------------------------------------

SELECT
    pr.kode_produk,
    pr.nama_produk,
    pr.kategori_produk,
    SUM(dp.jumlah_produk) AS total_terjual
FROM detail_pesanan AS dp
JOIN produk AS pr
    ON pr.kode_produk = dp.kode_produk
GROUP BY
    pr.kode_produk,
    pr.nama_produk,
    pr.kategori_produk
ORDER BY total_terjual DESC, pr.nama_produk
LIMIT 5;


-- ---------------------------------------------------------
-- Laporan 3 (KI-03): Ringkasan pesanan per status pembayaran
-- COUNT menghitung jumlah pesanan.
-- SUM menjumlahkan nilai pembayaran berdasarkan status.
--
-- Hasil diharapkan:
-- Satu baris untuk setiap status pembayaran yang tersedia.
--
-- Hasil nyata:
-- Belum Dibayar: 1 pesanan, total Rp460.000.
-- Menunggu Konfirmasi: 1 pesanan, total Rp625.000.
-- Lunas: 8 pesanan, total Rp26.225.000.
-- ---------------------------------------------------------

SELECT
    pb.status_pembayaran,
    COUNT(*) AS jumlah_pesanan,
    SUM(pb.jumlah_pembayaran) AS total_nilai
FROM pembayaran AS pb
GROUP BY pb.status_pembayaran;


-- ---------------------------------------------------------
-- Laporan 4 (KI-04): Ringkasan pesanan per status pengiriman
-- COUNT menghitung jumlah pengiriman berdasarkan status.
--
-- Hasil diharapkan:
-- Satu baris untuk setiap status pengiriman yang tersedia.
--
-- Hasil nyata:
-- Belum Dikirim: 2 pengiriman.
-- Dalam Pengiriman: 3 pengiriman.
-- Terkirim: 5 pengiriman.
-- ---------------------------------------------------------

SELECT
    pg.status_pengiriman,
    COUNT(*) AS jumlah_pengiriman
FROM pengiriman AS pg
GROUP BY pg.status_pengiriman;


-- ---------------------------------------------------------
-- Laporan 5 (KI-05): Pelanggan dengan total belanja > Rp5.000.000
-- HAVING digunakan karena syaratnya berasal dari hasil SUM
-- setelah proses pengelompokan.
-- COUNT, MIN, dan MAX melengkapi ringkasan pelanggan.
--
-- Hasil diharapkan:
-- Hanya pelanggan dengan total belanja lebih dari Rp5.000.000.
--
-- Hasil nyata:
-- 1. Citra Amelia: 2 pesanan, Rp8.500.000.
-- 2. Eka Putri: 2 pesanan, Rp8.455.000.
-- 3. Bunga Lestari: 2 pesanan, Rp8.210.000.
-- ---------------------------------------------------------

SELECT
    pl.id_pelanggan,
    pl.nama_pelanggan,
    COUNT(DISTINCT ps.no_pesanan) AS jumlah_pesanan,
    SUM(dp.jumlah_produk * dp.harga_saat_transaksi) AS total_belanja,
    MIN(ps.tanggal_pesanan) AS pesanan_pertama,
    MAX(ps.tanggal_pesanan) AS pesanan_terakhir
FROM pelanggan AS pl
JOIN pesanan AS ps
    ON ps.id_pelanggan = pl.id_pelanggan
JOIN detail_pesanan AS dp
    ON dp.no_pesanan = ps.no_pesanan
GROUP BY
    pl.id_pelanggan,
    pl.nama_pelanggan
HAVING SUM(dp.jumlah_produk * dp.harga_saat_transaksi) > 5000000
ORDER BY total_belanja DESC;


-- =========================================================
-- AKHIR MILESTONE PROYEK 9
-- =========================================================