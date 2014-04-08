class AddSignatureToUser < ActiveRecord::Migration
  def change
    add_column :users, :personal_sign, :string
  end
end
