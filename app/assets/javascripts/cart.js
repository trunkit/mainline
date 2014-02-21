SiteBindings.cart = function() {
  $("form select").change(function() {
    $(this).parents("form").trigger("submit");
  })
};
