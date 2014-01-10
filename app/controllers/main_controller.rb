class MainController < ApplicationController
  protect_from_forgery


  def index


    user_post = User.find_by_id(1).posts


    for post in user_post

      logger.info "now we have the post #{post.content}"

    end



  end


end
