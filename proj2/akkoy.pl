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

flattenedMatrix([0,0,0,1,1,1,0,0,1,1,0,0,1,0,1,0,1,0,0,1,0,1,0,0,1,1,1,0,1,0,1,0,0,0,1,0,1,1,0,1,1,0,0,0,0,1,0,0,0]).

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
	(ToY #= FromY #/\ abs(FromX - ToX) #= 1) #\/ (ToX #= FromX #/\ abs(FromY - ToY) #= 1).

is_neighbour(From, To, Length):-
	FromX #= From // Length, FromY #= From mod Length,
	ToX #= To // Length, ToY #= To mod Length,
	(ToY #= FromY #/\ abs(FromX - ToX) #= 1) #\/ (ToX #= FromX #/\ abs(FromY - ToY) #= 1).

isConnected(StartX-StartY, EndX-EndY, Length, Board):-
	isNeighbour(StartX-StartY, EndX-EndY, Length),
	matrix_at(StartX, StartY, Board, Source),
	matrix_at(EndX, EndY, Board, Destination),
	StartX-StartY #\= EndX-EndY,
	Source #= 0,
	Destination #= 0,
	labeling([], [EndX, EndY, Source, Destination]).

adjacentTester([_], B, B).
adjacentTester([X,Y|T], [B|Bs], Bd):-
	(X #= 1 #/\ Y #= 0) #<=> B,
	append([B], Bd, Br),
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
verifyBlock([H|T], [P|C]):-
	length(P, Lacunas), nl, nl,
	write(H),
	verifyBlock_aux(H, Lacunas),
	verifyBlock(T, C).

checkConnected([_], [_], _, _).
checkConnected([X1,X2|A], [Y1,Y2|B], Length, Board):-
	isConnected(X1-Y1, X2-Y2, Length, Board),
	checkConnected(A, B, Length, Board).

flattenConnected([], _).
flattenConnected([H|T], Board):-
	count_equals(T, H, Board, Count),
	Count #> 0,
	flattenConnected([T], Board).

%flattenCheck([], _From, _White, _Length).
%flattenCheck([H|T], From, White, Length):-
%	member(H, White),
%	is_neighbour(From, H, Length),
%	flattenCheck(T, From, White, Length).

flattenConnectedAux(From, To, Length, List):-
	Start #= From + 1,
	End #= From + Length,
	To in Start..End,
	is_neighbour(From, To, Length),
	element(_, List, From),
	element(_, List, To),
	labeling([], [To]).

count_equals([_], _, _, 0).
count_equals([H|T], From, Board, Count):-
	flattenConnectedAux(From, H, Board) #<=> B,
	count_equals(T, From, Board, Next),
	Count #= Next + B.

newPath(Start, Board, Resultado):-
	%length(ResultadoX, 4),
	length(Resultado, 4),
	%domain(ResultadoX, 1, 7),
	domain(Resultado, 0, 49),
	%element(1, ResultadoX, StartX),
	element(1, Resultado, Start),
	all_distinct(Resultado),
	flattenConnected(Resultado, Board),
	%append(ResultadoX, ResultadoY, Resultado),
	labeling([], Resultado).

% encontra um caminho ligado por discos entre duas células do tabuleiro
checkPath(Start, Board, Lista):-
	checkPath(Start, Length, Board, [Start], Lista).

checkPath(Start, End, Length, _Board, Lista, Lista):-
	StartX #>= Length #\/ StartY #>= Length.

checkPath(Start, Length, Board, [Middle|Lista], ListaFim):-
	#\flattenConnectedAux(Start, Middle, Length, Board).

checkPath(Start, Length, Board, [Middle|Lista], ListaFim):-
	flattenConnectedAux(Start, Middle, Length, Board),
	#\member(Middle, Lista),
	checkPath(Middle, Length, Board, Lista, ListaFim).


checkPath(Start, End, Board, Length, Lista):-
	checkPath(Start, End, Board, Length, [Start], Lista).



checkPath(Start, End, Board, Length, Lista, ListaFim):-
	flattenConnectedAux(Start, Middle, Length, Board),
	#\member(Middle, Lista),
	append(Lista, [Middle], Lista2),
	checkPath(Middle, End, Board, Length, Lista2, ListaFim).

checkPath(Start, End, _Board, Length, Lista, Lista).

isBlack(Symbol):- Symbol #= 1.
isWhite(Symbol):- Symbol #= 0.

% percorre uma linha do tabuleiro
% obtém uma lista com as células dessa linha que verificam determinado objetivo

scanBlack(List, Result):-
	scanList(List, 0, isBlack, Result).
scanWhite(List, Result):-
	scanList(List, 0, isWhite, Result).

scanList([], _Position, _Predicate, []).
scanList([H|T], Position, Predicate, [Position|Lista]):-
	call(Predicate, H),
	Next #=  Position + 1,
	scanList(T, Next, Predicate, Lista).
scanList([_H|T], Position, Predicate, Lista):-
	Next #= Position + 1,
	scanList(T, Next, Predicate, Lista).