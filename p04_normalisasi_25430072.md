# Modul 4 — Normalisasi dan Skema Relasional

## Identitas Proyek

- Nama: Selvi Dia Nurmala
- NIM: 25430072
- Kelas: C
- Nama Proyek: Toko Serba Digital SDN
- Modul: 4 — Normalisasi dan Skema Relasional

## 1. Sumber Data

Sumber data yang digunakan dalam proses normalisasi berasal dari dokumen analisis kebutuhan pada Modul 2 dan rancangan ERD pada Modul 3.

Data yang dikelola dalam sistem Toko Serba Digital SDN meliputi:

1. Data pelanggan
2. Data produk
3. Data pesanan
4. Data detail pesanan
5. Jumlah produk yang dipesan
6. Harga produk saat transaksi
7. Ongkos kirim
8. Alamat pengiriman
9. Tanggal pesanan
10. Data pembayaran
11. Data pengiriman

Normalisasi dilakukan untuk mengurangi redundansi data, mencegah anomali penyisipan, pembaruan, dan penghapusan, serta menghasilkan skema relasional yang terstruktur.

## 2. Analisis Anomali Data

Pada sistem Toko Serba Digital SDN, pencatatan data pelanggan, pesanan, dan produk dalam satu tabel dapat menimbulkan tiga jenis anomali.

1. **Anomali ubah (update anomaly)**

   Informasi pelanggan atau produk dapat tercatat berulang pada beberapa baris. Jika informasi tersebut berubah, setiap baris terkait harus diperbarui agar tidak terjadi ketidakkonsistenan data.

2. **Anomali sisip (insert anomaly)**

   Produk baru akan sulit dicatat apabila tabel hanya digunakan untuk menyimpan produk yang sudah masuk ke suatu pesanan. Pemisahan tabel produk memungkinkan data produk dicatat secara mandiri.

3. **Anomali hapus (delete anomaly)**

   Jika detail produk merupakan satu-satunya tempat informasi produk tercatat, penghapusan detail tersebut dapat menyebabkan informasi produk ikut hilang.

Normalisasi dilakukan untuk mengurangi anomali tersebut dengan memisahkan data berdasarkan ketergantungan fungsionalnya.

## 3. Bentuk Tidak Normal (UNF)

Bentuk Tidak Normal (Unnormalized Form/UNF) merupakan bentuk data yang masih memiliki kelompok atribut berulang dalam satu relasi.

Pada proyek Toko Serba Digital SDN, satu pesanan dapat mencakup beberapa produk. Oleh karena itu, informasi produk dapat berulang untuk nomor pesanan yang sama.

Relasi UNF:

PESANAN_UNF(
no_pesanan,
tanggal_pesanan,
id_pelanggan,
nama_pelanggan,
alamat_pelanggan,
{kode_produk, nama_produk, jumlah_produk, harga_saat_transaksi},
ongkos_kirim,
alamat_pengiriman
)

Keterangan atribut:

- no_pesanan: nomor unik pesanan.
- tanggal_pesanan: tanggal pesanan dibuat.
- id_pelanggan: identitas pelanggan.
- nama_pelanggan: nama pelanggan.
- alamat_pelanggan: alamat pelanggan.
- kode_produk: kode produk yang dipesan.
- nama_produk: nama produk.
- jumlah_produk: jumlah produk yang dipesan.
- harga_saat_transaksi: harga produk saat pesanan dibuat.
- ongkos_kirim: biaya pengiriman pesanan.
- alamat_pengiriman: alamat tujuan pengiriman.

Kelompok atribut di dalam tanda kurung kurawal menunjukkan data produk yang dapat berulang dalam satu pesanan.

## 4. Bentuk Normal Pertama (1NF)

Bentuk Normal Pertama (First Normal Form/1NF) merupakan tahap normalisasi yang memastikan setiap atribut hanya memiliki satu nilai dalam setiap baris dan tidak terdapat kelompok data berulang.

Pada sistem Toko Serba Digital SDN, satu pesanan dapat berisi beberapa jenis produk. Oleh karena itu, setiap produk yang dipesan harus dicatat pada baris tersendiri. Dengan cara ini, setiap baris menunjukkan satu produk dalam suatu pesanan.

Relasi setelah diubah ke bentuk 1NF:

**PESANAN_1NF**

| no_pesanan | tanggal_pesanan | id_pelanggan | nama_pelanggan | alamat_pelanggan | kode_produk | nama_produk | jumlah_produk | harga_saat_transaksi | ongkos_kirim | alamat_pengiriman |
|---|---|---|---|---|---|---|---|---|---|---|
| ORD-001 | 2026-10-04 | PLG-001 | Selvi | Jl. Contoh No. 1 | PRD-001 | Keyboard | 2 | 150000 | 20000 | Jl. Contoh No. 1 |

**Keterangan:**

- Setiap kolom menyimpan satu nilai untuk setiap baris.
- Jika satu pesanan berisi beberapa produk, setiap produk dicatat pada baris yang berbeda.
- Nomor pesanan dapat muncul berulang apabila pesanan tersebut memiliki lebih dari satu produk.
- Harga saat transaksi tetap dicatat agar harga pada saat pemesanan dapat diketahui meskipun harga produk berubah.

Pada tahap ini, data sudah memenuhi bentuk 1NF. Namun, beberapa atribut masih berpotensi mengalami redundansi karena informasi pelanggan dan pesanan dapat tercatat berulang pada setiap produk yang dipesan.

## 5. Bentuk Normal Kedua (2NF)

Bentuk Normal Kedua (Second Normal Form/2NF) merupakan tahap normalisasi yang mengharuskan suatu relasi memenuhi 1NF dan setiap atribut nonkunci bergantung sepenuhnya pada seluruh bagian kunci utama, bukan hanya sebagian kunci.

Pada relasi PESANAN_1NF, satu pesanan dapat memiliki beberapa produk. Oleh karena itu, kunci untuk mengidentifikasi setiap baris merupakan gabungan dari no_pesanan dan kode_produk, dengan asumsi bahwa produk yang sama hanya dicatat satu kali dalam satu pesanan.

Ketergantungan atribut pada relasi 1NF masih menimbulkan masalah. Informasi tanggal pesanan, pelanggan, ongkos kirim, dan alamat pengiriman bergantung pada no_pesanan saja. Sementara itu, nama produk bergantung pada kode_produk. Kondisi tersebut menunjukkan adanya ketergantungan parsial terhadap kunci gabungan.

Untuk memenuhi 2NF, data dipisahkan menjadi beberapa relasi berikut.

**1. Tabel PESANAN**

| no_pesanan (PK) | tanggal_pesanan | id_pelanggan | ongkos_kirim | alamat_pengiriman |
|---|---|---|---|---|
| ORD-001 | 2026-10-04 | PLG-001 | 20000 | Jl. Contoh No. 1 |

**2. Tabel PRODUK**

| kode_produk (PK) | nama_produk | kategori_produk | harga_produk | stok_produk |
|---|---|---|---|---|
| PRD-001 | Keyboard | Periferal | 150000 | 10 |

**3. Tabel DETAIL_PESANAN**

| no_pesanan (PK, FK) | kode_produk (PK, FK) | jumlah_produk | harga_saat_transaksi |
|---|---|---|---|
| ORD-001 | PRD-001 | 2 | 150000 |

**Keterangan:**

- Tabel PESANAN menyimpan informasi utama dari setiap pesanan.
- Tabel PRODUK menyimpan identitas dan nama produk.
- Tabel DETAIL_PESANAN mencatat produk yang terdapat dalam suatu pesanan, beserta jumlah dan harga saat transaksi.
- PK (*Primary Key*) merupakan kunci utama untuk mengidentifikasi data secara unik.
- FK (*Foreign Key*) merupakan kunci asing yang menghubungkan suatu tabel dengan tabel lain.

Pemisahan tersebut mengurangi ketergantungan parsial karena informasi pesanan disimpan berdasarkan nomor pesanan, sedangkan informasi produk disimpan berdasarkan kode produk. Pada tahap 3NF, informasi pelanggan dipisahkan ke dalam tabel PELANGGAN agar data identitas pelanggan dikelola secara terpisah dari data pesanan.

## 6. Bentuk Normal Ketiga (3NF)

Bentuk Normal Ketiga (Third Normal Form/3NF) merupakan tahap normalisasi yang mengharuskan relasi memenuhi 2NF dan tidak memiliki ketergantungan transitif antara atribut nonkunci terhadap kunci utama.

Pada relasi PESANAN_1NF, atribut nama_pelanggan dan alamat_pelanggan masih dicatat bersama informasi pesanan dan produk. Karena identitas pelanggan ditentukan oleh id_pelanggan, informasi pelanggan perlu dikelola secara terpisah agar tidak berulang pada setiap pesanan. Oleh karena itu, tabel PELANGGAN digunakan untuk menyimpan identitas pelanggan, sedangkan tabel PESANAN menyimpan id_pelanggan sebagai foreign key.

Untuk mengatasi masalah tersebut, data pelanggan dipisahkan dari tabel PESANAN. Hasil pemisahan relasi pada tahap 3NF adalah sebagai berikut.

**1. Tabel PELANGGAN**

| id_pelanggan (PK) | nama_pelanggan | email_pelanggan | no_hp_pelanggan | alamat_pelanggan |
|---|---|---|---|---|
| PLG-001 | Selvi | selvi@example.com | 081234567890 | Jl. Contoh No. 1 |

**2. Tabel PESANAN**

| no_pesanan (PK) | tanggal_pesanan | id_pelanggan (FK) | ongkos_kirim | alamat_pengiriman |
|---|---|---|---|---|
| ORD-001 | 2026-10-04 | PLG-001 | 20000 | Jl. Contoh No. 1 |

Tabel PESANAN menyimpan informasi setiap pesanan. Atribut `no_pesanan` menjadi primary key (PK), sedangkan `id_pelanggan` menjadi foreign key (FK) yang menghubungkan tabel PESANAN dengan tabel PELANGGAN. Atribut `nama_pelanggan` tidak disimpan kembali dalam tabel ini karena sudah tersedia pada tabel PELANGGAN. Atribut `alamat_pengiriman` tetap disimpan karena merupakan alamat tujuan untuk pesanan tersebut.

**3. Tabel PRODUK**

| kode_produk (PK) | nama_produk | kategori_produk | harga_produk | stok_produk |
|---|---|---|---|---|
| PRD-001 | Keyboard | Periferal | 150000 | 10 |

Tabel PRODUK menyimpan informasi setiap produk. Atribut `kode_produk` menjadi primary key (PK) yang mengidentifikasi setiap produk secara unik. Nama, kategori, harga, dan stok produk disimpan dalam tabel ini agar informasi produk tidak perlu diulang pada setiap pesanan.

**4. Tabel DETAIL_PESANAN**

| no_pesanan (PK, FK) | kode_produk (PK, FK) | jumlah_produk | harga_saat_transaksi |
|---|---|---|---|
| ORD-001 | PRD-001 | 2 | 150000 |

Tabel DETAIL_PESANAN menyimpan rincian produk dalam setiap pesanan. Primary key (PK) gabungan terdiri dari `no_pesanan` dan `kode_produk`. Kedua atribut tersebut juga menjadi foreign key (FK) yang menghubungkan tabel DETAIL_PESANAN dengan tabel PESANAN dan PRODUK. Atribut `jumlah_produk` menyimpan kuantitas produk, sedangkan `harga_saat_transaksi` menyimpan harga produk saat pesanan dilakukan sesuai aturan bisnis AB-03.

Keterangan:

- Tabel PELANGGAN menyimpan informasi setiap pelanggan.
- Tabel PESANAN menyimpan informasi transaksi pesanan dan menggunakan id_pelanggan sebagai FK.
- Tabel PRODUK menyimpan identitas produk.
- Tabel DETAIL_PESANAN menyimpan produk yang dipesan, jumlah, dan harga produk saat transaksi.
- Pemisahan data pelanggan membantu mencegah pengulangan nama, email, nomor telepon, dan alamat pelanggan pada banyak pesanan.

Dengan pemisahan tersebut, atribut nonkunci ditempatkan pada tabel sesuai dengan ketergantungan fungsionalnya. Rancangan ini telah memenuhi prinsip 3NF berdasarkan ketergantungan yang telah diidentifikasi, dengan asumsi setiap tabel memiliki kunci yang sesuai.

## 7. Functional Dependency (FD)

Functional Dependency (FD) menunjukkan hubungan ketergantungan antara atribut dalam suatu tabel. Atribut di sebelah kiri menentukan nilai atribut di sebelah kanan.

1. `no_pesanan → tanggal_pesanan, id_pelanggan, ongkos_kirim, alamat_pengiriman`
   
   Nomor pesanan menentukan tanggal pesanan, pelanggan, ongkos kirim, dan alamat pengiriman.

2. `id_pelanggan → nama_pelanggan, email_pelanggan, no_hp_pelanggan, alamat_pelanggan`
   
   ID pelanggan menentukan informasi identitas pelanggan.

3. `kode_produk → nama_produk, kategori_produk, harga_produk, stok_produk`
   
   Kode produk menentukan informasi produk.

4. `(no_pesanan, kode_produk) → jumlah_produk, harga_saat_transaksi`

   Gabungan nomor pesanan dan kode produk menentukan jumlah serta harga produk saat transaksi. Ketergantungan ini menggunakan asumsi bahwa satu produk hanya dicatat satu kali dalam satu pesanan.

## 8. Pemeriksaan Boyce-Codd Normal Form (BCNF)

BCNF terpenuhi apabila setiap determinan dalam ketergantungan fungsional merupakan superkey.

| Tabel | Determinan | Keterangan |
|---|---|---|
| PELANGGAN | id_pelanggan | Merupakan primary key dan menentukan atribut pelanggan lainnya. |
| PESANAN | no_pesanan | Merupakan primary key dan menentukan atribut pesanan lainnya. |
| PRODUK | kode_produk | Merupakan primary key dan menentukan atribut produk lainnya. |
| DETAIL_PESANAN | (no_pesanan, kode_produk) | Merupakan primary key gabungan yang menentukan jumlah dan harga produk saat transaksi. |

Berdasarkan ketergantungan fungsional yang telah diidentifikasi, seluruh determinan merupakan superkey pada tabel masing-masing. Dengan demikian, skema memenuhi BCNF berdasarkan ketergantungan fungsional yang diasumsikan.

## 9. Keputusan Penyimpanan Nilai Turunan

Nilai turunan adalah nilai yang dapat dihitung dari atribut lain. Pada sistem Toko Serba Digital SDN, keputusan penyimpanan nilai turunan adalah sebagai berikut.

| Nilai | Rumus | Keputusan | Alasan |
|---|---|---|---|
| Subtotal | Jumlah seluruh `jumlah_produk × harga_saat_transaksi` | Tidak disimpan sebagai atribut terpisah | Subtotal dapat dihitung dari detail pesanan. |
| Diskon | 1% × subtotal | Tidak disimpan sebagai atribut terpisah | Diskon dapat dihitung berdasarkan aturan bisnis AB-10. |
| Total pembayaran | Subtotal − diskon + ongkos kirim | Tidak disimpan sebagai atribut terpisah | Total dapat dihitung dari subtotal, diskon, dan ongkos kirim. |

Harga saat transaksi tetap disimpan dalam tabel DETAIL_PESANAN sesuai aturan bisnis AB-03. Ongkos kirim tetap disimpan dalam tabel PESANAN sesuai aturan bisnis AB-04. Dengan demikian, perhitungan menggunakan harga transaksi dan ongkos kirim yang terkait dengan pesanan tersebut.

## 10. Skema Relasional Akhir

Skema relasional akhir hasil normalisasi sistem Toko Serba Digital SDN adalah sebagai berikut.

1. **PELANGGAN**

   `PELANGGAN(id_pelanggan PK, nama_pelanggan, email_pelanggan, no_hp_pelanggan, alamat_pelanggan)`

2. **PESANAN**

   `PESANAN(no_pesanan PK, tanggal_pesanan, id_pelanggan FK, ongkos_kirim, alamat_pengiriman)`

3. **PRODUK**

   `PRODUK(kode_produk PK, nama_produk, kategori_produk, harga_produk, stok_produk)`

4. **DETAIL_PESANAN**

   `DETAIL_PESANAN(no_pesanan PK/FK, kode_produk PK/FK, jumlah_produk, harga_saat_transaksi)`

**Relasi antartabel:**

- `PESANAN.id_pelanggan` mereferensikan `PELANGGAN.id_pelanggan`.
- `DETAIL_PESANAN.no_pesanan` mereferensikan `PESANAN.no_pesanan`.
- `DETAIL_PESANAN.kode_produk` mereferensikan `PRODUK.kode_produk`.

**Catatan:** Primary key DETAIL_PESANAN merupakan gabungan `no_pesanan` dan `kode_produk`, dengan asumsi produk yang sama hanya dicatat satu kali dalam satu pesanan.

## 11. Kesimpulan

Berdasarkan analisis data Toko Serba Digital SDN, normalisasi dilakukan untuk mengurangi anomali penyisipan, perubahan, dan penghapusan data.

Proses normalisasi dari bentuk tidak normal (UNF) hingga bentuk normal ketiga (3NF) menghasilkan empat tabel utama, yaitu PELANGGAN, PESANAN, PRODUK, dan DETAIL_PESANAN. Setiap tabel memiliki primary key (PK), sedangkan foreign key (FK) digunakan untuk menghubungkan tabel yang saling berelasi.

Ketergantungan fungsional digunakan untuk menjelaskan hubungan antaratribut dan memeriksa bentuk normal. Berdasarkan ketergantungan fungsional yang diasumsikan, skema hasil normalisasi juga memenuhi BCNF.

Nilai subtotal, diskon, dan total pembayaran dapat dihitung berdasarkan data transaksi. Harga saat transaksi dan ongkos kirim tetap disimpan agar perhitungan menggunakan nilai yang sesuai dengan pesanan.

Skema akhir perlu disesuaikan dengan ERD dan aturan bisnis Toko Serba Digital SDN agar konsisten dengan kebutuhan sistem.