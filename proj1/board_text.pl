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

printTab(0).
printTab(Y):- 
	Y > 0, 
	write('    '), 
	Y1 is Y - 1, 
	print_char(Y1).

printBoard(Board, Length):-
	printFirstRow(Length),
	printRows(Board, Length).

printRows(Board, Length) :-
	printRows(Board, Length, 0).

printRows([], Length, Length).
printRows([H|T], Length, Current):-
	printRow(H, Length, Current),
	Next is Current + 1,
	printRows(T, Length, Next).

printFirstRow(Length):-
	write('    +'),
	createSeparator(Length, '-------+'), nl.

printRow(Items, Length, Current):-
	Current is Length - 1,
	printRowItems(Items, Current), nl,
	printTab(Current), 
	write('    +'),
	createSeparator(Length, '-------+').

printRow(Items, Length, Current):-
	printRowItems(Items, Current), nl,
	printTab(Current), 
	write('    +'),
	createSeparator(Length, '-------+'), 
	write('---+'), nl.

printRowItems(Items, Current):-
	printTab(Current), 
	write('    | '),
	printFirstLine(Items), nl,
	printTab(Current), 
	write('    | '),
	printSecondLine(Items), nl,
	printTab(Current), 
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