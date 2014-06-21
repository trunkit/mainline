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

  form.find("input.number").keyup(function() {
    var number = $(this).val();

    $(".row.type div").each(function() {
      if($(this).hasClass("visa") && (/^4/.test(number)))
        $(this).removeClass("gray");
      if($(this).hasClass("mastercard") && (/^5[0-3]/.test(number)))
        $(this).removeClass("gray");
      else if($(this).hasClass("amex") && (/^3[47]/.test(number)))
        $(this).removeClass("gray");
      else if($(this).hasClass("discover") && (/^6[0245]/.test(number)))
        $(this).removeClass("gray");
      else if($(this).hasClass("jcb") && (/^35[2-8][0-9]/.test(number)))
        $(this).removeClass("gray");
      else if($(this).hasClass("diners") && (/^5[4-5]/.test(number)))
        $(this).removeClass("gray");
      else if(number.length > 1)
        $(this).addClass("gray");
      else
        $(this).removeClass("gray");
    });
  });
};
