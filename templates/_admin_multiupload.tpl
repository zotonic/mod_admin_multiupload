{#
params:
- id
#}
{% lib "js/jquery.fileupload.js" %}

<div class="control-group save">
  <div id="progressarea" style="display:none">
      <p>{_ Please wait while uploading… _}</p>

      <div id="progress" class="progress progress-striped active">
          <div class="bar" style="width: 0%;"></div>
      </div>
  </div>
  
  <div id="uploadbutton" class="form-group">
      <input type="file" id="fileupload" data-url="/api/admin_multiupload/upload" multiple value="" style="width: 0;" />
      <button class="btn btn-default" onclick="$('#fileupload').click();return false">{_ Choose one or more files to upload _}</button>
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
$('#fileupload').fileupload({
    dataType: 'json',
    done: function (e, data) {
        z_event("refresh_files");
        $('#uploadbutton').show();
        $('#progressarea').hide();
    },
    progressall: function (e, data) {
        $('#uploadbutton').hide();
        $('#progressarea').show();
        var progress = parseInt(data.loaded / data.total * 100, 10);
        $('#progress .bar').css('width', progress + '%');
    }
});
{% endjavascript %}