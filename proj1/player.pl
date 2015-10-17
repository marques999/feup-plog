%===========================%
%		PLAYER CLASS		%
%===========================%

%		------- %
% #factos 		%
%		------- %

player(whitePlayer).
player(blackPlayer).

playerColor(whitePlayer, white).
playerColor(blackPlayer, black).

playerName(whitePlayer, 'White').
playerName(blackPlayer, 'Black').

initializePlayer(Name, playerState(Name, 24, 24)).
resetPlayer(playerState(Name, _, _), playerState(Name, 24, 24)).

%		------- %
% #predicados 	%
%		------- %

decrementDiscs(playerState(Name, NumberDiscs, NumberRings), playerState(Name, NewDiscs, NumberRings)):-
	NewDiscs is NumberDiscs - 1.

decrementRings(playerState(Name, NumberDiscs, NumberRings), playerState(Name, NumberDiscs, NewRings)):-
	NewRings is NumberRings - 1.