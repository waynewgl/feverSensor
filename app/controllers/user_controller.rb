#encoding: UTF-8
class UserController < ApplicationController
  protect_from_forgery

  include CodeHelper
  def index

    user_post = User.find_by_id(1).posts
    for post in user_post

      logger.info "now we have the post #{post.content}"
    end

    #example    many to many associations         user  - >  fever
    #user = User.find_by_id(5)
    #
    #logger.info "display user fever #{user.fevers}"
    #
    #logger.info "display user symptom #{user.fever_symptoms}"
    #
    #
    #fever = Fever.find_by_id(1)
    #
    #logger.info "display fever users  #{fever.users}"

    user = User.find_by_id(1)
    logger.info "display user favoriate #{user.favoriates}"
    logger.info "display user post #{user.posts}"
    com = Comment.find_by_id(4)
    #render :json =>  com.to_json
    #user = User.find_by_id(5)

    #logger.info "display user fever #{user.fevers}"

    #logger.info "display user symptom #{user.fever_symptoms}"

  end


  api :POST, "/user/dev_pushTest", "测试通知推送服务"

  param :token, String, "用户的设备TOKEN", :required => true

  description <<-EOS

  EOS

  def  dev_pushTest

    deviceToken = params[:token]

    if !params[:host].nil?

      deviceToken = "73df3eb9e0064b59a1d417430070b975f5855d262f81c5c48a1eb26b48f59e3d"
    end

    certificateFile =  "EMTemperature_dev.pem"
    content = params[:content].nil? ? "development environment testing":params[:content]
    certificate =   certificateFile
    devicetoken =   deviceToken
    environment = "development"
    pushNotification(certificate, devicetoken, environment, content)
  end


  def  pro_pushTest

    deviceToken = params[:token]
    certificate_env = "EMTemperature_pro.pem"
    content = params[:content].nil? ? "production environment testing":params[:content]
    certificate =   certificate_env
    devicetoken =   deviceToken
    environment = "production"
    pushNotification(certificate, devicetoken, environment, content)
  end


  api :POST, "/user/register", "注册新用户"
  param :account, String, "用户账户号", :required => true
  param :password, String, "用户密码", :required => true
  param :email, String, "用户邮箱", :required => true
  param :token, String, "用户的设备TOKEN, 手机端必须提供此参数实现通知推送服务", :required => false
  param :nickname, String, "用户昵称", :required => false

  def getUser

    user_post = User.find_by_id(1).posts
    render :json => user_post.to_json
  end

  api :POST, "/user/register", "注册新用户"
  param :account, String, "用户账户号", :required => true
  param :password, String, "用户密码", :required => true
  param :token, String, "用户的设备TOKEN, 手机端必须提供此参数实现通知推送服务", :required => false

  description <<-EOS
    用于注册新用户
    注册成功 返回：
    {
      response: #{CodeHelper.CODE_SUCCESS}
      code: 200
      user_id:1
      description:“成功”
    }

    注册失败 返回
    {
      response:#{CodeHelper.CODE_FAIL}
      code:222
      description:“用户注册失败”
    }

    参数缺少 返回
    {
      response:#{CodeHelper.CODE_MISSING_PARAMS}
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
      return
    else

      user = User.where("account = ? and password = ?", params[:account], Digest::SHA1.hexdigest(params[:password]) ).first

      if user.nil?

        new_user = User.new
        new_user.account = params[:account]
        new_user.password =  Digest::SHA1.hexdigest(params['password'])
        new_user.email = params[:email]
        new_user.nickname = params[:nickname]
        new_user.token = params[:token]

        if new_user.save

          msg[:response] = CodeHelper.CODE_SUCCESS
          msg[:user_id] = new_user.id
          msg[:description] = "用户注册成功"
          render :json =>  msg.to_json

        else

          msg[:response] = CodeHelper.CODE_FAIL
          msg[:description] = "用户注册失败"
          render :json =>  msg.to_json
        end
      else

        msg[:response] = CodeHelper.CODE_FAIL
        msg[:description] = "该用户已经存在，请重新选用其他账号注册"
        render :json =>  msg.to_json
      end
    end

  end


  api :POST, "/user/user_login", "用户登录"
  param :account, String, "用户账户号", :required => true
  param :password, String, "用户密码", :required => true
  param :token, String, "用户的设备TOKEN, 手机端必须提供此参数实现通知推送服务", :required => false

  description <<-EOS
    用于注册新用户
    注册成功 返回：
    {
      code: 200
      user_id:1
      description:“用户登录成功”
    }

    注册失败 返回
    {
      response:#{CodeHelper.CODE_USER_NOT_EXIST}
      code:333
      description:“该用户不存在”
    }

    参数缺少 返回
    {
      response:#{CodeHelper.CODE_MISSING_PARAMS}
      code:223
      description:“缺少必须参数”
    }

  EOS
  def user_login

    msg_userLogin = Hash.new
    if params[:account].nil? || params[:password].nil?

      msg_userLogin[:code] = 233
      msg_userLogin[:description] = "缺少参数: account 或者 password"
      render :json =>  msg_userLogin.to_json
      return
    end

    user = User.where("account = ? and password = ?", params[:account], Digest::SHA1.hexdigest(params[:password]) ).first

    if user.nil?

      msg_userLogin[:response] = CodeHelper.CODE_USER_NOT_EXIST
      msg_userLogin[:user_id] = nil
      msg_userLogin[:description] = "该用户不存在"
      render :json =>  msg_userLogin.to_json
    else
      msg_userLogin[:response] = CodeHelper.CODE_SUCCESS
      msg_userLogin[:user_id] = user.id
      user.update_attribute(:passport_token, user.generate_token)
      msg_userLogin[:passport_token] = user.passport_token
      msg_userLogin[:description] = "登陆成功"
      render :json =>  msg_userLogin.to_json
    end
  end


  api :POST, "/user/getUser", "得到用户信息"

  param :user_id, String, "用户id", :required => true
  param :passport_token, String, "用户令牌，用于操作的身份验证", :required => true

  description <<-EOS
    用于获得用户信息
    上传成功 返回：
    {
      response: #{CodeHelper.CODE_SUCCESS}
      user:{}
      description:“获取用户信息成功”
    }

    passport token不存在或者失效， 返回
    {
      response:#{CodeHelper.CODE_TOKEN_NOT_EXIST}
      description:“用户 passport token 不存在或者失效”
    }

    用户不存在 返回
    {
      response:#{CodeHelper.CODE_USER_NOT_EXIST}
      description:“用户不存在”
    }

    参数缺少 返回
    {
      response:#{CodeHelper.CODE_MISSING_PARAMS}
      description:“缺少必须参数”
    }

  EOS
  def getUser

    msg = Hash.new

    if params[:user_id].nil? || params[:user_id].blank? || params[:passport_token].blank?

      msg[:response] =CodeHelper.CODE_MISSING_PARAMS_USER_ID
      msg[:description] = "需要提供用户id和用户passport_token"
      render :json =>  msg
      return
    end

    user = User.find_by_id(params[:user_id])

    if user.nil?

      msg[:response] = CodeHelper.CODE_USER_NOT_EXIST
      msg[:user_id] = nil
      msg[:description] = "该用户不存在"
      render :json =>  msg.to_json
    else

      if user.passport_token !=  params[:passport_token]

        msg[:response] =CodeHelper.CODE_PASSPORT_TOKEN_NOT_EXIST
        msg[:description] = "用户 passport token 不存在或者失效"
        render :json =>  msg
        return
      end

      respond_to do |format|

        msg[:response] = CodeHelper.CODE_SUCCESS
        msg[:user] = user
        msg[:description] = "获取用户资料成功"

        format.html {
          render :json => msg
        }
        format.json {
          render :json => msg
        }
      end
    end
  end


  api :POST, "/user/upload_avatar_ios", "用户上传头像"

  param :user_id, String, "用户id", :required => true
  param :avatar, String, "用户头像数据", :required => true
  param :passport_token, String, "用户令牌，用于操作的身份验证", :required => true

  description <<-EOS
    用于用户上传头像
    上传成功 返回：
    {
      response: #{CodeHelper.CODE_SUCCESS}
      user_id:1
      image_url:""
      description:“用户上传头像成功”
    }

    上传失败 返回：
    {
      response: #{CodeHelper.CODE_FAIL}
      description:“用户上传头像失败”
    }

    passport token不存在或者失效， 返回
    {
      response:#{CodeHelper.CODE_TOKEN_NOT_EXIST}
      description:“用户 passport token 不存在或者失效”
    }

    用户不存在 返回
    {
      response:#{CodeHelper.CODE_USER_NOT_EXIST}
      description:“用户不存在，无法上传头像”
    }

    参数缺少 返回
    {
      response:#{CodeHelper.CODE_MISSING_PARAMS}
      description:“缺少必须参数”
    }

  EOS
  def upload_avatar_ios

    msg = Hash.new

    if params[:avatar].nil? || params[:user_id].blank? || params[:passport_token].blank?

      msg[:response] = CodeHelper.CODE_MISSING_PARAMS
      msg[:description] = "缺少必要参数"
      render :json =>  msg
      return
    else

      @user = User.find_by_id(params[:user_id])

      if @user.nil?

        msg[:response] =CodeHelper.CODE_USER_NOT_EXIST
        msg[:description] = "用户不存在"
        render :json =>  msg
        return
      else

        if @user.passport_token !=  params[:passport_token]

          msg[:response] =CodeHelper.CODE_TOKEN_NOT_EXIST
          msg[:description] = "用户 passport token 不存在或者失效"
          render :json =>  msg
          return
        end

        if @user.update_attributes(:avatar => params[:avatar])

          render :json =>  @user
          return
        else

          msg[:response] =CodeHelper.CODE_FAIL
          msg[:description] = "用户上传头像失败"
          render :json =>  msg
          return
        end
      end

    end

  end


  api :POST, "/user/userFavoriatePost", "用户收藏帖子"

  param :user_id, String, "用户id", :required => true
  param :post_id, String, "帖子id", :required => true
  param :passport_token, String, "用户令牌，用于操作的身份验证", :required => true

  description <<-EOS
    用于用户收藏帖子
    收藏成功 返回：
    {
      response: #{CodeHelper.CODE_SUCCESS}
      user_id:1
      image_url:""
      description:“用户收藏帖子成功”
    }

    上传失败 返回：
    {
      response: #{CodeHelper.CODE_FAIL}
      description:“用户收藏帖子失败”
    }

    passport token不存在或者失效， 返回
    {
      response:#{CodeHelper.CODE_TOKEN_NOT_EXIST}
      description:“用户 passport token 不存在或者失效”
    }

    用户不存在 返回
    {
      response:#{CodeHelper.CODE_USER_NOT_EXIST}
      description:“用户不存在”
    }

    参数缺少 返回
    {
      response:#{CodeHelper.CODE_MISSING_PARAMS}
      description:“缺少必须参数”
    }

  EOS
  def userFavoriatePost

     msg = Hash.new

     if  params[:user_id].blank? ||  params[:post_id].blank? || params[:passport_token].blank?

       msg[:response] =CodeHelper.CODE_MISSING_PARAMS
       msg[:description] = "缺少必要参数， i.e.  user_id 或者 post_id"
       render :json =>  msg
       return
     else

        user = User.find_by_id(params[:user_id])

        if user.nil?

          msg[:response] =CodeHelper.CODE_USER_NOT_EXIST
          msg[:description] = "该用户不存在"
          render :json =>  msg
          return
        end

        if user.passport_token !=  params[:passport_token]

          msg[:response] =CodeHelper.CODE_TOKEN_NOT_EXIST
          msg[:description] = "用户 passport token 不存在或者失效"
          render :json =>  msg
          return
        end

        fav = Favoriate.where(user_id: params[:user_id], post_id: params[:post_id])
        if  fav.count > 0
          msg[:response] =CodeHelper.CODE_FAIL
          msg[:description] = "你已经收藏此帖子"
          render :json =>  msg
          return
        end
     end


     fav = Favoriate.new
     fav.user_id = params[:user_id]
     fav.post_id = params[:post_id]

     if fav.save

       msg[:response] =CodeHelper.CODE_SUCCESS
       msg[:description] = "收藏成功"
       msg[:fav_id] = fav.id
       render :json =>  msg
       return
     else

       msg[:response] =CodeHelper.CODE_FAIL
       msg[:description] = "收藏失败"
       render :json =>  msg
       return
     end

  end



  api :POST, "/user/updateProfile", "用户更新资料"

  param :user_id, String, "用户id", :required => true
  param :firstName, String, "用户名", :required => false
  param :lastName, String, "用户姓氏", :required => false
  param :credits, String, "用户金币", :required => false
  param :age, String, "用户年龄", :required => false
  param :level, String, "用户等级", :required => false
  param :recent_login, String, "用户最近登录", :required => false
  param :email, String, "用户邮箱", :required => false
  param :mobile, String, "用户手机号码", :required => true
  param :nickname, String, "用户昵称", :required => false
  param :sex, String, "用户性别", :required => false
  param :mood, String, "用户情绪", :required => false
  param :passport_token, String, "用户令牌，用于操作的身份验证", :required => true

  description <<-EOS
    用于用户更新资料
    收藏成功 返回：
    {
      response: #{CodeHelper.CODE_SUCCESS}
      user_id:1
      description:“用户更新资料成功”
    }

    更新失败 返回：
    {
      response: #{CodeHelper.CODE_FAIL}
      description:“用户更新资料失败”
    }

    passport token不存在或者失效， 返回
    {
      response:#{CodeHelper.CODE_TOKEN_NOT_EXIST}
      description:“用户 passport token 不存在或者失效”
    }

    用户不存在 返回
    {
      response:#{CodeHelper.CODE_USER_NOT_EXIST}
      description:“用户不存在，无法更新”
    }

    参数缺少 返回
    {
      response:#{CodeHelper.CODE_MISSING_PARAMS}
      description:“缺少必须参数”
    }

  EOS
  def updateProfile

    msg = Hash.new

    if params[:user_id].nil? || params[:user_id].blank?  || params[:passport_token].blank?

      msg[:response] =CodeHelper.CODE_MISSING_PARAMS
      msg[:description] = "需要提供user id 和 passport token"
      render :json =>  msg
      return
    end

    userUpdate = User.find_by_id(params[:user_id])

    if userUpdate.nil?

      msg[:response] =CodeHelper.CODE_USER_NOT_EXIST
      msg[:description] = "该用户不存在"
      render :json =>  msg
      return
    end

    logger.debug "do we get user passport token compare #{params[:passport_token]} with #{ userUpdate.passport_token} "

    if userUpdate.passport_token !=  params[:passport_token]

      msg[:response] =CodeHelper.CODE_TOKEN_NOT_EXIST
      msg[:description] = "用户 passport token 不存在或者失效"
      render :json =>  msg
      return
    end

    userUpdate.mood = params[:mood].blank? ? " ": params[:mood]
    userUpdate.sex = params[:sex].blank? ? " ": params[:sex]
    userUpdate.nickname = params[:nickname].blank? ? " ": params[:nickname]
    userUpdate.mobile = params[:mobile].blank? ? " ": params[:mobile]
    userUpdate.email = params[:email].blank? ? " ": params[:email]
    userUpdate.recent_login = params[:recent_login].blank? ? " ": params[:recent_login]
    userUpdate.level = params[:level].blank? ? " ": params[:level]
    userUpdate.age = params[:age].blank? ? " ": params[:age]
    userUpdate.credits = params[:credits].blank? ? " ": params[:credits]
    userUpdate.firstName = params[:firstName].blank? ? " ": params[:firstName]
    userUpdate.lastName = params[:lastName].blank? ? " ": params[:lastName]

    if userUpdate.save

      msg[:response] =CodeHelper.CODE_SUCCESS
      msg[:description] = "更新用户信息成功"
      render :json =>  msg
      return
    else

      msg[:response] =CodeHelper.CODE_FAIL
      msg[:description] = "更新用户信息失败"
      render :json =>  msg
      return
    end
  end


  api :POST, "/user/followUser", "用户关注某用户"

  param :user_id, String, "用户id", :required => true
  param :follower_id, String, "用户关注的用户ID", :required => true
  param :passport_token, String, "用户令牌，用于操作的身份验证", :required => true

  description <<-EOS
    用于用户添加关注
    收藏成功 返回：
    {
      response: #{CodeHelper.CODE_SUCCESS}
      user_id:1
      description:“用户关注成功”
    }

    更新失败 返回：
    {
      response: #{CodeHelper.CODE_FAIL}
      description:“用户关注失败”
    }

    passport token不存在或者失效， 返回
    {
      response:#{CodeHelper.CODE_TOKEN_NOT_EXIST}
      description:“用户 passport token 不存在或者失效”
    }

    用户不存在 返回
    {
      response:#{CodeHelper.CODE_USER_NOT_EXIST}
      description:“用户不存在，无法关注”
    }

    参数缺少 返回
    {
      response:#{CodeHelper.CODE_MISSING_PARAMS}
      description:“缺少必须参数”
    }

  EOS
  def followUser

    msg = Hash.new

    if params[:user_id].nil? || params[:user_id].blank? || params[:passport_token].blank?

      msg[:response] =CodeHelper.CODE_MISSING_PARAMS_USER_ID
      msg[:description] = "需要提供user id"
      render :json =>  msg
      return
    end

    user = User.find_by_id(params[:user_id])

    if user.nil?

      msg[:response] =CodeHelper.CODE_USER_NOT_EXIST
      msg[:description] = "该用户不存在"
      render :json =>  msg
      return
    else

      if user.passport_token !=  params[:passport_token]

        msg[:response] =CodeHelper.CODE_TOKEN_NOT_EXIST
        msg[:description] = "用户 passport token 不存在或者失效"
        render :json =>  msg
        return
      end
    end

    if params[:follower_id].nil? || params[:follower_id].blank?

      msg[:response] =CodeHelper.CODE_MISSING_PARAMS
      msg[:description] = "需要提供follower id"
      render :json =>  msg
      return
    end

    checkFollower =  Follower.where("user_id = ? AND follower_id = ?", params[:user_id], params[:follower_id])

    if  !checkFollower.nil?

      msg[:response] =CodeHelper.CODE_FAIL
      msg[:description] = "你已经关注该用户"
      render :json =>  msg
      return
    end

    newFollow = Follower.new
    newFollow.user_id = params[:user_id]
    newFollow.follower_id = params[:follower_id]

    if newFollow.save

      msg[:response] =CodeHelper.CODE_SUCCESS
      msg[:description] = "关注成功"
      render :json =>  msg
      return
    else

      msg[:response] =CodeHelper.CODE_FAIL
      msg[:description] = "关注失败"
      render :json =>  msg
      return
    end
  end


  api :POST, "/user/cancelFollowUser", "用户取消关注某用户"

  param :user_id, String, "用户id", :required => true
  param :follower_id, String, "用户关注的用户ID", :required => true
  param :passport_token, String, "用户令牌，用于操作的身份验证", :required => true

  description <<-EOS
    用于取消用户关注
    收藏成功 返回：
    {
      response: #{CodeHelper.CODE_SUCCESS}
      user_id:1
      description:“取消用户关注成功”
    }

    更新失败 返回：
    {
      response: #{CodeHelper.CODE_FAIL}
      description:“用户取消关注失败”
    }

    passport token 不存在或者失效， 返回
    {
      response:#{CodeHelper.CODE_TOKEN_NOT_EXIST}
      description:“用户 passport token 不存在或者失效”
    }

    用户不存在 返回
    {
      response:#{CodeHelper.CODE_USER_NOT_EXIST}
      description:“用户不存在，无法取消关注”
    }

    参数缺少 返回
    {
      response:#{CodeHelper.CODE_MISSING_PARAMS}
      description:“缺少必须参数”
    }

  EOS
  def cancelFollowUser

    msg = Hash.new

    if params[:user_id].nil? || params[:user_id].blank?  || params[:passport_token].blank?

      msg[:response] =CodeHelper.CODE_MISSING_PARAMS_USER_ID
      msg[:description] = "需要提供user id"
      render :json =>  msg
      return
    end

    user = User.find_by_id(params[:user_id])

    if user.nil?

      msg[:response] =CodeHelper.CODE_USER_NOT_EXIST
      msg[:description] = "该用户不存在"
      render :json =>  msg
      return
    else

      if user.passport_token !=  params[:passport_token]

        msg[:response] =CodeHelper.CODE_TOKEN_NOT_EXIST
        msg[:description] = "用户 passport token 不存在或者失效"
        render :json =>  msg
        return
      end
    end

    if params[:follower_id].nil? || params[:follower_id].blank?

      msg[:response] =CodeHelper.CODE_MISSING_PARAMS
      msg[:description] = "需要提供follower id"
      render :json =>  msg
      return
    end

    removeFollow = Follower.delete_all(["user_id = ? AND follower_id = ?", params[:user_id], params[:follower_id]])
    if removeFollow != 0

      msg[:response] =CodeHelper.CODE_SUCCESS
      msg[:description] = "取消关注成功"
      render :json =>  msg
      return
    else

      msg[:response] =CodeHelper.CODE_FAIL
      msg[:description] = "取消关注失败，可能不存在该记录"
      render :json =>  msg
      return
    end

  end


  api :POST, "/user/blackList", "用户添加黑名单用户"

  param :user_id, String, "用户id", :required => true
  param :block_user_id, String, "用户加入黑名单的用户ID", :required => true
  param :passport_token, String, "用户令牌，用于操作的身份验证", :required => true

  description <<-EOS
    用于添加用户入黑名单
    添加成功 返回：
    {
      response: #{CodeHelper.CODE_SUCCESS}
      user_id:1
      description:“添加用户入黑名单成功”
    }

    更新失败 返回：
    {
      response: #{CodeHelper.CODE_FAIL}
      description:“添加用户入黑名单失败”
    }

    passport token 不存在或者失效， 返回
    {
      response:#{CodeHelper.CODE_TOKEN_NOT_EXIST}
      description:“用户 passport token 不存在或者失效”
    }

    用户不存在 返回
    {
      response:#{CodeHelper.CODE_USER_NOT_EXIST}
      description:“用户不存在，无法添加黑名单关注”
    }

    参数缺少 返回
    {
      response:#{CodeHelper.CODE_MISSING_PARAMS}
      description:“缺少必须参数”
    }

  EOS
  def blackList

    msg = Hash.new

    if params[:user_id].nil? || params[:user_id].blank?  || params[:passport_token].blank?

      msg[:response] =CodeHelper.CODE_MISSING_PARAMS_USER_ID
      msg[:description] = "需要提供user id"
      render :json =>  msg
      return
    end

    user = User.find_by_id(params[:user_id])

    if user.nil?

      msg[:response] =CodeHelper.CODE_USER_NOT_EXIST
      msg[:description] = "该用户不存在"
      render :json =>  msg
      return
    else

      if user.passport_token !=  params[:passport_token]

        msg[:response] =CodeHelper.CODE_TOKEN_NOT_EXIST
        msg[:description] = "用户 passport token 不存在或者失效"
        render :json =>  msg
        return
      end
    end

    if params[:block_user_id].nil? || params[:block_user_id].blank?

      msg[:response] =CodeHelper.CODE_MISSING_PARAMS_USER_ID
      msg[:description] = "需要提供黑名单的用户 id"
      render :json =>  msg
      return
    end

    blockUser = BlackList.new
    blockUser.user_id = params[:user_id]
    blockUser.block_user_id = params[:block_user_id]

    if blockUser.save

      msg[:response] =CodeHelper.CODE_SUCCESS
      msg[:description] = "添加用户到黑名单成功"
      render :json =>  msg
      return
    else

      msg[:response] =CodeHelper.CODE_FAIL
      msg[:description] = "添加用户到黑名单失败"
      render :json =>  msg
      return
    end
  end

  api :POST, "/user/removeBlackList", "用户取消黑名单用户"

  param :user_id, String, "用户id", :required => true
  param :block_user_id, String, "用户加入黑名单的用户ID", :required => true
  param :passport_token, String, "用户令牌，用于操作的身份验证", :required => true

  description <<-EOS
    用于取消黑名单中的某一用户
    取消成功 返回：
    {
      response: #{CodeHelper.CODE_SUCCESS}
      user_id:1
      description:“取消黑名单中用户成功”
    }

    更新失败 返回：
    {
      response: #{CodeHelper.CODE_FAIL}
      description:“取消黑名单中用户成功失败”
    }

    passport token不存在或者失效， 返回
    {
      response:#{CodeHelper.CODE_TOKEN_NOT_EXIST}
      description:“用户 passport token 不存在或者失效”
    }

    用户不存在 返回
    {
      response:#{CodeHelper.CODE_USER_NOT_EXIST}
      description:“用户不存在，取消黑名单中用户”
    }

    参数缺少 返回
    {
      response:#{CodeHelper.CODE_MISSING_PARAMS}
      description:“缺少必须参数”
    }

  EOS
  def removeBlackList

    msg = Hash.new

    if params[:user_id].nil? || params[:user_id].blank?  || params[:passport_token].blank?

      msg[:response] =CodeHelper.CODE_MISSING_PARAMS_USER_ID
      msg[:description] = "需要提供user id和passport token"
      render :json =>  msg
      return
    end

    if params[:block_user_id].nil? || params[:block_user_id].blank?

      msg[:response] =CodeHelper.CODE_MISSING_PARAMS_USER_ID
      msg[:description] = "需要提供黑名单的用户 id"
      render :json =>  msg
      return
    end

    user = User.find_by_id(params[:user_id])

    if user.nil?

      msg[:response] =CodeHelper.CODE_USER_NOT_EXIST
      msg[:description] = "该用户不存在"
      render :json =>  msg
      return
    else

      if user.passport_token !=  params[:passport_token]

        msg[:response] =CodeHelper.CODE_TOKEN_NOT_EXIST
        msg[:description] = "用户 passport token 不存在或者失效"
        render :json =>  msg
        return
      end
    end

    removeBlockUser = BlackList.delete_all(["user_id = ? AND block_user_id = ?", params[:user_id], params[:block_user_id]])

    if removeBlockUser != 0

      msg[:response] =CodeHelper.CODE_SUCCESS
      msg[:description] = "移除黑名单用户成功"
      render :json =>  msg
      return
    else

      msg[:response] =CodeHelper.CODE_FAIL
      msg[:description] = "移除黑名单用户失败, 用户ID 或者 黑名单用户ID 不匹配"
      render :json =>  msg
      return
    end
  end


  api :POST, "/user/updateLocation", "用户更新当前位置"

  param :user_id, String, "用户id", :required => true
  param :latitude, String, "用户id", :required => true
  param :longitude, String, "用户id", :required => true
  param :passport_token, String, "用户令牌，用于操作的身份验证", :required => true


  description <<-EOS
    用户更新当前位置
    更新成功 返回：
    {
      response: #{CodeHelper.CODE_SUCCESS}
      description:“更新位置成功”
    }

    更新失败 返回：
    {
      response: #{CodeHelper.CODE_FAIL}
      description:“更新位置失败”
    }

    passport token不存在或者失效， 返回
    {
      response:#{CodeHelper.CODE_TOKEN_NOT_EXIST}
      description:“用户 passport token 不存在或者失效”
    }

    用户不存在 返回
    {
      response:#{CodeHelper.CODE_USER_NOT_EXIST}
      description:“用户不存在，无法更新”
    }

    参数缺少 返回
    {
      response:#{CodeHelper.CODE_MISSING_PARAMS}
      description:“缺少必须参数”
    }

  EOS
  def updateLocation

    msg = Hash.new

    if params[:user_id].nil? || params[:user_id].blank?

      msg[:response] =CodeHelper.CODE_MISSING_PARAMS_USER_ID
      msg[:description] = "需要提供user id"
      render :json =>  msg
      return
    end

    if params[:latitude].blank? || params[:longitude].blank?

      msg[:response] =CodeHelper.CODE_MISSING_PARAMS
      msg[:description] = "需要提供用户的当前地点"
      render :json =>  msg
      return
    end

    user = User.find_by_id(params[:user_id])

    if user.nil?

      msg[:response] =CodeHelper.CODE_USER_NOT_EXIST
      msg[:description] = "该用户不存在"
      render :json =>  msg
      return
    else

      if user.passport_token !=  params[:passport_token]

        msg[:response] =CodeHelper.CODE_TOKEN_NOT_EXIST
        msg[:description] = "用户 passport token 不存在或者失效"
        render :json =>  msg
        return
      end
    end

    location = Location.new
    location.latitude = params[:latitude]
    location.longitude = params[:longitude]

    if location.save

      msg[:response] =CodeHelper.CODE_SUCCESS
      msg[:description] = "用户更新位置成功"
      render :json =>  msg
      return
    else

      msg[:response] =CodeHelper.CODE_MISSING_PARAMS
      msg[:description] = "用户更新位置失败"
      render :json =>  msg
      return
    end
  end


  api :POST, "/user/userNickname", "用户查询，添加，修改其他用户昵称"

  param :user_id, String, "用户id", :required => true
  param :nick_user_id, String, "需要为其修改昵称的用户id", :required => true
  param :nickname, String, "用户想要修改的昵称， 未指定该参数，仅为查询", :required => false
  param :type, String, "edit  和 add , 作为修改或者添加昵称 操作, 未指定该参数，仅为查询", :required => false
  param :passport_token, String, "用户令牌，用于操作的身份验证", :required => true

  description <<-EOS
    用户查询，添加，修改其他用户昵称
    操作成功 返回：
    {
      response: #{CodeHelper.CODE_SUCCESS}
      description:“添加或者修改昵称成功”
    }

    操作失败 返回：
    {
      response: #{CodeHelper.CODE_FAIL}
      description:“更新或者添加昵称失败”
    }

    passport token不存在或者失效， 返回
    {
      response:#{CodeHelper.CODE_TOKEN_NOT_EXIST}
      description:“用户 passport token 不存在或者失效”
    }

    用户昵称不存在 返回
    {
      response:#{CodeHelper.CODE_USER_NOT_EXIST}
      description:“昵称不存在，无法更新”
    }

    参数缺少 返回
    {
      response:#{CodeHelper.CODE_MISSING_PARAMS}
      description:“缺少必须参数”
    }

  EOS
  def userNickname

    msg = Hash.new

    if params[:user_id].nil? || params[:user_id].blank?

      msg[:response] =CodeHelper.CODE_MISSING_PARAMS_USER_ID
      msg[:description] = "需要提供user id"
      render :json =>  msg
      return
    end

    user = User.find_by_id(params[:user_id])

    if user.nil?

      msg[:response] =CodeHelper.CODE_USER_NOT_EXIST
      msg[:description] = "该用户不存在"
      render :json =>  msg
      return
    else

      if user.passport_token !=  params[:passport_token]

        msg[:response] =CodeHelper.CODE_TOKEN_NOT_EXIST
        msg[:description] = "用户 passport token 不存在或者失效"
        render :json =>  msg
        return
      end
    end


    if params[:nick_user_id].nil? || params[:nick_user_id].blank?

      msg[:response] =CodeHelper.CODE_MISSING_PARAMS_USER_ID
      msg[:description] = "需要提供 nick_user_id"
      render :json =>  msg
      return
    end

    nickName = Nickname.where("user_id = ? and nick_user_id = ?",params[:user_id], params[:nick_user_id]).first

    if nickName.nil?

      if !params[:nickname].nil? && !params[:nickname].blank? && params[:type] = "add"

        newNickName = Nickname.new
        newNickName.user_id = params[:user_id]
        newNickName.nick_user_id = params[:nick_user_id]
        newNickName.nickname = params[:nickname]

        if newNickName.save

          msg[:response] =CodeHelper.CODE_SUCCESS
          msg[:nickName] = newNickName
          msg[:description] = "添加昵称成功"
          render :json =>  msg
          return
        else

          msg[:response] =CodeHelper.CODE_FAIL
          msg[:description] = "添加昵称失败"
          render :json =>  msg
          return
        end
      end

      msg[:response] =CodeHelper.CODE_SUCCESS
      msg[:nickName] = nickName
      msg[:description] = "返回昵称失败"
      render :json =>  msg
      return

    else

      if !params[:nickname].nil? && !params[:nickname].blank? && params[:type] = "edit"

        nickName.nickname = params[:nickname]

        if nickName.save

          msg[:response] =CodeHelper.CODE_SUCCESS
          msg[:nickName] = nickName
          msg[:description] = "修改昵称成功"
          render :json =>  msg
          return
        else

          msg[:response] =CodeHelper.CODE_FAIL
          msg[:nickName] = nickName
          msg[:description] = "修改昵称失败"
          render :json =>  msg
          return
        end
      end

      msg[:response] =CodeHelper.CODE_SUCCESS
      msg[:nickName] = nickName
      msg[:description] = "返回昵称成功"
      render :json =>  msg
      return
    end

  end
end
