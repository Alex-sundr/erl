-module(bs04).
-export([decode/2 ]).

decode(Bin,Selector) ->

	case Selector of
		
		%proplist -> decode_in_proplist(Bin,<<>>);   
		
		map -> decode_in_map(Bin,<<>>,<<>>,empty,[],0)   

	end.

 


decode_in_map(<<"{", Rest/binary>>,K_Acc,V_Acc,KvAccCondition,Acc,BracketCnt)->
          decode_in_map( Rest ,K_Acc,V_Acc,KvAccCondition,Acc,BracketCnt+1);

%decode_in_map(<<"}", Rest/binary>>,KvAcc,V_AccKvAccCondition,Acc,BracketCnt)->
         % decode_in_map( Rest ,K_Acc,V_AccKvAccCondition,Acc,BracketCnt-1);

 
          
decode_in_map(_,_,_,empty,Acc,0) ->
          Acc;

decode_in_map(Bin,_,_,empty,Acc,BracketCnt)->  %Вытаскиваем ключ
		 [H, T] = binary:split(Bin, <<":">>, []),
          decode_in_map(T,H, <<>>,krawbin,Acc,BracketCnt);

decode_in_map(Bin,<<"'", KVRest/binary>>,V_Acc,krawbin,Acc,BracketCnt)-> % преобразуем и добавляем ключ в аккумулятор ключа 
		 [H, _] = binary:split(KVRest, <<"'">>, []),
          decode_in_map(Bin,binary_to_list(H),V_Acc,krawbin,Acc,BracketCnt);          

decode_in_map(<<"'", Rest/binary>>,K_Acc,_,krawbin,Acc,BracketCnt)->  %Вытаскиваем значения для ключа если текст
		 [H, T] = binary:split(Rest, <<"'">>, []),
          decode_in_map( T,<<>>,vrawbin,maps:put(K_Acc,binary_to_list(H),Acc),BracketCnt);  


			  
decode_in_map(<<",", Rest/binary>> ,K_Acc,V_Acc,vrawbin,Acc,BracketCnt)  ->  %Вытаскиваем значения для соотв ключа если не текст 
   if
	    is_atom(V_Acc) ->
	      decode_in_map(Rest,<<>>,<<>>,empty,maps:put(K_Acc,binary_to_atom(V_Acc,utf8),Acc),BracketCnt); 
	    is_list(V_Acc)->  
	       decode_in_map(Rest,<<>>,<<>>,empty,maps:put(K_Acc,binary_to_list(V_Acc),Acc),BracketCnt); 
	    is_number(V_Acc)->  
	      decode_in_map(Rest,<<>>,<<>>,empty,maps:put(K_Acc,binary_to_integer(V_Acc),Acc),BracketCnt) 
   end;
		   


decode_in_map(<< "}", Rest/binary>>,K_Acc,V_Acc,vrawbin,Acc,BracketCnt)  ->  %Вытаскиваем значения для соотв ключа если не текст 

		  if
	    is_atom(V_Acc) ->
	      decode_in_map(Rest,<<>>,<<>>,empty,maps:put(K_Acc,binary_to_atom(V_Acc,utf8),Acc),BracketCnt-1); 
	    is_list(V_Acc)->  
	       decode_in_map(Rest,<<>>,<<>>,empty,maps:put(K_Acc,binary_to_list(V_Acc),Acc),BracketCnt-1); 
	    is_number(V_Acc)->  
	      decode_in_map(Rest,<<>>,<<>>,empty,maps:put(K_Acc,binary_to_integer(V_Acc),Acc),BracketCnt-1) 
		end;



	

decode_in_map(<<C/utf8, Rest/binary>>,K_Acc,V_Acc,vrawbin,Acc,BracketCnt) ->      
	decode_in_map(Rest,K_Acc,<<V_Acc,C>>,vrawbin,Acc,BracketCnt).	 

 

       %when C /= "{" and C /= "[" 
  

 
	%  decode(<<"{'squadName':'Super hero squad','homeTown':'Metro City'}">>,map)
		%Var = <<"{'squadName':'Super hero squad','homeTown':'Metro City','formed': 2016, secretBase':'Super tower','active': true,}">>.
   %bs04:decode (Var, map).


%[Key, K_rest] = binary:split(<<"squadName':'Super hero squad'">>, <<"':'">>, []).


 