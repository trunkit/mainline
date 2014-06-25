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
    element  = $('div.item-quantity');
    form     = element.parents('form');
    newRow   = element.find("div.row:last-child");
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
      newRow = $(this).parent().clone();
      newRow.find("input").val("");

      $(this).parents("div.item-quantity").append(newRow);
    };

    $(document).on('change', 'div.item-quantity div.row:last-child input', newRowChangeBinding);

    form.bind(bindType, function() {
      _form = $(this);

      _form.find(".row").each(function() {
        var label = $(this).find("input[name=name]").val();
        var value = parseInt($(this).find("input[name=quantity]").val());

        var attrs = {
          "name": "item[sizes]["+label+"]",
          "type": "hidden"
        };

        if(isNaN(value) || value < 0)
          value = 0;

        if(label.length > 0)
          _form.append($("<input>").attr(attrs).val(value));

        $(this).find("input").attr("disabled", true);
      });
    });
  },
  details: function(itemSizes) {
    $("article.item div.thumbs a").click(function() {
      $(this).parents("section.photos").children("img").attr("src", $(this).attr("href"));
      return false;
    });

    $("article.item form select.size").change(function() {
      maxQuantity    = parseInt(itemSizes[$(this).val()]);
      quantitySelect = $(this).siblings("select")
      quantitySelect.empty();
      quantitySelect.append($("<option></option>").text("Quantity"))

      for(var i = 1; i <= maxQuantity; i++)
        quantitySelect.append($("<option></option>").text(i));
    }).trigger("change");
  },
  brands: function(prefix) {
    if(typeof prefix === 'undefined')
      var prefix = '';

    $("#item_brand_id").change(function() {
      var s = $(this);

      if(s.val() == "-1") {
        s.parents("form").find("form, input:visible, button:visible, select, textarea").attr("disabled", true);
        s.parents("form").find(".brand-select").hide();
        s.parents("form").find(".brand-add").show();
      }

      return true;
    }).trigger("change");

    $("#add-brand").click(function() {
      e    = $(this).parents(".brand-add")
      val = $(this).parent().find("input").val();

      data = {"brand": { "name": val }};

      $.ajax({ url: (prefix + "/brands.json"), type: "POST", data: data, complete: function() {
        $.getJSON((prefix + "/brands.json"), function(data) {
          e.parents("form").find("form, input, button:visible, select, textarea").removeAttr("disabled");
          e.hide();

          s = e.parents("form").find(".brand-select").show();
          console.log(s);
          s = s.find("select");

          s.empty();

          for(i = 0; i < data.length; i++) {
            brand = data[i];
            s.append($("<option></option>").text(brand.name).val(brand.id));
          }

          s.append($("<option></option>").text("(Add a New Brand)").val("-1"));
        });
      }});

      return false;
    });
  }
};
