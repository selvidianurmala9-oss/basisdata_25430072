-- =========================================================
-- Modul 10: Menghubungkan Tabel dengan JOIN
-- Latihan Basis Data Kopma
--
-- Nama     : Selvi Dia Nurmala
-- NIM      : 25430072
-- Kelas    : C
-- Database : kopma_072
-- Berkas   : p10_join_kopma_25430072.sql
-- =========================================================
-- Catatan:
-- File kopma_data_lanjutan.sql belum tersedia saat
-- pengerjaan. Oleh karena itu, kueri diuji menggunakan
-- data sampel pada database kopma_072.
--
-- Data yang tersedia:
-- - 3 nota penjualan (24-26 September 2026).
-- - 7 baris detail penjualan.
--
-- Rentang tanggal pada modul yang semula Oktober 2026
-- disesuaikan menjadi September 2026 agar sesuai dengan
-- data yang tersedia.
--
-- Karena jumlah data berbeda dari contoh buku, hasil
-- pengujian juga berbeda dari hasil yang diharapkan
-- pada modul, seperti 75 nota, 146 detail, dan 10.950
-- baris hasil perkalian Kartesius.
-- =========================================================

USE kopma_072;

SET SESSION sql_mode =
CONCAT(@@sql_mode, ',ONLY_FULL_GROUP_BY');


-- =========================================================
-- D.1 INNER JOIN: Barang Terlaris (KI-02)
--
-- Jalur ERD:
-- barang -> detail_penjualan -> penjualan
--
-- Tujuan:
-- Menampilkan lima barang dengan jumlah penjualan
-- terbanyak selama September 2026.
--
-- Hasil pengujian:
-- 1. ATK-001 Pulpen Gel 0.5  : 8
-- 2. MNM-001 Air Mineral 600 : 3
-- 3. MKN-001 Roti Cokelat    : 3
-- 4. ATK-002 Buku Tulis 58   : 1
--
-- Hanya empat barang yang muncul karena hanya empat
-- barang yang tercatat dalam detail penjualan.
-- =========================================================

SELECT
    b.kode_barang,
    b.nama_barang,
    SUM(d.qty_detail_penjualan) AS terjual
FROM detail_penjualan d
INNER JOIN barang b
    ON b.id_barang = d.id_barang
INNER JOIN penjualan p
    ON p.id_penjualan = d.id_penjualan
WHERE p.tgl_penjualan >= '2026-09-01'
  AND p.tgl_penjualan < '2026-10-01'
GROUP BY
    b.id_barang,
    b.kode_barang,
    b.nama_barang
ORDER BY terjual DESC, b.nama_barang
LIMIT 5;


-- =========================================================
-- TITIK ANALISIS 1
-- Barang Terjual dengan Stok di Bawah Minimum (KI-03)
--
-- Jalur ERD:
-- barang -> detail_penjualan -> penjualan
--
-- Tujuan:
-- Mengetahui barang yang pernah terjual tetapi stok
-- saat ini berada di bawah batas minimum.
--
-- Hasil pengujian:
-- Empty set.
--
-- Artinya, tidak ditemukan barang terjual yang stoknya
-- berada di bawah stok minimum pada data sampel.
-- =========================================================

SELECT
    b.kode_barang,
    b.nama_barang,
    b.stok_barang,
    b.stok_minimum_barang,
    b.stok_minimum_barang - b.stok_barang AS kekurangan,
    SUM(d.qty_detail_penjualan) AS terjual
FROM barang b
INNER JOIN detail_penjualan d
    ON d.id_barang = b.id_barang
INNER JOIN penjualan p
    ON p.id_penjualan = d.id_penjualan
WHERE p.tgl_penjualan >= '2026-09-01'
  AND p.tgl_penjualan < '2026-10-01'
GROUP BY
    b.id_barang,
    b.kode_barang,
    b.nama_barang,
    b.stok_barang,
    b.stok_minimum_barang
HAVING b.stok_barang < b.stok_minimum_barang
ORDER BY terjual DESC;


-- =========================================================
-- D.2 JOIN TIGA TABEL
-- Anggota dengan Belanja Terbesar (KI-04)
--
-- Jalur ERD:
-- anggota -> penjualan -> detail_penjualan
--
-- Tujuan:
-- Menampilkan anggota berdasarkan total nilai belanja,
-- jumlah nota, dan total pembelian.
--
-- Hasil pengujian:
-- A-0001 Andi : 1 nota, belanja Rp26.500.
-- A-0002 Budi : 1 nota, belanja Rp25.000.
--
-- Pembeli umum tidak ditampilkan karena tidak memiliki
-- relasi dengan tabel anggota.
-- =========================================================

SELECT
    a.no_anggota,
    a.nama_anggota,
    COUNT(DISTINCT p.id_penjualan) AS nota,
    SUM(
        d.qty_detail_penjualan *
        d.harga_satuan_detail_penjualan
    ) AS belanja
FROM anggota a
INNER JOIN penjualan p
    ON p.id_anggota = a.id_anggota
INNER JOIN detail_penjualan d
    ON d.id_penjualan = p.id_penjualan
GROUP BY
    a.id_anggota,
    a.no_anggota,
    a.nama_anggota
ORDER BY belanja DESC
LIMIT 5;


-- =========================================================
-- D.3 LEFT JOIN
-- Barang yang Belum Pernah Terjual
--
-- Jalur ERD:
-- barang -> detail_penjualan
--
-- Tujuan:
-- Menampilkan barang yang belum memiliki catatan
-- penjualan pada tabel detail_penjualan.
--
-- COUNT(d.id_barang) hanya menghitung nilai yang bukan
-- NULL. Karena itu, barang tanpa pasangan menghasilkan 0.
--
-- Hasil pengujian:
-- Empty set.
--
-- Artinya, keempat barang pada data sampel sudah pernah
-- tercatat dalam detail penjualan.
-- =========================================================

SELECT
    b.kode_barang,
    b.nama_barang,
    COUNT(d.id_barang) AS baris_terjual
FROM barang b
LEFT JOIN detail_penjualan d
    ON d.id_barang = b.id_barang
GROUP BY
    b.id_barang,
    b.kode_barang,
    b.nama_barang
HAVING COUNT(d.id_barang) = 0;


-- =========================================================
-- D.3 PERBANDINGAN COUNT(*) DAN COUNT(id_barang)
--
-- COUNT(*) menghitung seluruh baris hasil LEFT JOIN,
-- termasuk baris yang kolom tabel kanannya bernilai NULL.
--
-- COUNT(d.id_barang) hanya menghitung nilai yang bukan NULL.
-- Jika barang belum pernah terjual, COUNT(*) menghasilkan 1
-- sedangkan COUNT(d.id_barang) menghasilkan 0.
--
-- Hasil pengujian:
-- Pulpen Gel 0.5  : 2
-- Buku Tulis 58   : 1
-- Air Mineral 600 : 2
-- Roti Cokelat    : 2
--
-- Total terdapat 7 baris detail. Pada data sampel ini
-- seluruh barang sudah pernah terjual sehingga tidak
-- ditemukan perbedaan jumlah antara kedua fungsi tersebut.
-- =========================================================

SELECT
    b.kode_barang,
    b.nama_barang,
    COUNT(*) AS baris_terjual
FROM barang b
LEFT JOIN detail_penjualan d
    ON d.id_barang = b.id_barang
GROUP BY
    b.id_barang,
    b.kode_barang,
    b.nama_barang;


-- =========================================================
-- D.4 MEMBUKTIKAN PERKALIAN KARTESIUS
--
-- Tujuan:
-- Membandingkan jumlah baris hasil perkalian Kartesius
-- dengan jumlah baris hasil JOIN menggunakan kondisi relasi.
--
-- Hasil pengujian:
-- Jumlah penjualan          : 3
-- Jumlah detail penjualan   : 7
-- Perkalian Kartesius       : 21 (3 x 7)
-- JOIN dengan kondisi benar : 7
--
-- Hasil berbeda dari contoh buku karena jumlah data
-- sampel yang digunakan lebih sedikit.
-- =========================================================

SELECT COUNT(*) AS jumlah_penjualan
FROM penjualan;


SELECT COUNT(*) AS jumlah_detail_penjualan
FROM detail_penjualan;


-- Perkalian Kartesius tanpa kondisi JOIN (hasil: 21).

SELECT COUNT(*) AS hasil_kartesius
FROM penjualan, detail_penjualan;


-- JOIN dengan kondisi relasi yang benar (hasil: 7).

SELECT COUNT(*) AS hasil_join
FROM penjualan p
INNER JOIN detail_penjualan d
    ON d.id_penjualan = p.id_penjualan;


-- =========================================================
-- E.1 NOTA BESERTA NAMA KASIR DAN ANGGOTA
--
-- Jalur ERD:
-- penjualan -> petugas
-- penjualan -> anggota
--
-- Tujuan:
-- Menampilkan nomor nota, tanggal transaksi, nama kasir,
-- dan nama anggota yang melakukan pembelian.
--
-- INNER JOIN digunakan untuk menghubungkan nota dengan
-- petugas, sedangkan LEFT JOIN digunakan agar transaksi
-- pembeli umum tetap ditampilkan.
--
-- COALESCE() mengganti nama anggota yang NULL menjadi
-- tulisan 'Umum'.
--
-- Rentang tanggal: September 2026.
--
-- Hasil pengujian:
-- PJ-2609-0142 | 24-09-2026 | Rina  | Andi
-- PJ-2609-0143 | 25-09-2026 | Dimas | Umum
-- PJ-2609-0144 | 26-09-2026 | Sari  | Budi
-- =========================================================

SELECT
    p.no_nota_penjualan,
    p.tgl_penjualan,
    pt.nama_petugas AS kasir,
    COALESCE(a.nama_anggota, 'Umum') AS nama_anggota
FROM penjualan p
INNER JOIN petugas pt
    ON pt.id_petugas = p.id_petugas
LEFT JOIN anggota a
    ON a.id_anggota = p.id_anggota
WHERE p.tgl_penjualan >= '2026-09-01'
  AND p.tgl_penjualan < '2026-10-01'
ORDER BY p.tgl_penjualan;


-- =========================================================
-- E.2 MEMBUKTIKAN AB-04
-- Perbandingan Harga Pulpen Gel 0.5
--
-- Jalur ERD:
-- barang -> detail_penjualan -> penjualan
--
-- Tujuan:
-- Membandingkan harga barang ketika transaksi dilakukan
-- dengan harga jual barang yang tercatat saat ini.
--
-- Data sampel hanya memiliki transaksi September 2026,
-- sehingga perbandingan sebelum dan sesudah 15 Oktober
-- seperti pada contoh modul belum dapat dilakukan.
--
-- Hasil pengujian:
-- PJ-2609-0142 (24-09):
-- Harga transaksi Rp4.000, harga sekarang Rp4.000.
--
-- PJ-2609-0144 (26-09):
-- Harga transaksi Rp4.000, harga sekarang Rp4.000.
--
-- Kesimpulan:
-- Pada data sampel, belum terlihat perbedaan harga antara
-- harga saat transaksi dan harga jual saat ini. Oleh karena
-- itu, perubahan harga berdasarkan AB-04 belum dapat
-- dibuktikan menggunakan data yang tersedia.
-- =========================================================

SELECT
    p.no_nota_penjualan,
    p.tgl_penjualan,
    b.nama_barang,
    d.harga_satuan_detail_penjualan
        AS harga_saat_transaksi,
    b.harga_jual_barang
        AS harga_sekarang
FROM detail_penjualan d
INNER JOIN barang b
    ON b.id_barang = d.id_barang
INNER JOIN penjualan p
    ON p.id_penjualan = d.id_penjualan
WHERE b.nama_barang LIKE 'Pulpen Gel 0.5%'
ORDER BY p.tgl_penjualan;


-- =========================================================
-- AKHIR MODUL 10
-- =========================================================