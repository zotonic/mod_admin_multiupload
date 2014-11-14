{% extends "admin_base.tpl" %}

{% block content %}
<div class="admin-header">
    <h2>{_ Upload multiple media files _}</h2>
    <p>{_ Upload multiple files at once and add them to the Media list. _}</p>
</div>
{% include "_admin_multiupload.tpl" %}
{% endblock %}