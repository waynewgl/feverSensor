#encoding: UTF-8
class UserController < ApplicationController
  protect_from_forgery


  def index


    user_post = User.find_by_id(1).posts


    for post in user_post

      logger.info "now we have the post #{post.content}"

    end

  end


  def show

    user = User.find_by_id(params[:id])

    if user

      post = user.posts
      render :json => post.to_json
    else

      message = Hash.new
      message[:code] = "222"
      message[:description] = "找不到该用户"
      render :json => message.to_json
    end

  end


  def getUser


    user_post = User.find_by_id(1).posts

    render :json => user_post.to_json
  end



  api :POST, "/user/register", "注册新用户"
  param :account, String, "用户账户号", :required => true
  param :password, String, "用户密码", :required => true
  param :token, String, "用户的设备TOKEN", :required => true

  description <<-EOS
    用于注册新用户
    注册成功 返回：
    {
      code: 200
      user_id:1
      description:“成功”
    }

    否则返回
    {
      code:222
      description:“用户注册失败”
    }
  EOS

  def register



  end



  def user_login


    render :inline => "login succeed"

    logger.info "received  use account #{params[:username]}  and  password #{params[:password]}"

  end


end
