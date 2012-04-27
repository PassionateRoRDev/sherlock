var SHERLOCK = SHERLOCK || {};
SHERLOCK.videos = SHERLOCK.videos || {};

SHERLOCK.videos.initEditForm = function(settings) {  
  
  var uploadifyWidth = 218;
  
  var form = $('#video-form form');
  var utf8_val = $('input[name=utf8]', form).val();
      
  form.submit(function() {
    var result = false;
    if (! this._uploading) {
      
      // if client-side (or AJAX-based) validation true
      var queueLength = $('#upload_video_queue .uploadifyQueueItem').length;
      if (!queueLength) {
        
        // if it's not a new video, just submit the form:
        if (settings.video_id == '0') {        
          alert('Please select a file to upload');            
        } else {
          result = true;
        }
        
      } else {        
        this._uploading = true;
        $(this).find('input[type=submit]').val('Saving...');
        $('#upload_video').uploadifyUpload('*');
      }                
    }
    return result;
  });  
  
  $('#btn-thumbnail-change').click(function(e) {
    $('#block-thumbnail-change-wrapper').show();
    $('#link-thumbnail-keep').parent().removeClass('hidden');
    $('input[name=keep_thumbnail]').val('0');
    return false;
  });
  
  $('#link-thumbnail-keep').click(function(e) {
    $('#block-thumbnail-change-wrapper').hide();    
    $('input[name=keep_thumbnail]').val('1');
    $('#link-thumbnail-keep').parent().addClass('hidden');
    return false;
  });
  
  $('#video_thumbnail_method_auto').change(function(e) {
    var autoSpan = $('span', '#block-thumbnail-method-auto');
    var manualDiv = $('div', '#block-thumbnail-method-manual');
    if (!this.selected) {
      autoSpan.removeClass('hidden');
      manualDiv.addClass('hidden');
    } else {
      autoSpan.addClass('hidden');
      manualDiv.removeClass('hidden');
    }
  });
  
  $('#video_thumbnail_method_manual').change(function(e) {
    var autoSpan = $('span', '#block-thumbnail-method-auto');
    var manualDiv = $('div', '#block-thumbnail-method-manual');    
    if (this.selected) {
      autoSpan.removeClass('hidden');
      manualDiv.addClass('hidden');
    } else {
      autoSpan.addClass('hidden');
      manualDiv.removeClass('hidden');
    }
  });
  
  $('#video-change-block a').click(function(e) {
      $('#video-field-wrapper').hide();
      $('#video-change-block a').css('visibility', 'hidden');
      return false;
  });
  $('#btn-video-change').click(function(e) {
      $('#video-field-wrapper').show();
      $('#video-change-block a').css('visibility', 'visible');
  });
  $('#thumbnail-change-block a').click(function(e) {
      $('#thumbnail-field-wrapper').hide();
      $('#thumbnail-change-block a').css('visibility', 'hidden');
      return false;
  });  
  $('#btn-thumbnail-change').click(function(e) {
    $('#thumbnail-field-wrapper').show();
    $('#thumbnail-change-block a').css('visibility', 'visible');
  });
        
  $('#upload_video').uploadify({        
      buttonText: 'Select File...',
      buttonClass: 'button2 button2-wide',
      uploader : settings.paths.tmp_new + '.js',
      removeCompleted: false,
      width: uploadifyWidth,
      checkExisting: settings.paths.tmp_check,
      cancelImage: '/assets/uploadify-cancel.png',
      fileObjName: 'upload[video]',
      postData: { 
        '_http_accept': 'application/javascript',
        '_method': 'put',
        '_sherlock_session': encodeURIComponent(settings.cookie),
        'authenticity_token': settings.token,
        'utf8': utf8_val
      },
      successTimeout : 600,
      swf: '/uploadify.swf',
      queueSizeLimit : 1,
      auto: false,

      onUploadError : function(file, errorCode, errorMsg, errorString, queue) {
        alert(errorCode);
        switch (errorCode) {
          case -280:
            break;
          default:
            alert('Error: ' + file + ', ' + errorCode + ', ' + errorMsg + ', ' + errorString);
        }              
      },

      onUploadSuccess : function(fileObj, data, response) {                
        $('#upload_video .uploadifyProgressBar').css('width', '100%');
        SHERLOCK.utils.showAjaxLoading();
        form.get(0).via_tmp.value = 1;        
        form.get(0).submit();
      }
  });
};