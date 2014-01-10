class User < ActiveRecord::Base

  has_many :posts
  attr_accessible :frstName, :lastName, :avatar


  has_attached_file :avatar, :styles => { :small => "150x150>", :content => "800x800>", :thumb => "60x60>", :thumb_small=>"30x30>" },
                    :url => "/upload/paperclip/:class/user/:id/:style_:basename.:extension"  ,
                    :path => ":rails_root/public/upload/paperclip/:class/user/:id/:style_:basename.:extension"

end
