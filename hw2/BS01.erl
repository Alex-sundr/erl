-module(BS01).
-export([first_word/1]).

first_word(Bin)->
	first_word(Bin,<< >>).

first_word(<<" ",_/Binary>>,Acc)->
	Acc;

first_word(<< C/Utf8,Rest/Binary>>, Acc)->
	first_word(Rest,<<Acc/Binary,C/Utf8>>);

first_word(<< >>, Acc)->
	Acc.		