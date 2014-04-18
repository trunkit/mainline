SiteBindings.streamItems = function() {
  SiteBindings.item.quantities();

  $('form.item-quantity').on("ajax:beforeSend", function() {
    $.fancybox.showLoading();
  }).on("ajax:complete", function() {
    $.fancybox.hideLoading();
    $(this).find("input[type=text]").removeAttr("disabled");
    $(this).children("input[type=hidden]").remove();
  });
};
