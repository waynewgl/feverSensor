class AddAttachmentImageToPostAttachments < ActiveRecord::Migration
  def self.up
    change_table :post_attachments do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :post_attachments, :image
  end
end
