%===========================%
%		BOARD CLASS			%
%===========================%

%		------- %
% #includes		%
%		------- %

:- include('list.pl').
:- include('disc.pl').
:- include('ring.pl').

%		------- %
% #factos 		%
%		------- %

createSinglePiece(disc, black, 1).
createSinglePiece(disc, white, 2).
createSinglePiece(ring, black, 4).
createSinglePiece(ring, white, 8).

%		------- %
% #predicados 	%
%		------- %

sameRow(From, To):- To is From - 1.
sameRow(From, To):- To is From + 1.

isTwopiece(Symbol):-
	isRing(Symbol, _), isDisc(Symbol, _).

isEmpty(Symbol):-
	Symbol is 0.

isNeighbour(FromX, FromY, FromX, ToY):-
	sameRow(FromY, ToY),
	ToY > 0, ToY < 8.

isNeighbour(FromX, FromY, ToX, FromY):-
	sameRow(FromX, ToX),
	ToX > 0, ToX < 8.

isNeighbour(FromX, FromY, ToX, ToY):-
	ToX is FromX - 1,
	ToX > 0, ToX < 8, 
	ToY is FromY + 1,
	ToY > 0, ToY < 8.

isNeighbour(FromX, FromY, ToX, ToY):-
	ToX is FromX + 1,
	ToX > 0, ToX < 8, 
	ToY is FromY - 1,
	ToY > 0, ToY < 8.

playerOwnsBoth(X, Y, Board, Player):-
	getSymbol(X, Y, Board, Symbol),
	getPlayerColor(Player, Color),
	isRing(Symbol, Color),
	isDisc(Symbol, Color).

playerOwnsDisc(X, Y, Board, Player):-
	getSymbol(X, Y, Board, Symbol),
	getPlayerColor(Player, Color),
	isDisc(Symbol, Color).

playerOwnsRing(X, Y, Board, Player):-
	getSymbol(X, Y, Board, Symbol),
	getPlayerColor(Player, Color),
	isRing(Symbol, Color).

getPieceColor(X, Y, Player, Board, Symbol):-
	getSymbol(FromX, FromY, Board, Symbol),
	getPlayerColor(Player, Color),
	isDisc(Symbol, Color).

getPieceColor(X, Y, Player, Board, Symbol):-
	getSymbol(FromX, FromY, Board, Symbol),
	getPlayerColor(Player, Color),
	isRing(Symbol, Color).

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

checkPathRing(Length, _, _, _, Length).
checkPathRing(_, Length, _, _, Length).
checkPathRing(0, _, _, _, _).
checkPathRing(_, 0, _, _, _).

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

validMoves(Board, Player, X, Y, List):-
	matrix_at(X, Y, Board, Symbol),
	\+isTwopiece(Symbol).