class CreateFavoriates < ActiveRecord::Migration
  def change
    create_table :favoriates do |t|
      t.string :user_id
      t.string :post_id

      t.timestamps
    end
  end
end
