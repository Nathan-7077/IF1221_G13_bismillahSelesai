:- include('card.pl').
:- include('player.pl').

balik(List, Hasil) :- 
    balik(List, [], Hasil).

balik([], B, B).
balik([H|T], B, Hasil) :- 
    balik(T, [H|B], Hasil).

efekReverse :- 
    listPlayer(Awal), 
    balik(Awal, Dibalik), 
    retract(listPlayer(Awal)),
    assertz(listPlayer(Dibalik)),
    listPlayer(X),
    write(X).

efekSkip :- 
    passTurn.

efekDrawTwo :-

efekWild :- 
    write('Pilih warna kartu yang diinginkan: '), 
    read(WarnaNew), 
    retract(topCard(X, Y)),
    assertz(topCard(_, WarnaNew)),
    write('Kartu paling atas sekarang berwarna '), write(WarnaNew).

efekDrawFour :-


