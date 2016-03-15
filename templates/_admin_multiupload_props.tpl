<h2>{_ File properties _}</h2>
<p>
    {_ Set here default properties for the uploaded files. _}
    {_ You can start uploading and set the properties afterwards. _}<br/>
    {_ Any newly uploaded files will be automatically saved. _}
</p>

<p>
    <button type="submit" id="{{ #save }}" class="btn btn-primary disabled">{_ Save to all uploaded files _}</button>
</p>

<div class="uploaded_ids">
    {# Hidden inputs with the uploaded ids are added here #}
</div>

<div class="widget">
    <div class="widget-content">
        {% if m.rsc[q.subject_id].is_linkable and m.rsc[q.predicate].id %}
            <div class="form-group">
                <label class="control-label">{_ Add as: _} {{ m.rsc[q.predicate].title }}</label>
                <p>
                    <a href="{% url admin_edit_rsc id=m.rsc[q.subject_id].id %}">
                        {{ m.rsc[q.subject_id].title }}
                    </a>
                </p>
                <input type="hidden" name="subject:{{ m.rsc[q.predicate].name }}" value="{{ m.rsc[q.subject_id].id }}" />
            </div>
        {% endif %}
        <div class="form-group">
            <label class="control-label">{_ Title _}</label>
            <input name="title" class="form-control" value="" placeholder="{_ Filename _}" />
        </div>

        <div class="form-group">
            <label class="control-label">{_ Summary _}</label>
            <textarea name="summary" class="form-control" value=""></textarea>
        </div>

        <div class="form-group">
            <label class="control-label">{_ Part of _} {{ m.rsc.collection.title|capfirst }}</label>

            <div class="block-page clearfix row">
                <div class="col-md-4">
                    <a class="btn btn-default page-connect" style="{% if subject_id %}display:none{% endif %}" id="{{ #collection }}" href="#connect">{_ Select _} {{ m.rsc.collection.title }}</a>

                    <a class="btn btn-default page-disconnect" style="{% if not subject_id %}display:none{% endif %}" id="{{ #uncollection }}" href="#disconnect">{_ Deselect _}</a>
                </div>

                <div class="rsc-item-wrapper col-md-8" id="{{ #wrap }}">
                    {% if subject_id %}
                        {% catinclude "_rsc_item.tpl" subject_id %}
                    {% endif %}
                </div>
                <input type="hidden" name="subject:haspart" value="{{ subject_id }}" />
            </div>
        </div>

        {% javascript %}
            $('#{{ #collection }}').on('click', function(event) {
                window.zBlockConnectTrigger = this;
                z_event("admin-block-connect", { category: "collection" });
                event.preventDefault();
            });
            $('#{{ #uncollection }}').on('click', function(event) {
                var $block_page = $(this).closest(".block-page");
                $("a.page-disconnect", $block_page).hide();
                $("a.page-connect", $block_page).show();
                $("input[type=hidden]", $block_page).val('');
                $(".rsc-item-wrapper", $block_page).html('');
                event.preventDefault();
            });
            window.zAdminBlockConnectDone = function(v) {
                var $block_page = $(window.zBlockConnectTrigger).closest(".block-page");
                var target_id = $(".rsc-item-wrapper", $block_page).attr('id');
                $("input[type=hidden]", $block_page).val(v.object_id);
                $("a.page-disconnect", $block_page).show();
                $("a.page-connect", $block_page).hide();
                z_notify("update", {z_delegate: 'mod_admin', template: "_rsc_item.tpl", id: v.object_id, z_target_id: target_id});
            }
        {% endjavascript %}

        {% wire name="admin-block-connect" 
            action={dialog_open
                subject_id=subject_id
                predicate=""
                template="_action_dialog_connect.tpl"
                title=_"Find page"
                callback="window.zAdminBlockConnectDone"
                center=0
            }
        %}

        {% if not m.modules.active.mod_media_exif %}
            <div class="form-group">
                <select name="_force" class="form-control">
                    <option value="form">{_ Use date and geolocation set below (if filled) _}</option>
                    <option value="exif">{_ Prefer date and geolocation set by the camera _}</option>
                </select>
            </div>
        {% else %}
            {% if m.acl.is_admin %}
                <div class="form-group">
                    <p class="help-block"><span class="z-icon z-icon-info-circle"></span> {_ Enable <em>mod_admin_exif</em> to set location and time from photo metadata. _}</p>
                </div>
            {% endif %}
            <input type="hidden" name="_force" value="form" />
        {% endif %}

        <div class="form-group">
            <label class="control-label">{_ Date _}</label>
            <div>
                {% include "_edit_date.tpl" is_editable name="date_start" %}
            </div>
        </div>

        <div class="form-group">
            <label class="control-label" for="address_country">{_ Country _}</label>
            <div>
            {% if m.modules.active.mod_l10n %}
                <select class="form-control" id="address_country" name="address_country">
                    <option value=""></option>
                    {% optional include "_l10n_country_options.tpl" country=r.address_country %}
                </select>
            {% else %}
                <input class="form-control" id="address_country" type="text" name="address_country" value="{{ r.address_country }}" />
            {% endif %}
            </div>
        </div>
        {% wire id="address_country" 
                type="change" 
                action={script script="
                    if ($(this).val() != '') $('#visit_address').slideDown();
                    else $('#visit_address').slideUp();
                "}
        %}
        
        <div id="visit_address" {% if not r.address_country %}style="display:none"{% endif %}>
            <div class="form-group">
                <label class="control-label" for="address_street_1">{_ Street _}</label>
                <div>
                    <input class="form-control" id="address_street_1" type="text" name="address_street_1" value="{{ r.address_street_1 }}" />
                </div>
            </div>

            <div class="row">
                <div class="form-group col-lg-6 col-md-6">
                    <label class="control-label" for="address_city">{_ City _}</label>
                    <div>
                        <input class="form-control" id="address_city" type="text" name="address_city" value="{{ r.address_city }}" />
                    </div>
                </div>

                <div class="form-group col-lg-6 col-md-6">
                    <label class="control-label" for="address_postcode">{_ Postcode _}</label>
                    <div>
                        <input class="form-control" id="address_postcode" type="text" name="address_postcode" value="{{ r.address_postcode }}" />
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="form-group col-lg-6 col-md-6">
                    <label class="control-label" for="address_state">{_ State _}</label>
                    <div>
                        <input class="form-control" id="address_state" type="text" name="address_state" value="{{ r.address_state }}" />
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

{% optional include "_geomap_admin_location.tpl" %}

