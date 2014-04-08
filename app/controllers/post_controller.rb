#encoding: UTF-8
class PostController < ApplicationController
  protect_from_forgery

  include CodeHelper

  api :GET, "/post/listUserPosts", "根据用户ID， 返回用户发的帖子"
  param :user_id, String, "用户id", :required => true
  param :passport_token, String, "用户令牌，用于操作的身份验证", :required => true

  description <<-EOS
    用于注册新用户
    返回成功 返回：
    {
      response: #{CodeHelper.CODE_SUCCESS}
      post: {}
      description:“成功”
    }

    passport token不存在或者失效， 返回
    {
      response:#{CodeHelper.CODE_TOKEN_NOT_EXIST}
      description:“用户 passport token 不存在或者失效”
    }

    返回失败 返回
    {
      response:#{CodeHelper.CODE_FAIL}
      description:“获取帖子失败”
    }

    参数缺少 返回
    {
      response:#{CodeHelper.CODE_MISSING_PARAMS}
      description:“缺少必须参数”
    }

  EOS
  def listUserPosts

    msg = Hash.new

    if !params[:user_id].nil? && !params[:user_id].blank?

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

      post = user.posts
      msg[:response] = CodeHelper.CODE_SUCCESS
      msg[:posts] = post
      msg[:description] = "成功"
      render :json =>  msg
      return
    else

        msg[:response] = CodeHelper.CODE_MISSING_PARAMS
        msg[:description] = "user id缺失"
        render :json =>  msg
        return
    end

  end



  api :GET, "/post/listPostComments", "根据帖子id， 返回帖子的相关回复"
  param :user_id, String, "用户id", :required => true
  param :post_id, String, "帖子id", :required => true
  param :passport_token, String, "用户令牌，用于操作的身份验证", :required => true

  description <<-EOS
    用于获得帖子相关图片
    返回成功 返回：
    {
      response: #{CodeHelper.CODE_SUCCESS}
      post: {}
      description:“成功”
    }

    passport token不存在或者失效， 返回
    {
      response:#{CodeHelper.CODE_TOKEN_NOT_EXIST}
      description:“用户 passport token 不存在或者失效”
    }

    返回失败 返回
    {
      response:#{CodeHelper.CODE_FAIL}
      description:“获取帖子回复失败”
    }

    参数缺少 返回
    {
      response:#{CodeHelper.CODE_MISSING_PARAMS}
      description:“缺少必须参数”
    }

  EOS
  def listPostComments

    msg = Hash.new

    if !params[:user_id].nil? && !params[:user_id].blank?

      user = User.find_by_id(params[:user_id])

      if user.nil?

        msg[:response] =CodeHelper.CODE_USER_NOT_EXIST
        msg[:description] = "操作无效，用户不存在"
        render :json =>  msg
        return
      end

      if user.passport_token !=  params[:passport_token]

        msg[:response] =CodeHelper.CODE_TOKEN_NOT_EXIST
        msg[:description] = "用户 passport token 不存在或者失效"
        render :json =>  msg
        return
      end

      if params[:post_id].nil? || params[:post_id].blank?

        msg[:response] =CodeHelper.CODE_FAIL
        msg[:description] = "需提供帖子id"
        render :json =>  msg
        return
      else

        post = Post.find_by_id(params[:post_id])

        if post.nil?

          msg[:response] =CodeHelper.CODE_FAIL
          msg[:description] = "帖子不存在"
          render :json =>  msg
          return
        else

          msg[:response] =CodeHelper.CODE_SUCCESS
          msg[:comment] = post.comments
          msg[:description] = "返回帖子回复成功"
          render :json =>  msg
          return
        end
      end
    else

      msg[:response] = CodeHelper.CODE_MISSING_PARAMS
      msg[:description] = "user id缺失"
      render :json =>  msg
      return
    end
  end


  api :POST, "/post/createPost", "用户发布新的帖子"
  param :user_id, String, "用户id", :required => true
  param :title, String, "帖子主题", :required => true
  param :content, String, "帖子内容", :required => true
  param :author, String, "帖子作者", :required => false
  param :date , String, "帖子发布日期", :required => false
  param :passport_token, String, "用户令牌，用于操作的身份验证", :required => true

  description <<-EOS
    发布新的帖子
    返回成功 返回：
    {
      response: #{CodeHelper.CODE_SUCCESS}
      post_id: {}
      description:“成功”
    }

    passport token不存在或者失效， 返回
    {
      response:#{CodeHelper.CODE_TOKEN_NOT_EXIST}
      description:“用户 passport token 不存在或者失效”
    }

    返回失败 返回
    {
      response:#{CodeHelper.CODE_FAIL}
      description:“发布帖子失败”
    }

    参数缺少 返回
    {
      response:#{CodeHelper.CODE_MISSING_PARAMS}
      description:“缺少必须参数”
    }

  EOS
  def createPost

      msg = Hash.new

      if params[:user_id].nil? || params[:user_id].blank?

        msg[:response] = CodeHelper.CODE_MISSING_PARAMS
        msg[:description] = "user id缺失"
        render :json =>  msg
        return
      end

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

      if params[:title].blank?  || params[:content].blank?

        msg[:response] = CodeHelper.CODE_MISSING_PARAMS
        msg[:description] = "帖子主题 或者 内容不能为空"
        render :json =>  msg
        return
      end

      newPost = Post.new
      newPost.user_id = params[:user_id].blank? ? " ": params[:user_id]
      newPost.title = params[:title].blank? ? " ": params[:title]
      newPost.content = params[:content].blank? ? " ": params[:content]
      newPost.date = params[:date].blank? ? " ": params[:date]
      newPost.author = params[:author].blank? ? " ": params[:author]

      if newPost.save

        msg[:response] = CodeHelper.CODE_SUCCESS
        msg[:post_id] = newPost.id
        msg[:description] = "成功"
        render :json =>  msg
        return
      else

        msg[:response] = CodeHelper.CODE_FAIL
        msg[:description] = "发布帖子失败"
        render :json =>  msg
        return
      end
  end


  api :GET, "/post/getSpecificPost", "根据帖子id返回帖子"
  param :post_id, String, "帖子id", :required => true
  param :passport_token, String, "用户令牌，用于操作的身份验证", :required => true
  param :user_id, String, "用户id", :required => true

  description <<-EOS
    发布新的帖子
    返回成功 返回：
    {
      response: #{CodeHelper.CODE_SUCCESS}
      post: {}
      description:“成功”
    }

    passport token不存在或者失效， 返回
    {
      response:#{CodeHelper.CODE_TOKEN_NOT_EXIST}
      description:“用户 passport token 不存在或者失效”
    }

    返回失败 返回
    {
      response:#{CodeHelper.CODE_FAIL}
      description:“发布帖子失败”
    }

    参数缺少 返回
    {
      response:#{CodeHelper.CODE_MISSING_PARAMS}
      description:“缺少必须参数”
    }

  EOS
  def getSpecificPost

      msg = Hash.new

      if params[:user_id].nil? || params[:user_id].blank?

        msg[:response] = CodeHelper.CODE_MISSING_PARAMS
        msg[:description] = "user id缺失"
        render :json =>  msg
        return
      end

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

      if params[:post_id].nil? || params[:post_id].blank?

        msg[:response] = CodeHelper.CODE_MISSING_PARAMS
        msg[:description] = "需要提供帖子id"
        render :json =>  msg
        return

      else

        post = post.find_by_id(params[:post_id])
        msg[:response] = CodeHelper.CODE_SUCCESS
        msg[:post] = post
        msg[:description] = "返回帖子成功"
        render :json =>  msg
        return
     end
  end


  api :GET, "/post/searchPost", "根据搜索关键词返回帖子"
  param :user_id, String, "用户id", :required => true
  param :searchKey, String, "搜索关键词", :required => true
  param :passport_token, String, "用户令牌，用于操作的身份验证", :required => true

  description <<-EOS
    发布新的帖子
    返回成功 返回：
    {
      response: #{CodeHelper.CODE_SUCCESS}
      post: {}
      description:“成功”
    }

    passport token不存在或者失效， 返回
    {
      response:#{CodeHelper.CODE_TOKEN_NOT_EXIST}
      description:“用户 passport token 不存在或者失效”
    }

    返回失败 返回
    {
      response:#{CodeHelper.CODE_FAIL}
      description:“发布帖子失败”
    }

    参数缺少 返回
    {
      response:#{CodeHelper.CODE_MISSING_PARAMS}
      description:“缺少必须参数”
    }

  EOS
  def searchPost

    msg = Hash.new

    if params[:user_id].blank? || params[:user_id].nil?

      msg[:response] = CodeHelper.CODE_MISSING_PARAMS
      msg[:post] = nil
      msg[:description] = "需要提供用户ID"
      render :json =>  msg
      return
    end

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

    if params[:searchKey].blank? || params[:searchKey].nil?

      msg[:response] = CodeHelper.CODE_MISSING_PARAMS
      msg[:post] = nil
      msg[:description] = "需要提供搜索关键词"
      render :json =>  msg
      return
    else

      post_search = Post.where("content like ? or title like ?", "%#{params[:searchKey]}%", "%#{params[:searchKey]}%").all
      msg[:response] = CodeHelper.CODE_SUCCESS

      if post_search.count > 0

        msg[:posts] = post_search
        msg[:description] = "搜索成功"
      else

        msg[:posts] = nil
        msg[:description] = "没有相关帖子"
      end
      render :json =>  msg
      return
    end
  end


  api :POST, "/post/addAttachment", "添加帖子附件"
  param :user_id, String, "用户id", :required => true
  param :post_id, String, "帖子ID", :required => true
  param :image, String, "图片数据", :required => true
  param :passport_token, String, "用户令牌，用于操作的身份验证", :required => true

  description <<-EOS
    发布新的帖子附件
    返回成功 返回：
    {
      response: #{CodeHelper.CODE_SUCCESS}
      description:“成功”
    }

    返回失败 返回
    {
      response:#{CodeHelper.CODE_FAIL}
      description:“上传附件失败”
    }

    passport token不存在或者失效， 返回
    {
      response:#{CodeHelper.CODE_TOKEN_NOT_EXIST}
      description:“用户 passport token 不存在或者失效”
    }

    参数缺少 返回
    {
      response:#{CodeHelper.CODE_MISSING_PARAMS}
      description:“缺少必须参数”
    }

  EOS
  def addAttachment

    msg = Hash.new
    if params[:post_id].nil? || params[:post_id].blank?

      msg[:response] = CodeHelper.CODE_MISSING_PARAMS_POST_ID
      msg[:description] = "缺失 post id "
      render :json =>  msg
      return
    end

    if params[:user_id].nil? || params[:user_id].blank?

      msg[:response] = CodeHelper.CODE_MISSING_PARAMS_USER_ID
      msg[:description] = "缺失 user id "
      render :json =>  msg
      return
    end

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

    if params[:image].nil? || params[:image].blank?

      msg[:response] = CodeHelper.CODE_MISSING_PARAMS
      msg[:description] = "请上传图片"
      render :json =>  msg
      return
    else

      attach = PostAttachment.new
      attach.post_id = params[:post_id]
      attach.update_attributes(:image => params[:image])
      attach.note = params[:note]

      if attach.save

        msg[:response] = CodeHelper.CODE_SUCCESS
        msg[:id]= attach.id
        msg[:description] = "上传成功"
        render :json =>  msg
        return
      end
    end
  end

  api :POST, "/post/deleteAttachment", "删除帖子附件"
  param :att_id, String, "附件id", :required => true
  param :passport_token, String, "用户令牌，用于操作的身份验证", :required => true
  param :user_id, String, "用户id", :required => true

  description <<-EOS
    删除帖子附件
    返回成功 返回：
    {
      response: #{CodeHelper.CODE_SUCCESS}
      description:“成功”
    }

    返回失败 返回
    {
      response:#{CodeHelper.CODE_FAIL}
      description:“删除附件失败”
    }

    参数缺少 返回
    {
      response:#{CodeHelper.CODE_MISSING_PARAMS}
      description:“缺少必须参数”
    }

  EOS
  def deleteAttachment

    msg = Hash.new

    if params[:att_id].nil? || params[:att_id].blank?

      msg[:response] = CodeHelper.CODE_MISSING_PARAMS
      msg[:description] = "缺失 附件 id "
      render :json =>  msg
      return
    end

    if params[:user_id].nil? || params[:user_id].blank?

      msg[:response] = CodeHelper.CODE_MISSING_PARAMS_USER_ID
      msg[:description] = "缺失 user id "
      render :json =>  msg
      return
    end

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

    d_attach = PostAttachment.find_by_id(params[:att_id])
    if d_attach.nil?

      msg[:response] = CodeHelper.CODE_FAIL
      msg[:description] = "附件不存在 "
      render :json =>  msg
      return
    else

      if d_attach.update_attributes(:image => nil)

        msg[:response] = CodeHelper.CODE_SUCCESS
        msg[:description] = "附件删除成功 "
        render :json =>  msg
        return
      else

        msg[:response] = CodeHelper.CODE_FAIL
        msg[:description] = "附件删除失败"
        render :json =>  msg
        return
      end
    end
  end

end
