{#
params:
- id
- q.uploading
#}
{% with m.session.multiupload_files as files %}
    {% if files %}
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>
                        {_ MULTIUPLOAD_HEADER_FILENAME _}
                    </th>
                    <th>
                        {_ MULTIUPLOAD_HEADER_SIZE _}
                    </th>
                    <th>
                        {_ MULTIUPLOAD_HEADER_TYPE _}
                    </th>
                </tr>
            </thead>
            <tbody>
                {% for file in files %}
                    <tr>
                        <td>
                            {{ file.original_filename }}
                        </td>
                        <td>
                            {{ file.size|filesizeformat }}
                        </td>
                        <td>
                            {{ file.mime }}

                            {% button class="btn btn-default btn-xs pull-right" text=_"MULTIUPLOAD_ACTION_DELETE" postback={delete_file file=file id=id} delegate=`mod_admin_multiupload` %}
                        </td>
                    </tr>
                {% endfor %}
            </tbody>
        </table>
        {% if not q.uploading %}
            <div id="amu_actions" class="well">
                {% button class="btn btn-primary" text=_"MULTIUPLOAD_ACTION_UPLOAD"
                    action={mask body}
                    postback={save_batch id=id}
                    delegate=`mod_admin_multiupload`
                %}
                {% button class="btn btn-default" text=_"MULTIUPLOAD_ACTION_CLEAR"
                    postback={
                        cancel_batch
                        id=id
                    }
                    action={
                        script
                        script="$('#amu_progress_area').hide();"
                    }
                    delegate=`mod_admin_multiupload`
                %}
            </div>
        {% endif %}
    {% endif %}
{% endwith %}
