{% overrules %}

{% block upload_form %}
    {% if id %}
        {# replacing medium #}
        {% inherit %}
    {% else %}
        <div class="tab-pane {% if is_active %}active{% endif %}" id="{{ tab }}-upload">
            {% include "_admin_multiupload.tpl" id=subject_id %}
        </div>
    {% endif %}
{% endblock %}
