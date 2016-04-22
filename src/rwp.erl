-module(rwp).
-author('elbrujohalcon@inaka.net').

-export([run/0]).

-spec run() -> ok.
run() ->
  _ = wpool:start(),
  io:format("~n~n~n"),
  InitialTimeout = 15000,
  Options =
    [ {workers, 3}
    , {woker_opt, [{debug, [log, trace]}]}
    , {worker, {rwp_worker, InitialTimeout}}
    , {strategy, {one_for_one, 1000, 1}}
    ],
  {ok, _} = wpool:start_sup_pool(rwp, Options),
  io:format(" 3!! ~n"),
  timer:sleep(5000),
  io:format(" 2!! ~n"),
  timer:sleep(5000),
  io:format(" 1!! ~n"),
  timer:sleep(5000),
  io:format(
    "!! After 5 secs, one of the processes should not restart anymore !!~n"),
  ok = wpool:cast(rwp, {wait_for, 5000, infinity}, next_worker),
  timer:sleep(15000),
  io:format(
    "!! Next round, just one process should be restarted !!~n"),
  ok = wpool:cast(rwp, {wait_for, 1, infinity}, next_worker),
  ok.
