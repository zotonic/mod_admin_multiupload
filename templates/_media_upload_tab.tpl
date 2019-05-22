{% if not tabs_enabled or "oembed"|member:tabs_enabled %}
    <li {% if tab == "multi" %}class="active"{% endif %}>
        <a data-toggle="tab" href="#{{ tab }}-multi">{_ Multi upload _}</a>
    </li>
{% endif %}
