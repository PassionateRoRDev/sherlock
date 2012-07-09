
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

SHERLOCK.cases.insertWitnessStatementBlockBefore = function(insertBefore) {
    var url = SHERLOCK.urls.create_witness_statement;    
    var next = insertBefore.next();
    if (next.hasClass('block')) {
        var blockId = next.data('block_id');
        url += ('?insert_before_id=' + blockId);            
    }
    
    var newBlock = $('.blocks-area .new-witness-statement-block');
    newBlock.data('form-url', url);
    
    newBlock.find('.block-editable .block-editable-html').html('');
    
    SHERLOCK.utils.richEditorRemove('form-tinymce-textarea');    
    insertBefore.before(newBlock);
    newBlock.show();
    SHERLOCK.cases.startEditingBlockInline(newBlock);
    
};

SHERLOCK.cases.insertDataLogBlockBefore = function(insertBefore) {
  
    var url = SHERLOCK.urls.create_block_data_log;    
    var next = insertBefore.next();
    if (next.hasClass('block')) {
        var blockId = next.data('block_id');
        url += ('?insert_before_id=' + blockId);            
    }
    
    var newBlock = $('.blocks-area .new-data-log-block');
    newBlock.data('form-url', url);
    
    newBlock.find('.block-editable .block-editable-html').html('');
    
    SHERLOCK.utils.richEditorRemove('form-tinymce-textarea');    
    insertBefore.before(newBlock);
    newBlock.show();
    SHERLOCK.cases.startEditingBlockInline(newBlock);
};

SHERLOCK.cases.insertTextBlockBefore = function(blocktypeSelectWrapper) {
                        
    var url = SHERLOCK.urls.create_block_text;                
    var next = blocktypeSelectWrapper.next();
    if (next.hasClass('block')) {
        var blockId = next.data('block_id');
        url += ('?insert_before_id=' + blockId);            
    }
    
    var newBlock = $('.blocks-area .new-text-block');
    newBlock.data('form-url', url);
    
    newBlock.find('.block-editable .block-editable-html').html('');
    
    SHERLOCK.utils.richEditorRemove('form-tinymce-textarea');    
    blocktypeSelectWrapper.before(newBlock);
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

SHERLOCK.cases.moveBackCustomForm = function() {
  var form = $('#form-tinymce');
  var customForm = form.find('.custom-form');
  if (customForm.length) {
    switch (customForm.data('block_type')) {
      case 'data-log':
        $('.new-data-log-block .block-editable form').prepend(customForm);
        break;
      case 'witness-statement':
        $('.new-witness-statement-block .block-editable form').prepend(customForm);
        break;
    }
  }
};

SHERLOCK.cases.moveCustomFormFieldsIntoInjectedForm = function(block) {  
  
  var blockWrapper = block;
  if (!blockWrapper.hasClass('block-wrapper')) {
    blockWrapper = block.find('.block-wrapper');
  }
  
  var blockType = blockWrapper.data('block_type');
  
  var mapping = null;
  var value;
  
  var isNewBlock = blockWrapper.parent().hasClass('new-block');
  var form = $('#form-tinymce');           
  var editable = blockWrapper.find('.block-editable');
  
  switch (blockType) {
    case 'witness-statement':
      mapping = {
        'day': 'day-value',
        'hour': 'hour-value',
        'name': 'name-value',
        'address': 'address-value',
        'city_state_zip': 'city_state_zip-value'
      };      
      break;
    case 'data-log':
      mapping = {
        'day': 'day-value',
        'hour': 'hour-value',
        'location': 'location-value'
      }            
      break;
  }
  
  if (mapping != null) {      
      var customForm = $('.new-' + blockType + '-block .block-editable form .custom-form');
      for (var field in mapping) {        
        value = isNewBlock ? '' 
                : $.trim($('.' + mapping[field], editable).text())
        customForm.find('input[name=' + field + ']').val(value);
      }                      
      form.prepend(customForm);
  }
             
};

SHERLOCK.cases.finishEditingBlockInline = function(block) {
  
  block.find('.links-for-static').show();
  block.find('.links-for-editable').hide();
  
  var editable = block.find('.block-editable');
  
  SHERLOCK.cases.moveBackCustomForm();  
  
  editable.show();
  
  var isNewBlock = block.parent().hasClass('new-block');
  if (isNewBlock) {
    SHERLOCK.utils.richEditorRemove('form-tinymce-textarea');
    block.parent().hide();  
  } else {
    var ed = tinyMCE.get('form-tinymce-textarea');
    if (ed != null) {
      ed.setContent(editable.find('.block-editable-html').html());        
    }
    $('#form-tinymce').hide();
  }
  
  
};

SHERLOCK.cases.blocksSwapped = function(block1, block2) {
  var b1 = $('#block-' + block1.id);
  var b2 = $('#block-' + block2.id);
  var before2 = b2.prev();
  b1.before(b2);  
  before2.after(b1);      

  b1.find('.move-links a:eq(0)').attr('href', 
    '/block_swaps?block1_id=' + block1.prev_id + '&block2_id=' + block1.id);
  b1.find('.move-links a:eq(1)').attr('href', 
    '/block_swaps?block1_id=' + block1.id + '&block2_id=' + block1.next_id);
  
  b2.find('.move-links a:eq(0)').attr('href', 
    '/block_swaps?block1_id=' + block2.prev_id + '&block2_id=' + block2.id);
  b2.find('.move-links a:eq(1)').attr('href', 
    '/block_swaps?block1_id=' + block2.id + '&block2_id=' + block2.next_id);  
  
};

SHERLOCK.cases.startEditingBlockInline = function(block) {
    
    block.find('.links-for-static').hide();

    var editable = block.find('.block-editable');
    var htmlToEdit = editable.find('.block-editable-html').html();
    
    var form = $('#form-tinymce');
    var editableParent = editable.get(0).parentNode;

    SHERLOCK.utils.richEditorRemove('form-tinymce-textarea');            
    editableParent.insertBefore(form.get(0), editable.get(0));        
    tinyMCE.execCommand('mceAddControl', false, 'form-tinymce-textarea');

    var ed = tinyMCE.get('form-tinymce-textarea');        
    if (ed != null) {
      ed.setContent(htmlToEdit);
    }
    
    SHERLOCK.cases.moveCustomFormFieldsIntoInjectedForm(block);    

    form.show();
    editable.hide();

    block.find('.links-for-editable').show();
};

SHERLOCK.cases.editableCancelClicked = function(link) {      
    var block = $(link).parents('.block:first');      
    SHERLOCK.cases.finishEditingBlockInline(block);
    return false;
};

SHERLOCK.cases.blockDetailCreated = function(blockName, blockHtml, msg) {
  $('.blocks-area .no-blocks-msg').remove();
  var temporaryNewBlock = $('.' + blockName);
  temporaryNewBlock.after(blockHtml);
  temporaryNewBlock.next().find('select.rich-dropdown').msDropDown();
  temporaryNewBlock.hide();

  SHERLOCK.cases.resetBlockTypeLists();

  SHERLOCK.utils.hideAjaxLoading();
  SHERLOCK.utils.flashMessage('notice', msg);
}

SHERLOCK.cases.blockDetailUpdated = function(fieldNames, values) {
  var block = $('.injected-form').parents('.block:first');
  var editable = block.find('.block-editable');
  var fields = $('.' + fieldNames, editable);  
  for (var fieldName in values) {
    $('.' + fieldName + '-value', fields).text(values[fieldName]);
  }
  
};

SHERLOCK.cases.witnessStatementUpdated = function(values) {
  SHERLOCK.cases.blockDetailUpdated('witness-statement-fields', values);        
};

SHERLOCK.cases.dataLogUpdated = function(values) {        
  SHERLOCK.cases.blockDetailUpdated('data-log-fields', values);    
};

/**
 * Called by the update.js.erb template after block update.
 */
SHERLOCK.cases.blockUpdated = function(msg) {
  
  SHERLOCK.utils.hideAjaxLoading();
  SHERLOCK.utils.flashMessage('notice', msg);
  var block = $('.injected-form').parents('.block:first');
  var editable = block.find('.block-editable');
  var ed = tinyMCE.get('form-tinymce-textarea');
  editable.find('.block-editable-html').html(ed.getContent());
  
  $('#form-tinymce').hide();
  SHERLOCK.cases.moveBackCustomForm();
  
  editable.show();
  block.find('.links-for-editable').hide();
  block.find('.links-for-static').show();
};
 
SHERLOCK.cases.editableSaveClicked = function(link) {  
    
  var url = link.href;
  var method = 'put';
  var newBlock = $(link).parents('.new-block:first');
  if (newBlock.length) {
    url = newBlock.data('form-url');    
    method = 'post'
  }
  
  var ed, contents;  
  var data = {};
  
  var error = false;
  
  var blockWrapper = $(link).parents('.block-wrapper:first');
  var blockType = blockWrapper.data('block_type');
      
  var form;
            
  switch (blockType) {
    case 'data-log':      
      form = $('#form-tinymce').get(0);  
      ed = tinyMCE.get('form-tinymce-textarea');
      contents = ed.getContent();
      if ($.trim(contents) == '') {
        alert('Please provide the description.');
        error = true;
      } else {
        data = { 
          'data_log_detail[contents]': contents,
          'data_log_detail[day]':   form.day.value,
          'data_log_detail[hour]': form.hour.value,
          'data_log_detail[location]': form.location.value
        }
      }
      break;
    
    case 'witness-statement':      
      form = $('#form-tinymce').get(0);      
      ed = tinyMCE.get('form-tinymce-textarea');
      contents = ed.getContent();
      if ($.trim(contents) == '') {
        alert('Please provide statement contents.');
        error = true;
      } else {
        data = { 
          'witness_statement[contents]': contents,
          'witness_statement[day]':   form.day.value,
          'witness_statement[hour]': form.hour.value,
          'witness_statement[name]': form.name.value,
          'witness_statement[address]': form.address.value,
          'witness_statement[city_state_zip]': form.city_state_zip.value
        }
      }
      
      break;
      
    case 'text':
      ed = tinyMCE.get('form-tinymce-textarea');
      contents = ed.getContent();
      if ($.trim(contents) == '') {
        alert('Please provide block contents');
        error = true;
      } else {
        data = { 
          'html_detail[contents]': contents
        }
      }
      break;
  }
  
  if (!error) {
  
    data['_method'] = method;
    SHERLOCK.utils.showAjaxLoading();

    $.ajax({  
      url: url,
      data: data,      
      'type': 'POST',
      error : function() {
        SHERLOCK.utils.showAjaxError();
      }        
    });
  
  }
  
  return;
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
            case 'data_log':
                SHERLOCK.cases.finishEditingCurrentBlock();
                SHERLOCK.cases.insertDataLogBlockBefore(wrapper);
                break;
            case 'witness_statement':
                SHERLOCK.cases.finishEditingCurrentBlock();
                SHERLOCK.cases.insertWitnessStatementBlockBefore(wrapper);
                break;               
            case 'text':
                SHERLOCK.cases.finishEditingCurrentBlock();
                SHERLOCK.cases.insertTextBlockBefore(wrapper);                
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

