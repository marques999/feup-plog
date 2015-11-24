%Quatro carros, de cores amarelas, verde, azul, e preta, estão em fila. 
%Sabe-se que o carro que está imediatamente antes do carro azul é menor do que o que está imediatamente depois do carro azul; que o carro verde é o menor de todos, que o carro verde está depois do carro azul, e que o carro amarelo está depois do preto.
%A qeustão a resolver é a seguinte: 
%O prime iro carro: a) é amarelo ; b) é azul; c) é preto ; d) é verde; e) não pode ser determinado com estes dados? 

:- use_module(library(clpfd)).
:- use_module(library(random)).

fila_carros:-
	NomesCores = ['Amarelo', 'Verde', 'Azul', 'Preto'],
	Cores = [Amarelo, Verde, Azul, Preto],
	NomesTamanhos = ['Nano', 'Micro', 'Mini', 'Pequeno'],
	Tamanhos = [Nano, Micro, Mini, Pequeno],
	domain(Cores, 1, 4),
	all_distinct(Cores),
	domain(Tamanhos, 1, 4),
	all_distinct(Tamanhos),
	AntesAzul #= Azul - 1,
	DepoisAzul #= Azul + 1,
	element(Indice1, Tamanhos, AntesAzul),
	element(Indice2, Tamanhos, DepoisAzul),
	Indice1 #< Indice2,
	Verde #> Azul,
	Amarelo #> Preto,
	Verde #= Nano,
	append(Cores, Tamanhos, oResultado),
	labeling([], Resultado),
	write('CORES : '), nl,
	print_labels(NomesCores, Cores), nl,
	write('TAMANHOS : '), nl,
	print_labels(NomesTamanhos, Tamanhos).

print_labels([], []).
print_labels([H|T], [X|Y]):-
	write(H),
	write('-'),
	write(X), nl,
	print_labels(T, Y).

tias_excentricas(Tias, Idades, Bebida)
	Nomes = [Hortensia, Eugenia, Honoria, Leticia, Naosei],
	Bebida = [Tequila, Vodka].

classificar_livros(Value):-
	Livros = [CC_HI, CC_HF, CC_LI, CC_LF, CD_HI, CD_HF, CD_LI, CD_LF],
	domain(Livros, 1, 100),
	Value #> 0,
	CC_HI + CC_HF + CD_HI + CD_HF #= 52,
	CD_HI #= 27,
	CD_HI + CD_HF + CD_LI + CD_LF #= 34,
	CD_HF #= 3,
	CC_HI + CC_LI + CD_HI + CD_LI #= 46,
	CC_HI + CC_LI #= 23,
	CC_LF + CD_LF #= 20,
	CC_LI + CC_LF #= 31,
	Value is CC_HI + CC_HF + CC_LI + CC_LF + CD_HI + CD_HF + CD_LI + CD_LF,
	labeling([], Livros).

corrida_automoveis(Value):-
	length(Automobilistas, 6),
	Nacionalidades = [Alemanha, Inglaterra, Brasil, Espanha, Italia, Franca],
	Marcas = [1, LaVie, 5, SysV, 3, Fagor],
	all_distinct(Marcas),
	all_distinct(Nacionalidades),
	element(Fagor, Espanha, 3).

count_equals([], _, 0).
count_equals([H|T], Valor, Count):-
	H #= Valor #<=> A,
	count_equals(T, Valor, Next),
	Count #= Next + A.

% posição na lista = posição na fila
% valor da lista = cor
% RESTRIÇÕES:
% Amarelos	4
% Verdes	2
% Vermelhos	3
% Azuis		1
%
% COR(primeiro carro) = COR(último carro)
% COR(segundo carro) = COR(penúltimo carro)
%
% sequência de 3 com cores tres_diferentes
% sequência Amarelo-Verde-Vermelho-Azul deve aparecer uma única vez
%
mais_carros:-

	length(Carros, 12),
	domain(Carros, 1, 4),

	%+==================+
	%| CORES 			|
	%| 1 ) Azul 		|
	%| 2 ) Amarelo 		|
	%| 3 ) Verde 		|
	%| 4 ) Vermelho 	|
	%+==================+

	global_cardinality(Carros, [1-3, 2-4, 3-2, 4-3]),
	element(1, Carros, First),
	element(12, Carros, Last),
	First #= Last,
	element(2, Carros, Second),
	element(11, Carros, Penultimate),
	element(5, Carros, 1),
	Second #= Penultimate,
	tres_diferentes(Carros),
	quatro_sequencia(Carros, 1),
	labeling([], Carros), 
	write(Carros).

tres_diferentes([_, _]).
tres_diferentes([H1,H2,H3|T]):-
	all_distinct([H1,H2,H3]),
	tres_diferentes([H2,H3|T]).

quatro_sequencia([_,_,_], 0).
quatro_sequencia([A,B,C,D|T], N):-
	(A #=2 #/\ B #= 3 #/\ C #= 4 #/\ D #= 1) #<=> E,
	quatro_sequencia([B,C,D|T], X),
	N #= X + E.

verifica_pretos(Matriz):-
	transpose(Matriz, [_|NovaMatriz]),
	verifica_tudo(NovaMatriz, 1).

verifica_brancos([_|NovaMatriz]):-
	verifica_tudo(NovaMatriz, 0).

verifica_tudo([H|T], Cor):-
	verifica_linha(H, Cor),
	verifica_tudo(T).

verifica_linha([Contagem|Linha], Cor):-
	sequencia(Linha, 0, Cor, Resultado),
	list_equals(Contagem, Resultado).

list_equals([], []).
list_equals([H|T], [X|Y]):-
	H #= X, !,
	list_equals(T, Y).

sequencia([], 0, _, []).
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

transpose([F|Fs], Ts) :-
    transpose(F, [F|Fs], Ts).
transpose([], _, []).
transpose([_|Rs], Ms, [Ts|Tss]) :-
        lists_firsts_rests(Ms, Ts, Ms1),
        transpose(Rs, Ms1, Tss).

lists_firsts_rests([], [], []).
lists_firsts_rests([[F|Os]|Rest], [F|Fs], [Os|Oss]) :-
        lists_firsts_rests(Rest, Fs, Oss).