class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :user_id
      t.string :post_id
      t.string :content
      t.string :parent_id

      t.timestamps
    end
  end
end
