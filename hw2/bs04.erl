-module(bs04).
-export([decode/2 ]).

decode(Bin,Selector) ->

	case Selector of
		
		%proplist -> decode_in_proplist(Bin,<<>>);   
		
		map -> decode_in_map(Bin,maps:new(),0)   

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

decode_in_map(Bin,Acc,N)->

       case Bin of
      <<>> -> 	
	 		Acc ;

	<< "}", Rest/binary >> ->                   
			decode_in_map(Rest,Acc,N-1); 

	<< "{", Rest/binary >> ->                   
			decode_in_map(Rest,Acc,N+1); 
	%<< ",", Rest/binary >> ->                   
		%	decode_in_map(Rest,Acc,N); 

	

        

    <<"'", Rest/binary>> ->
	        [Key, K_rest] = binary:split(Rest, <<"':">>, []),

	        [Value, V_rest] = binary:split(K_rest, <<",">>, []),
	           if
	           	is_atom(Value) ->
	           		  decode_in_map(V_rest, maps:put(Key , binary_to_atom (Value, utf8), Acc), N);

	           	is_list(Value)->  
	           		decode_in_map(V_rest, maps:put(Key , binary_to_list(Value), Acc), N);

	           	is_number(Value)->  
	           		decode_in_map(V_rest, maps:put(Key , list_to_integer(binary_to_list(Value)), Acc), N);

	           		true ->

	                                 [Value, V_rest] = binary:split(K_rest, <<"'">>, []),
	                                 [_,Value1] = <<"'", Value/binary>>,
	                                 decode_in_map(V_rest, maps:put(Key , Value1, Acc), N)

	          end

		




        end.    


	%ex()->
	%  decode(<<"{'squadName':'Super hero squad','homeTown':'Metro City'}">>,map)
		%Var = <<"{'squadName':'Super hero squad','homeTown':'Metro City','formed': 2016,
%'secretBase':'Super tower','active': true}">>.
   %bs04:decode (Var, map).


%[Key, K_rest] = binary:split(<<"squadName':'Super hero squad'">>, <<"':'">>, []).


%