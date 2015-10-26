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

checkPathDisc(Length, _, _, _, Length).
checkPathDisc(_, Length, _, _, Length).
checkPathDisc(0, _, _, _, _).
checkPathDisc(_, 0, _, _, _).
checkPathDisc(X, Y, Board, _, Color, _):-
	matrix_at(X, Y, Board, Symbol),
	\+isDisc(Symbol, Color), !.
checkPathDisc(X, Y, Board, Color, Length):-
	XP1 is X + 1,
	XM1 is X - 1,
	YP1 is Y + 1,
	YM1 is Y - 1,
	checkPathDisc(XP1, YP1, Board, Color, Length),
	checkPathDisc(XM1, YP1, Board, Color, Length),
	checkPathDisc(XP1, YM1, Board, Color, Length),
	checkPathDisc(XM1, YM1, Board, Color, Length),
	checkPathDisc(XP1, Y, Board, Color, Length),
	checkPathDisc(XM1, Y, Board, Color, Length),
	checkPathDisc(X, YP1, Board, Color, Length),
	checkPathDisc(X, YM1, Board, Color, Length).