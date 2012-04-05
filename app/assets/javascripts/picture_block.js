var SHERLOCK = SHERLOCK || {};

SHERLOCK.pictures = SHERLOCK.pictures || {};

SHERLOCK.pictures.initEditForm = function() {  
  
  var form = $('form.edit_picture').get(0);
  
  $( "#dialog-crop-confirm" ).dialog({
    resizable: false,
    autoOpen : false,
    height:180,
    width: 600,
    modal: true,
    buttons: {
      'Cancel': function() {
        $(this).dialog('close');
      },
      'Replace Current': function() {
        $(this).dialog('close');
        form.submit();
      },            
      'Create New' : function() {
        form.crop_new_block.value = 1;
        $(this).dialog('close');
        form.submit();
      }      
    }
  });
  
  $('form.edit_picture').submit(function() {
    
    function hasCrop(form)
    {      
      var crop_x = '' + $('#crop-x', form).val();      
      return (crop_x != '');
    }
    
    var result = true;    
    if (hasCrop(this)) {      
      result = false;
      $( "#dialog-crop-confirm").dialog('open');      
    }   
    return result;
  });
}

SHERLOCK.pictures.initForm = function() {
  
    $('#picture-holder').Jcrop({
      onSelect: function(c) {
        $('#crop-x').val(c.x);
        $('#crop-y').val(c.y);
        $('#crop-w').val(c.w);
        $('#crop-h').val(c.h);
      }
    });          
        
    $('#btn-change-picture').click(function() {
      $('#btn-change-picture').hide();
      $('#image-field-wrapper').show();
      $('#link-keep-picture').css('visibility', 'visible');
      return false;
    });
    
    $('#link-keep-picture').click(function(e) {
      $('#btn-change-picture').show();
      $('#image-field-wrapper').hide();
      $('#link-keep-picture').css('visibility', 'hidden');
      return false;
    });      
};

SHERLOCK.pictures.initAppletContainer = function(data) {
  
  data.normalized_updated_at = normalizeDate(data.updated_at);
      
  function normalizeDate(s)
  {
    s = ('' + s).replace(/[^0-9]/g, '');
    return s;
  }
  
  function initAppletContainer()
  {
    var container = $('#appletContainer');
    container.empty();
    var appletURL = data.urls.root + 'SherlockScreen.jar?v=' + 
                    new Date().valueOf();                      
    var token = $('meta[name=csrf-token]').attr('content');
    var code = '<applet archive="' + appletURL + '" ' +
      'code="sherlockscreen.SherlockScreen.class" ' +
      'width="1" height="1" MAYSCRIPT>' +        
      '<param name="type" value="picture"/>' +
      '<param name="token" value="' + token + '"/>' +
      '<param name="unique_code" value="' + data.unique_code + '"/>' +
      '<param name="cookie" value="' + data.cookie + '"/>' +            
      '<param name="insert_before_id" value="' + data.insert_before_id + '"/>' +
      '<param name="post_url" value="' + data.urls.post + '"/>' +            
      '<param name="editor_url" value="' + data.urls.root + 'SherlockEditor.jar"/>'+            
      '<param name="picture_id" value="' + data.picture_id + '"/>' +
      '</applet>';

    container.html(code);        
    container.show();

    checkImage();
    
  }
  
  function screenCaptureClicked()
  {
    
    if (!SHERLOCK.utils.startJavaDetectionForCapture()) {
      return;
    }    
        
    $('#java-applet-launching .app-is-running').hide();
    $('#java-applet-launching').show();
    $('#java-applet-launching .please-wait').show();
    $('#java-applet-launching .spinning').show();

    initAppletContainer();  
  }
                          
  var settings = {
    cache: false,
    dataType: 'json',
    success: function(response_data) {
      if (response_data && 
          (normalizeDate(response_data.updated_at) != data.normalized_updated_at)) {            
        var url_redirect = data.urls.base_redirect + '/' + 
                           response_data.id + '/edit';
        location.href = url_redirect;            
      } else {
        setTimeout(checkImage, 2000);
      }
    }
  };
      
  function checkImage()
  {
    $.ajax(data.urls.check, settings);
  }
  
  $('#btn-screen-capture').click(screenCaptureClicked);                                        
  
};

  