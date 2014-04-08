class AddPassportToUser < ActiveRecord::Migration
  def change
    add_column :users, :passport_token, :string
  end
end
