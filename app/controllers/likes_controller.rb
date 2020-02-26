class LikesController < ApplicationController
  def create
    like = Like.new
    like.fan_id = session[:current_user_id]
    like.photo_id = params["query_photo_id"].to_i
    like.save

    redirect_to("/photos/#{like.photo_id}")
  end

  def delete
    like = Like.where({ :id => params["like_id"] })[0]
    pid  = like.photo_id
    like.destroy

    redirect_to("/photos/#{pid}")
  end
end