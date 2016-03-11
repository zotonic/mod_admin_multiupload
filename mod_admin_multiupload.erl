%% @author Arjan Scherpenisse <arjan@scherpenisse.net>
%% @copyright 2013-2016 Arjan Scherpenisse, Marc Worrell
%% @doc Adds support to the admin for uploading multiple files in one batch

%% Copyright 2013-2016 Arjan Scherpenisse, Marc Worrell
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%% 
%%     http://www.apache.org/licenses/LICENSE-2.0
%% 
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.

-module(mod_admin_multiupload).
-author("Arjan Scherpenisse <arjan@scherpenisse.net>").

-mod_title("Multi upload of media files").
-mod_description("Upload multiple files at once.").
-mod_prio(500).

-include_lib("zotonic.hrl").
-include_lib("modules/mod_admin/include/admin_menu.hrl").

-export([
    observe_admin_menu/3,
    event/2
]).


%%====================================================================
%% API
%%====================================================================

observe_admin_menu(admin_menu, Acc, Context) ->
    [
     #menu_item{
      id=admin_multiupload,
      parent=admin_content,
      label=?__("MULTIUPLOAD_MENU_LABEL", Context),
      url={admin_multiupload, []},
      visiblecheck={acl, use, ?MODULE}}
     | Acc].

event(#submit{message=save_props}, Context) ->
    Qs = filter_empty(z_context:get_q_all_noz(Context)),
    {Ids, Qs1} = split_ids(Qs),
    {Subjects, Objects, Qs2} = split_edges(Qs1),
    lists:foreach(
            fun(QId) ->
                Id = z_convert:to_integer(QId),
                save_props(Id, Qs2, Context),
                lists:foreach(
                        fun({Pred, SubjectId}) ->
                            m_edge:insert(m_rsc:rid(SubjectId, Context), Pred, Id, Context)
                        end,
                        Subjects),
                lists:foreach(
                        fun({Pred, ObjectId}) ->
                            m_edge:insert(Id, Pred, m_rsc:rid(ObjectId, Context), Context)
                        end,
                        Objects)
            end,
            Ids),
    Context.

save_props(Id, Qs, Context) ->
    IsForceMedium = case proplists:get_value("_force", Qs) of
                        "form" -> false;
                        "exif" -> true
                    end,
    Qs1 = proplists:delete("_force", Qs),
    Props = m_rsc_update:normalize_props(Id, Qs1, Context),
    Props1 = maybe_date_end(Props),
    case IsForceMedium of
        false ->
            m_rsc:update(Id, Props1, Context);
        true ->
            Props2 = force_medium(Id, Props1, Context),
            m_rsc:update(Id, Props2, Context)
    end.

maybe_date_end(Props) ->
    case proplists:get_value(date_start, Props) of
        undefined -> Props;
        DT -> [{date_end, DT}|Props]
    end.

force_medium(Id, Props, Context) ->
    case z_module_manager:active(mod_media_exif, Context) of
        true ->
            Medium = m_media:get(Id, Context),
            MediumProps = mod_media_exif:medium_props(Medium),
            z_utils:props_merge(MediumProps, Props);
        false ->
            Props
    end.

filter_empty(Qs) ->
    lists:filter(
            fun
                ({_, []}) -> false;
                ({_, <<>>}) -> false;
                (_) -> true
            end,
            Qs).

split_ids(Qs) ->
    lists:foldl(
            fun
                ({"id", Id}, {Ids, Rs}) ->
                    {[Id|Ids], Rs};
                ({<<"id">>, Id}, {Ids, Rs}) ->
                    {[Id|Ids], Rs};
                (QArg, {Ids, Rs}) ->
                    {Ids, [QArg|Rs]}
            end,
            {[], []},
            Qs).

split_edges(Qs) ->
    lists:foldl(
            fun
                ({"subject:" ++ Pred, Id}, {Ss, Os, Rs}) ->
                    {[{Pred, Id}|Ss], Os, Rs};
                ({"object:" ++ Pred, Id}, {Ss, Os, Rs}) ->
                    {Ss, [{Pred, Id}|Os], Rs};
                ({<<"subject:", Pred/binary>>, Id}, {Ss, Os, Rs}) ->
                    {[{Pred, Id}|Ss], Os, Rs};
                ({<<"object:", Pred/binary>>, Id}, {Ss, Os, Rs}) ->
                    {Ss, [{Pred, Id}|Os], Rs};
                (QArg, {Ss, Os, Rs}) ->
                    {Ss, Os, [QArg|Rs]}
            end,
            {[], [], []},
            Qs).

