class ChangeDataTypeFks < ActiveRecord::Migration[5.2]
  def change
    rename_column :albums, :artist_id, :artist_id_text
    add_column :albums, :artist_id, :integer
    remove_column :albums, :artist_id_text

    rename_column :songs, :album_id, :album_id_text
    add_column :songs, :album_id, :integer
    remove_column :songs, :album_id_text
  end
end
