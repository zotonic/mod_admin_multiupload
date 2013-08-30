-module(service_admin_multiupload_upload).

-svc_title("Multiupload handler.").
-svc_needauth(false).

-export([process_post/2]).

-include_lib("zotonic.hrl").

process_post(_ReqData, Context) ->
    case z_acl:is_allowed(use, mod_admin_multiupload, Context) of
        true ->
            U = #upload{} = z_context:get_q("files[]", Context),

            File =
                [{tmpfile, U#upload.tmpfile},
                 {original_filename, U#upload.filename},
                 {mime, z_media_identify:guess_mime(U#upload.filename)},
                 {size, filelib:file_size(U#upload.tmpfile)},
                 {title, filename:basename(U#upload.filename, filename:extension(U#upload.filename))}
                ],
            FileList = z_context:get_session(multiupload_files, Context, []),
            z_context:set_session(multiupload_files, [File | FileList], Context),
            {struct, [{result, ok}]};
        false ->
            {error, access_denied, "Access denied"}
    end.
