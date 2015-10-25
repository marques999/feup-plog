%===========================%
%		  RING CLASS		%
%===========================%

%		------- %
% #predicados 	%
%		------- %

isRing(Symbol, black):-
	Symbol < 16, 4 is Symbol /\ 12.
isRing(Symbol, white):-
	Symbol < 16, 8 is Symbol /\ 12.

insertRing(Destination, Source, NewSymbol) :-
	isRing(Source, _),
	\+isTwopiece(Destination),
	NewSymbol is Destination \/ Source.

removeRing(Symbol, Color, NewSymbol):-
	isRing(Symbol, Color),
	createSinglePiece(ring, Color, Toggle),
	NewSymbol is Symbol /\ \(Toggle).

canMoveRing(FromX, FromY, ToX, ToY, Board):-
	isNeighbour(FromX, FromY, ToX, ToY),
	getSymbol(FromX, FromY, Board, Source),
	isRing(Source, _),
	getSymbol(ToX, ToY, Board, Destination),
	isDisc(Destination, _).

moveRing(FromX, FromY, ToX, ToY, Board, NewBoard):-
	getSymbol(ToX, ToY, Board, Destination),
	getSymbol(FromX, FromY, Board, Source),
	insertRing(Destination, Source, NewDestination),
	moveSymbol(FromX, FromY, ToX, ToY, NewDestination, Board, NewBoard).

canPlaceRing(Board, X, Y):-
	getSymbol(X, Y, Board, Destination),
	isEmpty(Destination).

canPlaceRing(Board, X, Y):-
	getSymbol(X, Y, Board, Destination),
	isDisc(Destination, _).

placeRing(X, Y, Color, Board, NewBoard):-
	getSymbol(X, Y, Board, Destination),
	createSinglePiece(ring, Color, Source),
	insertRing(Destination, Source, Symbol),
	setSymbol(X, Y, Symbol, Board, NewBoard).