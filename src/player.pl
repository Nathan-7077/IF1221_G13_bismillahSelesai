:- dynamic(player/1).
:- dynamic(cards/2).
:- dynamic(points/2).
:- dynamic(currentPlayer/1).
:- dynamic(playerOrder/2).
:- dynamic(numPlayers/1).
:- dynamic(saidUni/1).

% inisialisasi pemain pertama
initializeFirstPlayer :-
    playerOrder(1,Player),
    assertz(currentPlayer(Player)).

% get player selanjutnya
getNextPlayer(Current,Next) :-
    playerOrder(Index,Current),
    numPlayers(Max),
    NextIndex is (Index mod Max)+1,
    playerOrder(NextIndex,Next).

% ganti giliran
passTurn :-
    currentPlayer(Current),
    getNextPlayer(Current,Next),
    retract(currentPlayer(Current)),
    assertz(currentPlayer(Next)).

% tampilkan daftar pemain
displayPlayers :-
    nl,
    write('===== DAFTAR PEMAIN ====='),
    nl,
    tampilPlayer(1).

tampilPlayer(I) :-
    numPlayers(N),
    I>N,
    !.

tampilPlayer(I) :-
    playerOrder(I,Player),
    write(I),
    write('. '),
    write(Player),
    nl,

    I2 is I+1,
    tampilPlayer(I2).
