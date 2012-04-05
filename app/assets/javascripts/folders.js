var SHERLOCK = SHERLOCK || {};
SHERLOCK.folders = SHERLOCK.folders || {};

SHERLOCK.folders.showInit = function() {
  
  function moveCase(theCase)
  {
    $.ajax({  
      url: location.href + '/move_out_case',
      data: {
        case_id: theCase.data('case-id')
      },
      'type': 'POST',
      success: function(data, textStatus, jqXHR) {
        theCase.remove();
        var list = $('.case-icons-list');
        if ($('li', list).length == 1) {
          var msg = $('<h2>This folder is empty</h2>')
                    .attr('id', 'folder-is-empty')
          list.after(msg);
        }
      }
    });
  }
  
  SHERLOCK.cases.makeIconsDraggable();   
  
  //
  // move case off the current folder
  //
  $('.case-icons-list .link-up').droppable({  
    drop: function(event, ui) {      
      var theCase = ui.draggable;
      //alert(theCase.get(0).tagName);
      if (confirm('Do you want to move this Case to the main list?')) {
        theCase.get(0)._moved = true;
        moveCase(theCase);
      } else {
      }
    }
  }); 
};

