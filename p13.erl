-module(p13).

-export([decode/1]).

decode([])->
	[];
decode([L])->
	p005:reverse(decode(L,[]).

decode([],Acc)->
	Acc;
	
decode([{Number, Letter}|T],Acc)->
	decode(T, [let_gen:letter_list(Number,Letter) ++ Acc]);
 
decode([H|T],Acc)->
	decode(T,[H|Acc]).
