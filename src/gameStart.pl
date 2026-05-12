:- include('fakta.pl').
:- dynamic(player/1).
:- dynamic(playerList/1).
:- dynamic(hand/2).
:- dynamic(discardPile/1).
:- dynamic(currentPlayer/1).
:- dynamic(gameStarted/0).

find_card(Template, Goal, List):-
    findall(Template, Goal, List).
startGame:-
    gameStarted, !,
    write('Game sudah dimulai!!'), nl.
startGame:-
    retractall(player(_)),
    retractall(playerList(_)),
    retractall(hand(_, _)),
    retractall(discardPile(_)),
    retractall(currentPlayer(_)),
    retractall(gameStarted),
    initializationPlayer,
    cardDistribution,
    write('Setiap pemain mendapatkan 7 kartu acak.'), nl,
    initializationDiscardPile,
    assertz(gameStarted),
    playerList(PlayerList),
    PlayerList = [First|_],
    assertz(currentPlayer(First)),
    format('Giliran ~w.~n', [First]).

/*Inisialisasi Pemain*/
initializationPlayer:-
    write('Masukkan jumlah pemain: '),
    catch(read(N), _, (write('Input tidak valid. Coba lagi.'), nl, initializationPlayer)),
    (integer(N), N >= 2, N =< 4
    -> inputPlayerName(N, 1, Names),
      shuffle(Names, Shuffled),
      assertz(playerList(Shuffled)),
      write('Urutan pemain: '),
      writeList(Shuffled), write('.'), nl
    ; write('Mohon masukkan angka antara 2 - 4.'), nl,
      initializationPlayer
    ).

/*Validadi keunikan nama pemain*/
readUniqueName(Name):-
    catch(read(Tmp), _, (write('Input tidak valid. Coba lagi.'), nl, readUniqueName(Name))),
    (   player(Tmp)
    -> write('Nama sudah digunakan. Masukkan nama lain: '),
      readUniqueName(Name)
    ; Name = Tmp
    ).
inputPlayerName(0, _, []):- !.
inputPlayerName(N, Num, Names):-
    N > 0,
    format('Masukkan nama pemain ~w: ', [Num]),
    readUniqueName(Name),
    Names = [Name|Rest],
    assertz(player(Name)),
    N1 is N - 1,
    Num1 is Num + 1,
    inputPlayerName(N1, Num1, Rest).
/*Shuffle list (Buat shuffle pemain sama deck kartu entar)*/
shuffle([], []).
shuffle(List, [Elem|Shuffled]):-
    length(List, Len),
    random(0, Len, Index),
    removeElement(Index, List, Elem, Rest),
    shuffle(Rest, Shuffled).

/*Buat hapus elemen berdasar indkes*/
removeElement(0, [H|T], H, T):- !.
removeElement(N, [H|T], Elem, [H|Rest]):-
    N>0,
    N1 is N-1,
    removeElement(N1, T, Elem, Rest).
writeList([]):- !.
writeList([H]):- write(H), !.
writeList([H|T]):-
    format('~w - ', [H]),
    writeList(T).

/*Distribusi Kartu (7 tiap player)*/
cardDistribution:-
    find_card(kartu(W, J), (warna(W), jenis(J)), Deck),
    shuffle(Deck, Shuffled),
    playerList(Players),
    distributeLogic(Players, Shuffled).
distributeLogic([], _).
distributeLogic([P|Ps], Deck):-
    length(Hand, 7),
    append(Hand, Rest, Deck),
    assertz(hand(P, Hand)),
    distributeLogic(Ps, Rest).

/*Discard Pile Logic*/
initializationDiscardPile:-
    find_card(kartu(W, J), (warna(W), jenis(J), integer(J)), Numerics),
    length(Numerics, Len),
    random(0, Len, Index),
    removeElement(Index, Numerics, K, _),
    assertz(discardPile([K])),
    K= kartu(Warna, Jenis),
    format('Kartu discard top: ~w-~w.~n', [Warna, Jenis]).

/*Validasi kartu*/
isCardValid(kartu(wild, drawFour), kartu(wild, drawFour)):-
    !, fail. %Wildfour gaboleh setelah wildfour
isCardValid(kartu(_, drawTwo), kartu(_, drawTwo)):-
    !, fail. %drawtwo gaboleh setelah drawtwo
isCardValid(kartu(Color, _), kartu(Color, _)):- !. %warna harus sama
isCardValid(kartu(_, Type), kartu(_, Type)):-
    Type\= wild,
    Type\= drawFour, !.
isCardValid(kartu(wild, _), _):- !. %jenis atau angka sama

/*Validasi buat yang wild draw four*/
checkDrawFourConstraint(Hand, kartu(CurrentColor, CurrentType)):-
    \+ (
        member(kartu(Color, Type), Hand),
        Color\= wild,
        (
         Color= CurrentColor ;
         Type= CurrentType
        )
    ).


/*Validasi boleh taruh kartu*/
canPlayCard(Player, Card):-
    currentPlayer(Player),
    hand(Player, Hand),
    member(Card, Hand),
    discardPile([Top|_]),
    isCardValid(Card, Top),
    (Card = kartu(wild, drawFour)
    -> checkDrawFourConstraint(Hand, Top)
    ; true
    ).