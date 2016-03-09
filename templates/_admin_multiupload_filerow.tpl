{% with m.rsc[q.id].id as id %}
{% with id.medium as medium %}
<tr id="{{ #row.id }}">
    <td>
        {{ medium.original_filename|escape }}
    </td>
    <td>
        {{ medium.size|filesizeformat }}
    </td>
    <td>
        {{ medium.mime }}

        {% if id.is_deletable %}
            {% button class="btn btn-default btn-xs pull-right" 
                      text=_"MULTIUPLOAD_ACTION_DELETE" 
                      action={mask target=#row.id}
                      action={delete_rsc id=id on_success={remove target=#row.id}}
            %}
        {% endif %}
        {% if not is_dialog and id.is_editable %}
            {% button class="btn btn-default btn-xs pull-right" 
                      text=_"Edit" 
                      action={redirect dispatch=`admin_edit_rsc` id=id}
            %}
        {% endif %}
    </td>
</tr>
{% endwith %}
{% endwith %}
