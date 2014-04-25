class BoutiqueSignUpController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    Notifier.boutique_signup(params[:boutique]).deliver
    render(inline: "<script>window.close()</script>")
  end
end
