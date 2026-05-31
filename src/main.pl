:- include('startGame.pl').
:- include('turn.pl').
:- include('endGame.pl').
:- include('saveAndLoad.pl').

:- initialization(main).

main :-
    write('\nKetik "startGame." untuk memulai permainan UNI. \n'),
    write('>> '),
    read(Command),
    (
        Command = startGame
        ->
        (
            nl,
            write('SELAMAT DATANG DI PERMAINAN UNI S1GMA!'), nl,nl,
            startGame, !
        )
        ;
        Command = exit
        ->
        halt, !
        ;
        write('Command tidak valid!'),
        nl,
        main
    ).
