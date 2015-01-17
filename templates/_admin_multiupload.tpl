{#
params:
- id
#}
{% if m.acl.is_allowed.use.mod_admin_multiupload %}
    {% lib "js/jquery.fileupload.js" %}
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

    {% wire
        name="refresh_files"
        action={
            update
            target="files"
            template="_admin_multiupload_filelist.tpl"
            id=id
        }
    %}
    <div id="files">
      {% include "_admin_multiupload_filelist.tpl" id=id %}
    </div>
    
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
        progressInterval: '300'
    }).on('fileuploadstart', function(e, data) {
        done = false;
        z_event("refresh_files", {uploading: true});
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
        z_event("refresh_files", {uploading: !done});
    }).on('fileuploaddone', function(e, data) {
        z_event("refresh_files", {uploading: !done});
    }).on('fileuploadprogressall', function(e, data) {
        var progress = parseInt(data.loaded / data.total * 100, 10),
            isUploading = (progress == 100) ? false : true,
            displayPercentage = barMinPercent + (progress / 100 * (100 - barMinPercent));
        z_event("refresh_files", {uploading: !done});
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