
var SHERLOCK = SHERLOCK || {};

SHERLOCK.ajaxHtmlDo = function(url, success) {    
    var options = {
        url: url,
        cache: false,
        dataType: 'html',
        success : success
    };
    $.ajax(options);        
}

SHERLOCK.cases = SHERLOCK.cases || {};

SHERLOCK.cases.resetBlockTypeLists = function() {
  $('.form-insert-block select').each(function() {
     this.selectedIndex = 0; 
  });
};

SHERLOCK.cases.insertBlockBefore = function(insertBefore) {
                        
    var url = SHERLOCK.urls.create_block_text;    
            
    var next = insertBefore.next();
    if (next.hasClass('block')) {
        var blockId = next.data('block_id');
        url += ('?insert_before_id=' + blockId);            
    }
    
    var newBlock = $('.blocks-area .new-block');
    newBlock.data('form-url', url);
    
    newBlock.find('.block-editable').html('');
    
    SHERLOCK.utils.richEditorRemove('form-tinymce-textarea');    
    insertBefore.before(newBlock);
    newBlock.show();
    SHERLOCK.cases.startEditingBlockInline(newBlock);
            
};

SHERLOCK.cases.updatePageInfoOrigValues = function() {
  var f = $('.section-page-info form');
  $('input.txtfield', f).each(function() {
      var field = $(this);
      var hidden = field.prev();
      var val = field.hasClass('hinted') ? '' : field.val();
      hidden.val(val);      
  });
};

SHERLOCK.cases.initCasePage = function() {
  
  var f = $('.section-page-info form');
  $('input.txtfield', f).each(function() {
    var hidden = $('<input/>').attr({
        'type': 'hidden',
        'value': 0,
        'class': 'hint-marker',
        'name': this.name.replace('case', 'hinted')
    });
    $(this).parent().prepend(hidden);
  });
  
  SHERLOCK.cases.checkBeforeLeavingPage();
  SHERLOCK.utils.formAjaxify(f);
    
};

SHERLOCK.cases.makeIconsDraggable = function() {
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
};

SHERLOCK.cases.makeFoldersDroppable = function() {
  
  function moveCase(folder, theCase)
  {
    var url = '/folders/' + folder.data('folder-id') + '/move_case';
    $.ajax({  
      url: url,
      data: {
        case_id: theCase.data('case-id')
      },
      'type': 'POST',
      success: function(data, textStatus, jqXHR) {
        theCase.remove();          
      }
    });
  }
  
  $('.case-icons-list .folder').droppable({  
    drop: function(event, ui) {      
      var theCase = ui.draggable;      
      if (confirm('Do you want to move this Case to folder?')) {
        theCase.get(0)._moved = true;
        moveCase($(this), theCase);
      } else {
      }
    }
  }); 
  
};

SHERLOCK.cases.initCasesList = function() {
  
  if ($('.case-icons-list').length) {    
    SHERLOCK.cases.makeIconsDraggable();
    SHERLOCK.cases.makeFoldersDroppable();    
  }
};

SHERLOCK.cases.finishEditingCurrentBlock = function() {  
  var currentBlock = $('#form-tinymce').parents('.block:first');
  if (currentBlock.length > 0) {
    SHERLOCK.cases.finishEditingBlockInline(currentBlock);
  }      
};

SHERLOCK.cases.finishEditingBlockInline = function(block) {
  
  block.find('.links-for-static').show();
  block.find('.links-for-editable').hide();
  
  var editable = block.find('.block-editable');
  editable.show();
  
  var isNewBlock = block.parent().hasClass('new-block');
  if (isNewBlock) {
    SHERLOCK.utils.richEditorRemove('form-tinymce-textarea');
    block.parent().hide();  
  } else {
    var ed = tinyMCE.get('form-tinymce-textarea');
    if (ed != null) {
      ed.setContent(editable.html());        
    }
    $('#form-tinymce').hide();
  }
  
  
};

SHERLOCK.cases.startEditingBlockInline = function(block) {
    
    block.find('.links-for-static').hide();

    var editable = block.find('.block-editable');
    var form = $('#form-tinymce');
    var editableParent = editable.get(0).parentNode;

    SHERLOCK.utils.richEditorRemove('form-tinymce-textarea');            
    editableParent.insertBefore(form.get(0), editable.get(0));        
    tinyMCE.execCommand('mceAddControl', false, 'form-tinymce-textarea');

    var ed = tinyMCE.get('form-tinymce-textarea');        
    if (ed != null) {
      ed.setContent(editable.html());
    }

    form.show();
    editable.hide();

    block.find('.links-for-editable').show();
};

SHERLOCK.cases.editableCancelClicked = function(link) {      
      var block = $(link).parents('.block:first');      
      SHERLOCK.cases.finishEditingBlockInline(block);
      return false;
 };
 
SHERLOCK.cases.editableSaveClicked = function(link) {  
    
  var url = link.href;  
  var method = 'put';
  var ed = tinyMCE.get('form-tinymce-textarea');        
  var html = ed.getContent();

  var newBlock = $(link).parents('.new-block:first');
  if (newBlock.length) {
    url = newBlock.data('form-url');    
    method = 'post'
  }    
  
  SHERLOCK.utils.showAjaxLoading();
  $.ajax({  
    url: url,        
    data: {
      _method: method,
      'html_detail[contents]': html
    },
    'type': 'POST',
    error : function() {
      SHERLOCK.utils.showAjaxError();
    }        
  });

};

SHERLOCK.cases.checkBeforeLeavingPage = function() {
  
  function checkPageInfoSection()
  {   
    
    var result = false;
    var f = $('.section-page-info form');    
    $('input.txtfield', f).each(function() {
      var field = $(this);
      var hidden = field.prev();
      var val = field.hasClass('hinted') ? '' : field.val();
      var orig = hidden.val();
      if (typeof orig === 'undefined') {
        orig = '';
      }
      if (val != orig) {        
        result = true;        
      }
    });
            
    return result;
  }
  
  $(window).bind('beforeunload', function() {
    var confirm = checkPageInfoSection();
    if (confirm) {
        return 'Do you want to leave the page without saving info?';
    }
  });
  
};

$(function() {        
    
    $('.remote-block-delete').live('ajax:before', function() {
      SHERLOCK.utils.showAjaxLoading();
    });     
    
    $('.form-insert-block').live('submit', function(e) {
      
        var t = $('select', this).val();
        var wrapper = 
            $(this).parents('.form-insert-block-wrapper:first');
        
        var insertBeforeQuery = '';
        var next = wrapper.next();
        if (next.hasClass('block')) {
            var blockId = next.data('block_id');            
            insertBeforeQuery = ('?insert_before_id=' + blockId);
        }
        
        switch (t) {
            case '':
                alert('Please select a block type');
                break;
            case 'text':
                SHERLOCK.cases.finishEditingCurrentBlock();
                SHERLOCK.cases.insertBlockBefore(wrapper);
                break;
            case 'picture':
                location.href = SHERLOCK.urls.new_block_picture +
                                insertBeforeQuery;
                break;            
            case 'video':
                location.href = SHERLOCK.urls.new_block_video +
                                insertBeforeQuery;
                break;            
        }                
        return false;
    });
    
    $('.links-for-editable .link-save').live('click', function(e) {      
      SHERLOCK.cases.editableSaveClicked(this);      
      return false;
    });
    
    $('.links-for-editable .link-cancel').live('click', function(e) {        
        SHERLOCK.cases.editableCancelClicked(this);
        return false;
    });
                
    $('.block-edit-ajax').live('click', function(e) {
      
        SHERLOCK.cases.finishEditingCurrentBlock();        
        var block = $(this).parents('.block:first');                
        SHERLOCK.cases.startEditingBlockInline(block);                
        return false;                      
    });
    
        
});

