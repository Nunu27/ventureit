# VentureIt

![VentureIt logo](https://pomf2.lain.la/f/hhmj7jdv.png)

## Permasalahan yang ingin diselesaikan

- Membantu dan memudahkan pengguna dalam memutuskan untuk mencari toko terbaik dengan melihat ulasan user lain.
- Membantu UMKM untuk mempromosikan usahanya.
- SDGS 8, 10, 17

## Ide aplikasi:

- Platform pembantu UMKM untuk memasarkan produk mereka menjadi digital dan dapat dijangkau masyarakat dalam bentuk semacam google maps akan tetapi lebih ter-highlight hanya untuk UMKM saja.
- Daily mission untuk UMKM yang memberikan budget promosi.
- Daily mission dikerjakan oleh customer dan mengulas UMKM yang mempromosikan tersebut.

## Use case diagram

### Member diagram

![Member use case diagram](https://pomf2.lain.la/f/mjsgke0m.png)
Terdapat sedikit perubahan dari use case pada Stage 1, yakni pengguna tidak wajib login untuk mengakses halaman _Explore_, tetapi tetap diperlukan untuk halaman lain.

### Admin diagram

![Admin use case](https://pomf2.lain.la/f/saoz1tdh.png)

### Sequence explore

![Explore sequence old](https://pomf2.lain.la/f/g0i3qkwt.png)

Untuk proses filter pada explore terdapat perubahan karena limitasi dari **Firestore** dimana query hanya bisa filter 1 field, sehingga tidak memungkinkan untuk melakukan semua filter secara bersamaan. jadi untuk proses query pada firestore dilakukan filter kategori dan juga jarak pelaku usaha dari lokasi pengguna saat ini. Lalu untuk filter lain, seperti minimal rating, terakhir di update, status buka dan juga pengurutan dilakukan oleh client.

![Explore sequence new](https://pomf2.lain.la/f/f53l1rd.png)

## Teknologi yang digunakan

- **Flutter**
- **Firebase**
- **Google Maps API**

## Screenshot

<table>
  <tr>
    <td>Explore (no location)</td>
    <td>Explore</td>
    <td>Filter<td>
  </tr>
  <tr>
    <td><img src="https://pomf2.lain.la/f/3aszx9nf.jpg" alt="explore no location" width="200"></td>
    <td><img src="https://pomf2.lain.la/f/qdfmslx9.jpg" alt="explore" width="200"></td>
    <td><img src="https://pomf2.lain.la/f/jf9z92.jpg" alt="filter" width="200"></td>
  </tr>  
    <tr>
    <td>Restricted access</td>
    <td>Login</td>
    <td>Register<td>
  </tr>
  <tr>
    <td><img src="https://pomf2.lain.la/f/88ww7er6.jpg" alt="restricted access" width="200"></td>
    <td><img src="https://pomf2.lain.la/f/gwpp2jnm.jpg" alt="login" width="200"></td>
    <td><img src="https://pomf2.lain.la/f/86d55jxt.jpg" alt="register" width="200"></td>
  </tr> 
    <tr>
    <td>Profile</td>
    <td>Edit profile</td>
    <td>Admin dashboard<td>
  </tr>
  <tr>
    <td><img src="https://pomf2.lain.la/f/wjbxg436.jpg" alt="profile" width="200"></td>
    <td><img src="https://pomf2.lain.la/f/vmftifea.jpg" alt="edit profile" width="200"></td>
    <td><img src="https://pomf2.lain.la/f/nn5o6s4.jpg" alt="admin dashboard" width="200"></td>
  </tr>  
</table>

Halaman lainnya masih berupa placeholder

## Permasalahan development

Data saat ini kami ambil dari Google Maps di area Sukolilo Surabaya, dan Tuban.
Permasalahan utama terdapat pada limitasi query pada Firestore yang tidak memungkinkan untuk melakukan query dengan banyak kriteria

## Jawaranya Insinyur

- Faris Muhammad
- Jhiven Agnar Fuad
- Wisnu Agung Pambudi
