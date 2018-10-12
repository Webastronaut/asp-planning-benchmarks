%
% Nomystery for ASP 2013.
%
% Domain specification freely adapted from the plasp PDDL-to-ASP output
% (http://potassco.sourceforge.net/labs.html)
%
% Author (2013) GB Ianni
%
% Problem description: https://www.mat.unical.it/aspcomp2013/Nomystery
%
#program initial.

truck(T) :- fuel(T,_).
package(P) :- at(P,L), not truck(P).
location(L) :- fuelcost(_,L,_).
location(L) :- fuelcost(_,_,L).
locatable(O) :- at(O,L).
%
%at(O,L,0) :- at(O,L).
%fuel(T,F,0) :- fuel(T,F).
%

action(unload(P,T,L))  :- package( P ), truck( T ), location( L ).
action(load(P,T,L))    :- package( P ), truck( T ), location( L ).
action(drive(T,L1,L2)) :- fuelcost( Fueldelta,L1,L2 ) , truck( T ).

%
% GENERATE  >>>>>
#program dynamic.

{ occurs(A) : action(A) }. % :- step(S), 0 < S.

done :- occurs(A).
:- done, not 'done.

unload( P,T,L )  :- occurs(unload(P,T,L)).
load( P,T,L )    :- occurs(load(P,T,L)).
drive( T,L1,L2 ) :- occurs(drive(T,L1,L2)).
% <<<<<  GENERATE

% unload/4, effects
at( P,L ) :- unload( P,T,L ).
del( in( P,T ) ) :- unload( P,T,L ).

% load/4, effects
del( at( P,L ) ) :- load( P,T,L ).
in( P,T ) :- load( P,T,L ).

% drive/4, effects
del( at( T,L1 ) ) :- drive( T,L1,L2 ).
at( T,L2 ) :- drive( T,L1,L2).
del( fuel( T,Fuelpre ) ) :- drive( T,L1,L2 ), 'fuel(T, Fuelpre).
fuel( T,Fuelpre - Fueldelta ) :- drive( T,L1,L2 ), _fuelcost(Fueldelta,L1,L2), 'fuel(T,Fuelpre), Fuelpre >= Fueldelta.
% <<<<<  EFFECTS APPLY
%
% INERTIA  >>>>>
at( O,L ) :- 'at( O,L ), not del( at( O,L )  ).
in( P,T ) :- in( P,T ), not del( in( P,T )  ).
fuel( T,Level ) :- 'fuel( T,Level ), not del( fuel( T,Level) ), _truck( T ).
% <<<<<  INERTIA
%

%
%
% PRECONDITIONS CHECK  >>>>>

% unload/4, preconditions
 :- unload( P,T,L ), not preconditions_u( P,T,L ).
preconditions_u( P,T,L ) :- 'at( T,L ), 'in( P,T ), _package( P ), _truck( T ).

% load/4, preconditions
 :- load( P,T,L ), not preconditions_l( P,T,L ).
preconditions_l( P,T,L ) :- 'at( T,L ), 'at( P,L ).

% drive/5, preconditions
 :- drive( T,L1,L2 ), not preconditions_d( T,L1,L2 ).
preconditions_d( T,L1,L2 ) :- 'at( T,L1 ), 'fuel( T, Fuelpre), _fuelcost(Fueldelta,L1,L2), Fuelpre >= Fueldelta.
% <<<<<  PRECONDITIONS HOLD
%

% GOAL CHECK
#program final.
:- _goal(P,L), not at(P,L).
%:- goal(P,L), step(S), not step(S+1), not at(P,L,S).

% goalreached :- step(S),  N = #count{ P,L : at(P,L,S) , goal(P,L) }, N = #count{ P1,L1 : goal(P1,L1) }.
% :- not goalreached.

% Gringo directives to show / hide particular literals
%#hide.
%#show unload/4.
%#show load/4.
%#show drive/4.
%#show at/2.
%#show at/3.
#show occurs/2.

