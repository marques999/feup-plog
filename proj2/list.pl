%=======================================%
%           MATRIX OPERATIONS           %
%=======================================%

% gera uma matriz quadrada de comprimento definido
matrix_generate(Length, Initial, [FirstRow|List]):-
	list_generate(Length, Initial, Row),
	list_generate(Length, [[]|Row], List), !,
	first_row(Length, FirstRow).

first_row(Length, [Length|List]):-
	once(list_generate(Length, [], List)).

% altera o elemento presente na posição de coordenadas (X,Y) de uma matriz
matrix_set(1-Y, NewElem, [OldRow|Tail], [NewRow|Tail]):-
	list_set(Y, NewElem, OldRow, NewRow).
matrix_set(X-Y, NewElem, [OldRow|Tail], [OldRow|NewTail]):-
	X > 1,
	X1 is X-1,
	matrix_set(X1, Y, NewElem, Tail, NewTail).

% obtém a matriz transposta de uma matriz quadrada N x N
matrix_transpose([F|Fs], Ts) :-
matrix_transpose(F, [F|Fs], Ts).
matrix_transpose([], _, []).
matrix_transpose([_|Rs], Ms, [Ts|Tss]) :-
        list_firsts_rests(Ms, Ts, Ms1),
        matrix_transpose(Rs, Ms1, Tss).

% obtém o elemento presente na posição de coordenadas (X,Y) de uma matriz
matrix_at(X, Y, List, Symbol):-
	X #>= 0,
	list_at(X, List, Row),
	list_at(Y, Row, Symbol).

matrix_size([[Size|_]|_], Size).

%=======================================%
%            LIST OPERATIONS            %
%=======================================%

% gera uma lista de comprimento definido
list_generate(0, _, []).
list_generate(Length, Initial, [Initial|Lista]):-
	Length > 0,
	NewLength is Length - 1,
	list_generate(NewLength, Initial, Lista).

% determina se duas listas são iguais
list_equals([], []).
list_equals([H|T], [X|Y]):-
	H #= X, !,
	list_equals(T, Y).

% determina se os elementos de uma lista estão contidos numa segunda
list_contains(Lista1, Lista2):-
	length(Lista1, T),
	length(Lista2, T),
	list_contains_aux(Lista1, Lista2).
list_contains_aux(_, []).
list_contains_aux(Lista, [H|T]):-
	member(H, Lista),
	list_contains_aux(Lista, T).

% determina o comprimento de uma lista
list_size([], 0).
list_size([_|T], Size):-
	list_size(T, TailSize),
	Size is TailSize + 1.

% altera o elemento presente na posição I de uma lista
list_set(0, Symbol, [_|L], [Symbol|L]).
list_set(I, Symbol, [H|L], [H|Result]):-
	I > 1,
	I1 is I-1, !,
	list_set(I1, Symbol, L, Result).

% obtém o elemento presente na posição I de uma lista
list_at(0, [H|_], H).
list_at(X, [_|T], Symbol):-
	X #>= 0,
	X1 #= X - 1,
	list_at(X1, T, Symbol).

list_firsts_rests([], [], []).
list_firsts_rests([[F|Os]|Rest], [F|Fs], [Os|Oss]) :-
        list_firsts_rests(Rest, Fs, Oss).

list_subtract([], _, []) :- !.
list_subtract([A|C], B, D) :-
        member(A, B), !,
        list_subtract(C, B, D).
list_subtract([A|B], C, [A|D]) :-
        list_subtract(B, C, D).