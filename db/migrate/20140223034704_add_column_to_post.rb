class AddColumnToPost < ActiveRecord::Migration
  def change
    add_column :posts, :fever_id, :string
    add_column :posts, :meature_time, :string
    add_column :posts, :title, :string
    add_column :posts, :date, :string
    add_column :posts, :author, :string
  end
end
