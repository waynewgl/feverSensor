class RecordGroup < ActiveRecord::Base
  attr_accessible :date_from, :date_to, :note, :user_id

  belongs_to :user
  has_many :temperatures

end
