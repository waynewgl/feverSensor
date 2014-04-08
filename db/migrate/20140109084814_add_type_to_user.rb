class AddTypeToUser < ActiveRecord::Migration
  def change
    add_column :users, :acc_type, :string
    add_column :users, :type, :string
  end
end
