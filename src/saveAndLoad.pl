saveGame:-
    gameStarted,
    nl,
    
    write('Masukkan nama file penyimpanan: '),
    read(FileName),

saveGame:-
    nl,
    
    write('Belum ada permainan yang berjalan.'),
    nl.

loadGame:-
    nl,
    
    write('Masukkan nama file yang akan dimuat: '),
    read(FileName),
