%=======================================%
%               RING CLASS              %
%=======================================%

%                 ------------- %
% #predicados                   %
%                 ------------- %

% verifica se uma determinada c�lula se encontra ocupada por um anel preto
isRing(Symbol, black):-
	4 is Symbol /\ 12.

% verifica se uma determinada c�lula se encontra ocupada por um anel branco
isRing(Symbol, white):-
	8 is Symbol /\ 12.

% verifica se uma determinada c�lula se encontra ocupada por uma pe�a simples (anel preto)
isSingleBlackRing(Symbol):-
	4 is Symbol /\ 15.

% verifica se uma determinada c�lula se encontra ocupada por uma pe�a simples (anel branco)
isSingleWhiteRing(Symbol):-
	8 is Symbol /\ 15.

% verifica se uma determinada c�lula se encontra ocupada por uma pe�a simples (anel qualquer)
isSingleRing(Symbol):-
	isSingleBlackRing(Symbol).
isSingleRing(Symbol):-
	isSingleWhiteRing(Symbol).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% calcula a nova pe�a do tabuleiro ap�s adi��o de um anel
insertRing(Destination, Source, NewSymbol):-
	\+isTwopiece(Destination),
	NewSymbol is Destination \/ Source.

% move um anel para uma c�lula ocupada por um disco
moveRing(FromX-FromY, ToX-ToY, Board, NewBoard):-
	getSymbol(ToX, ToY, Board, Destination),
	getSymbol(FromX, FromY, Board, Source),
	insertRing(Destination, Source, NewDestination),
	moveSymbol(FromX, FromY, ToX, ToY, NewDestination, Board, NewBoard).

% verifica se � poss�vel colocar um anel numa c�lula (situa��o normal de jogo)
canPlaceRing(Board, X, Y):-
	getSymbol(X, Y, Board, Destination),
	isEmpty(Destination).

% verifica se � poss�vel colocar um anel numa c�lula (situa��o excepcional de jogo)
canSpecialRing(Board, X, Y):-
	getSymbol(X, Y, Board, Symbol),
	\+isTwopiece(Symbol),
	isDisc(Symbol, _).

% coloca um anel numa determinada c�lula do tabuleiro
placeRing(X-Y, Color, Board, NewBoard):-
	getSymbol(X, Y, Board, Destination),
	createSinglePiece(ring, Color, Source),
	insertRing(Destination, Source, Symbol),
	setSymbol(X, Y, Symbol, Board, NewBoard).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% verifica se duas c�lulas se encontram ligadas por um anel da mesma cor
connectedRing(StartX-StartY, EndX-EndY, Board):-
	isNeighbour(StartX, StartY, EndX, EndY),
	getSymbol(StartX, StartY, Board, Source),
	getSymbol(EndX, EndY, Board, Destination),
	isRing(Source, Color),
	isRing(Destination, Color).

% encontra um caminho ligado por an�is entre duas c�lulas do tabuleiro
checkPathRing(Start, End, Board, Color, Lista):-
	checkPathRing(Start, End, Board, Color, [Start], Lista).
checkPathRing(7-StartY, _End, _Board, black, Lista, Lista):-
	StartY > 1, !.
checkPathRing(StartX-7, _End, _Board, white, Lista, Lista):-
	StartX > 1, !.
checkPathRing(Start, End, Board, Color, Lista, ListaFim):-
	connectedRing(Start, Middle, Board),
	Middle \= End,
	\+member(Middle, Lista),
	append(Lista, [Middle], Lista2),
	checkPathRing(Middle, End, Board, Color, Lista2, ListaFim).