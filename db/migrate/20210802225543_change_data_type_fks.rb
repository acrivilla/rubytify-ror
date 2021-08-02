class ChangeDataTypeFks < ActiveRecord::Migration[5.2]
  def change
    change_column :albums, :artist_id, :integer
    change_column :songs, :album_id, :integer
  end
end
