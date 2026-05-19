:- include('card.pl').
:- include('player.pl').


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

efekTerakhir([kartu(|Tail], Efek) :-
    ()

efekReverse :- 
    numPlayers(Max),
    balikUrutan(1, Max),
    write('Urutan pemain dibalik!'), nl.

efekSkip :- 
    passTurn,
    write('Pemain berikutnya kehilangan giliran'), nl.

efekDrawTwo :-
currentPlayer(Player),
    ambilKartuUmum(Player, 2, _),
    write('Pemain berikutnya mengambil dua kartu'), nl,
    passTurn.

efekWild :- 
    write('Pilih warna kartu yang diinginkan (hijau/kuning/biru/merah): '), 
    read(WarnaNew), 
    jadiTop(kartu(WarnaNew, _)),
    write('Kartu paling atas sekarang berwarna '), write(WarnaNew), nl.

efekDrawFour :-  
    currentPlayer(Player),
    write('Tantang '), write(Player), write(' (Ya/Tidak)? '),
    read(Konfirmasi),
    (Konfirmasi == Ya ->
    tantang
    ;
    Konfirmasi == Tidak ->
    passTurn,
    currentPlayer(NextPlayer)
    ambilKartuUmum(NextPlayer, 4, _)).

efekMimic :-



