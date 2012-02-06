
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
            
    var url = SHERLOCK.urls.new_block_text;
    var exists = $('.injected-form-new');
    if (!exists.length) {          
        
        var next = insertBefore.next();
        if (next.hasClass('block')) {
            var blockId = next.data('block_id');
            url += ('?insert_before_id=' + blockId);            
        }                
        
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

