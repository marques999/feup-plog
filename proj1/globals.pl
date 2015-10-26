%===========================%
%	  GLOBAL DEFINITIONS	%
%===========================%

%		------- %
% #predicados 	%
%		------- %

pressEnterToContinue:-
	write('Press <Enter> to continue...'), nl,
	waitForEnter, !.

waitForEnter:-
	get_code(_).

clearConsole:-
	clearConsole(40), !.

clearConsole(0).
clearConsole(N):-
	nl,
	N1 is N-1,
	clearConsole(N1).

getChar(Input):-
	get_char(Input),
	get_char(_).

getCode(Input):-
	get_code(Input),
	get_code(_).

getInt(Input):-
	get_code(TempInput),
	Input is TempInput - 48.

getCoordinates(X, Y):-
	getInt(X), 
	get_code(_),
	getInt(Y),
	get_code(_).