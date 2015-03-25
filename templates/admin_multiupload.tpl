{% extends "admin_base.tpl" %}

{% block content %}
<div class="admin-header">
    <h2>{_ MULTIUPLOAD_TITLE _}</h2>
    <p>{_ MULTIUPLOAD_MESSAGE _}</p>
</div>
{% include "_admin_multiupload.tpl" %}
{% endblock %}