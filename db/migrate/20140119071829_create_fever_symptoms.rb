class CreateFeverSymptoms < ActiveRecord::Migration
  def change
    create_table :fever_symptoms do |t|
      t.string :user_id
      t.string :fever_id
      t.string :meature_time
      t.string :description

      t.timestamps
    end
  end
end
