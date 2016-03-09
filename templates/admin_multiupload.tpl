{% extends "admin_base.tpl" %}

{% block content %}
<div class="admin-header">
    <h2>{_ MULTIUPLOAD_TITLE _}</h2>
    <p>{_ MULTIUPLOAD_MESSAGE _}</p>
    </div>
</div>
<div class="col-md-6">
    {% include "_admin_multiupload.tpl" %}
</div>
{% endblock %}