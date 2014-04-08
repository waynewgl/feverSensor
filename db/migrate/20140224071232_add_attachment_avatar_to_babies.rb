class AddAttachmentAvatarToBabies < ActiveRecord::Migration
  def self.up
    change_table :babies do |t|
      t.attachment :avatar
    end
  end

  def self.down
    drop_attached_file :babies, :avatar
  end
end
