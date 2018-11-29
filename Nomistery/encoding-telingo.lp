truck(T) :- fuel(T,_).
package(P) :- at(P,L), not truck(P).
location(L) :- fuelcost(_,L,_).
location(L) :- fuelcost(_,_,L).
locatable(O) :- at(O,L).
at(O,L) :- at(O,L).
fuel(T,F) :- fuel(T,F).

action(unload(P,T,L)) :- package(P), truck(T), location(L).
action(load(P,T,L)) :- package(P), truck(T), location(L).
action(drive(T,L1,L2)) :- fuelcost(Fueldelta,L1,L2), truck(T).

#program dynamic.
{ occurs(A) : _action(A) } <= 1.

done :- occurs(A).
:- done, not not &tel{ <* done }.

unload(P,T,L) :- occurs(unload(P,T,L)).
load(P,T,L) :- occurs(load(P,T,L)).
drive(T,L1,L2) :- occurs(drive(T,L1,L2)).

at(P,L) :- unload(P,T,L).
del(in(P,T)) :- unload(P,T,L).

del(at(P,L)) :- load(P,T,L).
in(P,T) :- load(P,T,L).

del(at(T,L1)) :- drive(T,L1,L2).
at(T,L2) :- drive(T,L1,L2).
del(fuel(T,Fuelpre)) :- drive(T,L1,L2), 'fuel(T,Fuelpre).
fuel(T,Fuelpre - Fueldelta) :- drive(T,L1,L2), _fuelcost(Fueldelta,L1,L2), 'fuel(T,Fuelpre), Fuelpre >= Fueldelta.

at(O,L) :- 'at(O,L), not del(at(O,L)).
in(P,T) :- 'in(P,T), not del(in(P,T)).
fuel(T,Level) :- 'fuel(T,Level), not del(fuel(T,Level)), _truck(T).

 :- unload(P,T,L), not preconditions_u(P,T,L).
preconditions_u(P,T,L) :- 'at(T,L), 'in(P,T), _package(P), _truck(T).

 :- load(P,T,L), not preconditions_l(P,T,L).
preconditions_l(P,T,L) :- 'at(T,L), 'at(P,L).

 :- drive(T,L1,L2), not preconditions_d(T,L1,L2).
preconditions_d(T,L1,L2) :- 'at(T,L1), 'fuel(T,Fuelpre), _fuelcost(Fueldelta,L1,L2), Fuelpre >= Fueldelta.

#program final.
:- _goal(P,L), not at(P,L), _package(P).
