class BoutiqueSignUpController < ApplicationController
  def create
    Notifier.boutique_signup(params[:boutique]).deliver
    render(inline: "<script>window.close()</script>")
  end
end
