class BoutiquesController < ApplicationController
  def redirect
    if b = Boutique.where(short_code: params[:short_code].strip).first
      session[:referring_boutique_id] = b.id
    end

    redirect_to(root_path)
  end
end
