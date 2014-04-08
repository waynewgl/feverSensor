class CreateRecordGroups < ActiveRecord::Migration
  def change
    create_table :record_groups do |t|
      t.string :user_id
      t.string :date_from
      t.string :date_to
      t.string :note

      t.timestamps
    end
  end
end
