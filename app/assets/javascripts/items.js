SiteBindings.item = {
  form: function(itemId, secondaryCategories) {
    $("#item_primary_category_id").change(function() {
      options = secondaryCategories[$(this).val()];
      target  = $("#item_secondary_category_id");
      target.empty();

      if(options === undefined)
        return false;

      for(i = 0; i < options.length; i++) {
        e = options[i];
        target.append($("<option></option>").attr("value", e.id).text(e.name));
      }

    }).trigger("change");

    $("#photo-upload").fileupload({
      dataType: 'script',
      start: function(e) { $.fancybox.showLoading(); },
      stop: function(e) { $.fancybox.hideLoading(); }
    });

    $(".photo .button span").click(function() {
      $("#photo-upload input[type=file]").click();
      return false;
    });

    $("a.delete").on("ajax:beforeSend", function() { $.fancybox.showLoading(); });
    $("a.delete").on("ajax:complete",   function() { $.fancybox.hideLoading(); });

    SiteBindings.item.sortablePhotos(itemId);
  },
  sortablePhotos: function(itemId) {
    $("#item-photos").sortable({
      stop: function(e, ui) {
        $.fancybox.showLoading();

        ids = [];

        $("#item-photos div.item-photo").each(function() {
          ids.push($(this).data("photo-id"));
        });

        $.ajax({
          complete: function() { $.fancybox.hideLoading(); },
          data: { "photo_ids": ids },
          dataType: "script",
          type: "PUT",
          url: "/items/" + itemId + "/photos/reorder"
        });
      }
    });
  }
};
