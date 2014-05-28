SiteBindings.billing = function() {
  var form = $("#payment-method form");

  function cardTokenHandler(status, res) {
    if(status != 200) {
      alert("There was a problem processing your credit card, please check your information and try again.");
      form.find("button, input[type=image], input[type=submit]").removeProp("disabled");
      $.fancybox.hideLoading();
      return;
    }

    form.find("input[data-stripe]").prop("disabled", true);
    form.append($("<input type=\"hidden\">").attr("name", "card_token").val(res.id));

    form.unbind("submit.cc").submit();
  }

  form.bind("submit.cc", function() {
    $.fancybox.showLoading();
    $(this).find("button, input[type=image], input[type=submit]").prop("disabled", true);
    Stripe.card.createToken($(this), cardTokenHandler);

    return false;
  });
};
