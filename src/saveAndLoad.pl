saveGame:-
    gameStarted,
    nl,

    write('Masukkan nama file penyimpanan: '),
    read(FileName),

    tell(FileName),
    listing(player),
    listing(cards),
    listing(points),
    listing(currentPlayer),
    listing(playerOrder),
    listing(numPlayers),
    listing(discardPile),
    listing(gameStarted),
    told,
    nl,
    
    write('Status permainan berhasil disimpan ke '),
    write(FileName),
    write('.'),
    nl,
    
    !.

saveGame:-
    nl,
    
    write('Belum ada permainan yang berjalan.'),
    nl.

loadGame:-
    nl,
    write('Masukkan nama file yang akan dimuat: '),
    read(FileName),

    retractall(player(_)),
    retractall(cards(_,_)),
    retractall(points(_,_)),
    retractall(currentPlayer(_)),
    retractall(playerOrder(_,_)),
    retractall(numPlayers(_)),
    retractall(discardPile(_)),
    retractall(gameStarted),
    retractall(finalScore(_,_)),
    consult(FileName),
    nl,
    
    write('Status permainan berhasil dimuat dari '),
    write(FileName),
    write('.'),
    nl,

    currentPlayer(Player),
    write('Melanjutkan giliran '),
    write(Player),
    write('.'),
    nl,nl.
