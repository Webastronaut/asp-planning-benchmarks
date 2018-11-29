on(0,N1,N) :- on0(N,N1).

#program check(t).
:- on(t,N1,N), N1>=N.

#program step(t).
{ occurs(some_action,t) }.
1 { move(t,N) : disk(N) } 1 :- occurs(some_action,t).

1 { where(t,N) : disk(N) }1 :- occurs(some_action,t).

:- move(t,N), N<5.

:- on(t-1,N,N1), move(t,N).

:- on(t-1,N,N1), where(t,N).

:- move(t,N), move(t-1,N).

on(t,N1,N) :- move(t,N), where(t,N1).
on(t,N,N1) :- on(t-1,N,N1), not move(t,N1).

#program check(t).
:- not on(t,N,N1), ongoal(N1,N), query(t).
:- on(t,N,N1), not ongoal(N1,N), query(t).
