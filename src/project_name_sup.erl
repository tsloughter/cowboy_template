%%%-------------------------------------------------------------------
%%% @author {username} <{email}>
%%% @copyright (C) {year}, {username}
%%% @doc
%%%
%%% @end
%%% Created : {date} by {username} <{email}>
%%%-------------------------------------------------------------------
-module(project_name_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%%===================================================================
%%% API functions
%%%===================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%%===================================================================
%%% Supervisor callbacks
%%%===================================================================

init([]) ->
    RestartStrategy = one_for_one,
    MaxRestarts = 1000,
    MaxSecondsBetweenRestarts = 3600,

    SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},

    Dispatch = cowboy_router:compile([
                                     %% {HostMatch, list({PathMatch, Handler, Opts})}
                                     {'_', [{'_', project_name_handler, []}]}
                                     ]),

    {ok, ListenPort} = application:get_env(http_port),

    ChildSpecs = [ranch:child_spec(project_name_cowboy, 100,
                                   ranch_tcp, [{port, ListenPort}],
                                   cowboy_protocol, [{env, [{dispatch, Dispatch}]}])],

    {ok, {SupFlags, ChildSpecs}}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
