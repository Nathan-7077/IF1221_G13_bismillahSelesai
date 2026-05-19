:- dynamic(finalScore/2).

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
    nl,
    write('Urutan pemenang:'),
    nl,

    urutanPlayer(1).

urutanPlayer(I) :-
    numPlayers(N),
    I>N,
    !.

urutanPlayer(I) :-
    cariPeringkat(I,Pemain),
    finalScore(Pemain,Skor),

    write(I),
    write('. '),
    write(Pemain),
    write(' ('),
    write(Skor),
    write(' poin)'),
    nl,

    I2 is I+1,
    urutanPlayer(I2).


% cari peringkat pemain
cariPeringkat(N,Pemain) :-
    findall(
        (Skor,Player),
        finalScore(Player,Skor),
        List
    ),
    sort(List,Sorted),
    ambilPeringkat(N,Sorted,Pemain).

ambilPeringkat(1,[(_,P)|_],P).

ambilPeringkat(N,[_|T],P) :-
    N1 is N-1,
    ambilPeringkat(N1,T,P).
