{% if not id and m.acl.is_allowed.use.mod_admin_multiupload %}
    {% if not tabs_enabled or "multiupload"|member:tabs_enabled %}
        <li {% if tab == "multiupload" %}class="active"{% endif %}>
            <a data-toggle="tab" href="#{{ tab }}-multiupload">{_ Multi upload _}</a>
        </li>
    {% endif %}
{% endif %}
