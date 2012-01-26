

$(function() {
    
    function removeTinyMCE(eltId) {
        var exists = tinyMCE.get(eltId);
        if (exists) {
            tinyMCE.remove(exists);
        }
    }
    
    $('.block-edit-ajax').click(function(e) {
        var url = this.href;
        var block = $(this).parents('.block:first');
        var exists  = $('.injected-form', block);
        if (!exists.length) {        
            $.ajax({
                url: url,
                cache: false,
                dataType: 'html',
                success : function(responseText, textStatus, XMLHttpRequest) {
                    var editable = $('.block-editable', block);
                    editable.hide();
                    editable.after(responseText);
                    $('.link-cancel', block).click(function() {                    
                        $(this).parents('.injected-form').hide();
                        removeTinyMCE('html_detail_contents');                    
                        $(this).parents('.injected-form').remove();
                        editable.show();
                        return false;
                    });
                }
            });
        }
        return false; 
    });
    
    
    $('#link-create-html-block').click(function(e) {              
       var block = $('<div/>').addClass('block text');
       var title = $('<h3/>').addClass('block-title').text('Text block');       
       var f = $('<form/>');
       
       var textareaId = 'textarea-' + new Date().valueOf();
       var textarea = $('<textarea>').attr('id', textareaId);
       f.append(textarea);
       
       var actions = $('<div/>').addClass('actions');
       var save = $('<input/>').attr('type', 'submit').val('Save block');           
       var cancel = $('<a/>').addClass('cancel-block')
                             .attr('href', '#')
                             .text('Cancel');
       actions.append(save).append(cancel);
       f.append(actions);       
       block.append(title).append(f);
       $('.blocks-area').append(block);
              
       tinyMCE.execCommand('mceAddControl', false, textareaId);
       setTimeout(function() {       
        tinyMCE.execCommand('mceFocus', false, textareaId);
       }, 500);       
      
       return false;
    });
    
    $('.blocks-area .block a.cancel-block').live('click', function(e) {        
        $(this).parents('.block:first').remove();        
        return false;
    });
    
    $('.blocks-area .block a.remove-block').live('click', function(e) {
        if (confirm('Are you sure you want to remove this block?')) {
            $(this).parents('.block:first').remove();
        }
        return false;
    });
});

