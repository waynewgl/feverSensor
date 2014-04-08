class AddColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mobile, :string
    add_column :users, :mood, :string
    add_column :users, :nickname, :string
    add_column :users, :recent_login, :string
    add_column :users, :level, :string
    add_column :users, :credits, :string

  end
end
