:- include('card.pl').
:- include('player.pl').

/* balik(List, Hasil) :- 
    balik(List, [], Hasil).

balik([], B, B).
balik([H|T], B, Hasil) :- 
    balik(T, [H|B], Hasil). */

balikUrutan(Max, Max) :-
    playerOrder(Max, Current),
    !,
    retract(playerOrder(Max, Current)),
    assertz(playerOrder(1, Current)).

balikUrutan(Index1, Max) :- 
    Index1 < Max, 
    N is Max - Index1 + 1,
    playerOrder(Index1, Current),
    !,
    retract(playerOrder(Index1, Current)),
    assertz(playerOrder(N, Current)),
    NextIndex is Index1 + 1,
    balikUrutan(NextIndex, Max).


efekReverse :- 
    numPlayers(Max),
    balikUrutan(1, Max),
    write('Urutan pemain dibalik!'), nl.

efekSkip :- 
    passTurn,
    write('Pemain berikutnya kehilangan giliran'), nl.

% efekDrawTwo :-

efekWild :- 
    write('Pilih warna kartu yang diinginkan: '), 
    read(WarnaNew), 
    jadiTop(kartu(WarnaNew, _)),
    write('Kartu paling atas sekarang berwarna '), write(WarnaNew).

% efekDrawFour :-


