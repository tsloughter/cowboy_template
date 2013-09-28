-module(project_name_handler).

-export([init/3,
         allowed_methods/2,
         content_types_provided/2,
         get_json/2,
         terminate/3]).

init(_Transport, _Req, _Opts) ->
    {upgrade, protocol, cowboy_rest}.

allowed_methods(Req, State) ->
    {[<<"HEAD">>, <<"GET">>], Req, State}.

content_types_provided(Req, State) ->
    {[{{<<"application">>, <<"json">>, []}, get_json}], Req, State}.

get_json(Req, State) ->
    {<<>>, Req, State}.

terminate(_Reason, _Req, _State) ->
    ok.
