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

efekTerakhir([], Hasil) :- Hasil = 0.
efekTerakhir([kartu(_, Jenis)|Tail], Hasil) :-
    (Jenis == reverse ->
    efekReverse, !, 
    Hasil = 1,
    fail
    ;
    Jenis == skip ->
    efekJenis, !, 
    Hasil = 1,
    fail
    ;
    Jenis == draw_two ->
    efekDrawTwo, !, 
    Hasil = 1,
    fail
    ;
    efekTerakhir(Tail)).

efekReverse :- 
    numPlayers(Max),
    balikUrutan(1, Max),
    write('Urutan pemain dibalik!'), nl.

efekSkip :- 
    passTurn,
    write('Pemain berikutnya kehilangan giliran'), nl.

efekDrawTwo :-
    passTurn,
    currentPlayer(NextPlayer),
    ambilKartuUmum(NextPlayer, 2, _),
    write('Pemain  '), write(NextPlayer), write(' mengambil dua kartu'), nl.

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
    discardPile(Discard),
    efekTerakhir(Discard, Hasil), 
    (Hasil == 1 ->
    write('Efek mimic aktif'), nl).
    