D.1 Identitas Proyek

Nama Proyek/Organisasi : Toko Serba Digital SDN
Tema                   : Toko Daring
Kode Tema              : toko
NIM                    : 25430072
P                      : 1

D.2 Proses Bisnis

| Kode | Proses Bisnis | Aktor | Pemicu |
|---|---|---|---|
| PB-00 | Mengelola data pelanggan | Pelanggan/Admin | Pelanggan melakukan pendaftaran atau mengubah data |
| PB-01 | Mengelola katalog produk | Admin | Ada produk baru atau perubahan informasi produk |
| PB-02 | Mengelola keranjang | Pelanggan | Pelanggan memilih produk |
| PB-03 | Membuat pesanan | Pelanggan | Pelanggan melakukan checkout |
| PB-04 | Mencatat pembayaran | Pelanggan/Admin | Pembayaran dilakukan |
| PB-05 | Mengelola pengiriman | Admin/Petugas | Pesanan sudah dibayar |
| PB-06 | Membuat laporan penjualan | Admin | Akhir periode laporan |

D.3 Analisis Data

Data yang disimpan:
1. Nomor pesanan
2. Tanggal pesanan
3. Data pelanggan
4. Produk
5. Jumlah produk
6. Harga produk saat transaksi
7. Ongkos kirim
8. Alamat pengiriman
9. Tanggal pembayaran

Data yang dihitung:
1. Subtotal
2. Diskon
3. Total pembayaran

D.4 Entitas Kandidat dan Aturan Bisnis

### Entitas Kandidat

| Entitas Kandidat | Elemen Data Utama | Sumber |
|---|---|---|
| Pelanggan | id pelanggan, nama, email, nomor HP, alamat | Data pelanggan |
| Produk | kode produk, nama produk, kategori, harga, stok | Katalog produk |
| Keranjang | id keranjang, pelanggan, tanggal dibuat | Data keranjang |
| Detail Keranjang | id keranjang, produk, jumlah | Data keranjang |
| Pesanan | nomor pesanan, tanggal pesanan, pelanggan, ongkos kirim, alamat pengiriman | Halaman pesanan |
| Detail Pesanan | nomor pesanan, produk, jumlah, harga saat transaksi | Halaman pesanan |
| Pembayaran | id pembayaran, nomor pesanan, tanggal pembayaran, jumlah pembayaran, status pembayaran | Bukti pembayaran |
| Pengiriman | nomor pengiriman, nomor pesanan, tanggal pengiriman, nomor resi, status pengiriman | Resi pengiriman |
| Admin | id admin, nama admin, peran | Data admin |

### Aturan Bisnis

| Kode | Aturan Bisnis |
|---|---|
| AB-01 | Setiap pesanan memiliki nomor pesanan yang unik dan minimal memiliki satu produk. |
| AB-02 | Jumlah produk dalam satu pesanan maksimal 3 item. |
| AB-03 | Harga produk yang digunakan pada pesanan disimpan sesuai harga saat transaksi. |
| AB-04 | Ongkos kirim disimpan pada setiap pesanan. |
| AB-05 | Alamat pengiriman disimpan pada setiap pesanan. |
| AB-06 | Pembayaran harus terkait dengan satu pesanan. |
| AB-07 | Pesanan yang belum dibayar tidak dapat diproses ke tahap pengiriman. |
| AB-08 | Setiap pengiriman memiliki nomor resi yang unik. |
| AB-09 | Stok produk tidak boleh bernilai negatif. |
| AB-10 | Diskon transaksi ditetapkan sebesar 1% dari subtotal. |

D.5 Kebutuhan Informasi

| Kode | Kebutuhan Informasi | Data yang Digunakan |
|---|---|---|
| KI-01 | Mengetahui jumlah dan nilai penjualan per hari dan per bulan | Pesanan, Detail Pesanan |
| KI-02 | Mengetahui produk yang paling banyak terjual | Produk, Detail Pesanan |
| KI-03 | Mengetahui daftar pesanan yang belum dibayar | Pesanan, Pembayaran |
| KI-04 | Mengetahui status pengiriman pesanan | Pesanan, Pengiriman |
| KI-05 | Mengetahui riwayat pembelian setiap pelanggan | Pelanggan, Pesanan, Detail Pesanan |

### Matriks CRUD

| Proses | Pelanggan | Produk | Keranjang | Detail Keranjang | Pesanan | Detail Pesanan | Pembayaran | Pengiriman |
|---|---|---|---|---|---|---|---|---|
| PB-00 Mengelola data pelanggan | C/R/U | | | | | | | |
| PB-01 Mengelola katalog produk | | C/R/U | | | | | | |
| PB-02 Mengelola keranjang | R | R | C/R/U | C/R/U | | | | |
| PB-03 Membuat pesanan | R | R | R | R | C | C | | |
| PB-04 Mencatat pembayaran | | | | | R | | C | |
| PB-05 Mengelola pengiriman | | | | | R | | R | C/R/U |
| PB-06 Membuat laporan penjualan | R | R | | | R | R | R | R |

D.6 Kamus Data Awal

| Elemen | Arti | Contoh | Aturan | Penanggung Jawab |
|---|---|---|---|---|
| id_pelanggan | Identitas unik pelanggan | PLG-001 | Unik | Admin |
| nama_pelanggan | Nama pelanggan | Selvi | Tidak boleh kosong | Admin |
| email_pelanggan | Email pelanggan | selvid@email.com | Format email | Admin |
| no_hp_pelanggan | Nomor HP pelanggan | 081234567890 | Data pribadi | Admin |
| alamat_pelanggan | Alamat pelanggan | Jl. Contoh No. 1 | Tidak boleh kosong | Admin |
| kode_produk | Kode unik produk | PRD-001 | Unik | Admin |
| nama_produk | Nama produk | Keyboard | Tidak boleh kosong | Admin |
| kategori_produk | Kategori produk | Elektronik | Tidak boleh kosong | Admin |
| harga_produk | Harga produk | 150000 | Bilangan bulat ≥ 0 | Admin |
| stok_produk | Jumlah stok produk | 25 | Bilangan bulat ≥ 0 | Admin |
| id_keranjang | Identitas keranjang | KRG-001 | Unik | Pelanggan |
| jumlah_produk | Jumlah produk dalam keranjang | 2 | Bilangan bulat > 0 | Pelanggan |
| no_pesanan | Nomor unik pesanan | ORD-001 | Unik | Admin |
| tanggal_pesanan | Tanggal pesanan dibuat | 2026-10-04 | Format tanggal | Admin |
| harga_saat_transaksi | Harga produk saat dipesan | 150000 | Disimpan per transaksi | Admin |
| ongkos_kirim | Biaya pengiriman pesanan | 20000 | Bilangan bulat ≥ 0 | Admin |
| alamat_pengiriman | Alamat tujuan pengiriman | Jl. Contoh No. 1 | Disimpan per pesanan | Admin |
| id_pembayaran | Identitas pembayaran | PAY-001 | Unik | Admin |
| tanggal_pembayaran | Tanggal pembayaran dilakukan | 2026-10-04 | Format tanggal | Admin |
| status_pembayaran | Status pembayaran pesanan | Lunas | Sesuai status pembayaran | Admin |
| nomor_resi | Nomor resi pengiriman | RESI123456 | Unik | Petugas |

## D.7 Kebutuhan Data Non-Fungsional

| Aspek | Kebutuhan |
|---|---|
| Volume data | Sistem diperkirakan menangani sekitar 45 transaksi per hari. |
| Penyimpanan | Data pesanan, pembayaran, dan pengiriman disimpan minimal selama 5 tahun. |
| Data pribadi | Data nama, email, nomor HP, dan alamat pelanggan harus dijaga kerahasiaannya. |
| Hak akses | Data pelanggan hanya dapat diakses oleh admin yang berwenang dan digunakan untuk kebutuhan transaksi. |
| Integritas data | Nomor pesanan, kode produk, dan nomor resi harus unik dan tidak boleh kosong. |
| Keamanan | Data transaksi dan data pribadi harus terlindungi dari perubahan atau akses yang tidak berwenang. |

## D.8 Masalah Kualitas Data

Beberapa masalah kualitas data yang mungkin terjadi adalah:

1. Data pelanggan tidak lengkap, seperti email atau nomor HP kosong.
2. Data produk memiliki harga atau stok yang tidak sesuai.
3. Nomor pesanan atau nomor resi tercatat lebih dari satu kali.
4. Alamat pengiriman tidak lengkap sehingga dapat menghambat proses pengiriman.
5. Data pembayaran tidak sesuai dengan pesanan yang dibuat.
6. Kesalahan memasukkan jumlah produk dapat menyebabkan jumlah stok menjadi tidak sesuai.

## D.9 Dokumen Sumber Fiktif

Dokumen sumber yang digunakan adalah **Halaman Pesanan Toko Serba Digital SDN**.

Contoh isi dokumen:

| Field | Contoh Isi |
|---|---|
| Nomor Pesanan | ORD-001 |
| Tanggal Pesanan | 2026-10-04 |
| Nama Pelanggan | Selvi |
| Produk | Keyboard |
| Jumlah | 2 |
| Harga Satuan | 150000 |
| Ongkos Kirim | 20000 |
| Alamat Pengiriman | Jl. Contoh No. 1 |
| Status Pembayaran | Lunas |

### Analisis Dokumen Sumber

Dari dokumen tersebut, data yang perlu disimpan adalah nomor pesanan, tanggal pesanan, data pelanggan, produk, jumlah produk, harga produk saat transaksi, ongkos kirim, alamat pengiriman, dan status pembayaran. Data subtotal dan total pembayaran dapat dihitung berdasarkan data transaksi.