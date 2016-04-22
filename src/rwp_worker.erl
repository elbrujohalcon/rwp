-module(rwp_worker).

-behavior(gen_server).

-export([ init/1
        , terminate/2
        , code_change/3
        , handle_call/3
        , handle_cast/2
        , handle_info/2
        ]).

-type state() :: #{name => {pid(), atom()}}.

-spec init(timeout()) -> {ok, state()}.
init(Timeout) ->
  {registered_name, RN} = erlang:process_info(self(), registered_name),
  Name = {self(), RN},
  io:format("~p is aliiiive! In ~p ms, I'll die~n", [Name, Timeout]),
  {ok, #{name => Name}, Timeout}.

-spec handle_call(Msg, _From, state()) ->
  {stop, {unknown_request, Msg}, {unknown_request, Msg}, state()}.
handle_call(Msg, _From, State) ->
  {stop, {unknown_request, Msg}, {unknown_request, Msg}, State}.

-spec handle_cast({wait_for, pos_integer(), timeout()}, state()) ->
  {noreply, state(), timeout()}.
handle_cast({wait_for, Sleep, Timeout}, State = #{name := Name}) ->
  io:format("~p going to sleep for ~p ms...~n", [Name, Sleep]),
  timer:sleep(Sleep),
  io:format("~p waking up. In ~p ms, I'll die~n", [Name, Timeout]),
  {noreply, State, Timeout}.

%% @private
-spec handle_info(timeout, state()) -> {stop, normal, state()}.
handle_info(timeout, State = #{name := Name}) ->
  io:format("~p dying...~n", [Name]),
  {stop, normal, State}.

%% @private
-spec terminate(_, state()) -> ok.
terminate(_Reason, _State) -> ok.

%% @private
-spec code_change(term(), state(), term()) -> {ok, state()}.
code_change(_OldVersion, State, _Extra) -> {ok, State}.
