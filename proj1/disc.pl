%===========================%
%		  DISC CLASS		%
%===========================%

%		------- %
% #predicados 	%
%		------- %

isDisc(Symbol, black):-
	1 is Symbol /\ 3.
isDisc(Symbol, white):-
	2 is Symbol /\ 3.

isSingleBlackDisc(Symbol):-
	isDisc(Symbol, black),
	\+isRing(Symbol, _).
isSingleWhiteDisc(Symbol):-
	isDisc(Symbol, white),
	\+isRing(Symbol, _).

insertDisc(Destination, Source, NewSymbol):-
	\+isTwopiece(Destination),
	NewSymbol is Destination \/ Source.

moveDisc(FromX-FromY, ToX-ToY, Board, NewBoard):-
	getSymbol(ToX, ToY, Board, Destination),
	getSymbol(FromX, FromY, Board, Source),
	insertDisc(Destination, Source, NewDestination),
	moveSymbol(FromX, FromY, ToX, ToY, NewDestination, Board, NewBoard).

canPlaceDisc(Board, X, Y):-
	getSymbol(X, Y, Board, Destination),
	isEmpty(Destination).

placeDisc(X-Y, Color, Board, NewBoard):-
	getSymbol(X, Y, Board, Destination),
	createSinglePiece(disc, Color, Source),
	insertDisc(Destination, Source, Symbol),
	setSymbol(X, Y, Symbol, Board, NewBoard).

checkPathDisc(Start, End, Board, Color, Lista):-
	checkPathDisc(Start, End, Board, Color, [Start], Lista).

checkPathDisc(7-_StartY, _End, _Board, black, Lista, Lista):- !.
checkPathDisc(_StartX-7, _End, _Board, white, Lista, Lista):- !.
checkPathDisc(Start, End, Board, Color, Lista, ListaFim):-
	ligacaoDisc(Start, Middle, Board),
	Middle \= End,
	\+member(Middle, Lista),
	append(Lista, [Middle], Lista2),
	checkPathDisc(Middle, End, Board, Color, Lista2, ListaFim).