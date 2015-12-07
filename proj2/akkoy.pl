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