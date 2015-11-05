%===========================%
%		PLAYER CLASS		%
%===========================%

%			------- %
% #factos			%
%			------- %

% nomes dos jogadores
player(whitePlayer).
player(blackPlayer).

% cores dos jogadores correspondentes
playerColor(whitePlayer, white).
playerColor(blackPlayer, black).

% nomes dos jogadores correspondentes
playerName(whitePlayer, 'WHITE PLAYER').
playerName(blackPlayer, 'BLACK PLAYER').

% obt�m o nome de determinado jogador
getPlayerName(playerState(Name, _NumberDiscs, _NumberRings), Name).

% obt�m o n�mero de discos que determinado jogador possui
getNumberDiscs(playerState(_Name, NumberDiscs, _NumberRings), NumberDiscs).

% obt�m o n�mero de an�is que determinado jogador possui
getNumberRings(playerState(_Name, _NumberDiscs, NumberRings), NumberRings).

%			------- %
% #predicados       %
%			------- %

% gera um novo jogador com o n�mero de pe�as por omiss�o
initializePlayer(Name, playerState(Name, 24, 24)):-
	player(Name).

% gera um novo jogador com o n�mero de pe�as especificado nos argumentos
initializePlayer(Name, NumberDiscs, NumberRings, 
        playerState(Name, NumberDiscs, NumberRings)):-
        player(Name).

% obt�m a cor associada ao nome de determinado jogador
getPlayerColor(playerState(Name, _NumberDiscs, _NumberRings), Color):-
	playerColor(Name, Color).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% verifica se determinado jogador possui discos
hasDiscs(playerState(_Name, NumberDiscs, _NumberRings)):-
	NumberDiscs > 0.

% verifica se determinado jogador possui pelo menos uma das pe�as
hasPieces(playerState(_Name, NumberDiscs, NumberRings)):-
	NumberDiscs > 0, NumberRings > 0.

% verifica se determinado jogador possui an�is
hasRings(playerState(_Name, _NumberDiscs, NumberRings)):-
	NumberRings > 0.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% decrementa o n�mero de discos que determinado jogador possui
decrementDiscs(playerState(Name, NumberDiscs, NumberRings),
	playerState(Name, NewDiscs, NumberRings)):-
	NewDiscs is NumberDiscs - 1.

% decrementa o n�mero de an�is que determinado jogador possui
decrementRings(playerState(Name, NumberDiscs, NumberRings),
	playerState(Name, NumberDiscs, NewRings)):-
	NewRings is NumberRings - 1.