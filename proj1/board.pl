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
	[6, 4, 1, 1, 2, 0, 0],
	[0, 2, 2, 1, 10, 0, 6],
	[0, 1, 2, 10, 5, 0, 0],
	[5, 1, 9, 1, 2, 5, 6]
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

isTopWall(X, _) :- X is 0.
isBottomWall(X, _, Length) :- X is Length.
isLeftWall(_, Y) :- Y is 0.
isRightWall(_, Y, Length) :- Y is Length.

checkPath(X, Y, Board, Length):-
	matrix_at(X, Y, Board, Symbol),
	isRing(Symbol, Color),
	checkPathRing(X, Y, Board, Color, Length).

checkPath(X, Y, Board, Length):-
	matrix_at(X, Y, Board, Symbol),
	isDisc(Symbol, Color),
	checkPathDisc(X, Y, Board, Color, Length).

checkPathDisc(Length, _, _, _, Length).
checkPathDisc(_, Length, _, _, Length).
checkPathDisc(0, _, _, _, _).
checkPathDisc(_, 0, _, _, _).

checkPathDisc(X, Y, _, _, _):-
	X =< 0, Y =< 0, !.

checkPathDisc(X, Y, Board, _, Color, _):-
	matrix_at(X, Y, Board, Symbol),
	\+isDisc(Symbol, Color), !.

checkPathDisc(X, Y, Board, Color, Length):-
	X > 0, Y > 0,
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

checkPathRing(Length, _, _, _, Length).
checkPathRing(_, Length, _, _, Length).
checkPathRing(0, _, _, _, _).
checkPathRing(_, 0, _, _, _).

checkPathRing(X, Y, _, _, _):-
	X =< 0, Y =< 0, !.

checkPathRing(X, Y, Board, _, Color, _):-
	matrix_at(X, Y, Board, Symbol),
	\+isRing(Symbol, Color), !.
	
checkPathRing(X, Y, Board, Color, Length):-
	XP1 is X + 1,
	XM1 is X - 1,
	YP1 is Y + 1,
	YM1 is Y - 1,
	checkPathRing(XP1, YP1, Board, Color, Length),
	checkPathRing(XM1, YP1, Board, Color, Length),
	checkPathRing(XP1, YM1, Board, Color, Length),
	checkPathRing(XM1, YM1, Board, Color, Length),
	checkPathRing(XP1, Y, Board, Color, Length),
	checkPathRing(XM1, Y, Board, Color, Length),
	checkPathRing(X, YP1, Board, Color, Length),
	checkPathRing(X, YM1, Board, Color, Length).