class User < ActiveRecord::Base

  #has_many :fever_symptoms
  #has_many :fevers, :through => :fever_symptoms

  has_many :posts
  has_many :favoriates
  has_many :followers
  has_many :black_lists
  has_many :nicknames
  has_many :locations
  has_many :record_groups

  attr_accessible :firstName, :lastName, :avatar , :avatar_content_type, :avatar_file_name, :avatar_file_size, :avatar_updated_at

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
        last_name: self.lastName,
        email: self.email,
        sex: self.sex,
        age: self.age,
        mood: self.mood,
        image_url: self.avatar.url,
        last_name: self.lastName
    }
  end


  def generate_token
    self.passport_token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless User.exists?(passport_token: random_token)
    end
  end

end
