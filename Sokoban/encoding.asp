#program base.
at(P,To,0) :- at(P,To).
clear(P,0) :- clear(P).
atgoal(S,0) :- isgoal(L), stone(S), at(S,L).

#program step(t).
{ occurs(some_action,t) }.
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

del(at(P,Ppos),t) :- 	pushtonongoal(P,S,Ppos,From,To,Dir,t),
						movedir(Ppos,From,Dir),
						movedir(From,To,Dir),
						isnongoal(To),
						player(P),
						stone(S),
						Ppos != To,
						Ppos != From,
						From != To.
del(at(S,From),t) :- 	pushtonongoal(P,S,Ppos,From,To,Dir,t),
						movedir(Ppos,From,Dir),
						movedir(From,To,Dir),
						isnongoal(To),
						player(P),
						stone(S),
						Ppos != To,
						Ppos != From,
						From != To.
del(clear(To),t) :- 	pushtonongoal(P,S,Ppos,From,To,Dir,t),
						movedir(Ppos,From,Dir),
						movedir(From,To,Dir),
						isnongoal(To),
						player(P),
						stone(S),
						Ppos != To,
						Ppos != From,
						From != To.
at(P,From,t) :- 		pushtonongoal(P,S,Ppos,From,To,Dir,t),
						movedir(Ppos,From,Dir),
						movedir(From,To,Dir),
						isnongoal(To),
						player(P),
						stone(S),
						Ppos != To,
						Ppos != From,
						From != To.
at(S,To,t) :- 			pushtonongoal(P,S,Ppos,From,To,Dir,t),
						movedir(Ppos,From,Dir),
						movedir(From,To,Dir),
						isnongoal(To),
						player(P),
						stone(S),
						Ppos != To,
						Ppos != From,
						From != To.
clear(Ppos,t) :- 		pushtonongoal(P,S,Ppos,From,To,Dir,t),
						movedir(Ppos,From,Dir),
						movedir(From,To,Dir),
						isnongoal(To),
						player(P),
						stone(S),
						Ppos != To,
						Ppos != From,
						From != To.
del(atgoal(S),t) :- 	pushtonongoal(P,S,Ppos,From,To,Dir,t),
						movedir(Ppos,From,Dir),
						movedir(From,To,Dir),
						isnongoal(To),
						player(P),
						stone(S),
						Ppos != To,
						Ppos != From,
						From != To.

del(at(P,From),t) :- 	move(P,From,To,Dir,t),
						movedir(From,To,Dir),
						player(P),
						From != To.
del(clear(To),t) :- 	move(P,From,To,Dir,t),
						movedir(From,To,Dir),
						player(P),
						From != To.
at(P,To,t) :- 			move(P,From,To,Dir,t),
						movedir(From,To,Dir),
						player(P),
						From != To.
clear(From,t) :- 		move(P,From,To,Dir,t),
						movedir(From,To,Dir),
						player(P),
						From != To.

del(at(P,Ppos),t) :- 	pushtogoal(P,S,Ppos,From,To,Dir,t),
						movedir(Ppos,From,Dir),
						movedir(From,To,Dir),
						isgoal(To),
						player(P),
						stone(S),
						Ppos != To,
						Ppos != From,
						From != To.
del(at(S,From),t) :- 	pushtogoal(P,S,Ppos,From,To,Dir,t),
						movedir(Ppos,From,Dir),
						movedir(From,To,Dir),
						isgoal(To),
						player(P),
						stone(S),
						Ppos != To,
						Ppos != From,
						From != To.
del(clear(To),t) :- 	pushtogoal(P,S,Ppos,From,To,Dir,t),
						movedir(Ppos,From,Dir),
						movedir(From,To,Dir),
						isgoal(To),
						player(P),
						stone(S),
						Ppos != To,
						Ppos != From,
						From != To.
at(P,From,t) :- 		pushtogoal(P,S,Ppos,From,To,Dir,t),
						movedir(Ppos,From,Dir),
						movedir(From,To,Dir),
						isgoal(To),
						player(P),
						stone(S),
						Ppos != To,
						Ppos != From,
						From != To.
at(S,To,t) :- 			pushtogoal(P,S,Ppos,From,To,Dir,t),
						movedir(Ppos,From,Dir),
						movedir(From,To,Dir),
						isgoal(To),
						player(P),
						stone(S),
						Ppos != To,
						Ppos != From,
						From != To.
clear(Ppos,t) :- 		pushtogoal(P,S,Ppos,From,To,Dir,t),
						movedir(Ppos,From,Dir),
						movedir(From,To,Dir),
						isgoal(To),
						player(P),
						stone(S),
						Ppos != To,
						Ppos != From,
						From != To.
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

clear(L,t) :- 	clear(L,t-1),
				not del(clear(L),t).
atgoal(S,t) :- atgoal(S,t-1),
				not del(atgoal(S),t),
				stone(S).
at(T,L,t) :- 	at(T,L,t-1),
				not del(at(T,L),t).

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

:- 	move(P,From,To,Dir,t),
	not preconditions_m(P,From,To,Dir,t),
	movedir(From,To,Dir),
	player(P),
	From != To.
preconditions_m(P,From,To,Dir,t) :- 	at(P,From,t-1),
										clear(To,t-1),
										movedir(From,To,Dir),
										movedir(From,To,Dir),
										player(P),
										From != To.

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

goalreached(t) :- 	goalreached(t-1).
goalreached(t) :- 	N = #count{ X : atgoal(X,t), goal(X) },
					N = #count{ X1 : goal(X1) }.

#program check(t).
:- not goalreached(t), query(t).
