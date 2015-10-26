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

getPieceColor(X, Y, Player, Board):-
	getSymbol(X, Y, Board, Symbol),
	getPlayerColor(Player, Color),
	isDisc(Symbol, Color).

getPieceColor(X, Y, Player, Board):-
	getSymbol(X, Y, Board, Symbol),
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