{% if m.acl.is_allowed.use.mod_admin_multiupload %}
    <li {% if tab == "multi" %}class="active"{% endif %}>
        <a data-toggle="tab" href="#{{ tab }}-multi">{_ Multi upload _}</a>
    </li>
{% endif %}
