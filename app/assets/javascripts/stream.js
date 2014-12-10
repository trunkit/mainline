SiteBindings.stream = {
  items: function() {
    SiteBindings.item.quantities();

    $(document).on("article.item", "mouseleave", function() {
      if($(this).find("form.item-quantity").is(":visible")) {
        $(this).find(".edit.button").trigger("click");
      }
    });

    $(".edit.button").click(function() {
      quantityForm = $(this).parents("article.item").find("form.item-quantity");

      if(quantityForm.is(":visible")) {
        quantityForm.hide();
        $(this).removeClass("closeMobile");
        $(this).removeClass("closeButton");
        $(this).html("Edit");
      } 
      else {
        quantityForm.show();
        $(this).addClass("closeMobile");
        $(this).addClass("closeButton");
        $(this).html("Close");
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

    $('.imagen:not([src=""])').show();
    $('.imagen[src=""]').attr("src", 'assets/items/placeholder.jpg');
  },
  watcher: function(nextURL) {
    $("#stream-watcher").bind("inview", function( event, isInView, visiblePartX, visiblePartY ) {
      if(nextURL === "" || typeof nextURL === "undefined")
        return;

      if(visiblePartY == 'both') {
        $.fancybox.showLoading();
        $("#stream-watcher").unbind("inview");

        $.ajax({
          dataType: "script",
          type: "GET",
          url: nextURL,
          complete: function() {
            $.fancybox.hideLoading();
          }
        });
      }
    });
  }
};
