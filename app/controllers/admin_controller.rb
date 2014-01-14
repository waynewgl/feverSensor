#encoding: UTF-8
class AdminController < ApplicationController
  protect_from_forgery


  def index

    @user = User.find_by_id(1)


  end

  def upload_avatar


    logger.info "what do we get  "

    @user = User.find_by_id(1)
    @user.update_attributes(params[:user])

    render :partial => "partials/admin/avatar"
    return

  end



end
