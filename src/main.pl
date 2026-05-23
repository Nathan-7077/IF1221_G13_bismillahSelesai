:- include('startGame.pl').
:- include('turn.pl').
:- include('endGame.pl').
:- include('saveAndLoad.pl').

main :-
    nl,
    write('Ketik "mulaiUNI." untuk memulai permainan UNI.'),
    nl,
    write('>> '),
    read(Command),
    (
        Command = mulaiUNI
        ->
        (
            startGame,
            inputCommand
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
