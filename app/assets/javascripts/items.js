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

    $(document).on("ajax:beforeSend", function() { $.fancybox.showLoading(); });

    if(itemId)
      SiteBindings.item.sortablePhotos(itemId);

    SiteBindings.item.quantities();
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
  },
  quantities: function() {
    element  = $('.item-quantity');
    form     = element.parents('form');
    newRow   = element.find("div.row").last();
    bindType = (form.data("remote") == "true") ? "ajax:beforeSend" : "submit";

    $(document).on("click", ".item-quantity .increase", function() {
      qtyElem = $(this).siblings("input[name=quantity]");
      qty     = parseInt(qtyElem.val()) + 1;

      if(isNaN(qty))
        qty = 1;

      qtyElem.val(qty);

      return false;
    });

    $(document).on("click", ".item-quantity .decrease", function() {
      qtyElem = $(this).siblings("input[name=quantity]");
      qty     = parseInt(qtyElem.val()) - 1;

      if(qty < 0 || isNaN(qty))
        qty = 0;

      qtyElem.val(qty);

      return false;
    });

    newRowChangeBinding = function() {
      $(this).parent().find("input").unbind("change");
      newRow = $(this).parent().clone();
      newRow.find("input").val("").change(newRowChangeBinding);

      element.append(newRow);
    };

    newRow.find("input").change(newRowChangeBinding);

    form.bind(bindType, function() {
      element.find(".row").each(function() {
        var label = $(this).find("input[name=name]").val();
        var value = parseInt($(this).find("input[name=quantity]").val());

        var attrs = {
          "name": "item[sizes]["+label+"]",
          "type": "hidden"
        };

        if(isNaN(value) || value < 0)
          value = 0;

        if(label.length > 0)
          form.append($("<input>").attr(attrs).val(value));

        $(this).find("input").attr("disabled", true);
      });
    });
  }
};
