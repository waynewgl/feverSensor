#encoding: UTF-8
class UserController < ApplicationController
  protect_from_forgery


  def index

    user_post = User.find_by_id(1).posts
    for post in user_post

      logger.info "now we have the post #{post.content}"
    end
  end



  def  dev_pushTest

    content = params[:content].nil? ? "development environment testing":params[:content]
    certificate =   "certificate.pem"
    devicetoken =   "775382506cb9518b407027a1415a415a543238dfe597fbf2a123b13da73ae879"
    environment = "development"
    pushNotification(certificate, devicetoken, environment, content)

  end


  def  pro_pushTest

    content = params[:content].nil? ? "production environment testing":params[:content]
    certificate =   "pro_certificate.pem"
    devicetoken =   "b90818897de3ed29c984c098b4fbfe0ccf6d3b876e9f40556109174475b74b3f"
    environment = "production"
    pushNotification(certificate, devicetoken, environment, content)

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

    注册失败 返回
    {
      code:222
      description:“用户注册失败”
    }

    参数缺少 返回
    {
      code:223
      description:“缺少必须参数”
    }

  EOS

  def register

    msg = Hash.new

    if params[:account].nil? || params[:password].nil?  || params[:token].nil?

      msg[:code] = 233
      msg[:description] = "缺少参数: account 或者 password 或者 token"
      render :json =>  msg.to_json

    else

      new_user = User.new
      new_user.account = params[:account]
      new_user.password = params[:password]
      new_user.token = params[:token]

      if new_user.save

        msg[:code] = 200
        msg[:user_id] = new_user.id
        msg[:description] = "用户注册成功"
        render :json =>  msg.to_json

      else

        msg[:code] = 222
        msg[:description] = "用户注册失败"
        render :json =>  msg.to_json
      end

    end


  end



  def user_login


    render :inline => "login succeed"

    logger.info "received  use account #{params[:username]}  and  password #{params[:password]}"

  end


end
