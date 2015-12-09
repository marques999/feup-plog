%=======================================%
%           MATRIX GENERATION           %
%=======================================%

%                 ------------- %
% #includes                     %
%                 ------------- %

?- ensure_loaded('globals.pl').

%                 ------------- %
% #predicados                   %
%                 ------------- %

generate_hanjie(Width,Height,ColHints,RowHints):-
	make_atom_grid(PuzzleGrid,Width,Height),
	generate_rows_hints(PuzzleGrid,RH),
	transpose(PuzzleGrid,Cols),
	generate_rows_hints(Cols,CH),
	strip_zeros(RH,RowHints),
	strip_zeros(CH,ColHints).

generate_hanjie_full(Width,Height,ColHints,RowHints):-
	make_atom_grid_full(PuzzleGrid,Width,Height),
	generate_rows_hints(PuzzleGrid,RH),
	transpose(PuzzleGrid,Cols),
	generate_rows_hints(Cols,CH),
	strip_zeros(RH,RowHints),
	strip_zeros(CH,ColHints).

generate_hanjie_empty(Width,Height,ColHints,RowHints):-
	make_atom_grid_empty(PuzzleGrid,Width,Height),
	generate_rows_hints(PuzzleGrid,RH),
	transpose(PuzzleGrid,Cols),
	generate_rows_hints(Cols,CH),
	strip_zeros(RH,RowHints),
	strip_zeros(CH,ColHints).

strip_zeros([],[]).
strip_zeros([Row|Rest],[Result|Rs]):-
	delete(Row,0,Temp),
	(Temp = [],
	Result = [0] ; Result=Temp), !,
	strip_zeros(Rest,Rs).

make_rows([],_).
make_rows([G|Gs], Width):-
	length(G, Width),
	make_rows(Gs, Width), !.

make_grid(Board, Width, Height):-
	length(Board, Height),
	make_rows(Board, Width), !.

generate_rows_hints([],[]).
generate_rows_hints([Row|Rest],[RH|RHs]):-
	generate_hints_for_row(Row,RH),
	generate_rows_hints(Rest,RHs).

generate_hints_for_row([],[0]).
generate_hints_for_row([0|Rest],[0|RHs]):-
	generate_hints_for_row(Rest,RHs).
generate_hints_for_row([1|Rest],[Head|RHs]):-
	generate_hints_for_row(Rest,[NextHead|RHs]),
	Head is NextHead+1.

make_atom_grid_empty([], _, 0).
make_atom_grid_empty([H|T], Width, Height):-
	Height > 0,
	make_atom_row_empty(H, Width),
	RemainingHeight is Height - 1,
	make_atom_grid_empty(T, Width, RemainingHeight), !.

make_atom_row_empty([], 0).
make_atom_row_empty([0|T],Width):-
	Width > 0,
	RemainingWidth is Width - 1,
	make_atom_row_empty(T, RemainingWidth), !.

make_atom_grid_full([], _, 0).
make_atom_grid_full([H|T], Width, Height):-
	Height > 0,
	make_atom_row_full(H, Width),
	RemainingHeight is Height - 1,
	make_atom_grid_full(T, Width, RemainingHeight), !.

make_atom_row_full([], 0).
make_atom_row_full([1|T], Width):-
	Width > 0,
	RemainingWidth is Width - 1,
	make_atom_row_full(T, RemainingWidth), !.

make_atom_grid([], _, 0).
make_atom_grid([H|T], Width, Height):-
	Height > 0,
	make_atom_row(H, Width),
	RemainingHeight is Height - 1,
	make_atom_grid(T, Width, RemainingHeight), !.

make_atom_row([], 0).
make_atom_row([H|T], Width):-
	Width > 0,
	random(0, 2, H),
	RemainingWidth is Width - 1,
	make_atom_row(T, RemainingWidth), !.