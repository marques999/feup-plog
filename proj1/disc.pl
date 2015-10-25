%===========================%
%		  DISC CLASS		%
%===========================%

%		------- %
% #predicados 	%
%		------- %

isDisc(Symbol, black):-
	Symbol < 16, 1 is Symbol /\ 3.
isDisc(Symbol, white):-
	Symbol < 16, 2 is Symbol /\ 3.

insertDisc(Destination, Source, NewSymbol) :-
	isDisc(Source, _),
	\+isTwopiece(Destination),
	NewSymbol is Destination \/ Source.

removeDisc(Symbol, Color, NewSymbol):-
	isDisc(Symbol, Color),
	createSinglePiece(disc, Color, Toggle),
	NewSymbol is Symbol /\ \(Toggle).

canMoveDisc(FromX, FromY, ToX, ToY, Board):-
	isNeighbour(FromX, FromY, ToX, ToY),
	getSymbol(FromX, FromY, Board, Source),
	isDisc(Source, _),
	getSymbol(ToX, ToY, Board, Destination),
	isRing(Destination, _).

moveDisc(FromX, FromY, ToX, ToY, Board, NewBoard):-
	getSymbol(ToX, ToY, Board, Destination),
	getSymbol(FromX, FromY, Board, Source),
	insertDisc(Destination, Source, NewDestination),
	moveSymbol(FromX, FromY, ToX, ToY, NewDestination, Board, NewBoard).

canPlaceDisc(Board, X, Y):-
	getSymbol(X, Y, Board, Destination),
	isEmpty(Destination).

canPlaceDisc(Board, X, Y):-
	getSymbol(X, Y, Board, Destination),
	isRing(Destination, _).

placeDisc(X, Y, Color, Board, NewBoard):-
	getSymbol(X, Y, Board, Destination),
	createSinglePiece(disc, Color, Source),
	insertDisc(Destination, Source, Symbol),
	setSymbol(X, Y, Symbol, Board, NewBoard).