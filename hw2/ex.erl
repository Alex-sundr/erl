-module(bs04).
-export([decode/2 ]).

-record(jsonkv, {list = <<>>, key=[], Value =[], raw = <<>> }).


decode(Bin,Selector) ->

	case Selector of
		
		%proplist -> decode_in_proplist(Bin,<<>>);   
		
		map -> decode_in_map(json(#jsonkv{raw = Bin},[])   

	end.

 
json(RAW,Key) ->
      [H,T] = <<H/utf8, Rest/binary>>,
  case [H,T] of
  	[${,_] ->  json(#jsonkv{raw=T},[]); %запускаем новый
  	[$',_] ->  json(RAW#jsonkv{raw=T},Key); %кавычку игнорируем 
    [$,,_] ->  json(RAW#jsonkv{raw=T},[]); % добавляем следующий ключ 
    [$:,_] ->  KeyVal =  value([],T); % ищем значение 
    [$},_] ->  RAW#jsonkv{raw = T}; % ищем значение 

  	[_,_] ->  json(RAW#jsonkv{raw=T},Key++[H]) %Добавляем символ к ключу 
  end.

value(Value,RAW)->
 [H,T] = <<H/utf8, Rest/binary>>,
  case  H  of
    $: -> throw('unexpected token');
    ${ -> J = json(RAW),                                  % recurse to get list
            #jsonkv{value=J#jsonkv.list, raw=J#jsonkv.raw};  
    $, -> #jsonkv{value=string:strip(Value), raw=RawJSON};    % terminator, return
    $} -> #jsonkv{value=string:strip(Value), raw=RawJSON};    % terminator, return
    $' -> json_value_quoted(Value, T);                        % run to next quote,exit
    _     -> json_value(Value ++ [H], T)    
  end.

json_value_quoted(Value, [$' | T]) ->
  #jsonkv{value=Value, raw=T};

json_value_quoted(Value, [H | T]) ->
  json_value_quoted(Value ++ [H], T).


