% atrobot(X,0) :- at(X).
atrobot(X) :- at(X).

% #program step(t).
#program dynamic.

% { occurs(some_action,t) }.
{ occurs(some_action) }.

% atrobot(N,t) :- connected(C,N), C != N, not atother(N,t), occurs(some_action,t).
atrobot(N) :- _connected(C,N), C != N, not atother(N), occurs(some_action).

% atother(N,t) :- connected(C,N), C != N, atrobot(O,t), O != N, occurs(some_action,t).
atother(N) :- _connected(C,N), C != N, atrobot(O), O != N, occurs(some_action).

% move(C,N,t) :- atrobot(C,t-1), atrobot(N,t), connected(C,N), C != N.
move(C,N) :- 'atrobot(C), atrobot(N), _connected(C,N), C != N.

% done(t)     :- move(C,N,t).
done     :- move(C,N).

% :- not done(t), occurs(some_action,t).
:- not done, occurs(some_action).

% visited(X,t) :- visited(X,t-1).
visited(X) :- 'visited(X).

% visited(X,t) :- atrobot(X,t).
visited(X) :- atrobot(X).

% #program check(t).
#program final.

% :- visit(X), not visited(X,t), query(t).
:- _visit(X), not visited(X).