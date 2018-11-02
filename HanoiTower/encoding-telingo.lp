% Problem description: www.mat.unical.it/aspcomp2013/HanoiTower


% The meaning of the time predicate is self-evident. As for the disk
% predicate, there are k disks 1,2,...,k. Disks 1, 2, 3, 4 denote pegs.
% Disks 5, ... are "movable". The larger the number of the disk,
% the "smaller" it is.
%
% The program uses additional predicates:
% on(T,N,M), which is true iff at time T, disk M is on disk N
% move(t,N), which is true iff at time T, it is disk N that will be
% moved
% where(T,N), which is true iff at time T, the disk to be moved is moved
% on top of the disk N.
% goal, which is true iff the goal state is reached at time t
% steps(T), which is the number of time steps T, required to reach the goal (provided part of Input data)
#program initial.
% Read in data
on(N1,N) :- on0(N,N1).

#program dynamic.


%onG(K,N1,N) :- ongoal(N,N1), steps(K).

% Specify valid arrangements of disks
% Basic condition. Smaller disks are on larger ones

%#program always.
%:- on(N1,N), N1>=N.

% Specify a valid move (only for T<t)
% pick a disk to move

%#program step(t).
{ occurs(some_action) }.
1 { move(N) : _disk(N) } 1 :- occurs(some_action).

% pick a disk onto which to move
1 { where(N) : _disk(N) }1 :- occurs(some_action).

% pegs cannot be moved
:- move(N), N<5.

% only top disk can be moved
:- 'on(N,N1), move(N).

% a disk can be placed on top only.
:- 'on(N,N1), where(N).

% no disk is moved in two consecutive moves
:- move(N), 'move(N).

% Specify effects of a move
on(N1,N) :- move(N), where(N1).
on(N,N1) :- 'on(N,N1), not move(N1).

put(M,N) : move(N), where(M).

:- on(N1,N), N1>=N.

% Goal description
#program final.
:- not on(N,N1), _ongoal(N1,N).
:- on(N,N1), not _ongoal(N1,N).

% Solution
%#show put(M,N,T) : move(T,N), where(T,M), T=t.
%#show move/2.
%#show on/3.
#show put/2.
