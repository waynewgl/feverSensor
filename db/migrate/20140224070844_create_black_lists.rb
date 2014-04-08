class CreateBlackLists < ActiveRecord::Migration
  def change
    create_table :black_lists do |t|
      t.string :user_id
      t.string :block_user_id

      t.timestamps
    end
  end
end
