Rails.application.routes.draw do

  get("/", { :controller => "users", :action => "index" })

  # User routes

  # LOGINS
  get("/user_sign_in", { :controller => "users", :action => "sign_in" })
  get("/user_sign_up", { :controller => "users", :action => "sign_up" })
  get("/user_sign_out", { :controller => "users", :action => "sign_out" })
  get("/verify_credentials", { :controller => "users", :action => "verify_credentials" }) 

  # CREATE
  get("/insert_user", {:controller => "users", :action => "create" })

  # READ
  get("/users", {:controller => "users", :action => "index"})
  get("/users/:the_username", {:controller => "users", :action => "show_own"})
  get("/users/:the_username/liked_photos", {:controller => "users", :action => "show_liked"})
  get("/users/:the_username/feed", {:controller => "users", :action => "show_feed"})
  get("/users/:the_username/discover", {:controller => "users", :action => "show_discover"})

  # UPDATE
  get("/modify_user", {:controller => "users", :action => "update_small" })
  get("/update_user", {:controller => "users", :action => "update" })
  get("/edit_user_profile", {:controller => "users", :action => "edit_profile" })

  # Photo routes

  # CREATE
  get("/insert_photo_record", { :controller => "photos", :action => "create" })

  # READ
  get("/photos", { :controller => "photos", :action => "index"})

  get("/photos/:the_photo_id", { :controller => "photos", :action => "show"})

  # UPDATE
  get("/update_photo/:the_photo_id", { :controller => "photos", :action => "update" })

  # DELETE
  get("/delete_photo/:the_photo_id", { :controller => "photos", :action => "destroy"})

  # Comment routes

  # CREATE
  get("/insert_comment_record", { :controller => "comments", :action => "create" })

  # Like routes

  # CREATE
  get("/insert_like", { :controller => "likes", :action => "create" })

  # DELETE
  get("/delete_like/:like_id", { :controller => "likes", :action => "delete" })

  # Follow request routes
  # CREATE
  get("/insert_follow_request", { :controller => "users", :action => "insert_follow_request" })

  # EDIT
  get("/modify_follow_request/:id", { :controller => "users", :action => "modify_follow_request" })

  # DELETE
  get("/delete_follow_request/:id", { :controller => "users", :action => "delete_follow_request" })

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
