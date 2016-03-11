{% extends "admin_base.tpl" %}

{% block title %}{_ MULTIUPLOAD_TITLE _}{% endblock %}

{% block content %}
    <div class="admin-header">
        <h2>{_ MULTIUPLOAD_MESSAGE _}</h2>
    </div>

    {% wire id="multiupload_props" type="submit" postback=`save_props` delegate=`mod_admin_multiupload` %}
    <form id="multiupload_props" class="multiupload_props" action="postback">
        <div class="row">
            <div class="col-md-6">
                {% include "_admin_multiupload.tpl" %}
            </div>
            <div class="col-md-6">
                {% include "_admin_multiupload_props.tpl" %}
            </div>
        </div>
    </form>
{% endblock %}