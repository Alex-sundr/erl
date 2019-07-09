-module(bs05).
-export([decode/2 ]).

decode(Bin,Selector) ->

	case Selector of
		
		%proplist -> decode_in_proplist(Bin,<<>>);   
		
		map -> decode_in_map(Bin,<<>>,empty,[],0)   

	end.




	decode_in_map(<<C/utf8, Rest/binary>>,KvAcc,KvAccCondition,Acc,BracketCnt)->
          case expression of
          	C = "{"  when BracketCnt == 0->
          		decode_in_map( Rest ,KvAcc,KvAccCondition,Acc,BracketCnt);

            C = "'"  when KvAcc == empty->
                 decode_in_map( Rest ,KvAcc,KvAccCondition,Acc,BracketCnt);
            


            C = "["  when KvAcc == empty->




          decode_in_map( Rest ,KvAcc,KvAccCondition,Acc,BracketCnt+1);