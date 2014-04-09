class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|

      t.string :firstName
      t.string :lastName
      t.string :account
      t.string :password
      t.string :avatar
      t.string :email
      t.string :occupation

      t.timestamps
    end
  end
end
