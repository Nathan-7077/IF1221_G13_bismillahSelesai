/* data dasar */

warna([merah, kuning, hijau, biru]).

jenis_aksi([skip, reverse, draw_two]).
jenis_wild([wild, wild_draw_four]).

angka([0,1,2,3,4,5,6,7,8,9]).


/* rule kartu */

kartu(kartu(Warna, angka, Nilai)) :-
    warna(ListWarna),
    member(Warna, ListWarna),

    angka(ListAngka),
    member(Nilai, ListAngka).

kartu(kartu(Warna, Jenis, none)) :-
    warna(ListWarna),
    member(Warna, ListWarna),

    jenis_aksi(ListJenis),
    member(Jenis, ListJenis).

kartu(kartu(hitam, Jenis, none)) :-
    jenis_wild(ListWild),
    member(Jenis, ListWild).
