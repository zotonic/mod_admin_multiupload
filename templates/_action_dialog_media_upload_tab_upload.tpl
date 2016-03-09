{% overrules %}

{% block upload_form %}
    {% if id or not m.acl.is_allowed.use.mod_admin_multiupload %}
        {# replacing medium #}
        {% inherit %}
    {% else %}
        <div class="tab-pane {% if is_active %}active{% endif %}" id="{{ tab }}-upload">
            {% include "_admin_multiupload.tpl" subject_id=subject_id predicate=predicate|default:`depiction` is_dialog %}
        </div>
    {% endif %}
{% endblock %}
