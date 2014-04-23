SiteBindings.streamItems = function() {
  SiteBindings.item.quantities();

  $("article.item").mouseleave(function() {
    if($(this).find("form.item-quantity").is(":visible")) {
      $(this).find(".edit.button").trigger("click");
    }
  });

  $(".edit.button").click(function() {
    quantityForm = $(this).parents("article.item").find("form.item-quantity");

    if(quantityForm.is(":visible")) {
      quantityForm.hide();
      $(this).text("Edit");
    } else {
      quantityForm.show();
      $(this).text("Close");
    }

    return false;
  });

  $('form.item-quantity').on("ajax:beforeSend", function() {
    $.fancybox.showLoading();
  }).on("ajax:complete", function() {
    $.fancybox.hideLoading();
    $(this).find("input[type=text]").removeAttr("disabled");
    $(this).children("input[type=hidden]").remove();
  });
};
