:- include('card.pl').
:- include('player.pl').
:- include('gameLogic.pl').
:- include('startGame.pl').
:- include('turn.pl').
:- include('endGame.pl').

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
