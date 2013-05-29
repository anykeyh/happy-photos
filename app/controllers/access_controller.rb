# charset: utf-8
#
class AccessController < ApplicationController
  def do_login

    unless params[:password].nil?
      password = params[:password]

      if password.empty?
        @error = "Le mot de passe doit etre renseigne."
      elsif password == HAPPY_PHOTOS['admin_password']
        session[:rights] = :admin
      elsif password == HAPPY_PHOTOS['uploader_password']
        session[:rights] = :upload
      else
        @error = "Mauvais mot de passe."
      end

      if @error.nil?
        redirect_to("/", :flash => { :notice => "Bienvenue!" })
      else
        redirect_to(access_login_path, :flash => { :error => @error })
      end
    else
      redirect_to access_login_path, :flash => { :error => "?"}
    end
  end

  def login
    # Display login form
  end

  def logout
    session[:rights] = nil
    redirect_to "/", :flash => { :notice => "Disconnected" }
  end
end
