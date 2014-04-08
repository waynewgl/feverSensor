class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|

<<<<<<< HEAD
      t.string :firstName
=======
      t.string :frstName
>>>>>>> 3bc6584b50023a0852eff38f1380a687bfc0eeb9
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
