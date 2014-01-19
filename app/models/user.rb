class User < ActiveRecord::Base

  has_many :posts
  has_many :fever_symptoms
  has_many :fevers, :through => :fever_symptoms

  attr_accessible :frstName, :lastName, :avatar


  has_attached_file :avatar, :styles => { :small => "150x150>", :content => "800x800>", :thumb => "60x60>", :thumb_small=>"30x30>" },
                    :url => "/upload/avatars/:class/user/:id/:style_:basename.:extension"  ,
                    :path => ":rails_root/public/upload/avatars/:class/user/:id/:style_:basename.:extension"


  def as_json(options={})
    {
        id: self.id,
        first_name: self.firstName,
        last_name: self.lastName
    }
  end



end
