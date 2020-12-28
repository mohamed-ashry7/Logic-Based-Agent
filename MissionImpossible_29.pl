:- include('KB.pl').




is_there_soldier(Ex,Ey,[[Ex,Ey]|T],T).
is_there_soldier(Ex,Ey,[[X,Y]|T],L):-
    (Ex \= X ; Ey\=Y),
    is_there_soldier(Ex,Ey,T,L1),
    L = [[X,Y]|L1].
    
helper_goal(Ex,Ey,[],Ex,Ey,C,C,S,S).

helper_goal(Ex,Ey,L,Sx,Sy,C,Cp,S,G):-
    % move up. 
    Ex > 0,
    Ex1 is Ex-1,
    helper_goal(Ex1,Ey,L,Sx,Sy,C,Cp,result(up,S),G).
helper_goal(Ex,Ey,L,Sx,Sy,C,Cp,S,G):-
    % move down
    Ex < 3,
    Ex1 is Ex+1,
    helper_goal(Ex1,Ey,L,Sx,Sy,C,Cp,result(down,S),G).

helper_goal(Ex,Ey,L,Sx,Sy,C,Cp,S,G):-
    % move left
    Ey > 0, 
    Ey1 is Ey-1 , 
    helper_goal(Ex,Ey1,L,Sx,Sy,C,Cp,result(left,S),G).

helper_goal(Ex,Ey,L,Sx,Sy,C,Cp,S,G):-
    % move right
    Ey < 3, 
    Ey1 is Ey+1 , 
    helper_goal(Ex,Ey1,L,Sx,Sy,C,Cp,result(right,S),G).



helper_goal(Ex,Ey,L,Sx,Sy,C,Cp,S,G):-
    % carry
    C>0,
    is_there_soldier(Ex,Ey,L,L1),
    C1 is C-1,
    helper_goal(Ex,Ey,L1,Sx,Sy,C1,Cp,result(carry,S),G).

helper_goal(Ex,Ey,L,Ex,Ey,C,Cp,S,G):-
    % drop
    C\=Cp,
    helper_goal(Ex,Ey,L,Ex,Ey,Cp,Cp,result(drop,S),G).


goal(S):-
    ethan_loc(Ex,Ey),
    members_loc(L),
    submarine(Sx,Sy),
    capacity(C),
    call_with_depth_limit(helper_goal(Ex,Ey,L,Sx,Sy,C,C,s0,S),8,R),
    R\==depth_limit_exceeded.