module ApplicationHelper

  def action_link text, href, html=nil
    content_tag :li,  link_to(text, href, html)
  end

  def is_admin?
    session[:rights] == :admin
  end

  def is_logged?
    !session[:rights].nil?
  end

end
