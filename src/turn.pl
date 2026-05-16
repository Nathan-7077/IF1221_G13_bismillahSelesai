:- include('gameLogic.pl').
:- include('player.pl').
:- include('card.pl').

lihatCommand:-
    write('Aksi utama yang tersedia:'),nl,
    write('1. ambilKartu'), nl,
    write('2. tantang'), nl,
    nl,
    write('Aksi pendukung yang tersedia:'),nl,
    write('1. lihatCommand'),nl,
    write('2. lihatKartu'),nl,
    write('3. cekInfo'),nl.

lihatKartu:-
    write('Berikut kartu yang anda miliki'),nl,
    currentPlayer(Player),!,
    cards(Player, Hand),
    helperLihat(Hand, 1).
helperLihat([], _):- !.
helperLihat([kartu(Warna, Jenis)| Sisa], Indeks):-
    write(Indeks), write('. '), write(Warna), write('-'), write(Jenis),nl,
    Indeks2 is Indeks + 1,
    helperLihat(Sisa, Indeks2).

printUrutan([]) :-!.
printUrutan([H|[]]) :- !,
    write(H).

printUrutan([H|T]) :-
    write(H), write(' - '),
    printUrutan(T).

infoPemain([],[],_):-!.
infoPemain([H|T],[A|B], Indeks) :-
    hitungKartu(A, Jumlah),
    write('Nama Pemain '), write(Indeks), write(': '), write(H), nl,
    write('Jumlah Kartu : '), write(Jumlah), nl,nl,
    Indeks2 is Indeks+1,
    infoPemain(T,B, Indeks2).
hitungKartu([],0).
hitungKartu([_|Sisa], Jumlah):-
    hitungKartu(Sisa, JumlahSisa),
    Jumlah is JumlahSisa+1.
listPemain(Indeks, []):-
    numPlayers(Max),
    Indeks>Max, !.
listPemain(Indeks, [H|T]):-
    playerOrder(Indeks, H),
    Indeks2 is Indeks+1,
    listPemain(Indeks2, T).
listHand([],[]).
listHand([H|T], [A|B]):-
    cards(H,A),
    listHand(T, B).
cekInfo:-
    discardPile([kartu(Warna, Jenis)| _]),
    write('Kartu discard top: '), write(Warna), write('-'), write(Jenis), write('.'), nl,
    nl,
    listPemain(1, ListPemain),
    write('Urutan pemain: '),
    printUrutan(ListPemain),
    write('.'), nl,
    nl,
    listHand(ListPemain, ListHand),
    infoPemain(ListPemain, ListHand, 1),!.