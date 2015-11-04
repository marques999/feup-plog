%===========================%
%		BOARD CLASS			%
%===========================%

%		------- %
% #includes             %
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

isEmpty(0).

%		------- %
% #predicados           %
%		------- %

isTwopiece(Symbol):-
	isRing(Symbol, _), 
        isDisc(Symbol, _).

isWhiteSymbol(Symbol):-
        isDisc(Symbol, white).

isWhiteSymbol(Symbol):-
        isRing(Symbol, white).

isBlackSymbol(Symbol):-
        isDisc(Symbol, black).

isBlackSymbol(Symbol):-
        isRing(Symbol, black).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

hasPlayerWon(Board, Player):-
        getPlayerColor(Player, black),
        scanBlackWall(Board, List),
        checkMultiplePaths(List, Board).

hasPlayerWon(Board, Player):-
        getPlayerColor(Player, white),
        scanWhiteWall(Board, List),
        checkMultiplePaths(List, Board).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

checkMultiplePaths([H|_], Board):-
        checkPath(H, Board).

checkMultiplePaths([_|T], Board):-
        checkMultiplePaths(T, Board).

checkPath(X-Y, Board):-
        getSymbol(X, Y, Board, Symbol),
        isDisc(Symbol, Color),
        checkPathDisc(X-Y, 7-7, Board, Color, Lista), !,
        Lista \== [].

checkPath(X-Y, Board):-
	getSymbol(X, Y, Board, Symbol),
	isRing(Symbol, Color),
        checkPathRing(X-Y, 7-7, Board, Color, Lista), !,
        Lista \== [].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

scanMatrix([], _X, _Y, _Predicate, []).
scanMatrix([H|T], X, Y, Predicate, Lista):-
        scanMatrixRow(H, X, Y, Predicate, Row),
        X1 is X + 1,
        scanMatrix(T, X1, Y, Predicate, Resultado),
        append(Row, Resultado, Lista).

scanMatrixRow([], _X, _Y, _Predicate, []).
scanMatrixRow([H|T], X, Y, Predicate, Lista):-
        call(Predicate, H),
        Y1 is Y + 1,
        scanMatrixRow(T, X, Y1, Predicate, Resultado),
        append([X-Y], Resultado, Lista).

scanMatrixRow([_H|T], X, Y, Predicate, Lista):-
        Y1 is Y + 1,
        scanMatrixRow(T, X, Y1, Predicate, Lista).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

scanBlackWall(Board, List):-
        list_at(1, Board, Row), !,
        scanMatrixRow(Row, 1, 1, isBlackSymbol, List).
scanWhiteWall(Board, List):-
        scanWhite(1, 1, Board, List).

scanWhite(8, _Y, _Board, []). 
scanWhite(X, Y, Board, Lista):-
        getSymbol(X, Y, Board, Symbol),
        isWhiteSymbol(Symbol),
        X1 is X + 1,
        scanWhite(X1, Y, Board, NovaLista),
        append([X-Y], NovaLista, Lista).
scanWhite(X, Y, Board, Lista):-
        X1 is X + 1,
        scanWhite(X1, Y, Board, Lista).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%