:- dynamic(finalScore/2).

% tampilan pas endgame
endGame :-
    % nyari yang udah abis kartunya
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
% yang juara
hitungPoin([],0).

%yang kalah
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
    write('kartu habis').

tampilKartu([kartu(W,J)]) :-
    write(W),
    write('-'),
    write(J).

tampilKartu([kartu(W,J)|T]) :-
    write(W),
    write('-'),
    write(J),
    write(' + '),
    tampilKartu(T).
