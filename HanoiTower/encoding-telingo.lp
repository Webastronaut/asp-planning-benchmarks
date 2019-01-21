% on(0,N1,N) :- on0(N,N1).
on(N1,N) :- on0(N,N1).

% #program check(t).
#program always.
% :- on(t,N1,N), N1>=N.
:- on(N1,N), N1>=N.

% #program step(t).
#program dynamic.

% { occurs(some_action,t) }.
{ occurs(some_action) }.

% 1 { move(t,N) : disk(N) } 1 :- occurs(some_action,t).
1 { move(N) : _disk(N) } 1 :- occurs(some_action).

% 1 { where(t,N) : disk(N) }1 :- occurs(some_action,t).
1 { where(N) : _disk(N) }1 :- occurs(some_action).

% :- move(t,N), N<5.
:- move(N), N<5.

% :- on(t-1,N,N1), move(t,N).
:- 'on(N,N1), move(N).

% :- on(t-1,N,N1), where(t,N).
:- 'on(N,N1), where(N).

% :- move(t,N), move(t-1,N).
:- move(N), 'move(N).

% on(t,N1,N) :- move(t,N), where(t,N1).
on(N1,N) :- move(N), where(N1).

% on(t,N,N1) :- on(t-1,N,N1), not move(t,N1).
on(N,N1) :- 'on(N,N1), not move(N1).

% #program check(t).
#program final.

% :- not on(t,N,N1), ongoal(N1,N), query(t).
:- not on(N,N1), _ongoal(N1,N).

%:- on(t,N,N1), not ongoal(N1,N), query(t).
:- on(N,N1), not _ongoal(N1,N).
