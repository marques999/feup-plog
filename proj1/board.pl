%===========================%
%		BOARD CLASS			%
%===========================%

createSeparator(0, _).
createSeparator(N, SS):- 
	N1 is N-1, 
	write(SS), 
	createSeparator(N1, SS).

print_char(_, 0).
print_char(X, Y):- 
	Y > 0, 
	write(X), 
	Y1 is Y - 1, 
	print_char(X, Y1).

printBoard(Board, Length):-
	printFirstRow(Length),
	printRows(Board, Length),
	printFirstRow(Length).

printRows([], _).
printRows([H|T], Length):-
	printRow(H, Length), nl,
	printRows(T, Length).

printFirstRow(Length):-
	write('    +'),
	createSeparator(Length, '-----+'), nl.

printRow(Items, Length):- 
	printRowItems(Items), nl,
	write('    '), write('|'),
	createSeparator(Length, '_____|'), nl.

printRowItems(Items):- 
	write('    | '),
	printFirstLine(Items), nl,
	write('    | '),
	printSecondLine(Items), nl,
	write('    | '),
	printFirstLine(Items).

printFirstLine([]).
printFirstLine([H|T]):-
	firstLine(H, Char),
	write(Char),
	write(' | '),
	printFirstLine(T).

printSecondLine([]).
printSecondLine([H|T]):-
	secondLine(H, Char),
	write(Char),
	write(' | '),
	printSecondLine(T).

firstLine(8, '---').
firstLine(9, '---').
firstLine(10, '---').
firstLine(4, 'xxx').
firstLine(5, 'xxx').
firstLine(6, 'xxx').
firstLine(_, '   ').

secondLine(1, ' B ').
secondLine(2, ' W ').
secondLine(5, ' B ').
secondLine(6, ' W ').
secondLine(9, ' B ').
secondLine(10, ' W ').
secondLine(_, '   ').

createSinglePiece(disc, black, 1).
createSinglePiece(disc, white, 2).
createSinglePiece(ring, black, 4).
createSinglePiece(ring, white, 8).

isDisc(Symbol, black):- 
	Symbol < 16, 1 is Symbol /\ 3.
isDisc(Symbol, white):- 
	Symbol < 16, 2 is Symbol /\ 3.

isRing(Symbol, black):- 
	Symbol < 16, 4 is Symbol /\ 12.
isRing(Symbol, white):- 
	Symbol < 16, 8 is Symbol /\ 12.

isTwopiece(Symbol):- 
	isRing(Symbol, _), isDisc(Symbol, _).

isNeighbour(FromX, FromY, ToX, ToY):-
	FromX \= ToX,
	abs(FromX - ToX) =< 1,
	abs(FromY - ToY) =< 1.

isNeighbour(FromX, FromY, ToX, ToY):-
	FromY \= ToY,
	abs(FromX - ToX) =< 1,
	abs(FromY - ToY) =< 1.

removeDisc(Symbol, Color, NewSymbol):-  
	isDisc(Symbol, Color),
	createSinglePiece(disc, Color, Toggle),
	NewSymbol is Symbol /\ \(Toggle).

removeRing(Symbol, Color, NewSymbol):-
	isRing(Symbol, Color),
	createSinglePiece(ring, Color, Toggle),
	NewSymbol is Symbol /\ \(Toggle).

insertRing(Destination, Source, NewSymbol) :-
	isRing(Source, _),
	\+isTwopiece(Destination),
	isDisc(Destination, _),
	NewSymbol is Destination \/ Source.

insertDisc(Destination, Source, NewSymbol) :-
	isDisc(Source, _),
	\+isTwopiece(Destination),
	isRing(Destination, _),
	NewSymbol is Destination \/ Source.

moveRing(FromX, FromY, ToX, ToY, Board, NewBoard):-
	isNeighbour(FromX, FromY, ToX, ToY),
	matrix_at(ToX, ToY, Board, Destination),
	matrix_at(FromX, FromY, Board, Source),
	insertRing(Destination, Source, NewDestination),
	matrix_move(FromX, FromY, ToX, ToY, NewDestination, Board, NewBoard).

moveDisc(fromX, fromY, toX, toY, Board, NewBoard):-
	isNeighbour(FromX, FromY, ToX, ToY),
	matrix_at(ToX, ToY, Board, Destination),
	matrix_at(FromX, FromY, Board, Source),
	insertDisc(Destination, Source, NewDestination),
	matrix_move(FromX, FromY, ToX, ToY, NewDestination, Board, NewBoard).

canPlaceRing(playerStatus(Name, NumberDiscs, NumberRings)):-
	playerStatus(Name, NumberDiscs, NumberRings),
	NumberRings > 0.

canPlaceDisc(playerStatus(Name, NumberDiscs, NumberRings)):-
	playerStatus(Name, NumberDiscs, NumberRings),
	NumberDiscs > 0.

placeRing(X, Y, Color, Board, NewBoard):-
	matrix_at(X, Y, Board, Destination),
	Destination is 0,
	createSinglePiece(ring, Color, Symbol),
	matrix_set(X, Y, Symbol, Board, NewBoard).

placeDisc(X, Y, Color, Board, NewBoard):-
	matrix_at(X, Y, Board, Destination),
	Destination is 0,
	createSinglePiece(disc, Color, Symbol),
	matrix_set(X, Y, Symbol, Board, NewBoard).

testMatrix([
	[0, 1, 2, 1, 0, 0, 0],
	[0, 1, 2, 8, 9, 0, 5],
	[0, 1, 2, 4, 2, 5, 0],
	[6, 4, 0, 1, 2, 0, 0],
	[0, 1, 2, 0, 10, 0, 6],
	[0, 1, 2, 10, 2, 0, 0],
	[5, 1, 9, 1, 2, 0, 6]
]).