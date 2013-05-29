class PicturesController < ApplicationController
  before_filter :check_rights

  need_access!
  need_admin! :remove

  def index
    @resource = Picture.all_ordered
  end

  def show
    @picture = Picture.find params[:id]
  end

  def new
    @picture = Picture.new
  end

  def create
    params[:picture][:file].each do |f|
      @picture = Picture.new
      @picture.file = f
      @picture.date_of_shot = Picture.get_date_of_shot f

      if !@picture.save
        @error = true
      end
    end

    if !@error
      redirect_to pictures_path
    end
  end

  def destroy
    @picture = Picture.find params[:id]
    @picture.destroy
    render :text => ""
  end

  def tar
    pictures_id_list = params[:selected].split('+').map{|x| x.to_i }.uniq

    unless pictures_id_list.empty?
      pictures_to_zip = Picture.where("id in (?)", pictures_id_list).map{|x| x.file.path }.map{|x| ["-C " + x[0, x.rindex("/")], x[x.rindex("/")+1, x.length]] }.flatten.join(' ')
      render :content_type => "application/tar", :text => `tar -c #{pictures_to_zip}`
    end
  end

  def zip
    pictures_id_list = params[:selected].split(';').map{|x| x.to_i }.uniq

    unless pictures_id_list.empty?
      pictures_to_zip = Picture.where("id in (?)", pictures_id_list).map{|x| x.file.path }.map{|x| ["-C " + x[0, x.rindex("/")], x[x.rindex("/")+1, x.length]] }.flatten.join(' ')
      render :content_type => "application/tar", :text => `tar -c #{pictures_to_zip}`
    end

  end

  private

  def check_rights
    if session[:rights].nil?
      redirect_to "/"
    end
  end

end
