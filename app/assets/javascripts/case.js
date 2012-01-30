
var SHERLOCK = SHERLOCK || {};
SHERLOCK.cases = SHERLOCK.cases || {};

SHERLOCK.cases.removeInjectedForm = function() {
    var f = $('.injected-form');
    f.hide();
    var textarea = $('textarea', f);
    SHERLOCK.utils.removeTinyMCE(textarea.attr('id'));
    f.remove();
    return false;
};

$(function() {
    
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
                
                var newBlock = $('.blocks-area .new-block');
                newBlock.html(responseText);
                
                var f = $('.injected-form-new', newBlock);
                var textarea = $('textarea', f);
                
                $('.link-cancel', newBlock).click(
                    SHERLOCK.cases.removeInjectedForm);                                 
                SHERLOCK.utils.focusTinyMCE(textarea.attr('id'));                
            });
        }
        return false;
    });
    
    $('.block-edit-ajax').live('click', function(e) {
        var url = this.href;
        var block = $(this).parents('.block:first');
        var exists  = $('.injected-form', block);
        if (!exists.length) {
            ajaxHtmlDo(url, function(responseText, textStatus, XMLHttpRequest) {
                var editable = $('.block-editable', block);
                editable.hide();
                editable.after(responseText);
                $('.link-cancel', block).click(function() {
                    SHERLOCK.cases.removeInjectedForm();
                    editable.show();
                    return false;
                });                    
            });
        }
        return false; 
    });
    
        
});

