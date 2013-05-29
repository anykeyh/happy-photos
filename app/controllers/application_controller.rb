class ApplicationController < ActionController::Base
  protect_from_forgery

  def self.need_admin! *actions
    if actions && actions.length > 0
      self.before_filter :check_for_admin, :only => actions
    else
      self.before_filter :check_for_admin
    end
  end

  def self.need_access! *actions
    if actions && actions.length > 0
      self.before_filter :check_for_access, :only => actions
    else
      self.before_filter :check_for_access
    end
  end

  private

  def check_for_access
    redirect_to "/" if session[:right] != nil
  end

  def check_for_admin
    redirect_to "/" if session[:right] != :admin
  end
end
