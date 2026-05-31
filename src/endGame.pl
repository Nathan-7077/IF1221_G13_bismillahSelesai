:- dynamic(finalScore/2).
:- dynamic(tempScore/2).

% tampilan pas endgame
endGame :-
    player(Winner),
    cards(Winner,[]),
    nl,

    write('Permainan selesai! '),
    write(Winner),
    write(' menghabiskan semua kartunya!'),
    nl,nl,

    hitungSemuaPoin,
    tampilRanking,
    nl,

    write('Selamat, '),
    write(Winner),
    write(' menjadi pemenang!'),
    nl,
    !.

% output poin pemain
hitungSemuaPoin :-
    retractall(finalScore(_,_)),
    nl,

    write('Berikut perhitungan poin sisa kartu.'),
    nl,

    player(P),
    cards(P,Cards),
    hitungPoin(Cards,Total),
    assertz(finalScore(P,Total)),

    write(P),
    write(': '),

    tampilKartu(Cards),

    write(' = '),
    write(Total),
    write(' poin'),
    nl,
    fail.

hitungSemuaPoin.


% hitung poin
hitungPoin([],0).

hitungPoin([K|T],Total) :-
    nilaiKartu(K,Nilai),
    hitungPoin(T,Sisa),
    Total is Nilai + Sisa.


% nilai tiap kartu
nilaiKartu(kartu(_,Angka),Angka):-
    integer(Angka).

nilaiKartu(kartu(_,skip),10).
nilaiKartu(kartu(_,reverse),10).
nilaiKartu(kartu(_,draw_two),10).
nilaiKartu(kartu(hitam,wild),20).
nilaiKartu(kartu(hitam,wild_draw_four),20).
nilaiKartu(kartu(hitam,mimic),20).


% tampilkan kartu
tampilKartu([]):-
    write('kartu habis'),
    !.

tampilKartu([kartu(W,J)]) :-
    write(W),
    write('-'),
    write(J),
    !.

tampilKartu([kartu(W,J)|T]) :-
    write(W),
    write('-'),
    write(J),
    write(' + '),
    tampilKartu(T).


% tampilkan ranking
tampilRanking :-
    retractall(tempScore(_,_)),

    finalScore(P,S),
    assertz(tempScore(P,S)),
    fail.

tampilRanking :-
    nl,
    write('Urutan pemenang:'),
    nl,

    urutanPlayer(1),

    retractall(tempScore(_,_)).

urutanPlayer(I) :-
    ambilSkorTerkecil(Pemain,Skor),
    !,

    write(I),
    write('. '),
    write(Pemain),
    write(' ('),
    write(Skor),
    write(' poin)'),
    nl,

    retract(tempScore(Pemain,Skor)),

    I2 is I+1,
    urutanPlayer(I2).

urutanPlayer(_).


% cari skor terkecil
ambilSkorTerkecil(Pemain,Skor) :-
    tempScore(Pemain,Skor),
    tidakAdaYangLebihKecil(Skor).

tidakAdaYangLebihKecil(Skor) :-
    \+ (
        tempScore(_,SkorLain),
        SkorLain < Skor
    ).
