% #program base.
#program initial.

% at(P,To,0) :- at(P,To).
at_t(P,To) :- at(P,To).

% clear(P,0) :- clear(P).
clear_t(P) :- clear(P).

% atgoal(S,0) :- isgoal(L), stone(S), at(S,L).
atgoal(S) :- isgoal(L), stone(S), at(S,L).

% #program step(t).
#program dynamic.

% { occurs(some_action,t) }.
{ occurs(some_action) }.

%*
1 <= {
		pushtonongoal(P,S,Ppos,From,To,Dir,t) :
		movedir(Ppos,From,Dir),
		movedir(From,To,Dir),
		isnongoal(To),
		player(P),
		stone(S), 
		Ppos != To, 
		Ppos != From, 
		From != To;
	    
		move(P,From,To,Dir,t) :
		movedir(From,To,Dir),
		player(P), 
		From != To;
	    
		pushtogoal(P,S,Ppos,From,To,Dir,t) :
		movedir(Ppos,From,Dir),
		movedir(From,To,Dir),
		isgoal(To), 
		player(P), 
		stone(S), 
		Ppos != To, 
		Ppos != From, 
		From != To;
	    
		noop(t)
	} <= 1 :- occurs(some_action,t).
*%
1 <= {
		pushtonongoal(P,S,Ppos,From,To,Dir) :
		_movedir(Ppos,From,Dir),
		_movedir(From,To,Dir),
		_isnongoal(To),
		_player(P),
		_stone(S), 
		Ppos != To, 
		Ppos != From, 
		From != To;
	    
		move(P,From,To,Dir) :
		_movedir(From,To,Dir),
		_player(P), 
		From != To;
	    
		pushtogoal(P,S,Ppos,From,To,Dir) :
		_movedir(Ppos,From,Dir),
		_movedir(From,To,Dir),
		_isgoal(To), 
		_player(P), 
		_stone(S), 
		Ppos != To, 
		Ppos != From, 
		From != To;
	    
		noop
	} <= 1 :- occurs(some_action).

%*
del(at(P,Ppos),t) :- 	pushtonongoal(P,S,Ppos,From,To,Dir,t),
						movedir(Ppos,From,Dir),
						movedir(From,To,Dir),
						isnongoal(To),
						player(P),
						stone(S),
						Ppos != To,
						Ppos != From,
						From != To.
*%
del(at(P,Ppos)) :- 	pushtonongoal(P,S,Ppos,From,To,Dir),
					_movedir(Ppos,From,Dir),
					_movedir(From,To,Dir),
					_isnongoal(To),
					_player(P),
					_stone(S),
					Ppos != To,
					Ppos != From,
					From != To.

%*
del(at(S,From),t) :- 	pushtonongoal(P,S,Ppos,From,To,Dir,t),
						movedir(Ppos,From,Dir),
						movedir(From,To,Dir),
						isnongoal(To),
						player(P),
						stone(S),
						Ppos != To,
						Ppos != From,
						From != To.
*%
del(at(S,From)) :- 	pushtonongoal(P,S,Ppos,From,To,Dir),
					_movedir(Ppos,From,Dir),
					_movedir(From,To,Dir),
					_isnongoal(To),
					_player(P),
					_stone(S),
					Ppos != To,
					Ppos != From,
					From != To.

%*
del(clear(To),t) :- 	pushtonongoal(P,S,Ppos,From,To,Dir,t),
						movedir(Ppos,From,Dir),
						movedir(From,To,Dir),
						isnongoal(To),
						player(P),
						stone(S),
						Ppos != To,
						Ppos != From,
						From != To.
*%
del(clear(To)) :- 	pushtonongoal(P,S,Ppos,From,To,Dir),
					_movedir(Ppos,From,Dir),
					_movedir(From,To,Dir),
					_isnongoal(To),
					_player(P),
					_stone(S),
					Ppos != To,
					Ppos != From,
					From != To.

%*
at(P,From,t) :- 		pushtonongoal(P,S,Ppos,From,To,Dir,t),
						movedir(Ppos,From,Dir),
						movedir(From,To,Dir),
						isnongoal(To),
						player(P),
						stone(S),
						Ppos != To,
						Ppos != From,
						From != To.
*%
at_t(P,From) :- 	pushtonongoal(P,S,Ppos,From,To,Dir),
					_movedir(Ppos,From,Dir),
					_movedir(From,To,Dir),
					_isnongoal(To),
					_player(P),
					_stone(S),
					Ppos != To,
					Ppos != From,
					From != To.

%*
at(S,To,t) :- 			pushtonongoal(P,S,Ppos,From,To,Dir,t),
						movedir(Ppos,From,Dir),
						movedir(From,To,Dir),
						isnongoal(To),
						player(P),
						stone(S),
						Ppos != To,
						Ppos != From,
						From != To.
*%
at_t(S,To) :- 		pushtonongoal(P,S,Ppos,From,To,Dir),
					_movedir(Ppos,From,Dir),
					_movedir(From,To,Dir),
					_isnongoal(To),
					_player(P),
					_stone(S),
					Ppos != To,
					Ppos != From,
					From != To.

%*
clear(Ppos,t) :- 		pushtonongoal(P,S,Ppos,From,To,Dir,t),
						movedir(Ppos,From,Dir),
						movedir(From,To,Dir),
						isnongoal(To),
						player(P),
						stone(S),
						Ppos != To,
						Ppos != From,
						From != To.
*%
clear_t(Ppos) :- 	pushtonongoal(P,S,Ppos,From,To,Dir),
					_movedir(Ppos,From,Dir),
					_movedir(From,To,Dir),
					_isnongoal(To),
					_player(P),
					_stone(S),
					Ppos != To,
					Ppos != From,
					From != To.

%*
del(atgoal(S),t) :- 	pushtonongoal(P,S,Ppos,From,To,Dir,t),
						movedir(Ppos,From,Dir),
						movedir(From,To,Dir),
						isnongoal(To),
						player(P),
						stone(S),
						Ppos != To,
						Ppos != From,
						From != To.
*%
del(atgoal(S)) :- 	pushtonongoal(P,S,Ppos,From,To,Dir),
					_movedir(Ppos,From,Dir),
					_movedir(From,To,Dir),
					_isnongoal(To),
					_player(P),
					_stone(S),
					Ppos != To,
					Ppos != From,
					From != To.

%*
del(at(P,From),t) :- 	move(P,From,To,Dir,t),
						movedir(From,To,Dir),
						player(P),
						From != To.
*%
del(at(P,From)) :- 	move(P,From,To,Dir),
					_movedir(From,To,Dir),
					_player(P),
					From != To.

%*
del(clear(To),t) :- 	move(P,From,To,Dir,t),
						movedir(From,To,Dir),
						player(P),
						From != To.
*%
del(clear(To)) :- 	move(P,From,To,Dir),
					_movedir(From,To,Dir),
					_player(P),
					From != To.

%*
at(P,To,t) :- 			move(P,From,To,Dir,t),
						movedir(From,To,Dir),
						player(P),
						From != To.
*%
at_t(P,To) :- 		move(P,From,To,Dir),
					_movedir(From,To,Dir),
					_player(P),
					From != To.

%*
clear(From,t) :- 		move(P,From,To,Dir,t),
						movedir(From,To,Dir),
						player(P),
						From != To.
*%
clear_t(From) :- 	move(P,From,To,Dir),
					_movedir(From,To,Dir),
					_player(P),
					From != To.

%*
del(at(P,Ppos),t) :- 	pushtogoal(P,S,Ppos,From,To,Dir,t),
						movedir(Ppos,From,Dir),
						movedir(From,To,Dir),
						isgoal(To),
						player(P),
						stone(S),
						Ppos != To,
						Ppos != From,
						From != To.
*%
del(at(P,Ppos)) :- 	pushtogoal(P,S,Ppos,From,To,Dir),
					_movedir(Ppos,From,Dir),
					_movedir(From,To,Dir),
					_isgoal(To),
					_player(P),
					_stone(S),
					Ppos != To,
					Ppos != From,
					From != To.

%*
del(at(S,From),t) :- 	pushtogoal(P,S,Ppos,From,To,Dir,t),
						movedir(Ppos,From,Dir),
						movedir(From,To,Dir),
						isgoal(To),
						player(P),
						stone(S),
						Ppos != To,
						Ppos != From,
						From != To.
*%
del(at(S,From)) :- 	pushtogoal(P,S,Ppos,From,To,Dir),
					_movedir(Ppos,From,Dir),
					_movedir(From,To,Dir),
					_isgoal(To),
					_player(P),
					_stone(S),
					Ppos != To,
					Ppos != From,
					From != To.

%*
del(clear(To),t) :- 	pushtogoal(P,S,Ppos,From,To,Dir,t),
						movedir(Ppos,From,Dir),
						movedir(From,To,Dir),
						isgoal(To),
						player(P),
						stone(S),
						Ppos != To,
						Ppos != From,
						From != To.
*%
del(clear(To)) :- 	pushtogoal(P,S,Ppos,From,To,Dir),
					_movedir(Ppos,From,Dir),
					_movedir(From,To,Dir),
					_isgoal(To),
					_player(P),
					_stone(S),
					Ppos != To,
					Ppos != From,
					From != To.

%*
at(P,From,t) :- 		pushtogoal(P,S,Ppos,From,To,Dir,t),
						movedir(Ppos,From,Dir),
						movedir(From,To,Dir),
						isgoal(To),
						player(P),
						stone(S),
						Ppos != To,
						Ppos != From,
						From != To.
*%
at_t(P,From) :- 	pushtogoal(P,S,Ppos,From,To,Dir),
					_movedir(Ppos,From,Dir),
					_movedir(From,To,Dir),
					_isgoal(To),
					_player(P),
					_stone(S),
					Ppos != To,
					Ppos != From,
					From != To.

%*
at(S,To,t) :- 			pushtogoal(P,S,Ppos,From,To,Dir,t),
						movedir(Ppos,From,Dir),
						movedir(From,To,Dir),
						isgoal(To),
						player(P),
						stone(S),
						Ppos != To,
						Ppos != From,
						From != To.
*%
at_t(S,To) :- 		pushtogoal(P,S,Ppos,From,To,Dir),
					_movedir(Ppos,From,Dir),
					_movedir(From,To,Dir),
					_isgoal(To),
					_player(P),
					_stone(S),
					Ppos != To,
					Ppos != From,
					From != To.

%*
clear(Ppos,t) :- 		pushtogoal(P,S,Ppos,From,To,Dir,t),
						movedir(Ppos,From,Dir),
						movedir(From,To,Dir),
						isgoal(To),
						player(P),
						stone(S),
						Ppos != To,
						Ppos != From,
						From != To.
*%
clear_t(Ppos) :- 	pushtogoal(P,S,Ppos,From,To,Dir),
					_movedir(Ppos,From,Dir),
					_movedir(From,To,Dir),
					_isgoal(To),
					_player(P),
					_stone(S),
					Ppos != To,
					Ppos != From,
					From != To.

%*
atgoal(S,t) :- 		pushtogoal(P,S,Ppos,From,To,Dir,t),
						stone(S),
						movedir(Ppos,From,Dir),
						movedir(From,To,Dir),
						isgoal(To),
						player(P),
						stone(S),
						Ppos != To,
						Ppos != From,
						From != To.
*%
atgoal(S) :- 		pushtogoal(P,S,Ppos,From,To,Dir),
					_stone(S),
					_movedir(Ppos,From,Dir),
					_movedir(From,To,Dir),
					_isgoal(To),
					_player(P),
					_stone(S),
					Ppos != To,
					Ppos != From,
					From != To.

%*
clear(L,t) :- 	clear(L,t-1),
				not del(clear(L),t).
*%
clear_t(L) :- 	'clear_t(L),
				not del(clear(L)).

%*
atgoal(S,t) :- atgoal(S,t-1),
				not del(atgoal(S),t),
				stone(S).
*%
atgoal(S) :- 	'atgoal(S),
				not del(atgoal(S)),
				_stone(S).

%*
at(T,L,t) :- 	at(T,L,t-1),
				not del(at(T,L),t).
*%
at_t(T,L) :- 	'at_t(T,L),
				not del(at(T,L)).

%*
:- 	pushtonongoal(P,S,Ppos,From,To,Dir,t),
	not preconditions_png(P,S,Ppos,From,To,Dir,t),
	movedir(Ppos,From,Dir),
	movedir(From,To,Dir),
	isnongoal(To),
	player(P),
	stone(S),
	Ppos != To,
	Ppos != From,
	From != To.
*%
:- 	pushtonongoal(P,S,Ppos,From,To,Dir),
	not preconditions_png(P,S,Ppos,From,To,Dir),
	_movedir(Ppos,From,Dir),
	_movedir(From,To,Dir),
	_isnongoal(To),
	_player(P),
	_stone(S),
	Ppos != To,
	Ppos != From,
	From != To.

%*
preconditions_png(P,S,Ppos,From,To,Dir,t) :- 	at(P,Ppos,t-1),
												at(S,From,t-1),
												clear(To,t-1),
												movedir(Ppos,From,Dir),
												movedir(From,To,Dir),
												isnongoal(To),
												player(P),
												stone(S),
												Ppos != To,
												Ppos != From,
												From != To.
*%
preconditions_png(P,S,Ppos,From,To,Dir) :- 	'at_t(P,Ppos),
											'at_t(S,From),
											'clear_t(To),
											_movedir(Ppos,From,Dir),
											_movedir(From,To,Dir),
											_isnongoal(To),
											_player(P),
											_stone(S),
											Ppos != To,
											Ppos != From,
											From != To.

%*
:- 	move(P,From,To,Dir,t),
	not preconditions_m(P,From,To,Dir,t),
	movedir(From,To,Dir),
	player(P),
	From != To.
*%
:- 	move(P,From,To,Dir),
	not preconditions_m(P,From,To,Dir),
	_movedir(From,To,Dir),
	_player(P),
	From != To.

%*
preconditions_m(P,From,To,Dir,t) :- 	at(P,From,t-1),
										clear(To,t-1),
										movedir(From,To,Dir),
										movedir(From,To,Dir),
										player(P),
										From != To.
*%
preconditions_m(P,From,To,Dir) :- 	'at_t(P,From),
									'clear_t(To),
									_movedir(From,To,Dir),
									_movedir(From,To,Dir),
									_player(P),
									From != To.

%*
:- 	pushtogoal(P,S,Ppos,From,To,Dir,t),
	not preconditions_pg(P,S,Ppos,From,To,Dir,t),
	movedir(Ppos,From,Dir),
	movedir(From,To,Dir),
	isgoal(To),
	player(P),
	stone(S),
	Ppos != To,
	Ppos != From,
	From != To.
*%
:- 	pushtogoal(P,S,Ppos,From,To,Dir),
	not preconditions_pg(P,S,Ppos,From,To,Dir),
	_movedir(Ppos,From,Dir),
	_movedir(From,To,Dir),
	_isgoal(To),
	_player(P),
	_stone(S),
	Ppos != To,
	Ppos != From,
	From != To.

%*
preconditions_pg(P,S,Ppos,From,To,Dir,t) :- 	at(P,Ppos,t-1),
												at(S,From,t-1),
												clear(To,t-1),
												movedir(Ppos,From,Dir),
												movedir(From,To,Dir),
												isgoal(To),
												player(P),
												stone(S),
												Ppos != To,
												Ppos != From,
												From != To.
*%
preconditions_pg(P,S,Ppos,From,To,Dir) :- 	'at_t(P,Ppos),
											'at_t(S,From),
											'clear_t(To),
											_movedir(Ppos,From,Dir),
											_movedir(From,To,Dir),
											_isgoal(To),
											_player(P),
											_stone(S),
											Ppos != To,
											Ppos != From,
											From != To.

% goalreached(t) :- 	goalreached(t-1).
goalreached :- 	'goalreached.

%*
goalreached(t) :- 	N = #count{ X : atgoal(X,t), goal(X) },
					N = #count{ X1 : goal(X1) }.
*%
goalreached :- 	N = #count{ X : atgoal(X), _goal(X) },
				N = #count{ X1 : _goal(X1) }.

% #program check(t).
#program final.

% :- not goalreached(t), query(t).
:- not goalreached.