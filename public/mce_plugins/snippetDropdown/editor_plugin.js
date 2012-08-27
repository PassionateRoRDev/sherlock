(function() {
    tinymce.create('tinymce.plugins.SnippetDropdown', {        
        
        /*
        insertItem : function(title, id) {      
          var dropdown = this._dropdown;
          alert(dropdown);
          alert(dropdown.getLength());
          dropdown.add(title, id);                    
          alert(dropdown.getLength());
        },
        */
       
        fetchSnippetAndInsert : function(name) {
          var url = '/text_snippets/' + name + '.json'                          
          url += ('?c=' + new Date().valueOf());
          tinymce.util.XHR.send({
            url: url,
            content_type: 'application/json',
            success: function(result) {
              result = JSON.parse(result);
              var snippetBody = result.body;              
              tinymce.activeEditor.execCommand(
                'mceInsertContent', false, snippetBody);
              }
          });
        },
        createControl: function(n, cm) {          
          var self = this;
            switch( n ) {                
                case 'snippetDropdown':                    
                    var c = cm.createListBox('snippetDropdown', {
                        title : 'Snippets',
                        onselect : function(name) {
                          self.fetchSnippetAndInsert(name);                                                                              
                        }              
                    });
                    self._dropdown = c;
                    return c;
            }    
            return null;            
        }        
    });    
    tinymce.PluginManager.add('snippetDropdown', tinymce.plugins.SnippetDropdown);    
})();
