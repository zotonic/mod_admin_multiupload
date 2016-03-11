{% with m.rsc[q.id].id as id %}
{% with id.medium as medium %}
<tr id="{{ #fileupload.id }}">
    <td>
        {% image medium mediaclass="admin-list-overview" %}
    </td>
    <td>
        {% live topic=id template="_multiupload_title.tpl" id=id %}
        <span class="text-muted">{{ medium.original_filename|escape }}</span>
    </td>
    <td>
        {{ medium.mime }}<br/>
        <span class="text-muted">{{ medium.size|filesizeformat }}</span>
    </td>
    <td>
        {% if id.is_deletable %}
            {% button class="btn btn-default btn-xs pull-right" 
                      text=_"MULTIUPLOAD_ACTION_DELETE" 
                      action={mask target=#fileupload.id}
                      action={delete_rsc id=id on_success={remove target=#fileupload.id}}
            %}
        {% endif %}
        {% if not is_dialog and id.is_editable %}
            <a href="{% url admin_edit_rsc id=id %}" target="_edit" class="btn btn-default btn-xs pull-right">{_ Edit in new window _}</a>
        {% elseif is_dialog and subject_id %}
            <a href="{% url admin_edit_rsc id=id %}" target="_edit" class="btn btn-default btn-xs pull-right">{_ Edit in new window _}</a>
        {% elseif is_dialog %}
            <a href="{% url admin_edit_rsc id=id %}" class="btn btn-default btn-xs pull-right">{_ Edit _}</a>
        {% endif %}

        <input type="hidden" name="id" value="{{ id }}" />
    </td>
</tr>

{% javascript %}
  $('button[type=submit]', $('#{{ #fileupload.id }}').closest('form.multiupload_props')).removeClass('disabled');

  if (window.multiupload_saver) {
    clearTimeout(window.multiupload_saver);
  }
  window.multiupload_saver = setTimeout(
        function() {
          console.log($('#{{ #fileupload.id }}'));
          console.log($('#{{ #fileupload.id }}').closest('form.multiupload_props'));
          $('#{{ #fileupload.id }}').closest('form.multiupload_props').submit();
        }, ('q.done' == '') ? 2000 : 500);
{% endjavascript %}

{% endwith %}
{% endwith %}
