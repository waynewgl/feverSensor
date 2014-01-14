class MainController < ApplicationController
  protect_from_forgery


  def index


    user_post = User.find_by_id(1).posts


    for post in user_post

      logger.info "now we have the post #{post.content}"

    end

  end


  def getUser


    user_post = User.find_by_id(1).posts

    render :json => user_post.to_json
  end

  def user_login


    render :inline => "login succeed"

    logger.info "received  use account #{params[:username]}  and  password #{params[:password]}"

  end


end
