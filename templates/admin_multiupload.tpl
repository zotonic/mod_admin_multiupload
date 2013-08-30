{% extends "admin_base.tpl" %}

{% block head_extra %}
{% lib
        "js/jquery.fileupload.js" %}
{% endblock %}


{% block content %}
    <h2>{_ Batch media upload _}</h2>

    <p>{_ This page allows you to upload a batch of files in one go. After uploading the batch, click the "save as media files" button to import them into Zotonic. _}</p>

  <div class="control-group save">
      <div id="progressarea" style="display:none">
          <p>{_ Please wait while uploading… _}</p>

          <div id="progress" class="progress progress-striped active">
              <div class="bar" style="width: 0%;"></div>
          </div>
      </div>
      
      <div id="uploadbutton">
          <input type="file" id="fileupload" data-url="/api/admin_multiupload/upload" multiple value="" style="width: 0px" /><button class="btn btn-primary" onclick="$('#fileupload').click();return false">{_ Choose file(s) to upload _}</button>
      </div>
  </div>

  {% wire name="refresh_files" action={update target="files" template="_admin_multiupload_filelist.tpl"} %}
  <div id="files">
      {% include "_admin_multiupload_filelist.tpl" %}
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
      $('#progress .bar').css(
      'width',
      progress + '%'
      );
      }

      });
  {% endjavascript %}
    
{% endblock %}
