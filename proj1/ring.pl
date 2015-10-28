%===========================%
%		  RING CLASS		%
%===========================%

%		------- %
% #predicados 	%
%		------- %

isRing(Symbol, black):-
	Symbol < 16, 4 is Symbol /\ 12.
isRing(Symbol, white):-
	Symbol < 16, 8 is Symbol /\ 12.

insertRing(Destination, Source, NewSymbol) :-
	\+isTwopiece(Destination),
	NewSymbol is Destination \/ Source.

removeRing(Symbol, Color, NewSymbol):-
	isRing(Symbol, Color),
	createSinglePiece(ring, Color, Toggle),
	NewSymbol is Symbol /\ \(Toggle).

moveRing(FromX, FromY, ToX, ToY, Board, NewBoard):-
	getSymbol(ToX, ToY, Board, Destination),
	getSymbol(FromX, FromY, Board, Source),
	insertRing(Destination, Source, NewDestination),
	moveSymbol(FromX, FromY, ToX, ToY, NewDestination, Board, NewBoard).

canPlaceRing(Board, X, Y):-
	getSymbol(X, Y, Board, Destination),
	isEmpty(Destination).

canPlaceRing(Board, X, Y):-
	getSymbol(X, Y, Board, Destination),
	isDisc(Destination, _).

placeRing(X, Y, Color, Board, NewBoard):-
	getSymbol(X, Y, Board, Destination),
	createSinglePiece(ring, Color, Source),
	insertRing(Destination, Source, Symbol),
	setSymbol(X, Y, Symbol, Board, NewBoard).

checkPathRing(Start, End, Board, Color, Lista):-  
	checkPathRing(Start, End, Board, Color, [Start], Lista). 
checkPathRing(StartX-StartY, _End, _Board, white, Lista, Lista):-
	Lista \== [StartX-StartY],
	StartX == 1.
checkPathRing(StartX-StartY, _End, _Board, white, Lista, Lista):-
        Lista \== [StartX-StartY],
	StartX == 7.
checkPathRing(StartX-StartY, _End, _Board, black, Lista, Lista):-
	Lista \== [StartX-StartY],
	StartY == 1.
checkPathRing(StartX-StartY, _End, _Board, black, Lista, Lista):-
        Lista \== [StartX-StartY],
	StartY == 7.
checkPathRing(Start, End, Board, Color, Lista, ListaFim):- 
	ligacaoRing(Start, Middle, Board), 
	Middle \= End,
	\+member(Middle, Lista),  
	append(Lista, [Middle], Lista2), 
	checkPathRing(Middle, End, Board, Color, Lista2, ListaFim).