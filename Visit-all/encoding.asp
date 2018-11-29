atrobot(X,0) :- at(X).

#program step(t).
{ occurs(some_action,t) }.
atrobot(N,t) :- connected(C,N), C != N, not atother(N,t), occurs(some_action,t).
atother(N,t) :- connected(C,N), C != N, atrobot(O,t), O != N, occurs(some_action,t).

move(C,N,t) :- atrobot(C,t-1), atrobot(N,t), connected(C,N), C != N.
done(t)     :- move(C,N,t).

:- not done(t), occurs(some_action,t).

visited(X,t) :- visited(X,t-1).
visited(X,t) :- atrobot(X,t).

#program check(t).
:- visit(X), not visited(X,t), query(t).