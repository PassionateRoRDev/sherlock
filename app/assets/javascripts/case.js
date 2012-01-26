
var SHERLOCK = SHERLOCK || {};
SHERLOCK.cases = SHERLOCK.cases || {};

SHERLOCK.cases.removeNewBlockForm = function() {
    var blocks = $('.blocks-area');
    var newBlock = $('.new-block', blocks);
    var f = $('.injected-form-new', newBlock);       
    var textarea = $('textarea', f);
    f.hide();    
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
                
                var blocks = $('.blocks-area');
                var newBlock = $('.new-block', blocks);
                newBlock.html(responseText);
                var f = $('.injected-form-new', newBlock);
                var textarea = $('textarea', f);
                
                $('.link-cancel', newBlock).click(
                    SHERLOCK.cases.removeNewBlockForm);                                 
                
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
    
        
});

