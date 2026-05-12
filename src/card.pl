kartu(wild, _).
kartu(X, Y) :- warna(X), jenis(Y).

warna(['Merah','Biru','Hijau','Kuning']).
jenis([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 'skip', 'reverse', 'draw_two', 'draw_four']).
