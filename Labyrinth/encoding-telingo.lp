% #program base.
#program initial.

% dir(e). dir(w). dir(n). dir(s).
dir(e). dir(w). dir(n). dir(s).

% inverse(e,w). inverse(w,e).
inverse(e,w). inverse(w,e).

% inverse(n,s). inverse(s,n).
inverse(n,s). inverse(s,n).

% row(X) :- field(X,Y).
row(X) :- field(X,Y).

%col(Y) :- field(X,Y).
col(Y) :- field(X,Y).

% num_rows(X) :- row(X), not row(XX), XX = X+1.
num_rows(X) :- row(X), not row(XX), XX = X+1.

% num_cols(Y) :- col(Y), not col(YY), YY = Y+1.
num_cols(Y) :- col(Y), not col(YY), YY = Y+1.

% goal(X,Y,0)   :- goal_on(X,Y).
goal(X,Y)   :- goal_on(X,Y).

% reach(X,Y,0)  :- init_on(X,Y).
reach(X,Y)  :- init_on(X,Y).

% conn(X,Y,D,0) :- connect(X,Y,D).
conn(X,Y,D) :- connect(X,Y,D).

% dneighbor(n,X,Y,XX,Y) :- field(X,Y), field(XX,Y), XX = X+1.
dneighbor(n,X,Y,XX,Y) :- field(X,Y), field(XX,Y), XX = X+1.

% dneighbor(s,X,Y,XX,Y) :- field(X,Y), field(XX,Y), XX = X-1.
dneighbor(s,X,Y,XX,Y) :- field(X,Y), field(XX,Y), XX = X-1.

% dneighbor(e,X,Y,X,YY) :- field(X,Y), field(X,YY), YY = Y+1.
dneighbor(e,X,Y,X,YY) :- field(X,Y), field(X,YY), YY = Y+1.

% dneighbor(w,X,Y,X,YY) :- field(X,Y), field(X,YY), YY = Y-1.
dneighbor(w,X,Y,X,YY) :- field(X,Y), field(X,YY), YY = Y-1.

% neighbor(D,X,Y,XX,YY) :- dneighbor(D,X,Y,XX,YY).
neighbor(D,X,Y,XX,YY) :- dneighbor(D,X,Y,XX,YY).

% neighbor(n,X,Y, 1, Y) :- field(X,Y), num_rows(X).
neighbor(n,X,Y, 1, Y) :- field(X,Y), num_rows(X).

% neighbor(s,1,Y, X, Y) :- field(X,Y), num_rows(X).
neighbor(s,1,Y, X, Y) :- field(X,Y), num_rows(X).

% neighbor(e,X,Y, X, 1) :- field(X,Y), num_cols(Y).
neighbor(e,X,Y, X, 1) :- field(X,Y), num_cols(Y).

% neighbor(w,X,1, X, Y) :- field(X,Y), num_cols(Y).
neighbor(w,X,1, X, Y) :- field(X,Y), num_cols(Y).

% #program check(t).
#program always.

% neg_goal(t) :- goal(X,Y,t), not reach(X,Y,t).
neg_goal :- goal(X,Y), not reach(X,Y).

% #program step(t).
#program dynamic.

% { occurs(some_action,t) }.
{ occurs(some_action) }.

% rrpush(t)   :- neg_goal(t-1), not ccpush(t), occurs(some_action,t).
rrpush   :- 'neg_goal, not ccpush, occurs(some_action).

% ccpush(t)   :- neg_goal(t-1), not rrpush(t), occurs(some_action,t).
ccpush   :- 'neg_goal, not rrpush, occurs(some_action).

% orpush(X,t) :- row(X), row(XX), rpush(XX,t), X != XX.
orpush(X) :- _row(X), _row(XX), rpush(XX), X != XX.

% ocpush(Y,t) :- col(Y), col(YY), cpush(YY,t), Y != YY.
ocpush(Y) :- _col(Y), _col(YY), cpush(YY), Y != YY.

% rpush(X,t)  :- row(X), rrpush(t), not orpush(X,t).
rpush(X)  :- _row(X), rrpush, not orpush(X).

% cpush(Y,t)  :- col(Y), ccpush(t), not ocpush(Y,t).
cpush(Y)  :- _col(Y), ccpush, not ocpush(Y).

% push(X,e,t) :- rpush(X,t), not push(X,w,t).
push(X,e) :- rpush(X), not push(X,w).

% push(X,w,t) :- rpush(X,t), not push(X,e,t).
push(X,w) :- rpush(X), not push(X,e).

% push(Y,n,t) :- cpush(Y,t), not push(Y,s,t).
push(Y,n) :- cpush(Y), not push(Y,s).

% push(Y,s,t) :- cpush(Y,t), not push(Y,n,t).
push(Y,s) :- cpush(Y), not push(Y,n).

% shift(XX,YY,X,Y,t) :- neighbor(e,XX,YY,X,Y), push(XX,e,t).
shift(XX,YY,X,Y) :- _neighbor(e,XX,YY,X,Y), push(XX,e).

% shift(XX,YY,X,Y,t) :- neighbor(w,XX,YY,X,Y), push(XX,w,t).
shift(XX,YY,X,Y) :- _neighbor(w,XX,YY,X,Y), push(XX,w).

% shift(XX,YY,X,Y,t) :- neighbor(n,XX,YY,X,Y), push(YY,n,t).
shift(XX,YY,X,Y) :- _neighbor(n,XX,YY,X,Y), push(YY,n).

% shift(XX,YY,X,Y,t) :- neighbor(s,XX,YY,X,Y), push(YY,s,t).
shift(XX,YY,X,Y) :- _neighbor(s,XX,YY,X,Y), push(YY,s).

% shift( X, Y,X,Y,t) :- field(X,Y), not push(X,e,t), not push(X,w,t), not push(Y,n,t), not push(Y,s,t).
shift( X, Y,X,Y) :- _field(X,Y), not push(X,e), not push(X,w), not push(Y,n), not push(Y,s).

% conn(X,Y,D,t) :- conn(XX,YY,D,t-1), dir(D), shift(XX,YY,X,Y,t).
conn(X,Y,D) :- 'conn(XX,YY,D), _dir(D), shift(XX,YY,X,Y).

% goal(X,Y,t) :- goal(XX,YY,t-1), shift(XX,YY,X,Y,t).
goal(X,Y) :- 'goal(XX,YY), shift(XX,YY,X,Y).

% reach(X,Y,t) :- reach(XX,YY,t-1), shift(XX,YY,X,Y,t).
reach(X,Y) :- 'reach(XX,YY), shift(XX,YY,X,Y).

% reach(X,Y,t) :- reach(XX,YY,t), dneighbor(D,XX,YY,X,Y), conn(XX,YY,D,t), conn(X,Y,E,t), inverse(D,E).
reach(X,Y) :- reach(XX,YY), _dneighbor(D,XX,YY,X,Y), conn(XX,YY,D), conn(X,Y,E), _inverse(D,E).

% #program check(t).
#program final.

% :- neg_goal(t), query(t).
:- neg_goal.