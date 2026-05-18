:- include('player.pl').

kartuValid(kartu(hitam, wild),_).
kartuValid(kartu(hitam, wild_draw_four), _).
%kartuValid(kartu(hitam, mimic), _). Nyiapin doang buat entar
kartuValid(kartu(Color, _), kartu(Color, _)):-
    Color\=hitam.
kartuValid(kartu(_, Type), kartu(_, Type)):-
    Type \=wild,
    Type \= wild_draw_four.
%Type \= mimic. klo mau pake
%Cek WDF kuilangin, soalnya ternyata bisa dimainkan, cuma kalau dimainkan pemain selanjutnya bisa nantang (sebelumnya di startGame tulisannya gabisa soalnya, baru ngecek td di kelas alpro ternyata dibutuhin buat mekanik tantang)
bisaDimainkan(Player, Card):-
    currentPlayer(Player),
    cards(Player, Hand),
    member(Card, Hand),
    discardPile([Top|_]),
    kartuValid(Card, Top).