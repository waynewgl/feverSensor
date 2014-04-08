class Temperature < ActiveRecord::Base
  attr_accessible :group_id, :note, :range_from, :range_to, :time, :type, :user_id

  belongs_to :record_group
end
