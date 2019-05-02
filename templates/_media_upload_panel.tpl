{% extends "_action_dialog_media_upload_tab_upload.tpl" %}

{% block upload_form %}
    {% if id or not m.acl.is_allowed.use.mod_admin_multiupload %}
        {# replacing medium #}
        {% inherit %}
    {% else %}
        <div class="tab-pane {% if is_active %}active{% endif %}" id="{{ tab }}-multi">
            {% include "_admin_multiupload.tpl"
                       subject_id=subject_id
                       predicate=predicate|default:`depiction`
                       is_dialog
            %}
        </div>
    {% endif %}
{% endblock %}
