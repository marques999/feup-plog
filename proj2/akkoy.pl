%=======================================%
%               AKKOY CLASS             %
%=======================================%

%                 ------------- %
% #includes                     %
%                 ------------- %

:- use_module(library(clpfd)).
:- use_module(library(random)).

:- include('display.pl').
:- include('globals.pl').
:- include('list.pl').

%                 ------------- %
% #predicados                   %
%                 ------------- %

finishedGame([
	[7, [3],[1,1],[],[1,1,1],[],[1,4],[1]],
	[[1,3], 	0,0,0,1,1,1,0],
	[[1,2,1],	0,1,1,0,0,1,0],
	[[2,1,1],	1,0,1,0,0,1,0],
	[[1,2],		1,0,0,1,1,1,0],
	[[3,1],		1,0,1,0,0,0,1],
	[[1,1,1],	0,1,1,0,1,1,0],
	[[3,3],		0,0,0,1,0,0,0]
	]).

quatro_sequencia([_,_,_], 0).
quatro_sequencia([A,B,C,D|T], N):-
	(A #=2 #/\ B #= 3 #/\ C #= 4 #/\ D #= 1) #<=> E,
	quatro_sequencia([B,C,D|T], X),
	N #= X + E.

verifica_pretos(Matriz):-
	matrix_transpose(Matriz, [_|NovaMatriz]),
	verifica_tudo(NovaMatriz, 1).

verifica_brancos([_|NovaMatriz]):-
	verifica_tudo(NovaMatriz, 0).

verifica_tudo([], _).
verifica_tudo([H|T], Cor):-
	verifica_linha(H, Cor),
	verifica_tudo(T, Cor).

verifica_linha([Contagem|_], _):-
	length(Contagem, 0).
verifica_linha([Contagem|Linha], Cor):-
	sequencia(Linha, 0, Cor, Resultado),
	list_contains(Resultado, Contagem).

sequencia([], _, _, []).
sequencia([], Contador, _, [Contador]).
sequencia([H|T], Contador, Peca, Resultado):-
	H #= Peca,
	Next #= Contador + 1,
	sequencia(T, Next, Peca, Resultado).
sequencia([_|T], Contador, Peca, [Contador|Resultado]):-
	Contador #> 0,
	sequencia(T, 0, Peca, Resultado).
sequencia([_|T], Contador, Peca, Resultado):-
	sequencia(T, Contador, Peca, Resultado).

% verifica se duas células do tabuleiro são adjacentes em conetividade 4

isNeighbour(FromX-FromY, ToX-ToY, Length):-
	ToX #> 0, ToY #>0, ToX #=< Length, ToY #=< Length,
	(ToX #\= FromX) #=> (ToY #= FromY #/\ abs(FromX - ToX) #= 1),
	(ToY #\= FromY) #=> (ToX #= FromX #/\ abs(FromY - ToY) #= 1).

isConnected(StartX-StartY, EndX-EndY, Length, Board):-
	isNeighbour(StartX-StartY, EndX-EndY, Length),
	matrix_at(StartX, StartY, Board, Source),
	matrix_at(EndX, EndY, Board, Destination),
	StartX-StartY #\= EndX-EndY,
	Source #= 1,
	Destination #= 1,
	labeling([], [EndX, EndY, Source, Destination]).


adjacentTester([X|_], B, B).

adjacentTester([X,Y|T], [B|Bs], Bd):-
	write('blablabla'),
	(X #= 1 #/\ Y #= 0) #<=> B,
	write('oakdosad'),
	append([B], Bd, Br), write(Bd),
	adjacentTester([Y|T], Br, Br).

verifyBlock_aux(L, Lacunas):-
	length(L, ComprimentoL),
	ComprimentoB #= ComprimentoL - 1,
	length(B, ComprimentoB),
	write('comprimento de B: '), write(B),
	adjacentTester(L, B, Bs),
	length(B, SizeB),
	Complement #= SizeB - Lacunas,
	global_cardinality(Bs, [1-Lacunas]).

verifyBlock([], []).

checkConnected([_], [_], _, _).
checkConnected([X1,X2|A], [Y1,Y2|B], Length, Board):-
	isConnected(X1-Y1, X2-Y2, Length, Board),
	checkConnected(A, B, Length, Board).

newPath(StartX-StartY, Board, Resultado):-
	length(ListaX, 4),
	length(ListaY, 4),
	domain(ListaX, 1, 7),
	domain(ListaY, 1, 7),
	element(1, ListaX, StartX),
	element(1, ListaY, StartY),
	checkConnected(ListaX, ListaY, 7, Board),
	append(ListaX, ListaY, Resultado),
	labeling([], Resultado).

% encontra um caminho ligado por discos entre duas células do tabuleiro
checkPath(Start, Board, Lista):-
	matrix_at(0, 0, Board, Length),
	checkPath(Start, Length, Board, [Start], Lista).

checkPath(StartX-StartY, Length, _Board, Lista, Lista):-
	StartX #>= Length #\/ StartY #>= Length, !.

checkPath(Start, Length, Board, [Middle|Lista], ListaFim):-
	isConnected(Start, Middle, Length, Board),
	#\member(Middle, Lista),
	checkPath(Middle, Length, Board, Lista, ListaFim).