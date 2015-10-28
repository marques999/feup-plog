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

insertDisc(Destination, Source, NewSymbol):-
	\+isTwopiece(Destination),
	NewSymbol is Destination \/ Source.

removeDisc(Symbol, Color, NewSymbol):-
	isDisc(Symbol, Color),
	createSinglePiece(disc, Color, Toggle),
	NewSymbol is Symbol /\ \(Toggle).

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

checkPathDisc(Start, End, Board, Color, Lista):-  
	checkPathDisc(Start, End, Board, Color, [Start], Lista). 
checkPathDisc(StartX-StartY, End, Board, white, Lista, Lista):-
	Lista \== [StartX-StartY],
	StartX == 1.
checkPathDisc(StartX-StartY, End, Board, white, Lista, Lista):-
	StartX == 7.
checkPathDisc(StartX-StartY, End, Board, black, Lista, Lista):-
	Lista \== [StartX-StartY],
	StartY == 1.
checkPathDisc(StartX-StartY, End, Board, black, Lista, Lista):-
	StartY == 7.
checkPathDisc(Start, End, Board, Color, Lista, ListaFim):- 
	ligacaoRing(Start, Middle, Board), 
	Middle \= End,
	\+member(Middle, Lista),  
	append(Lista, [Middle], Lista2), 
	checkPathDisc(Middle, End, Board, Color, Lista2, ListaFim).