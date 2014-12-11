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

if($('body').hasClass('public')) {
  $('.login').click(function() {
    alert("The paragraph was clicked.");
    $( '.fancybox-wrap' ).each(function () {
      this.style.setProperty( 'top', '116px', 'important' );
    });
  });
}