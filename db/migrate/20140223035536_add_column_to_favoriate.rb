class AddColumnToFavoriate < ActiveRecord::Migration
  def change
    add_column :favoriates, :notes, :string
  end
end
