class UsersController < ApplicationController
  def index
    @users = User.all.order({ :username => :asc })
    @justsignedin = params["justsignedin"]
    @justsignedout = params["justsignedout"]
    @justcreated = params["justcreated"]
    render({ :template => "users/index.html" })
  end

  def sign_in
    @nouser = params["nouser"]
    @wrongpassword = params["wrongpassword"]
    @accessdenied = params["accessdenied"]
    render({ :template => "users/signin.html.erb" })
  end

  def sign_out
    session[:current_user_id] = nil
    redirect_to("/?justsignedout=1")
  end

  def sign_up
    @failure = params["failure"]
    render({ :template => "users/signup.html.erb" })
  end

  def verify_credentials
    u = User.where(:email => params["query_email"])[0]
    if (u == nil) 
      redirect_to("/user_sign_in?nouser=1")
      return
    end
    if (u.password != params["query_password"])
      redirect_to("/user_sign_in?wrongpassword=1")
      return
    end

    session[:current_user_id] = u.id
    redirect_to("/?justsignedin=1")
  end

  def show_discover
    if (session[:current_user_id] == nil) 
      redirect_to("/user_sign_in?accessdenied=1")
      return
    end
    the_username = params.fetch("the_username")
    @user = User.where({ :username => the_username }).at(0)
    @own = nil
    @liked = nil
    @discover = 1
    @feed = nil

    render({ :template => "users/show.html.erb" })
  end

  def show_own
    if (session[:current_user_id] == nil) 
      redirect_to("/user_sign_in?accessdenied=1")
      return
    end
    the_username = params.fetch("the_username")
    @user = User.where({ :username => the_username }).at(0)
    @own = 1
    @liked = nil
    @discover = nil
    @feed = nil

    render({ :template => "users/show.html.erb" })
  end

  def show_liked
    if (session[:current_user_id] == nil) 
      redirect_to("/user_sign_in?accessdenied=1")
      return
    end
    the_username = params.fetch("the_username")
    @user = User.where({ :username => the_username }).at(0)
    @own = nil
    @liked = 1
    @discover = nil
    @feed = nil

    render({ :template => "users/show.html.erb" })
  end

  def show_feed
    if (session[:current_user_id] == nil) 
      redirect_to("/user_sign_in?accessdenied=1")
      return
    end
    the_username = params.fetch("the_username")
    @user = User.where({ :username => the_username }).at(0)
    @own = nil
    @liked = nil
    @discover = nil
    @feed = 1

    render({ :template => "users/show.html.erb" })
  end

  def create
    if (params["query_email"] == "") 
      redirect_to("/user_sign_up?failure=1")
      return
    elsif (params["query_username"] == "") 
      redirect_to("/user_sign_up?failure=1")
      return
    elsif (params["query_password"] == "")
      redirect_to("/user_sign_up?failure=1")
      return
    elsif (params["query_password"] != params["query_password_confirmation"])
      redirect_to("/user_sign_up?failure=1")
      return
    elsif (User.where(:username => params["query_username"])[0] != nil)
      redirect_to("/user_sign_up?failure=1")
      return
    elsif (User.where({:email => params["query_email"]})[0] != nil) 
      redirect_to("/user_sign_up?failure=1")
      return
    end

    user = User.new

    user.email = params["query_email"]
    user.username = params["query_username"]
    user.password = params["query_password"]
    if (params["query_private"] == nil)
      user.is_private = false
    else 
      user.is_private = true
    end

    user.save

    user = User.where(:username => params["query_username"])[0]
    session[:current_user_id] = user.id

    redirect_to("/users?justcreated=1")
  end

  def destroy
    username = params.fetch("the_username")
    user = User.where({ :username => username }).at(0)

    user.destroy

    redirect_to("/users")
  end

  def insert_follow_request
    follow_request = FollowRequest.new
    follow_request.recipient_id = params["query_recipient_id"].to_i
    follow_request.sender_id = session[:current_user_id]
    recipient = User.where({:id => params["query_recipient_id"].to_i})[0]
    if (recipient.is_private == false)
      follow_request.status = "accepted"
    end

    follow_request.save
    
    redirect_to("/users/#{recipient.username}")
  end

  def modify_follow_request
    follow_request = FollowRequest.where({:id => params["id"]})[0]
    follow_request.status = "accepted"
    recipient = User.where({:id => params["query_recipient_id"].to_i})[0]
    follow_request.save

    redirect_to("/users/#{recipient.username}")
  end

  def delete_follow_request
    follow_request = FollowRequest.where({:id => params["id"]})[0]
    recipient = follow_request.recipient
    follow_request.destroy

    redirect_to("/users/#{recipient.username}")
  end 

  def edit_profile
    @user = User.where({:id => session[:current_user_id]})[0]
    render({ :template => "users/editprofile.html.erb" })
  end

  def update
    id = session[:current_user_id]
    user = User.where({ :id => id }).at(0)

    user.email = params["query_email"]
    if (params["query_private"] == nil)
      user.is_private = false
    else 
      user.is_private = true
    end
    user.username = params["query_username"]
    user.password = params["query_password"]
    user.save
    
    redirect_to("/users/#{user.username}")
  end

  def update_small
    id = session[:current_user_id]
    user = User.where({ :id => id }).at(0)

    user.username = params["query_username"]
    if (params["query_private"] == nil)
      user.is_private = false
    else 
      user.is_private = true
    end
    user.save 

    redirect_to("/users/#{user.username}")
  end

end