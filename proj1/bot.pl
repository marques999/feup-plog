%===========================%
%				BOT CLASS					  %
%===========================%

%				------- %
% #factos				%
%				------- %

botMode(random).
botMode(smart).

%				------- %
% #predicados	%
%				------- %

scanNeighbors(FromX-FromY, Lista):-
	findall(ToX-ToY, isNeighbour(FromX, FromY, ToX, ToY), Lista).

scanEmptyCells(Board, Lista):-
	scanMatrix(Board, 1, 1, isEmpty, Lista).

countEmptyCells(Board, Number):-
	scanMatrix(Board, 1, 1, isEmpty, Lista),
	list_size(Lista, Number), !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

botInitialMove(Board, Player, NewBoard, NewPlayer):-
	botRandomPlace(Position),
	random(0, 2, Action),
	Action > 0, !,
	botAction(1, Position, Board, Player, NewBoard, NewPlayer).
botInitialMove(Board, Player, NewBoard, NewPlayer):-
	botRandomPlace(Position),
	botAction(3, Position, Board, Player, NewBoard, NewPlayer).

botRandomMove(Board, Player, NewBoard, NewPlayer):-
	random(1, 5, Number),
	hasDiscs(Player), hasRings(Player), !,
	botRandomAction(Number, Board, Player, NewBoard, NewPlayer).

botSmartMove(Board, Player, Board, Player):-
	write('NOT IMPLEMENTED YET!!!').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% place disc
botAction(1, Position, Board, Player, NewBoard, NewPlayer):-
	botCanPlaceDisc(Position, Board, Player), !,
	getPlayerColor(Player, Color),
	printPlaceAction(disc, Position),
	placeDisc(Position, Color, Board, NewBoard),
	decrementDiscs(Player, NewPlayer).

% place ring
botAction(3, Position, Board, Player, NewBoard, NewPlayer):-
	botCanPlaceRing(Position, Board, Player), !,
	getPlayerColor(Player, Color),
	printPlaceAction(ring, Position),
	placeRing(Position, Color, Board, NewBoard),
	decrementRings(Player, NewPlayer).

% move disc
botAction(2, From, To, Board, Player, NewBoard, Player):-
	botCanMoveDisc(From, To, Board, Player), !,
	printMoveAction(disc, From, To),
	moveDisc(From, To, Board, NewBoard).

% move ring
botAction(4, From, To, Board, Player, NewBoard, Player):-
	botCanMoveRing(From, To, Board, Player),
	printMoveAction(ring, From, To),
	moveRing(From, To, Board, NewBoard).

printPlaceAction(Piece, Position):-
	write('bot placed '),
	write(Piece),
	write(' at position '),
	write(Position), nl.

printMoveAction(Piece, From, To):-
	write('bot moving '),
	write(Piece),
	write(' from position '),
	write(From),
	write(' to position '),
	write(To), nl.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

botRandomAction(1, Board, Player, NewBoard, NewPlayer):-
	botRandomPlace(Position),
	botAction(1, Position, Board, Player, NewBoard, NewPlayer).
	%botSecondRandom(disc, TempBoard, TempPlayer, NewBoard, NewPlayer).
botRandomAction(2, Board, Player, NewBoard, NewPlayer):-
	botRandomSource(Board, disc, Player, From),
	botRandomDestination(From, To),
	botAction(2, From, To, Board, Player, NewBoard, NewPlayer).
	%botSecondRandom(ring, TempBoard, TempPlayer, NewBoard, NewPlayer).
botRandomAction(3, Board, Player, NewBoard, NewPlayer):-
	botRandomPlace(Position),
	botAction(3, Position, Board, Player,NewBoard, NewPlayer).
	%botSecondRandom(disc, TempBoard, TempPlayer, NewBoard, NewPlayer).
botRandomAction(4, Board, Player, NewBoard, NewPlayer):-
	botRandomSource(Board, ring, Player, From),
	botRandomDestination(From, To),
	botAction(4, From, To, Board, Player, NewBoard, NewPlayer).
	%botSecondRandom(disc, TempBoard, TempPlayer, NewBoard, NewPlayer).
botRandomAction(_, Board, Player, NewBoard, NewPlayer):-
	botRandomMove(Board, Player, NewBoard, NewPlayer).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

botSecondRandom(disc, Board, Player, NewBoard, NewPlayer):-
	random(1, 11, Action),
	Action > 5, !,
	botRandomPlace(Position),
	botAction(1, Position, Board, Player, NewBoard, NewPlayer).
botSecondRandom(disc, Board, Player, NewBoard, NewPlayer):-
	botRandomSource(Board, disc, Player, From),
	botRandomDestination(From, To),
	botAction(2, From, To, Board, Player, NewBoard, NewPlayer).
botSecondRandom(ring, Board, Player, NewBoard, NewPlayer):-
	random(1, 11, Action),
	Action > 5, !,
	botRandomPlace(Position),
	botAction(3, Position, Board, Player, NewBoard, NewPlayer).
botSecondRandom(ring, Board, Player, NewBoard, NewPlayer):-
	botRandomSource(Board, ring, Player, From),
	botRandomDestination(From, To),
	botAction(4, From, To, Board, Player, NewBoard, NewPlayer).
botSecondRandom(Piece, Board, Player, NewBoard, NewPlayer):-
	botSecondRandom(Piece, Board, Player, NewBoard, NewPlayer).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

botSmartAction(1, Board, Player, NewBoard, NewPlayer):-
	botRandomPlace(Position),
	botAction(1, Position, Board, Player, NewBoard, NewPlayer).
botSmartAction(2, Board, Player, NewBoard, NewPlayer):-
	botRandomSource(Board, disc, Player, From),
	botRandomDestination(From, To),
	botAction(2, From, To, Board, Player, NewBoard, NewPlayer).
botSmartAction(3, Board, Player, NewBoard, NewPlayer):-
	botRandomPlace(Position),
	botAction(3, Position, Board, Player, NewBoard, NewPlayer).
botSmartAction(4, Board, Player, NewBoard, NewPlayer):-
	botRandomSource(Board, ring, Player, From),
	botRandomDestination(From, To),
	botAction(4, From, To, Board, Player, NewBoard, NewPlayer).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

botCanPlaceDisc(X-Y, Board, Player):-
	hasDiscs(Player),
	countEmptyCells(Board, Tamanho),
	Tamanho < 1, !,
	getSymbol(X, Y, Board, Symbol),
	isRing(Symbol, _),
	canPlaceDisc(Board, X, Y).

botCanPlaceDisc(X-Y, Board, Player):-
	hasDiscs(Player),
	getSymbol(X, Y, Board, Symbol),
	isEmpty(Symbol), !,
	canPlaceDisc(Board, X, Y).

botCanPlaceRing(X-Y, Board, Player):-
	hasRings(Player),
	countEmptyCells(Board, Tamanho),
	Tamanho < 1, !,
	getSymbol(X, Y, Board, Symbol),
	isDisc(Symbol, _),
	canPlaceDisc(Board, X, Y).

botCanPlaceRing(X-Y, Board, Player):-
	hasRings(Player),
	getSymbol(X, Y, Board, Symbol),
	isEmpty(Symbol), !,
	canPlaceRing(Board, X, Y).

botCanMoveRing(FromX-FromY, ToX-ToY, Board, Player):-
	getSymbol(FromX, FromY, Board, Source),
	getSymbol(ToX, ToY, Board, Destination),
	getPlayerColor(Player, Color),
	isRing(Source, Color), !,
	\+isTwopiece(Destination),
	isDisc(Destination, _).

botCanMoveDisc(FromX-FromY, ToX-ToY, Board, Player):-
	getSymbol(FromX, FromY, Board, Source),
	getSymbol(ToX, ToY, Board, Destination),
	getPlayerColor(Player, Color),
	isDisc(Source, Color), !,
	\+isTwopiece(Destination),
	isRing(Destination, _).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

botRandomSource(Board, Piece, Player, Resultado):-
	getPlayerColor(Player, Color),
	botScanMatrix(Board, Piece, Color, Lista), !,
	list_size(Lista, Tamanho),
	TamanhoExtra is Tamanho + 1,
	random(1, TamanhoExtra, Numero),
	list_at(Numero, Lista, Resultado).

botRandomDestination(X-Y, Position):-
	scanNeighbors(X-Y, Lista), !,
	list_size(Lista, Tamanho),
	TamanhoExtra is Tamanho + 1,
	random(1, TamanhoExtra, Number),
	list_at(Number, Lista, Position).

botRandomPlace(X-Y):-
	random(1, 8, X),
	random(1, 8, Y).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

botScanMatrix(Board, disc, black, Lista):-
	scanMatrix(Board, 1, 1, isSingleBlackDisc, Lista).
botScanMatrix(Board, disc, white, Lista):-
	scanMatrix(Board, 1, 1, isSingleWhiteDisc, Lista).
botScanMatrix(Board, ring, black, Lista):-
	scanMatrix(Board, 1, 1, isSingleBlackRing, Lista).
botScanMatrix(Board, ring, white, Lista):-
	scanMatrix(Board, 1, 1, isSingleWhiteRing, Lista).