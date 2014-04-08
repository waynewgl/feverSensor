#encoding: UTF-8
class AdminController < ApplicationController
  protect_from_forgery


  def index

    @user = User.find_by_id(1)


  end

  def upload_avatar


    logger.info "This is params: #{params[:user]}"
    logger.info "what do we get  "

    @user = User.find_by_id(1)
    @user.update_attributes(params[:user])

    render :partial => "partials/admin/avatar"
    #render :json =>  @user


    return

  end


  #  Parameters: {"utf8"=>"✓", "authenticity_token"=>"Ab3K2aqvgp0RkOH2eL+fnmB/iTgylO8L7oKWG5iKrjU=",
  # "user"=>{"avatar"=>#<ActionDispatch::Http::UploadedFile:0x007fb684c728a0 @original_filename="post_bg.png",
  # @content_type="image/png", @headers="Content-Disposition: form-data; name=\"user[avatar]\";
  # filename=\"post_bg.png\"\r\nContent-Type: image/png\r\n",
  # @tempfile=#<File:/var/folders/j5/hp66z3w95tqfy5_v0sfv22wh0000gn/T/RackMultipart20140225-1528-116rvfd>>},
  # "edit_true"=>"false"}


  #  Parameters: {"avatar"=>"avatar", "data"=>#<ActionDispatch::Http::UploadedFile:0x007fb68511bd98 @original_filename="11.jpeg",
  # @content_type="image/jpeg", @headers="Content-Disposition: form-data; name=\"data\"; filename=\"11.jpeg\"\r\nContent-Type: image/jpeg\r\n",
  # @tempfile=#<File:/var/folders/j5/hp66z3w95tqfy5_v0sfv22wh0000gn/T/RackMultipart20140225-1528-1hbloho>>}


  def upload_avatar_ios

    image = params[:avatar]
    @user = User.find_by_id(1)
    @user.update_attributes(:avatar => params[:avatar])

    #render :partial => "partials/admin/avatar"
    render :json =>  @user

    return

  end
end
