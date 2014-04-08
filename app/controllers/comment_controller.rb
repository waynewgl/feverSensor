#encoding: UTF-8
class CommentController < ApplicationController
  protect_from_forgery

  include CodeHelper

  api :POST, "/comment/createComment", "用户发表评论"
  param :user_id, String, "用户id", :required => true
  param :post_id, String, "回复帖子ID", :required => true
  param :comment_id, String, "该帖子中的评论ID, 不提供则为帖子评论，否则为评论的回复", :required => false
  param :content, String, "帖子内容", :required => false
  param :passport_token, String, "用户令牌，用于操作的身份验证", :required => true

  description <<-EOS
    发布新的回复
    返回成功 返回：
    {
      response: #{CodeHelper.CODE_SUCCESS}
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
      description:“发布评论失败”
    }

    参数缺少 返回
    {
      response:#{CodeHelper.CODE_MISSING_PARAMS}
      description:“缺少必须参数”
    }

  EOS
  def createComment

    msg = Hash.new

    if params[:post_id].nil? || params[:post_id].blank?

      msg[:response] = CodeHelper.CODE_MISSING_PARAMS_POST_ID
      msg[:description] = "需要提供帖子ID"
      render :json =>  msg
      return
    end

    if params[:user_id].nil? || params[:user_id].blank?

      msg[:response] = CodeHelper.CODE_MISSING_PARAMS_USER_ID
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

    newComment = Comment.new
    newComment.content =  params[:content].blank? ? " ": params[:content]
    newComment.user_id =  params[:user_id].blank? ? " ": params[:user_id]
    newComment.post_id =  params[:post_id].blank? ? " ": params[:post_id]

    if !params[:comment_id].blank?

      newComment.parent_id = params[:comment_id]
      msg[:parent_id] = newComment.parent_id
    end

    if newComment.save

      msg[:response] = CodeHelper.CODE_SUCCESS
      msg[:id] = newComment.id
      msg[:description] = "添加评论成功"
      render :json =>  msg
      return
    else

      msg[:response] = CodeHelper.CODE_FAIL
      msg[:description] = "添加评论失败"
      render :json =>  msg
      return
    end
  end


  api :POST, "/comment/addAttachment", "添加用户评论的附件"
  param :user_id, String, "用户id", :required => true
  param :comment_id, String, "回复ID", :required => true
  param :image, String, "文件数据", :required => true
  param :passport_token, String, "用户令牌，用于操作的身份验证", :required => true

  description <<-EOS
    发布新的评论附件
    返回成功 返回：
    {
      response: #{CodeHelper.CODE_SUCCESS}
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
      description:“上传附件失败”
    }

    参数缺少 返回
    {
      response:#{CodeHelper.CODE_MISSING_PARAMS}
      description:“缺少必须参数”
    }

  EOS
  def addAttachment

    msg = Hash.new
    if params[:comment_id].nil? || params[:comment_id].blank?

      msg[:response] = CodeHelper.CODE_MISSING_PARAMS_POST_ID
      msg[:description] = "缺失 comment id "
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

      attach = CommentAttachment.new
      attach.update_attributes(:image => params[:image])
      attach.comment_id = params[:comment_id]

      if attach.save

        msg[:response] = CodeHelper.CODE_SUCCESS
        msg[:id]= attach.id
        msg[:description] = "上传成功"
        render :json =>  msg
        return
      end
    end
  end


  api :POST, "/comment/deleteAttachment", "删除帖子附件"
  param :att_id, String, "评论的附件id", :required => true
  param :user_id, String, "用户id", :required => true
  param :passport_token, String, "用户令牌，用于操作的身份验证", :required => true

  description <<-EOS
    删除帖子附件
    返回成功 返回：
    {
      response: #{CodeHelper.CODE_SUCCESS}
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

    d_attach = CommentAttachment.find_by_id(params[:att_id])
    if d_attach.nil?

      msg[:response] = CodeHelper.CODE_FAIL
      msg[:description] = "附件不存在   "
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
