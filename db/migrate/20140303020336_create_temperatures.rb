class CreateTemperatures < ActiveRecord::Migration
  def change
    create_table :temperatures do |t|
      t.string :type
      t.string :range_from
      t.string :range_to
      t.string :time
      t.string :note
      t.string :group_id
      t.string :user_id

      t.timestamps
    end
  end
end
