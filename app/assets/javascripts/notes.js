var SHERLOCK = SHERLOCK || {};

SHERLOCK.notes = SHERLOCK.notes || {};

SHERLOCK.notes.hideCreateForm = function() {
  $('#new_note').remove();
  $('#create-note-wrapper').show();
};

SHERLOCK.notes.init = function() {    
  tinyMCE.execCommand('mceAddControl', false, 'note_contents');
  
  $('#new_note a.cancel').live('click', function() {   
    SHERLOCK.notes.hideCreateForm();
    return false;
  });  
  $("#dialog-note-add" ).dialog({
    resizable: false,
    autoOpen : false,
    height: 256,
    width: 600,
    modal: true,
    buttons: {           
      'Cancel': function() {
          $(this).dialog('close');
      },      
      'Create Note' : function() {
        var form = $('#new_note');
        var ed = tinyMCE.get('note-contents-inline');          
        if (ed) {            
          $('#note-contents-inline', form).val(ed.getContent());          
        }        
        form.submit();
        $(this).dialog('close');                  
      }      
    }
  });      
    
  $('#note-quick-add').click(function() {    
    var contents = $('#note-contents-inline').get(0);
    if (!contents._hasRichEditor) {      
      tinyMCE.execCommand('mceAddControl', false, 'note-contents-inline');
      contents._hasRichEditor = true;
    }
    $("#dialog-note-add" ).dialog('open');
    return false;
  });
};