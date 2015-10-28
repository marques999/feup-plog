%===========================%
%	  GLOBAL DEFINITIONS	%
%===========================%

messageInvalidChoice:-
        write('INVALID INPUT!'), nl,
        write('Please enter a valid number'), nl,
        pressEnterToContinue, nl.

messageSameCoordinates:-
        write('INVALID INPUT!'), nl,
        write('Source and destination cell coordinates must be different'), nl,
        pressEnterToContinue, nl, fail.

messageInvalidCoordinates:-
        write('INVALID INPUT!'), nl,
        write('Cell coordinates must be an integer between 0 and 7'), nl,
        pressEnterToContinue, nl, fail.

messageNoRings:-
        write('INVALID MOVE!'), nl,
        write('Player has no rings left to be played'), nl,
        pressEnterToContinue, nl, fail.

messageNoDiscs:-
        write('INVALID MOVE!'), nl,
        write('Player has no discs left to be played'), nl,
        pressEnterToContinue, nl, fail.

messageRingExists:-
        write('INVALID MOVE!'), nl,
        write('Destination cell should not be already occupied by a ring'), nl,
        pressEnterToContinue, nl, fail.

messageDiscExists:-
        write('INVALID MOVE!'), nl,
        write('Destination cell should not be already occupied by a disc'), nl,
        pressEnterToContinue, nl, fail.

messageSourceTwopiece:-
        write('INVALID MOVE!'), nl,
        write('Source cell is full and can\'t be moved (already occupied by two pieces)'), nl,
        pressEnterToContinue, nl, fail.

messageSourceNotDisc:-
        write('INVALID MOVE!'), nl,
        write('Source cell is not occupied by a disc'), nl,
        pressEnterToContinue, nl, fail.

messageSourceNotRing:-
        write('INVALID MOVE!'), nl,
        write('Source cell is not occupied by a ring'), nl,
        pressEnterToContinue, nl, fail.

messageDestinationNotDisc:-
        write('INVALID MOVE!'), nl,
        write('Destination cell is not occupied by a disc'), nl,
        pressEnterToContinue, nl, fail.

messageDestinationNotRing:-
        write('INVALID MOVE!'), nl,
        write('Destination cell is not occupied by a ring'), nl,
        pressEnterToContinue, nl, fail.

messageDestinationTwopiece:-
        write('INVALID MOVE!'), nl,
        write('Destination cell is full and can\'t be moved (already occupied by two pieces)'), nl,
        pressEnterToContinue, nl, fail.

messageNotNeighbours:-
        write('INVALID MOVE!'), nl,
        write('Source cell and destination cell aren\'t neighbors!'), nl,
        pressEnterToContinue, nl, fail.

messageNotOwned:-
        write('INVALID MOVE!'), nl,
        write('A player can only move his/her own pieces'), nl,
        pressEnterToContinue, nl, fail.

messagePlayerWins(Player):-
        getPlayerName(Player, PlayerName),
        write('CONGRATULATIONS!'), nl,
        write(PlayerName),
        write(' has won the match!'), nl,
        pressEnterToContinue, nl.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
	getCode(TempInput),
	Input is TempInput - 48.

getCoordinates(X, Y):-
	getInt(X), getInt(Y).