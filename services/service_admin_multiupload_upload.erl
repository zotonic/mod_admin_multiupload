-module(service_admin_multiupload_upload).

-svc_title("Multiupload handler.").
-svc_needauth(false).

-export([process_post/2]).

-include_lib("zotonic.hrl").

process_post(_ReqData, Context) ->
    case z_acl:is_allowed(use, mod_admin_multiupload, Context) of
        true ->
            U = #upload{} = z_context:get_q("files[]", Context),
            SubjectId = z_convert:to_integer(z_context:get_q("subject_id", Context)),
            PredicateId = m_rsc:rid(z_context:get_q("predicate", Context), Context),
            CGId = m_rsc:p(SubjectId, content_group_id, Context),
            Props = [
                {is_published, true},
                {content_group_id, CGId}
            ],
            case m_media:insert_file(U, Props, Context) of
                {ok, MediaId} ->
                    opt_edge(SubjectId, PredicateId, MediaId, Context),
                    {struct, [{result, ok}, {id, MediaId}]};
                {error, _} = Error ->
                    lager:error("[~p] Error ~p when uploading file ~p", [z_context:site(Context), U, Error]),
                    {struct, [{result, error}]}
            end;
        false ->
            {error, access_denied, "Access denied"}
    end.

opt_edge(SubjectId, PredicateId, MediaId, Context) when is_integer(SubjectId), is_integer(PredicateId) ->
    m_edge:insert(SubjectId, PredicateId, MediaId, Context);
opt_edge(_, _, _, _Context) ->
    ok.
