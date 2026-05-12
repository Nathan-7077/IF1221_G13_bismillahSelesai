/* data dasar */
warna(merah).
warna(kuning).
warna(hijau).
warna(biru).
jenis(skip).
jenis(reverse).
jenis(draw_two).
jenis(wild).
jenis(wild_draw_four).
jenis(0).
jenis(1).
jenis(2).
jenis(3).
jenis(4).
jenis(5).
jenis(6).
jenis(7).
jenis(8).
jenis(9).


/* rule kartu */
% kartu biasa & aksi
kartu(Warna, Jenis) :-
    warna(Warna),
    jenis(Jenis),
    Jenis \= wild,
    Jenis \= wild_draw_four.
% kartu wild
kartu(hitam, wild).
kartu(hitam, wild_draw_four).
