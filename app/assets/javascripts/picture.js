$(function() {
  $('form.edit_picture').submit(function() {
    
    function hasCrop(form)
    {      
      var crop_x = '' + $('#crop-x', form).val();      
      return (crop_x != '');
    }
    
    if (hasCrop(this)) {
      if (!confirm('Do you want REPLACE the existing picture with the cropped area')) {
        this.crop_new_block.value = 1;                
      }
    }
    
    return true;
  });

});