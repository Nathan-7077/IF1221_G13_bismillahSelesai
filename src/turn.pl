:- include('gameLogic.pl').
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
    printLihat(Hand, 1).
printLihat([], _):- !.
printLihat([kartu(Warna, Jenis)| Sisa], Index):-
    write(Index), write('. '), write(Warna), write('-'), write(Jenis),nl,
    Index2 is Index + 1,
    printLihat(Sisa, Index2).

cekInfo:-
    discardPile([kartu(Warna, Jenis)|_]),
    write('Kartu discard top: '),
    write(Warna), write('-'), write(Jenis), write('.'), nl,
    nl,
    write('Urutan pemain: '),
    printPemain
    


