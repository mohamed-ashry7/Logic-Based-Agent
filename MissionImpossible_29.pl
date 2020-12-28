:- include('KB.pl').




is_there_soldier(Ex,Ey,[[Ex,Ey]|T],T).
is_there_soldier(Ex,Ey,[[X,Y]|T],L):-
    (Ex \= X ; Ey\=Y),
    is_there_soldier(Ex,Ey,T,L1),
    L = [[X,Y]|L1].
    
helper_goal(Ex,Ey,[],C,S,S):-
    % Goal state.
    capacity(C),
    submarine(Ex,Ey).

helper_goal(Ex,Ey,L,C,S,G):-
    % move up. 
    Ex > 0,
    Ex1 is Ex-1,
    helper_goal(Ex1,Ey,L,C,result(up,S),G).
helper_goal(Ex,Ey,L,C,S,G):-
    % move down
    Ex < 3,
    Ex1 is Ex+1,
    helper_goal(Ex1,Ey,L,C,result(down,S),G).

helper_goal(Ex,Ey,L,C,S,G):-
    % move left
    Ey > 0, 
    Ey1 is Ey-1 , 
    helper_goal(Ex,Ey1,L,C,result(left,S),G).

helper_goal(Ex,Ey,L,C,S,G):-
    % move right
    Ey < 3, 
    Ey1 is Ey+1 , 
    helper_goal(Ex,Ey1,L,C,result(right,S),G).



helper_goal(Ex,Ey,L,C,S,G):-
    % carry
    C>0,
    is_there_soldier(Ex,Ey,L,L1),
    C1 is C-1,
    helper_goal(Ex,Ey,L1,C1,result(carry,S),G).

helper_goal(Ex,Ey,L,C,S,G):-
    % drop
    capacity(Cp),
    C\=Cp,
    submarine(Ex,Ey),
    helper_goal(Ex,Ey,L,Cp,result(drop,S),G).



call_with_incremental_goal(Ex,Ey,L,C,StartState,D,S):-
    call_with_depth_limit(helper_goal(Ex,Ey,L,C,StartState,S),D,R),
    R\==depth_limit_exceeded.

call_with_incremental_goal(Ex,Ey,L,C,StartState,D,S):-
    call_with_depth_limit(helper_goal(Ex,Ey,L,C,StartState,S),D,R),
    R==depth_limit_exceeded,
    D1 is D+2, 
    call_with_incremental_goal(Ex,Ey,L,C,StartState,D1,S).

has_var(S):-
    var(S).

has_var(S):-
    S = result(_,S1),
    has_var(S1).



goal(S):-
    % If S has a var.
    ethan_loc(Ex,Ey),
    members_loc(L),
    capacity(C),
    has_var(S),
    call_with_incremental_goal(Ex,Ey,L,C,s0,1,S).


goal(S):-
    % If S has not a var
    ethan_loc(Ex,Ey),
    members_loc(L),
    capacity(C),
    \+has_var(S),
    call_with_depth_limit(helper_goal(Ex,Ey,L,C,s0,S),15,R),
    write(R),
    R\==depth_limit_exceeded.
