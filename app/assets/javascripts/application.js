//= require jquery_ujs
//= require jquery-fileupload/basic
//= require_self
//= require_tree

window.SiteBindings = {};

$(document).ready(function () {
	$('#h5').bind('load', function(){
	    $('.videoBackground').imagefit();
	});
})
