class CreateFevers < ActiveRecord::Migration
  def change
    create_table :fevers do |t|
      t.string :fever_type
      t.string :description
      t.string :suggestion

      t.timestamps
    end
  end
end
