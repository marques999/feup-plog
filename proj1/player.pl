%===========================%
%		PLAYER CLASS		%
%===========================%

%		------- %
% #factos 		%
%		------- %

player(whitePlayer).
player(blackPlayer).

getPlayerColor(whitePlayer, white).
getPlayerColor(blackPlayer, black).

playerName(whitePlayer, 'WHITE PLAYER').
playerName(blackPlayer, 'BLACK PLAYER').

%		------- %
% #predicados 	%
%		------- %

initializePlayer(Name, NewState):-
	player(Name),
	NewState = playerState(Name, 24, 24).

resetPlayer(playerState(Name, _, _), NewState):-
	player(Name),
	NewState = playerState(Name, 24, 24).

getPlayerName(playerState(Name, _NumberDiscs, _NumberRings), Name).

hasRings(playerState(Name, _, NumberRings)):-
	player(Name),
	NumberRings > 0.

hasDiscs(playerState(Name, NumberDiscs, _)):-
	player(Name),
	NumberDiscs > 0.

decrementDiscs(playerState(Name, NumberDiscs, _), playerState(Name, NewDiscs, _)):-
	player(Name),
	NewDiscs is NumberDiscs - 1.

decrementRings(playerState(Name, _, NumberRings), playerState(Name, _, NewRings)):-
	player(Name),
	NewRings is NumberRings - 1.