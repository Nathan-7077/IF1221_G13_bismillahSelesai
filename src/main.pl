:- include('card.pl').
:- include('turn.pl').
:- include('startGame.pl').

:- initialization(main).

main :-
    write('\n Ketik "mulaiUNI." untuk memulai permainan UNI. \n >> '),
    read(Command),
    (
        Command = 'mulaiUNI' ->
        startGame
        ;
        Command = 'exit' ->
        fail
        ;
        main
    ).
