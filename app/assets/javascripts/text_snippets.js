
var SHERLOCK = SHERLOCK || {};
SHERLOCK.snippets = SHERLOCK.snippets || {};

SHERLOCK.snippets.init = function(options) {
  $('.insert-snippet-dropdown').change(function() {
    var snippetId = $(this).val();
    if (snippetId != '') {
      var url = options.urls.snippets + '/' + snippetId + '.json';
      url += '?ts=' + new Date().valueOf();
      $.get(url, function(data, textStatus, jqXHR) {
        var snippetBody = data.body;        
        if (tinyMCE) {
          var ed = tinyMCE.get(options.editor_id);
          if (ed) {            
            ed.execCommand('mceInsertContent', false, snippetBody);
          }
        }        
      });            
    }
  });
};
  