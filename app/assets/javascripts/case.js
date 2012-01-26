
$(function() {
    
    function removeTinyMCE(eltId) {
        var exists = tinyMCE.get(eltId);
        if (exists) {
            tinyMCE.remove(exists);
        }
    }
    
    function ajaxHtmlDo(url, success) 
    {
        var options = {
            url: url,
            cache: false,
            dataType: 'html',
            success : success
        };
        $.ajax(options);        
    }
    
    $('.block-add-ajax').click(function(e) {
        var url = this.href;
        var exists  = $('.injected-form-new');
        if (!exists.length) {            
            ajaxHtmlDo(url, function(responseText, textStatus, XMLHttpRequest) {
                var blocks = $('.blocks-area');
                var newBlock = $('.new-block', blocks);
                newBlock.html(responseText);
                var f = $('.injected-form-new', newBlock);
                var textarea = $('textarea', f);
                $('.link-cancel', newBlock).click(function() {                                        
                    f.hide();                    
                    removeTinyMCE(textarea.attr('id'));                    
                    f.remove();                    
                    return false;
                });
                setTimeout(function() {       
                    tinyMCE.execCommand('mceFocus', false, textarea.attr('id'));
                }, 500);
            });
        }
        return false;
    });
    
    $('.block-edit-ajax').click(function(e) {
        var url = this.href;
        var block = $(this).parents('.block:first');
        var exists  = $('.injected-form', block);
        if (!exists.length) {
            ajaxHtmlDo(url, function(responseText, textStatus, XMLHttpRequest) {
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
        
});

