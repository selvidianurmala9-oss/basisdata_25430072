# Dokumen Kebutuhan Data - Koperasi Mahasiswa Sejahtera

## 1. Latar belakang dan aktivitas organisasi

Koperasi Mahasiswa Sejahtera (Kopma) merupakan koperasi fiktif yang menjual alat tulis, makanan ringan, dan minuman di lingkungan kampus. Pembeli dapat berupa anggota maupun pembeli umum.

Mahasiswa dapat mendaftar sebagai anggota dengan NIM, nama, program studi, dan nomor HP. Anggota aktif mendapatkan diskon 5% untuk setiap nota.

Aktivitas utama Kopma meliputi pendaftaran anggota, pencatatan penjualan, pemeriksaan stok, pemesanan barang kepada pemasok, penerimaan barang, dan penyusunan laporan bulanan.

## 2. Aktor dan proses bisnis

| Kode | Proses Bisnis | Aktor | Pemicu |
|---|---|---|---|
| PB-01 | Mendaftarkan anggota | Kasir | Mahasiswa ingin menjadi anggota |
| PB-02 | Mencatat penjualan | Kasir | Pembeli membayar di kasir |
| PB-03 | Memesan barang ke pemasok | Petugas gudang | Stok di bawah batas minimum |
| PB-04 | Menerima barang dari pemasok | Petugas gudang | Barang datang bersama faktur |
| PB-05 | Menyusun laporan bulanan | Ketua koperasi | Awal bulan |
| PB-06 | Mengelola data pemasok | Petugas gudang | Ada pemasok baru atau perubahan data pemasok |

## 3. Dokumen sumber yang dianalisis

Dokumen sumber yang dianalisis adalah nota penjualan Kopma.

Elemen data pada nota digunakan sebagai dasar untuk menentukan data yang perlu disimpan. Harga barang saat transaksi perlu disimpan pada nota karena harga barang dapat berubah. Dengan menyimpan harga saat transaksi, harga pada nota lama tetap dapat diketahui meskipun harga barang saat ini sudah berubah.

Subtotal dan total merupakan nilai turunan yang dapat dihitung dari jumlah barang, harga, dan diskon. Nilai tersebut dapat dihitung kembali sehingga tidak selalu harus disimpan.

## 4. Entitas kandidat dan elemen data

| Entitas Kandidat | Elemen Data Utama | Sumber |
|---|---|---|
| Anggota | nomor anggota, NIM, nama, program studi, nomor HP, status aktif | Formulir pendaftaran |
| Barang | kode, nama, kategori, harga jual, stok, batas minimum stok | Daftar barang, faktur |
| Penjualan | nomor nota, tanggal-jam, kasir, anggota (opsional), bayar | Nota penjualan |
| Detail Penjualan | nomor nota, barang, qty, harga saat transaksi | Nota penjualan |
| Petugas | kode petugas, nama, peran (kasir/gudang/ketua) | Wawancara |
| Pemasok | kode, nama, telepon, alamat | Faktur pemasok |
| Pembelian dan Detailnya | nomor faktur, tanggal, pemasok, barang, qty, harga beli | Faktur pemasok |

## 5. Aturan bisnis

| Kode | Aturan Bisnis |
|---|---|
| AB-01 | Setiap nota memiliki nomor unik dan minimal satu baris barang. |
| AB-02 | Penjualan boleh tanpa anggota. Jika ada anggota, anggota harus berstatus aktif untuk memperoleh diskon 5%. |
| AB-03 | Stok barang tidak boleh negatif. Penjualan ditolak bila qty melebihi stok tersedia. |
| AB-04 | Harga jual yang dipakai pada nota disimpan per baris dan tidak berubah meskipun harga barang kemudian naik. |
| AB-05 | NIM anggota unik. Pencarian anggota dapat dilakukan melalui nomor anggota atau NIM. |
| AB-06 | Pesanan pembelian dibuat bila stok kurang dari batas minimum barang tersebut. |
| AB-07 | Data pemasok harus memiliki kode yang unik. |
| AB-08 | Status aktif anggota hanya dapat diubah oleh ketua koperasi. |

## 6. Kebutuhan informasi

| Kode | Kebutuhan Informasi | Data yang Diperlukan |
|---|---|---|
| KI-01 | Mengetahui omzet dan jumlah nota per hari dan per bulan | Penjualan, Detail Penjualan |
| KI-02 | Mengetahui lima barang terlaris per bulan berdasarkan jumlah terjual | Detail Penjualan, Barang |
| KI-03 | Mengetahui barang dengan stok di bawah batas minimum | Barang |
| KI-04 | Mengetahui sepuluh anggota dengan belanja terbesar per bulan | Penjualan, Detail Penjualan, Anggota |

## 7. Matriks CRUD

| Proses | Anggota | Barang | Penjualan | Detail Penjualan | Pemasok | Pembelian |
|---|---|---|---|---|---|---|
| PB-01 Mendaftarkan anggota | C | | | | | |
| PB-02 Mencatat penjualan | R | R | C | C | | |
| PB-03 Memesan barang ke pemasok | | R | | | R | C |
| PB-04 Menerima barang dari pemasok | | U | | | R | U |
| PB-05 Menyusun laporan bulanan | R | R | R | R | R | R |
| PB-06 Mengelola data pemasok | | | | | C/R/U | |

## 8. Kamus data awal

| Elemen | Arti | Contoh | Aturan | Penanggung Jawab |
|---|---|---|---|---|
| no_anggota | Nomor anggota koperasi | A-0457 | Unik, format A-4 digit | Ketua |
| nim_anggota | NIM anggota | 2301010123 | Unik, 10 digit | Ketua |
| no_hp_anggota | Nomor HP anggota | 0812xxxx | Data pribadi, akses terbatas | Ketua |
| no_nota_penjualan | Nomor nota penjualan | PJ-2609-0142 | Unik per nota | Kasir |
| harga_satuan_detail_penjualan | Harga jual saat transaksi | 4000 | Bilangan bulat ≥ 0 | Kasir |
| stok_barang | Jumlah barang tersedia | 35 | Bilangan bulat ≥ 0 | Petugas gudang |
| kode_barang | Kode barang | BRG-001 | Unik | Petugas gudang |
| nama_barang | Nama barang | Buku Tulis | Tidak boleh kosong | Petugas gudang |
| kategori_barang | Kategori barang | Alat Tulis | Tidak boleh kosong | Petugas gudang |
| batas_minimum_stok | Batas minimum stok | 10 | Bilangan bulat ≥ 0 | Petugas gudang |
| kode_petugas | Kode petugas | PTG-001 | Unik | Ketua |
| nama_petugas | Nama petugas | Andi | Tidak boleh kosong | Ketua |
| peran_petugas | Peran petugas | Kasir | Kasir/gudang/ketua | Ketua |
| kode_pemasok | Kode pemasok | PSP-001 | Unik | Petugas gudang |
| nama_pemasok | Nama pemasok | PT Sumber Jaya | Tidak boleh kosong | Petugas gudang |
| telepon_pemasok | Nomor telepon pemasok | 081234567890 | Format nomor telepon | Petugas gudang |
| alamat_pemasok | Alamat pemasok | Jl. Contoh No. 2 | Tidak boleh kosong | Petugas gudang |
| nomor_faktur | Nomor faktur pembelian | FK-001 | Unik | Petugas gudang |
| tanggal_pembelian | Tanggal pembelian | 2026-10-04 | Format tanggal | Petugas gudang |
| qty_detail_penjualan | Jumlah barang terjual | 2 | Bilangan bulat > 0 | Kasir |
| status_aktif_anggota | Status keaktifan anggota | Aktif | Aktif/Tidak aktif | Ketua |

## 9. Kebutuhan non-fungsional data

| Aspek | Kebutuhan |
|---|---|
| Volume | Sistem diperkirakan menangani sekitar 150 nota per hari. |
| Retensi | Data transaksi disimpan minimal selama 5 tahun. |
| Privasi | Nomor HP anggota merupakan data pribadi dan harus dilindungi. |
| Hak akses | Nomor HP anggota hanya boleh dilihat oleh ketua koperasi. |
| Integritas | Nomor anggota, NIM, nomor nota, kode barang, dan kode pemasok harus unik. |
| Keamanan | Data pribadi dan data transaksi hanya dapat diakses oleh pihak yang berwenang. |

## 10. Isu kualitas data yang diantisipasi

1. Data anggota dapat tidak lengkap atau salah saat pendaftaran.
2. NIM atau nomor anggota dapat tercatat lebih dari satu kali.
3. Stok barang dapat menjadi negatif jika transaksi tidak divalidasi.
4. Harga pada nota lama dapat tidak sesuai jika harga saat transaksi tidak disimpan.
5. Data stok dapat tidak sesuai dengan kondisi barang sebenarnya.
6. Data pemasok dapat tidak lengkap atau salah.
7. Data transaksi dapat tidak sesuai dengan kondisi pembayaran sebenarnya.