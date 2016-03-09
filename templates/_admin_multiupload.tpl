{#
params:
- subject_id
- predicate
#}
{% if m.acl.is_allowed.use.mod_admin_multiupload %}
    <div class="control-group">
        <div id="amu_choose_button" class="form-group">
            <input type="file" id="fileupload" data-url="/api/admin_multiupload/upload" multiple value="" style="display: none;" />
            <button class="btn btn-default" onclick="$('#fileupload').click();return false">{_ MULTIUPLOAD_MESSAGE_CHOOSE_FILES _}</button>
        </div>
        <div id="amu_progress_area" style="display: none;">
            <div id="amu_progress" class="progress clearfix">
                <div class="progress-bar" style="width: 0%;"></div>
            </div>
        </div>
    </div>

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
        <tbody id="{{ #filelist }}">
        </tbody>
    </table>

{% wire name="multiupload_show_file"
        action={insert_top target=#filelist template="_admin_multiupload_filerow.tpl" is_dialog=is_dialog}
%}
    
{% javascript %}
    var barActiveClass = 'progress-bar-striped active',
        barSuccessClass = 'progress-bar-success',
        barMinPercent = 1,
        bootstrapMargin = 18,
        barHeight = bootstrapMargin,
        done = false,
        barHeightInAnimationDuration = 300,
        barHeightOutAnimationDuration = 600;

    $('#fileupload').fileupload({
        dataType: 'json',
        progressInterval: '300',
        formData: {
            subject_id: "{{ subject_id }}",
            predicate: "{{ predicate }}"
        }
    }).on('fileuploadstart', function(e, data) {
        done = false;
        $('#amu_progress.progress').css({
            'height': 0,
            'margin-bottom': 0
        }).animate({
            'height': barHeight + 'px',
            'margin-bottom': bootstrapMargin + 'px'
        }, barHeightInAnimationDuration);
        $('#amu_progress .progress-bar')
          .removeClass(barSuccessClass)
          .addClass(barActiveClass)
          .css('width', 0 + '%');
        $('#amu_choose_button button').attr("disabled", "disabled");
        $('#amu_progress_area').show();
    }).on('fileuploadfail', function(e, data) {
    }).on('fileuploaddone', function(e, data) {
        if (data.result.result == 'ok') {
            z_event("multiupload_show_file", {id: data.result.id});
        } else {
            z_growl_add("{_ Error uploading file _}", false, "error");
        }
    }).on('fileuploadprogressall', function(e, data) {
        var progress = parseInt(data.loaded / data.total * 100, 10),
            isUploading = (progress == 100) ? false : true,
            displayPercentage = barMinPercent + (progress / 100 * (100 - barMinPercent));
        $('#amu_progress .progress-bar').css('width', displayPercentage + '%');
        if (!isUploading) {
            done = true;
            $('#amu_progress .progress-bar')
              .removeClass(barActiveClass)
              .addClass(barSuccessClass);
            $('#amu_choose_button button').removeAttr("disabled");
            setTimeout(function() {
                $('#amu_progress.progress').animate({
                    'height': 0,
                    'margin-bottom': 0
                }, barHeightOutAnimationDuration);
            }, 2000);
        }
    });
{% endjavascript %}

{% else %}
    <p class="alert alert-danger">{_ MULTIUPLOAD_MESSAGE_NOT_ALLOWED_USE _}</p>
{% endif %}
