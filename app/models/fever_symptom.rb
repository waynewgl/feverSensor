class FeverSymptom < ActiveRecord::Base
  attr_accessible :description, :fever_id, :meature_time, :user_id

  belongs_to :fever
  belongs_to :user

end
