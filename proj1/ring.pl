%===========================%
%		  RING CLASS		%
%===========================%

%		------- %
% #predicados 	%
%		------- %

isRing(Symbol, black):-
	4 is Symbol /\ 12.
isRing(Symbol, white):-
	8 is Symbol /\ 12.

isSingleBlackRing(Symbol):-
       isRing(Symbol, black),
       \+isDisc(Symbol, _).
isSingleWhiteRing(Symbol):-
        isRing(Symbol, white),
        \+isDisc(Symbol, _).

insertRing(Destination, Source, NewSymbol) :-
	\+isTwopiece(Destination),
	NewSymbol is Destination \/ Source.

moveRing(FromX-FromY, ToX-ToY, Board, NewBoard):-
	getSymbol(ToX, ToY, Board, Destination),
	getSymbol(FromX, FromY, Board, Source),
	insertRing(Destination, Source, NewDestination),
	moveSymbol(FromX, FromY, ToX, ToY, NewDestination, Board, NewBoard).

canPlaceRing(Board, X, Y):-
	getSymbol(X, Y, Board, Destination),
	isEmpty(Destination).

placeRing(X-Y, Color, Board, NewBoard):-
	getSymbol(X, Y, Board, Destination),
	createSinglePiece(ring, Color, Source),
	insertRing(Destination, Source, Symbol),
	setSymbol(X, Y, Symbol, Board, NewBoard).

checkPathRing(Start, End, Board, Color, Lista):-
	checkPathRing(Start, End, Board, Color, [Start], Lista).

checkPathRing(7-_StartY, _End, _Board, black, Lista, Lista):- !.
checkPathRing(_StartX-7, _End, _Board, white, Lista, Lista):- !.
checkPathRing(Start, End, Board, Color, Lista, ListaFim):-
	ligacaoRing(Start, Middle, Board),
	Middle \= End,
	\+member(Middle, Lista),
	append(Lista, [Middle], Lista2),
	checkPathRing(Middle, End, Board, Color, Lista2, ListaFim).