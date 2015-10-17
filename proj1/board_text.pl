%===================================%
%		BOARD REPRESENTATION		%
%===================================%

%		------- %
% #factos 		%
%		------- %

firstLine(8, ' --- ').
firstLine(9, ' --- ').
firstLine(10, ' --- ').
firstLine(4, ' xxx ').
firstLine(5, ' xxx ').
firstLine(6, ' xxx ').
firstLine(_, '     ').

secondLine(1, '  B  ').
secondLine(2, '  W  ').
secondLine(4, 'x   x').
secondLine(5, 'x B x').
secondLine(6, 'x W x').
secondLine(8, '|   |').
secondLine(9, '| B |').
secondLine(10, '| W |').
secondLine(_, '     ').

%		------- %
% #predicados 	%
%		------- %

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
	printRow(H, Length),
	printRows(T, Length).

printFirstRow(Length):-
	write('    +'),
	createSeparator(Length, '-------+'), nl.

printRow(Items, Length):- 
	printRowItems(Items), nl,
	write('    '), write('|'),
	createSeparator(Length, '-------|'), nl.

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