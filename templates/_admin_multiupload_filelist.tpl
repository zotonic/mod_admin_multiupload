{#
params:
- id
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
                            <b>{{ file.title }}</b>
                            ({{ file.original_filename }})
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

        <div class="well">
            {% button class="btn btn-primary" text=_"MULTIUPLOAD_ACTION_UPLOAD"
                action={mask body}
                postback={save_batch id=id}
                delegate=`mod_admin_multiupload`
            %}
            {% button class="btn btn-default" text=_"MULTIUPLOAD_ACTION_CLEAR"
                postback={cancel_batch id=id}
                delegate=`mod_admin_multiupload`
            %}
        </div>

    {% endif %}
{% endwith %}
