class CreateNicknames < ActiveRecord::Migration
  def change
    create_table :nicknames do |t|
      t.string :user_id
      t.string :nick_user_id
      t.string :nickname

      t.timestamps
    end
  end
end
