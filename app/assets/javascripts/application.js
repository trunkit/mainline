//= require jquery_ujs
//= require jquery-fileupload/basic
//= require_self
//= require_tree

window.SiteBindings = {};

$(document).ready(function () {
	$(window).bind('load', function(){
	    $('.videoBackground').imagefit();
	});
  $(".services").click(function() {
    $('html, body').animate({
      scrollTop: $('.section2').offset().top
    }, 'slow');
  })
})