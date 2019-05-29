{% if not id and m.acl.is_allowed.use.mod_admin_multiupload %}
    {% if not tabs_enabled or "multiupload"|member:tabs_enabled %}
          <div class="tab-pane {% if is_active %}active{% endif %}" id="{{ tab }}-multiupload">
              {% include "_admin_multiupload.tpl"
                         subject_id=subject_id
                         predicate=predicate|default:`depiction`
                         is_dialog
              %}
          </div>
    {% endif %}
{% endif %}
