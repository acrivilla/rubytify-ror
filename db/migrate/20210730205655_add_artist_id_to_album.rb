class AddArtistIdToAlbum < ActiveRecord::Migration[5.2]
  def change
    add_column :albums, :artist_id, :text, array: true
  end
end
