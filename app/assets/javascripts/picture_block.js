var SHERLOCK = SHERLOCK || {};

SHERLOCK.pictures = SHERLOCK.pictures || {};

SHERLOCK.pictures.initEditForm = function() {  
  
  $( "#dialog-crop-confirm" ).dialog({
    resizable: false,
    autoOpen : false,
    height:140,
    modal: true,
    buttons: {
      'Create New' : function() {
        $(this).dialog('close');
      },
      'Replace Current': function() {
        $(this).dialog('close');
      },      
      'Cancel': function() {
        $(this).dialog('close');
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
      /*
      if (!confirm('Do you want REPLACE the existing picture with the cropped area')) {
        this.crop_new_block.value = 1;                
      }*/
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
    
    var token = $('meta[name=csrf-token]').attr('content');
    var code = '<applet archive="' + data.urls.root + 'SherlockScreen.jar?v=' + new Date().valueOf() + '" ' +
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
    
    $('#accept-java').show();
    var javaVersion = SHERLOCK.utils.detectJava();
        
    var versionString = javaVersion.join('.');                                
    var msg = 'Detected ' + versionString;
    var color = 'green';
        
    var found = (javaVersion[0] >= 1);
    var correctFound = found && (javaVersion[1] >= 6);

    if (!correctFound) {
      color = 'red';
      if (!found) {
        msg = 'Java not found';
      }
    }
        
    $('.detecting .detecting-spinning').hide();
        
    $('#java-version-result').css({
      'margin-top': '0px' ,
      'color': color
    }).html(msg);
        
    if (!correctFound) {
      if (found) {
        $('#java-install .install').remove();
      } else {
        $('#java-install .upgrade').remove();
      }
      $('#java-install').show();
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

  