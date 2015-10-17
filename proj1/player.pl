%===========================%
%		PLAYER CLASS		%
%===========================%

%		------- %
% #factos 		%
%		------- %

player(whitePlayer).
player(blackPlayer).

playerName(whitePlayer, 'White').
playerName(blackPlayer, 'Black').

initializePlayer(Name, playerState(Name, 24, 24)).
resetPlayer(playerState(Name, _, _), playerState(Name, 24, 24)).

%		------- %
% #predicados 	%
%		------- %

removeDisc(playerState(Name, NumberDiscs, NumberRings), playerState(Name, NewDiscs, NumberRings)):-
	NewDiscs is NumberDiscs - 1.

removeRing(playerState(Name, NumberDiscs, NumberRings), playerState(Name, NumberDiscs, NewRings)):-
	NewRings is NumberRings - 1.