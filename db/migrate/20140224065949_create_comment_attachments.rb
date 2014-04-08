class CreateCommentAttachments < ActiveRecord::Migration
  def change
    create_table :comment_attachments do |t|
      t.string :comment_id

      t.timestamps
    end
  end
end
