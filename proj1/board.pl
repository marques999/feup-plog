%===========================%
%		BOARD CLASS			%
%===========================%

%			------- %
% #includes			%
%			------- %

:- include('list.pl').
:- include('disc.pl').
:- include('ring.pl').

%			------- %
% #factos			%
%			------- %

createSinglePiece(disc, black, 1).
createSinglePiece(disc, white, 2).
createSinglePiece(ring, black, 4).
createSinglePiece(ring, white, 8).

isEmpty(0).

%			------- %
% #predicados       %
%			------- %

% verifica se determinada célula contém uma peça dupla
isTwopiece(Symbol):-
	isRing(Symbol, _),
	isDisc(Symbol, _).

% verifica se determinada célula contém uma peça simples
isSinglePiece(Symbol):-
	\+isEmpty(Symbol),
	\+isTwopiece(Symbol).

% verifica se determinada célula contém uma peça simples de cor branca
isSingleWhitePiece(Symbol):-
	isSinglePiece(Symbol),
	isWhiteSymbol(Symbol).

% verifica se determinada célula contém uma peça simples de cor preta
isSingleBlackPiece(Symbol):-
	isSinglePiece(Symbol),
	isBlackSymbol(Symbol).

% verifica se duas células têm peças de tipo diferente
isDifferentSymbol(Source, Destination):-
	isDisc(Source, _),
	isRing(Destination, _).
isDifferentSymbol(Source, Destination):-
	isRing(Source, _),
	isDisc(Destination, _).

% verifica se determinada célula contém uma peça (simples || dupla) de cor branca
isWhiteSymbol(Symbol):-
	isDisc(Symbol, white).
isWhiteSymbol(Symbol):-
	isRing(Symbol, white).

% verifica se determinada célula contém uma peça (simples || dupla) de cor preta
isBlackSymbol(Symbol):-
	isDisc(Symbol, black).
isBlackSymbol(Symbol):-
	isRing(Symbol, black).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% conta o número de discos simples existentes no tabuleiro
countDiscs(Board, Lista, Number):-
	scanMatrix(Board, 1, 1, isSingleDisc, Lista),
	list_size(Lista, Number), !.

% conta o número de anéis simples existentes no tabuleiro
countRings(Board, Lista, Number):-
	scanMatrix(Board, 1, 1, isSingleRing, Lista),
	list_size(Lista, Number), !.

% obtém uma lista com as coordenadas das peças simples de cor preta
scanBlackPieces(Board, Lista):-
	scanMatrix(Board, 1, 1, isSingleBlackPiece, Lista), !.

% conta o número de discos de cor preta existentes no tabuleiro
countBlackDiscs(Board, Number):-
        scanMatrix(Board, 1, 1, isSingleBlackDisc, Lista),
        list_size(Lista, Number), !.
                                  
% conta o número de peças simples de cor preta existentes no tabuleiro
countBlackPieces(Board, Number):-
	scanMatrix(Board, 1, 1, isSingleBlackPiece, Lista),
	list_size(Lista, Number), !.

% conta o número de anéis de cor branca existentes no tabuleiro
countBlackRings(Board, Number):-
        scanMatrix(Board, 1, 1, isSingleBlackRing, Lista),
        list_size(Lista, Number), !.

% obtém uma lista com as coordenadas das peças simples de cor branca
scanWhitePieces(Board, Lista):-
	scanMatrix(Board, 1, 1, isSingleWhitePiece, Lista), !.

% conta o número de discos de cor branca existentes no tabuleiro
countWhiteDiscs(Board, Number):-
        scanMatrix(Board, 1, 1, isSingleWhiteDisc, Lista),
        list_size(Lista, Number), !.

% conta o número de peças simples de cor branca existentes no tabuleiro
countWhitePieces(Board, Number):-
	scanMatrix(Board, 1, 1, isSingleWhitePiece, Lista),
	list_size(Lista, Number), !.

% conta o número de anéis de cor branca existentes no tabuleiro
countWhiteRings(Board, Number):-
        scanMatrix(Board, 1, 1, isSingleWhiteRing, Lista),
        list_size(Lista, Number), !.

% obtém uma lista com as coordenadas das peças simples existentes no tabuleiro
scanSinglePieces(Board, Lista):-
	scanMatrix(Board, 1, 1, isSinglePiece, Lista), !.

% conta o número de células vazias no tabuleiro
countEmptyCells(Board, Number):-
	scanMatrix(Board, 1, 1, isEmpty, Lista),
	list_size(Lista, Number), !.

% obtém uma lista com as coordenadas vizinhas de uma célual do tabuleiro
scanNeighbors(FromX-FromY, Lista):-
        findall(ToX-ToY, isNeighbour(FromX, FromY, ToX, ToY), Lista), !.

% obtém uma lista com as coordenadas e número de celulas vazias no tabuleiro
scanEmptyCells(Board, Lista, Number):-
	scanMatrix(Board, 1, 1, isEmpty, Lista),
	list_size(Lista, Number), !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% verifica se determinado jogador ainda pode fazer jogadas regulares
isPlayerStuck(Board, _):-
	countEmptyCells(Board, NumberEmpty),
	NumberEmpty > 0, !, fail.
isPlayerStuck(Board, _):-
	scanSinglePieces(Board, ListSingle),
	ListSingle == [].

% verifica se o jogador de cor branca ainda pode fazer jogadas regulares
isPlayerStuck(Board, Player):-
	getPlayerColor(Player, white),
	scanSinglePieces(Board, ListSingle),
	scanWhitePieces(Board, ListWhite),
	\+hasMovesLeft(Board, ListWhite, ListSingle).

% verifica se o jogador de cor preta ainda pode fazer jogadas regulares
isPlayerStuck(Board, Player):-
	getPlayerColor(Player, black),
	scanSinglePieces(Board, ListSingle),
	scanBlackPieces(Board, ListBlack),
	\+hasMovesLeft(Board, ListBlack, ListSingle).

% verifica se determinado jogador pode mover alguma peça
hasMovesLeft(Board, ListColored, ListSingle):-
	member(X, ListSingle),
	member(Y, ListColored),
	isNeighbour(X, Y),
	getSymbol(X, Board, Source),
	getSymbol(Y, Board, Destination),
	isDifferentSymbol(Source, Destination).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sameRow(From, To):-
	To is From + 1.
sameRow(From, To):-
	To is From - 1.

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

% determina
isNeighbour(FromX-FromY, ToX-ToY):-
	isNeighbour(FromX, FromY, ToX, ToY).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% verifica se ambas as peças existentes numa célula pertencem a determinado jogador
playerOwnsBoth(X, Y, Board, Player):-
	getSymbol(X, Y, Board, Symbol),
	getPlayerColor(Player, Color),
	isRing(Symbol, Color),
	isDisc(Symbol, Color).

% verifica se um disco existente nuam célula pertence a determinado jogador
playerOwnsDisc(Symbol, Player):-
	getPlayerColor(Player, Color),
	isDisc(Symbol, Color).

% verifica se um anel existente numa pertence a determinado jogador
playerOwnsRing(Symbol, Player):-
	getPlayerColor(Player, Color),
	isRing(Symbol, Color).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% verifica se o jogador de cor preta venceu a partida
hasPlayerWon(Board, Player):-
	getPlayerColor(Player, black),
	scanBlackWall(Board, List), !,
	checkMultiplePaths(List, black, Board).

% verifica se o jogador de cor branca venceu a partida
hasPlayerWon(Board, Player):-
	getPlayerColor(Player, white),
	scanWhiteWall(Board, List), !,
	checkMultiplePaths(List, white, Board).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% dadas várias posições, verifica se é possível encontrar um caminho
checkMultiplePaths([H|_], Color, Board):-
	checkPath(H, Color, Board).
checkMultiplePaths([_|T], Color, Board):-
	checkMultiplePaths(T, Color, Board).

checkPath(X-Y, Color, Board):-
	getSymbol(X, Y, Board, Symbol),
	isDisc(Symbol, Color),
	checkPathDisc(X-Y, 7-7, Board, Color, Lista), !,
	Lista \== [].

checkPath(X-Y, Color, Board):-
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
        list_at(1, Board, Row),
        scanMatrixRow(Row, 1, 1, isBlackSymbol, List), !.
scanWhiteWall(Board, List):-
        scanWhite(1, 1, Board, List), !.

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