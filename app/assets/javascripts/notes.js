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
  $("#dialog-note-add").dialog({
    resizable: false,
    autoOpen : false,
    height: 270,
    width: 650,
    modal: true,
    buttons: {           
      'Cancel': function() {
          $(this).dialog('close');
      },      
      'Save' : function() {
        var form = $("#dialog-note-add").find('form');
        form.submit();
        $(this).dialog('close');        
      }      
    }
  });      
 
};