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
      }
    });
  }
  
  $('.case-icons-list li.case').draggable({
    containment: 'ul.case-icons-list',
    stop: function(event, ui) {
      if (!this._moved) {
        $(this).css({
          'left': 0,
          'top': 0
        });
      }
    }    
  });
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

