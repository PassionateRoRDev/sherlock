
var SHERLOCK = SHERLOCK || {};
SHERLOCK.snippets = SHERLOCK.snippets || {};

SHERLOCK.snippets.created = function(snippet, dropdownHtml)
{
  var block = $('.text-snippet-insert-block');
  var dropdown = $('.text-snippet-dropdown-wrapper');
  if (dropdown.length) {
     
  } else {
    $('.no-snippets-msg', block).remove();
    block.append(dropdownHtml);    
    var options = {
      rowHeight: 19,
      selectWidth: 218
    };    
    block.find('select.rich-dropdown').msDropDown(options);    
  }
  $("#dialog-snippet-title").dialog('close');
  alert('Snippet successfully created!');
}

SHERLOCK.snippets.init = function(options) {
      
  setupInsertLink();
  setupCreateLink();
  initPromptForTitleDialog();
  
  function initPromptForTitleDialog()
  {
    var dialog = $("#dialog-snippet-title");
    if (dialog.length) {
      
      dialog.dialog({
        autoOpen: false,
        draggable: false,
        resizable: false,
        width : 500,
        position : ['center', 150],
        modal : true,
        title: 'Snippet Title'
      });
      
      dialog.find('input.submit').click(function() {    
        var titleElt = dialog.find('#snippet-title');
        var title = titleElt.val();        
        if (title == '') {
          alert('Please provide a title');
          titleElt.focus();
        } else {        
          var selection = dialog.find('#snippet-body').val();
          var url = dialog.find('form').attr('action');
          url += '?ts=' + new Date().valueOf();        
          createSnippetDo(url, title, selection);                
        }
        
      });    
    }
    
  }
  
  function createSnippetDo(url, title, body) 
  {
    var data = {
      'text_snippet[title]': title,
      'text_snippet[body]': body
    };   
    $.post(url, data, function(data, textStatus, jqXHR) {
      eval(data);              
    }, 'text'); 
    
  }
  
  function setupCreateLink()
  {
    var block = $('.text-snippet-insert-block');
    var link = $('.create-wrapper a', block);
    link.click(function() {      
      var ed = getEditor();
      if (ed) {
                
        var selection = ed.selection.getContent();
        
        if (selection == '') {
          alert('Please select some text first');
        } else {        
          var dialog = $("#dialog-snippet-title");
          dialog.find('#snippet-body').val(selection);
          dialog.find('#snippet-title').val('');
          $("#dialog-snippet-title").dialog('open');
                 
          //var title = prompt('Enter snippet title:');          
          /*
          if (title !== null) {      
            var url = options.urls.snippets + '.json';
            url += '?ts=' + new Date().valueOf();            
            createSnippetDo(url, title, selection);                                          
          }
          */
         
        }
      }
      return false;
    });
  }
      
  function setupInsertLink()
  {    
    var wrapper = $('.text-snippet-dropdown-wrapper');
    $('a', wrapper).click(function() {
      var dropdown = $('select', wrapper);
      var snippetId = dropdown.val();
      if (snippetId != '') {
        var url = options.urls.snippets + '/' + snippetId + '.json';
        url += '?ts=' + new Date().valueOf();
        $.get(url, function(data, textStatus, jqXHR) {
          var snippetBody = data.body;
          var ed = getEditor();
          if (ed) {
            ed.execCommand('mceInsertContent', false, snippetBody);
          }                  
        });          
      }
      return false;
    });
  }
  
  function getEditor()
  {
    return tinyMCE ? tinyMCE.get(options.editor_id) : null;            
  }
  
};
  