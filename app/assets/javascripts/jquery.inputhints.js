// jQuery Input Hints plugin
// Copyright (c) 2009 Rob Volk
// http://www.robvolk.com

jQuery.fn.inputHints=function() {
    // hides the input display text stored in the title on focus
    // and sets it on blur if the user hasn't changed it.

    // show the display text
    $(this).each(function(i) {
        $(this).val($(this).attr('title'));
    });

    // hook up the blur & focus
    return $(this).focus(function() {
        if ($(this).val() == $(this).attr('title'))
            $(this).val('');
    }).blur(function() {
        if ($(this).val() == '')
            $(this).val($(this).attr('title'));
    });
};
