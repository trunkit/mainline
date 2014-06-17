SiteBindings.users = {
  resetPassword: function() {
    var form = $("form.reset-password");

    form.on("ajax:send", function() {
      $.fancybox.showLoading();
    });

    form.on("ajax:complete", function() {
      $.fancybox({ content: '\
      <div class="reset-success"> \
        <h1>Password Reset Sent!</h1> \
        <p>We\'ve sent you an email with instructions on how to reset your password. It takes less than a minute, we promise!</p> \
      </div> \
      '})
    });
  }
}