:- include('startGame.pl').
:- include('turn.pl').
:- include('endGame.pl').
:- include('saveAndLoad.pl').

:- initialization(main).

main :-
    write('\n Ketik "mulaiUNI." untuk memulai permainan UNI. \n'),
    write('>> '),
    read(Command),
    (
        Command = mulaiUNI
        ->
        (
            startGame
        )
        ;
        Command = exit
        ->
        halt
        ;
        write('Command tidak valid!'),
        nl,
        main
    ).
