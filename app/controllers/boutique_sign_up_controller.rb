class BoutiqueSignUpController < ApplicationController
  def create
    Notifier.boutique_signup(params[:boutique])
  end
end
