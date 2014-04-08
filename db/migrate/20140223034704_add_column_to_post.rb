class AddColumnToPost < ActiveRecord::Migration
  def change
    add_column :posts, :fever_id, :string
    add_column :posts, :meature_time, :string

  end
end
