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

-export([observe_admin_menu/3]).


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
