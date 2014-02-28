%%%-------------------------------------------------------------------
%%% File:      erlydtl_eunit_testrunner.erl
%%% @author    Andreas Stenius <kaos@astekk.se>
%%% @copyright 2014 Andreas Stenius
%%% @doc
%%% Test suite runner for erlydtl
%%% @end
%%%
%%% The MIT License
%%%
%%% Copyright (c) 2014 Andreas Stenius
%%%
%%% Permission is hereby granted, free of charge, to any person obtaining a copy
%%% of this software and associated documentation files (the "Software"), to deal
%%% in the Software without restriction, including without limitation the rights
%%% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
%%% copies of the Software, and to permit persons to whom the Software is
%%% furnished to do so, subject to the following conditions:
%%%
%%% The above copyright notice and this permission notice shall be included in
%%% all copies or substantial portions of the Software.
%%%
%%% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%%% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%%% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
%%% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%%% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
%%% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
%%% THE SOFTWARE.
%%%
%%% @since 2014 by Andreas Stenius
%%%-------------------------------------------------------------------
-module(erlydtl_eunit_testrunner).
-author('Andreas Stenius <kaos@astekk.se>').

-export([run_test/1, run_compile/1, run_render/1]).

-include_lib("eunit/include/eunit.hrl").

-define(noimport,).
-include("testrunner.hrl").


run_test(T) ->
    case run_compile(T) of
        ok -> run_render(T);
        error_ok -> ok
    end.

run_compile(T) ->
    case erlydtl:compile(
           T#test.source, T#test.module,
           [{vars, T#test.compile_vars}|T#test.compile_opts]) of
        {ok, M, W} ->
            ?assertEqual(T#test.module, M),
            ?assertEqual(T#test.warnings, W);
        {error, E, W} ->
            ?assertEqual(T#test.errors, E),
            ?assertEqual(T#test.warnings, W),
            error_ok
    end.

run_render(T) ->    
    case (T#test.module):render(T#test.render_vars, T#test.render_opts) of
        {ok, O} ->
            ?assertEqual(T#test.output, iolist_to_binary(O));
        RenderOutput ->
            ?assertEqual(T#test.output, RenderOutput),
            error_ok
    end.
