class PhotosController < ApplicationController
  def index
    @photos = Photo.all
    render({ :template => "photos/all_photos.html.erb"})
  end

  def show
    if (session[:current_user_id] == nil) 
      redirect_to("/user_sign_in?accessdenied=1")
      return
    end
    p_id = params.fetch("the_photo_id")
    @photo = Photo.where({:id => p_id }).first
    render({:template => "photos/details.html.erb"})
  end
end