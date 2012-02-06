
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

SHERLOCK.cases.removeInjectedForm = function() {
    var f = $('.injected-form');
    f.hide();
    var textarea = $('textarea', f);
    SHERLOCK.utils.removeTinyMCE(textarea.attr('id'));
    f.remove();
    
    // deselect block type from the lists:
    $('.form-insert-block select').each(function() {
       this.selectedIndex = 0; 
    });    
    return false;
};

SHERLOCK.cases.insertBlockBefore = function(insertBefore) {
    
    var url = $('.block-add-ajax').attr('href');            
    var exists = $('.injected-form-new');
    if (!exists.length) {          
        SHERLOCK.ajaxHtmlDo(url, function(responseText, textStatus, XMLHttpRequest) {                        
            var newBlock = $('.blocks-area .new-block');
            insertBefore.before(newBlock);
            newBlock.html(responseText);

            var f = $('.injected-form-new', newBlock);
            var textarea = $('textarea', f);

            $('.link-cancel', newBlock).click(
                SHERLOCK.cases.removeInjectedForm);                                 
            SHERLOCK.utils.focusTinyMCE(textarea.attr('id'));                
        });
    }
};

$(function() {        
    
    $('.form-insert-block').submit(function(e) {        
        var t = $('select', this).val();
        switch (t) {
            case '':
                alert('Please select a block type');
                break;
            case 'text':
                var wrapper = 
                    $(this).parents('.form-insert-block-wrapper:first');
                SHERLOCK.cases.insertBlockBefore(wrapper);
                break;
            default:
                alert('Not implemented yet!');
        }                
        return false;
    });
    
    $('.block-add-ajax').click(function(e) {        
        var insertBefore = $('.form-insert-block-wrapper:last');                
        SHERLOCK.cases.insertBlockBefore(insertBefore);                
        return false;
    });
    
    $('.block-edit-ajax').live('click', function(e) {
        var url = this.href;
        var block = $(this).parents('.block:first');
        var exists  = $('.injected-form', block);
        if (!exists.length) {
            SHERLOCK.ajaxHtmlDo(url, function(responseText, textStatus, XMLHttpRequest) {
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

