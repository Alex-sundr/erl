-module(bs04).
-export([decode/2 ]).

decode(Bin,Selector) ->

	case Selector of
		
		%proplist -> decode_in_proplist(Bin,<<>>);   
		
		map -> decode_in_map(Bin,<<>>,empty,maps:new(),0)   

	end.


%decode_in_proplist(Bin,Acc)->
    
  %  case Bin of 
    
  %  <<>> -> 
   % 	Acc;

   % << "}", _>> ->
   	%	Acc	; 

     %<< "{" , Rest/binary >> ->                   
	%		decode_in_proplist(Rest, Bin); 

	
   %<< "'", K,"':", Val/integer , Rest/binary>>  ->
		%decode_in_proplist(Rest, [{K,Val}|Acc]);
   %<< "'", K,"':'", Val, "'," , Rest/binary>> when  is_list(K), is_list(Val)->
	%	{K,Val}

		% decode_in_proplist(Rest, [{K,Val}|Acc])


   % end.


decode_in_map(<<"{", Rest/binary>>,KvAcc,KvAccCondition,Acc,BracketCnt)->
          decode_in_map( Rest ,KvAcc,KvAccCondition,Acc,1);

decode_in_map(<<"}", Rest/binary>>,KvAcc,KvAccCondition,Acc,BracketCnt)->
          decode_in_map( Rest ,KvAcc,KvAccCondition,Acc,BracketCnt-1);

decode_in_map(_,KvAcc,KvAccCondition,Acc,0)->
          Acc;

ecode_in_map(<<"}", Rest/binary>>,KvAcc,KvAccCondition,Acc,BracketCnt)->
          decode_in_map( Rest ,KvAcc,KvAccCondition,Acc,BracketCnt-1);

decode_in_map(Bin,KvAcc,rawbin,Acc,BracketCnt)->
      	decode_in_map(Bin,<<>>,empty, binary_to_list(KvAcc)++Acc,BracketCnt);


 
	%ex()->
	%  decode(<<"{'squadName':'Super hero squad','homeTown':'Metro City'}">>,map)
		%Var = <<"{'squadName':'Super hero squad','homeTown':'Metro City','formed': 2016,'secretBase':'Super tower','active': true}">>.
   %bs04:decode (Var, map).


%[Key, K_rest] = binary:split(<<"squadName':'Super hero squad'">>, <<"':'">>, []).

