class HomeController < ApplicationController
  def index
    if session[:rights].nil?
      redirect_to access_login_path
    else
      redirect_to pictures_path
    end
  end
end
