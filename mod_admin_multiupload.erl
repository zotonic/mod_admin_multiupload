%% @author Arjan Scherpenisse <arjan@scherpenisse.net>
%% @copyright 2013 Arjan Scherpenisse
%% @date 2013-08-30
%% @doc Adds support to the admin for uploading multiple files in one batch

%% Copyright 2013 Arjan Scherpenisse
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

-export([observe_admin_menu/3, event/2]).


%%====================================================================
%% API
%%====================================================================

observe_admin_menu(admin_menu, Acc, Context) ->
    [
     #menu_item{
      id=admin_multiupload,
      parent=admin_content,
      label=?__("Upload multiple", Context),
      url={admin_multiupload, []},
      visiblecheck={acl, use, ?MODULE}}
     | Acc].

    
event(#postback{message={save_batch, [{id, Id}]}}, Context) ->
    save_batch(Id, Context);
event(#postback{message={delete_file, [{file, F}, {id, Id}]}}, Context) ->
    clear_batch([F], Context),
    Html = z_template:render("_admin_multiupload_filelist.tpl", [{id, Id}], Context),
    z_render:update("files", Html, Context);
event(#postback{message={cancel_batch, [{id, Id}]}}, Context) ->
    clear_batch(Context),
    Html = z_template:render("_admin_multiupload_filelist.tpl", [{id, Id}], Context),
    z_render:update("files", Html, Context).


clear_batch(Context) ->
    clear_batch(z_context:get_session(multiupload_files, Context, []), Context).

clear_batch(Batch, Context) ->
    Files = z_context:get_session(multiupload_files, Context, []),
    Files1 = lists:foldl(
               fun(F, All) ->
                       TmpFile = proplists:get_value(tmpfile, F),
                       case filelib:is_regular(TmpFile) of
                           true ->
                               file:delete(TmpFile);
                           false ->
                               nop
                       end,
                       lists:delete(F, All)
               end,
               Files, Batch),
    z_context:set_session(multiupload_files, Files1, Context).


save_batch(PageId, Context) ->
    Files = z_context:get_session(multiupload_files, Context, []),
    MediaIds = lists:map(fun(F) ->
        TmpFile = proplists:get_value(tmpfile, F),
        {ok, MediaId} = m_media:insert_file(TmpFile, F, [], Context),
        MediaId
    end, Files),
    clear_batch(Context),
    case PageId of
        undefined ->
            z_render:wire([{redirect, [{dispatch, admin_media}]}], Context);
        Id ->
            lists:foreach(fun(MediaId) ->
                {ok, _} = m_edge:insert(Id, depiction, MediaId, Context)
            end, MediaIds),
            % generic way to update the page: do a page reload
            Location = z_dispatcher:url_for(admin_edit_rsc, [{id, Id}], Context),
            z_render:wire({redirect, [{location, Location}]}, Context)
    end.
