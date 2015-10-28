%===========================%
%		BOARD CLASS			%
%===========================%

%		------- %
% #includes		%
%		------- %

:- include('point.pl').
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

isTwopiece(Symbol):-
	isRing(Symbol, _), isDisc(Symbol, _).

isEmpty(Symbol):-
	Symbol is 0.

ligacaoRing(StartX-StartY, EndX-EndY, Board):-
	isNeighbour(StartX, StartY, EndX, EndY),
	getSymbol(StartX, StartY, Board, Source),
	getSymbol(EndX, EndY, Board, Destination),
	isRing(Source, Color),
	isRing(Destination, Color).

ligacaoDisc(StartX-StartY, EndX-EndY, Board):-
	isNeighbour(StartX, StartY, EndX, EndY),
	getSymbol(StartX, StartY, Board, Source),
	getSymbol(EndX, EndY, Board, Destination),
	isDisc(Source, Color),
	isDisc(Destination, Color).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sameRow(From, To):- To is From + 1.
sameRow(From, To):- To is From - 1.

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

isNeighbour(FromX, FromY, FromX, ToY):-
	sameRow(FromY, ToY),
	ToY > 0, ToY < 8.

isNeighbour(FromX, FromY, ToX, FromY):-
	sameRow(FromX, ToX),
	ToX > 0, ToX < 8.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

playerOwnsBoth(X, Y, Board, Player):-
	getSymbol(X, Y, Board, Symbol),
	getPlayerColor(Player, Color),
	isRing(Symbol, Color),
	isDisc(Symbol, Color).

playerOwnsDisc(X, Y, Board, Player):-
	getSymbol(X, Y, Board, Symbol),
	getPlayerName(Player, PlayerName),
	getPlayerColor(PlayerName, Color),
	isDisc(Symbol, Color).

playerOwnsRing(X, Y, Board, Player):-
	getSymbol(X, Y, Board, Symbol),
	getPlayerName(Player, PlayerName),
	getPlayerColor(PlayerName, Color),
	isRing(Symbol, Color).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

isTopWall(X, _) :- X is 0.
isBottomWall(X, _, Length) :- X is Length.
isLeftWall(_, Y) :- Y is 0.
isRightWall(_, Y, Length) :- Y is Length.

checkPath(X, Y, Board, Length):-
	getSymbol(X, Y, Board, Symbol),
	isRing(Symbol, Color),
	checkPathRing(X, Y, Board, Color, 0),
	checkPathRing(X, Y, Board, Color, Length).

checkPath(X, Y, Board, Length):-
	getSymbol(X, Y, Board, Symbol),
	isDisc(Symbol, Color),
	checkPathDisc(X, Y, Board, Color, 0),
	checkPathDisc(X, Y, Board, Color, Length).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%