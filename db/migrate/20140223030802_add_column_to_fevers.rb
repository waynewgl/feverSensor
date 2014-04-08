class AddColumnToFevers < ActiveRecord::Migration
  def change
    add_column :fevers, :range_from, :string
    add_column :fevers, :range_to, :string

  end
end
