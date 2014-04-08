class AddAttachmentImageToCommentAttachments < ActiveRecord::Migration
  def self.up
    change_table :comment_attachments do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :comment_attachments, :image
  end
end
