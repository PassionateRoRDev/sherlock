
$(function() {
  
    $("#sample-report-form").dialog({
        autoOpen: false,
        draggable: false,
        resizable: false,
        width : 500,
        position : ['center', 150],
        modal : true,
        title: 'Get Your Sample Report'
    });
  
    $('a.link-sample-report').click(function() {
      $("#sample-report-form").dialog('open');
      return false;
    });
  
    $('ul.nav a').bind('click',function(event){                    
        var $anchor = $(this);
        var href = $anchor.attr('href');                    

        if (href != '/pricing') {

        var jumpOffset = 0;                    
        if (href != '/') {
          var sel = 'a[name=' + href.substr(1) + ']';
          var jumpTo =  $(sel).next();
          jumpOffset = jumpTo.offset().top - 35;
        }                    

        $('html, body').stop().animate({
            scrollTop: jumpOffset
        }, 1500,'easeInOutExpo');
        /*
        if you don't want to use the easing effects:
        $('html, body').stop().animate({
            scrollTop: $($anchor.attr('href')).offset().top
        }, 1000);
        */
        event.preventDefault();                    

        }
    });
});
