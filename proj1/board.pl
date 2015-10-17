%===========================%
%		BOARD CLASS			%
%===========================%

%		------- %
% #factos 		%
%		------- %

testMatrix([
	[0, 1, 2, 1, 0, 0, 0],
	[0, 1, 2, 8, 9, 0, 5],
	[0, 1, 2, 4, 2, 5, 0],
	[6, 4, 0, 1, 2, 0, 0],
	[0, 1, 2, 0, 10, 0, 6],
	[0, 1, 2, 10, 2, 0, 0],
	[5, 1, 9, 1, 2, 0, 6]
]).

createSinglePiece(disc, black, 1).
createSinglePiece(disc, white, 2).
createSinglePiece(ring, black, 4).
createSinglePiece(ring, white, 8).

%		------- %
% #predicados 	%
%		------- %

isDisc(Symbol, black):- 
	Symbol < 16, 1 is Symbol /\ 3.
isDisc(Symbol, white):- 
	Symbol < 16, 2 is Symbol /\ 3.

isRing(Symbol, black):- 
	Symbol < 16, 4 is Symbol /\ 12.
isRing(Symbol, white):- 
	Symbol < 16, 8 is Symbol /\ 12.

isTwopiece(Symbol):- 
	isRing(Symbol, _), isDisc(Symbol, _).

isNeighbour(FromX, FromY, ToX, ToY):-
	FromX \= ToX,
	abs(FromX - ToX) =< 1,
	abs(FromY - ToY) =< 1.

isNeighbour(FromX, FromY, ToX, ToY):-
	FromY \= ToY,
	abs(FromX - ToX) =< 1,
	abs(FromY - ToY) =< 1.

removeDisc(Symbol, Color, NewSymbol):-  
	isDisc(Symbol, Color),
	createSinglePiece(disc, Color, Toggle),
	NewSymbol is Symbol /\ \(Toggle).

removeRing(Symbol, Color, NewSymbol):-
	isRing(Symbol, Color),
	createSinglePiece(ring, Color, Toggle),
	NewSymbol is Symbol /\ \(Toggle).

insertRing(Destination, Source, NewSymbol) :-
	isRing(Source, _),
	\+isTwopiece(Destination),
	isDisc(Destination, _),
	NewSymbol is Destination \/ Source.

insertDisc(Destination, Source, NewSymbol) :-
	isDisc(Source, _),
	\+isTwopiece(Destination),
	isRing(Destination, _),
	NewSymbol is Destination \/ Source.

moveRing(FromX, FromY, ToX, ToY, Board, NewBoard):-
	isNeighbour(FromX, FromY, ToX, ToY),
	matrix_at(ToX, ToY, Board, Destination),
	matrix_at(FromX, FromY, Board, Source),
	insertRing(Destination, Source, NewDestination),
	matrix_move(FromX, FromY, ToX, ToY, NewDestination, Board, NewBoard).

moveDisc(fromX, fromY, toX, toY, Board, NewBoard):-
	isNeighbour(FromX, FromY, ToX, ToY),
	matrix_at(ToX, ToY, Board, Destination),
	matrix_at(FromX, FromY, Board, Source),
	insertDisc(Destination, Source, NewDestination),
	matrix_move(FromX, FromY, ToX, ToY, NewDestination, Board, NewBoard).

canPlaceRing(playerStatus(Name, NumberDiscs, NumberRings)):-
	playerStatus(Name, NumberDiscs, NumberRings),
	NumberRings > 0.

canPlaceDisc(playerStatus(Name, NumberDiscs, NumberRings)):-
	playerStatus(Name, NumberDiscs, NumberRings),
	NumberDiscs > 0.

placeRing(X, Y, Color, Board, NewBoard):-
	matrix_at(X, Y, Board, Destination),
	Destination is 0,
	createSinglePiece(ring, Color, Symbol),
	matrix_set(X, Y, Symbol, Board, NewBoard).

placeDisc(X, Y, Color, Board, NewBoard):-
	matrix_at(X, Y, Board, Destination),
	Destination is 0,
	createSinglePiece(disc, Color, Symbol),
	matrix_set(X, Y, Symbol, Board, NewBoard).