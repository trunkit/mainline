class BoutiqueSignUpController < ApplicationController
  def create
    Notifier.boutique_signup(params[:boutique])
    render(inline: "<script>window.close()</script>")
  end
end
