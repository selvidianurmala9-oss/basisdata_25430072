-- =========================================================
-- Modul 9: Meringkas Data dengan Fungsi Agregat dan GROUP BY
-- Nama     : Selvi Dia Nurmala
-- NIM      : 25430072
-- Kelas    : C
-- Database : kopma_072
-- Berkas   : p09_agregasi_kopma_25430072.sql
-- =========================================================
--
-- Catatan:
-- Query disesuaikan dengan struktur database Kopma.
-- Data yang digunakan merupakan data sampel yang tersedia
-- pada database kopma_072 (kopma_data_lanjutan.sql belum
-- tersedia saat pengerjaan).
-- Hasil ditulis berdasarkan data yang benar-benar diuji.
-- =========================================================

USE kopma_072;

-- Aktifkan mode ketat pengelompokan.
SET SESSION sql_mode = CONCAT(@@sql_mode, ',ONLY_FULL_GROUP_BY');


-- ---------------------------------------------------------
-- D.1: Verifikasi data transaksi
-- KI-01: Mengetahui jumlah nota dan rentang tanggal transaksi.
-- COUNT menghitung jumlah nota.
-- MIN mencari tanggal transaksi paling awal.
-- MAX mencari tanggal transaksi paling akhir.
--
-- Hasil nyata:
-- 3 nota, transaksi awal 24 September 2026,
-- transaksi akhir 26 September 2026.
-- ---------------------------------------------------------
SELECT
    COUNT(*) AS total_nota,
    MIN(tgl_penjualan) AS transaksi_awal,
    MAX(tgl_penjualan) AS transaksi_akhir
FROM penjualan;


-- ---------------------------------------------------------
-- D.2: Total satu nota
-- KI-01: Menghitung total belanja berdasarkan satu nota.
-- SUM menjumlahkan subtotal setiap barang pada nota.
--
-- Nota yang digunakan: PJ-2609-0142.
-- Hasil nyata: subtotal Rp26.500.
-- ---------------------------------------------------------
SELECT
    p.no_nota_penjualan,
    SUM(
        d.qty_detail_penjualan *
        d.harga_satuan_detail_penjualan
    ) AS total_nota
FROM penjualan AS p
JOIN detail_penjualan AS d
    ON d.id_penjualan = p.id_penjualan
WHERE p.no_nota_penjualan = 'PJ-2609-0142'
GROUP BY
    p.id_penjualan,
    p.no_nota_penjualan;


-- ---------------------------------------------------------
-- D.3: KI-01 - Omzet harian
-- COUNT(DISTINCT ...) menghitung nota tanpa pengulangan.
-- SUM menghitung omzet berdasarkan harga saat transaksi.
-- WITH ROLLUP menambahkan baris total periode.
--
-- Rentang tanggal disesuaikan dengan data yang tersedia.
--
-- Hasil nyata:
-- 2026-09-24: 1 nota, omzet Rp26.500.
-- 2026-09-25: 1 nota, omzet Rp14.000.
-- 2026-09-26: 1 nota, omzet Rp25.000.
-- Total (NULL): 3 nota, omzet Rp65.500.
-- ---------------------------------------------------------
SELECT
    DATE(p.tgl_penjualan) AS tanggal,
    COUNT(DISTINCT p.id_penjualan) AS jumlah_nota,
    SUM(
        d.qty_detail_penjualan *
        d.harga_satuan_detail_penjualan
    ) AS omzet
FROM penjualan AS p
JOIN detail_penjualan AS d
    ON d.id_penjualan = p.id_penjualan
WHERE p.tgl_penjualan >= '2026-09-24'
  AND p.tgl_penjualan < '2026-09-27'
GROUP BY DATE(p.tgl_penjualan) WITH ROLLUP;


-- ---------------------------------------------------------
-- D.3: KI-01 - Omzet bulanan
-- DATE_FORMAT mengelompokkan transaksi berdasarkan bulan.
-- COUNT(DISTINCT ...) menghitung jumlah nota per bulan.
-- SUM menghitung omzet bulanan.
--
-- Hasil nyata:
-- 2026-09: 3 nota, omzet Rp65.500.
-- Tidak ada transaksi pada Oktober 2026 di data yang digunakan.
-- ---------------------------------------------------------
SELECT
    DATE_FORMAT(p.tgl_penjualan, '%Y-%m') AS bulan,
    COUNT(DISTINCT p.id_penjualan) AS jumlah_nota,
    SUM(
        d.qty_detail_penjualan *
        d.harga_satuan_detail_penjualan
    ) AS omzet
FROM penjualan AS p
JOIN detail_penjualan AS d
    ON d.id_penjualan = p.id_penjualan
WHERE p.tgl_penjualan >= '2026-09-01'
  AND p.tgl_penjualan < '2026-11-01'
GROUP BY DATE_FORMAT(p.tgl_penjualan, '%Y-%m')
ORDER BY bulan;


-- ---------------------------------------------------------
-- D.4: Kasir yang melayani lebih dari 20 nota
-- COUNT menghitung jumlah nota setiap petugas.
-- HAVING menyaring hasil pengelompokan agregat.
--
-- Hasil nyata:
-- Empty set karena tidak ada petugas yang melayani
-- lebih dari 20 nota pada data yang digunakan.
-- ---------------------------------------------------------
SELECT
    pt.id_petugas,
    pt.kode_petugas,
    pt.nama_petugas,
    COUNT(p.id_penjualan) AS jumlah_nota
FROM penjualan AS p
JOIN petugas AS pt
    ON pt.id_petugas = p.id_petugas
GROUP BY
    pt.id_petugas,
    pt.kode_petugas,
    pt.nama_petugas
HAVING COUNT(p.id_penjualan) > 20
ORDER BY jumlah_nota DESC;


-- ---------------------------------------------------------
-- D.4: Barang dengan total kuantitas terjual kurang dari 10
-- SUM menjumlahkan kuantitas setiap barang.
-- HAVING menyaring hasil penjumlahan.
--
-- Hasil nyata:
-- Buku Tulis 58       : 1
-- Roti Cokelat        : 3
-- Air Mineral 600     : 3
-- Pulpen Gel 0.5      : 8
-- ---------------------------------------------------------
SELECT
    b.kode_barang,
    b.nama_barang,
    SUM(d.qty_detail_penjualan) AS total_qty_terjual
FROM detail_penjualan AS d
JOIN barang AS b
    ON b.id_barang = d.id_barang
GROUP BY
    b.id_barang,
    b.kode_barang,
    b.nama_barang
HAVING SUM(d.qty_detail_penjualan) < 10
ORDER BY total_qty_terjual;


-- ---------------------------------------------------------
-- Titik Analisis 3: Rata-rata belanja anggota
-- Subquery menghitung total setiap nota terlebih dahulu.
-- WHERE id_anggota IS NOT NULL memilih transaksi anggota.
-- AVG menghitung rata-rata total belanja anggota.
--
-- Hasil nyata:
-- Rata-rata belanja anggota Rp25.750.
-- ---------------------------------------------------------
SELECT
    AVG(ringkasan.total_nota) AS rata_rata_belanja_anggota
FROM (
    SELECT
        p.id_penjualan,
        SUM(
            d.qty_detail_penjualan *
            d.harga_satuan_detail_penjualan
        ) AS total_nota
    FROM penjualan AS p
    JOIN detail_penjualan AS d
        ON d.id_penjualan = p.id_penjualan
    WHERE p.id_anggota IS NOT NULL
    GROUP BY p.id_penjualan
) AS ringkasan;


-- ---------------------------------------------------------
-- E.1: Total nota anggota aktif setelah diskon 5%
-- AB-02: Diskon diberikan kepada anggota berstatus aktif.
-- JOIN anggota dan WHERE status_anggota='aktif'
-- memastikan hanya transaksi anggota aktif yang dihitung.
-- SUM menghitung subtotal.
-- Perkalian 0.95 menghitung total setelah diskon 5%.
-- HAVING menyaring kembalian lebih dari Rp4.000.
--
-- Hasil nyata:
-- Nota PJ-2609-0142
-- Subtotal             : Rp26.500
-- Setelah diskon       : Rp25.175
-- Pembayaran           : Rp30.000
-- Kembalian            : Rp4.825
-- ---------------------------------------------------------
SELECT
    p.no_nota_penjualan,
    SUM(
        d.qty_detail_penjualan *
        d.harga_satuan_detail_penjualan
    ) AS subtotal,
    ROUND(
        SUM(
            d.qty_detail_penjualan *
            d.harga_satuan_detail_penjualan
        ) * 0.95,
        0
    ) AS total_setelah_diskon,
    p.bayar_penjualan,
    p.bayar_penjualan - ROUND(
        SUM(
            d.qty_detail_penjualan *
            d.harga_satuan_detail_penjualan
        ) * 0.95,
        0
    ) AS kembalian
FROM penjualan AS p
JOIN detail_penjualan AS d
    ON d.id_penjualan = p.id_penjualan
JOIN anggota AS a
    ON a.id_anggota = p.id_anggota
WHERE a.status_anggota = 'aktif'
GROUP BY
    p.id_penjualan,
    p.no_nota_penjualan,
    p.tgl_penjualan,
    p.bayar_penjualan
HAVING p.bayar_penjualan - ROUND(
    SUM(
        d.qty_detail_penjualan *
        d.harga_satuan_detail_penjualan
    ) * 0.95,
    0
) > 4000
ORDER BY p.tgl_penjualan;


-- ---------------------------------------------------------
-- E.2: Omzet per bulan per kategori barang dengan ROLLUP
-- KI-01: Mengetahui omzet berdasarkan waktu dan kategori.
-- SUM menghitung omzet dari jumlah dikali harga transaksi.
-- ROLLUP menghasilkan subtotal per bulan dan total akhir.
--
-- Hasil nyata:
-- September 2026 - ATK      : Rp38.500
-- September 2026 - makanan  : Rp15.000
-- September 2026 - minuman  : Rp12.000
-- Subtotal September        : Rp65.500
-- Total keseluruhan         : Rp65.500
-- ---------------------------------------------------------
SELECT
    DATE_FORMAT(p.tgl_penjualan, '%Y-%m') AS bulan,
    b.kategori_barang,
    SUM(
        d.qty_detail_penjualan *
        d.harga_satuan_detail_penjualan
    ) AS omzet
FROM penjualan AS p
JOIN detail_penjualan AS d
    ON d.id_penjualan = p.id_penjualan
JOIN barang AS b
    ON b.id_barang = d.id_barang
WHERE p.tgl_penjualan >= '2026-09-01'
  AND p.tgl_penjualan < '2026-11-01'
GROUP BY
    DATE_FORMAT(p.tgl_penjualan, '%Y-%m'),
    b.kategori_barang WITH ROLLUP;