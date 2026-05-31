
# IF1221 - Tugas Besar Logika Komputasional

## Daftar Isi
- [Gambaran Singkat](#gambaran-singkat)
- [Cara Menjalankan Program](#cara-menjalankan-program)
- [Struktur Repository](#struktur-repository)
- [Daftar Fitur Utama](#daftar-fitur-utama)
- [Anggota dan Pembagian Tugas](#anggota-dan-pembagian-tugas)

## Gambaran Singkat
Program berupa implementasi game bernama “UNI” dengan menggunakan GNU Prolog. Implementasi yang dibuat mengandung berbagai materi prolog yang telah diajarkan seperti deklarasi fakta dan rules, rekursi, list, file eksternal, penggunaan cut dan fail, dan materi-materi lain yang telah diajarkan di kelas Logika Komputasional IF1221.	

## Cara Menjalankan Program
###Prasyarat:  
   - Install [GNU Prolog](http://www.gprolog.org/#download).
   - 
###Menjalankan Program
**Windows (Command Prompt / PowerShell):**
```bash
gprolog --consult-file src/main.pl
```

**Linux / Mac:**
```bash
gprolog --consult-file src/main.pl
```

### Memulai Permainan
Setelah program berjalan, ketik perintah berikut di prompt `| ?-`:
```prolog
| ?- startGame.
```
## Struktur Repository
```text
.
├── docs/
|   ├── Milestone1_G13.pdf  # Laporan Milestone 1
│   ├── Milestone2_G13.pdf  # Laporan Milestone 2
│   └── Laporan             # Laporan Akhir
├── src/                     
│   ├── card.pl             # 
│   ├── endGame.pl          # 
│   ├── gameLogic.pl        #
│   ├── main.pl             #
│   ├── player.pl           #
│   ├── saveAndLoad.pl      #
│   ├── startGame.pl        #
│   ├── turn.pl             #
│   └── utils.pl            #
│
└── README.md               # Dokumentasi Projek
```
## Daftar Fitur Utama
| Command | Deskripsi |
|---|---|
|`mulaiUNI`| Memulai permainan UNI|
| `lihatCommand` | Menampilkan daftar command |
| `cekInfo` | Mengecek status aktif permainan |
| `lihatKartu ` | Mengecek kartu yang dimiliki pemain |
| `mainkanKartu` | Memainkan kartu |
| `uni` | Menyerukan UNI |
| `tantang` | Menantang penggunaan wild draw four |
| `tangkap` | Menangkap pemain yang tidak menyerukan UNI |
| `sembunyikanKartu` | Menyembunyikan kartu dari cek info |
| `tampilkanKartu ` | Menampilkan kartu yang disembunyikan |
---
## Anggota dan Pembagian Tugas
|Nama|NIM|Tugas|
|---|---|---|
|Faishal Ahmad Nurdin|13525027 |DDDDDDDDDDDDDD|
|Aditya Rasyid|13525039|DDDDDDDDD|
|Nathaniel Marvelo|13525107 |DDDDDDDDD|
|Abdur Rauuf Fawaaz|13525117|DDDDDDDDDD|
---
