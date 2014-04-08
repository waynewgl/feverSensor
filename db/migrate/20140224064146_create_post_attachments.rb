class CreatePostAttachments < ActiveRecord::Migration
  def change
    create_table :post_attachments do |t|
      t.string :post_id
      t.string :note

      t.timestamps
    end
  end
end
