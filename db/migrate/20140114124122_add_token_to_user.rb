class AddTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :age, :string
    add_column :users, :sex, :string
    add_column :users, :token, :string
  end
end
