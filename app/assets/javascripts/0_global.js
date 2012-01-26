$.ajaxSetup({
    'beforeSend': function (xhr) {
      xhr.setRequestHeader("Accept", "text/javascript");      
    }  
});

var SHERLOCK = SHERLOCK || {};
SHERLOCK.utils = SHERLOCK.utils || {};

SHERLOCK.utils.flashMessage = function(id, txt) {
    var msgs = $('.flash-messages');
    var m = msgs.find('#' + id);
    if (!m.length) {
        m = $('<div>').addClass('msg').attr('id', id);
        msgs.append(m);
    }
    m.html(txt);    
}

SHERLOCK.utils.removeTinyMCE = function(eltId) {
    if (tinyMCE && eltId) {
        var exists = tinyMCE.get(eltId);
        if (exists) {
            tinyMCE.remove(exists);
        }
    }
}

SHERLOCK.utils.focusTinyMCE = function(eltId) {
    if (tinyMCE) {
        setTimeout(function() {       
            tinyMCE.execCommand('mceFocus', false, eltId);
        }, 500);                
    }
}
