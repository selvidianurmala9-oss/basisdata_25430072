-- =========================================================
-- Milestone Proyek 10: Kueri Relasional dengan JOIN
-- Proyek   : Toko Daring Serba Digital SDN
--
-- Nama     : Selvi Dia Nurmala
-- NIM      : 25430072
-- Kelas    : C
-- Database : toko_072
-- Berkas   : p10_join_25430072.sql
-- =========================================================

USE toko_072;

SET SESSION sql_mode =
CONCAT(@@sql_mode, ',ONLY_FULL_GROUP_BY');


-- =========================================================
-- KUERI 1: INNER JOIN (3 tabel)
-- Nilai Pesanan beserta Nama Pelanggan
--
-- Jalur ERD:
-- pelanggan -> pesanan -> detail_pesanan
--
-- Tujuan:
-- Menampilkan nilai setiap pesanan dan pelanggan yang
-- membuatnya.
--
-- Hasil pengujian:
-- (isi setelah dijalankan)
-- =========================================================

SELECT
    ps.no_pesanan,
    ps.tanggal_pesanan,
    pl.nama_pelanggan,
    SUM(
        dp.jumlah_produk *
        dp.harga_saat_transaksi
    ) AS nilai_pesanan
FROM pesanan ps
INNER JOIN pelanggan pl
    ON pl.id_pelanggan = ps.id_pelanggan
INNER JOIN detail_pesanan dp
    ON dp.no_pesanan = ps.no_pesanan
GROUP BY
    ps.no_pesanan,
    ps.tanggal_pesanan,
    pl.nama_pelanggan
ORDER BY ps.tanggal_pesanan, ps.no_pesanan;


-- =========================================================
-- KUERI 2: JOIN dengan Agregasi (4 tabel)
-- Omzet per Kategori Produk (Pesanan Lunas)
--
-- Jalur ERD:
-- produk -> detail_pesanan -> pesanan -> pembayaran
--
-- Tujuan:
-- Menampilkan jumlah pesanan dan omzet setiap kategori
-- produk, hanya untuk pesanan berstatus Lunas.
--
-- Hasil pengujian:
-- (isi setelah dijalankan)
-- =========================================================

SELECT
    pr.kategori_produk,
    COUNT(DISTINCT ps.no_pesanan) AS jumlah_pesanan,
    SUM(
        dp.jumlah_produk *
        dp.harga_saat_transaksi
    ) AS omzet
FROM produk pr
INNER JOIN detail_pesanan dp
    ON dp.kode_produk = pr.kode_produk
INNER JOIN pesanan ps
    ON ps.no_pesanan = dp.no_pesanan
INNER JOIN pembayaran pb
    ON pb.no_pesanan = ps.no_pesanan
WHERE pb.status_pembayaran = 'Lunas'
GROUP BY pr.kategori_produk
ORDER BY omzet DESC;


-- =========================================================
-- KUERI 3: LEFT JOIN (Data Tanpa Pasangan)
-- Produk yang Belum Pernah Dipesan
--
-- Jalur ERD:
-- produk -> detail_pesanan
--
-- Tujuan:
-- Menemukan produk yang belum tercatat pada detail pesanan.
--
-- Hasil pengujian:
-- (isi setelah dijalankan; Empty set berarti semua produk
-- sudah pernah dipesan)
-- =========================================================

SELECT
    pr.kode_produk,
    pr.nama_produk,
    pr.stok_produk
FROM produk pr
LEFT JOIN detail_pesanan dp
    ON dp.kode_produk = pr.kode_produk
WHERE dp.kode_produk IS NULL;


-- =========================================================
-- KUERI 4: LEFT JOIN (Data Tanpa Pasangan)
-- Pelanggan yang Belum Pernah Memesan
--
-- Jalur ERD:
-- pelanggan -> pesanan
--
-- Tujuan:
-- Menemukan pelanggan yang belum memiliki pesanan.
--
-- Hasil pengujian:
-- (isi setelah dijalankan; Empty set berarti semua pelanggan
-- sudah pernah memesan)
-- =========================================================

SELECT
    pl.id_pelanggan,
    pl.nama_pelanggan,
    pl.email_pelanggan
FROM pelanggan pl
LEFT JOIN pesanan ps
    ON ps.id_pelanggan = pl.id_pelanggan
WHERE ps.no_pesanan IS NULL;


-- =========================================================
-- KUERI 5: JOIN Empat Tabel
-- Pesanan Lunas yang Belum Terkirim
--
-- Jalur ERD:
-- pelanggan -> pesanan
-- pesanan -> pembayaran
-- pesanan -> pengiriman
--
-- Tujuan:
-- Menampilkan pesanan yang sudah lunas tetapi pengirimannya
-- belum berstatus Terkirim.
--
-- Hasil pengujian:
-- (isi setelah dijalankan)
-- =========================================================

SELECT
    ps.no_pesanan,
    pl.nama_pelanggan,
    pb.status_pembayaran,
    pg.status_pengiriman,
    pb.jumlah_pembayaran
FROM pesanan ps
INNER JOIN pelanggan pl
    ON pl.id_pelanggan = ps.id_pelanggan
INNER JOIN pembayaran pb
    ON pb.no_pesanan = ps.no_pesanan
INNER JOIN pengiriman pg
    ON pg.no_pesanan = ps.no_pesanan
WHERE pb.status_pembayaran = 'Lunas'
  AND pg.status_pengiriman <> 'Terkirim'
ORDER BY ps.tanggal_pesanan, ps.no_pesanan;


-- =========================================================
-- AKHIR MILESTONE PROYEK 10
-- =========================================================