-module(background).
-export([start/0]).

is_png(File) ->
    [_ | Tail ] = string:tokens(File, "."),
    Tail == ["png"].

ffmpeg_remove_bg(File) ->
    [Head | _ ] = string:tokens(File, "."),
    Temp = string:concat(Head, ".temp.png"),
    Cmd = ["ffmpeg", "-i", File, "-vf", "\"colorkey=white:0.2:0.1\"", Temp],
    os:cmd(string:join(Cmd, " ")),
    file:rename(Temp, File),
    file:delete(Temp).

remove_bg(File) ->
    case is_png(File) of
        true  -> ffmpeg_remove_bg(File);
        false -> ok
    end.

start() ->
    lists:foreach(fun remove_bg/1, string:tokens(os:cmd("ls"), "\n")).
