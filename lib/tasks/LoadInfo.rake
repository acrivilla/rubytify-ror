require 'rake'
require 'yaml'
require 'rspotify/oauth'

namespace :loadcatalog do

    desc "Load Artists from file yml"
    task :load_artists_from_yml => :environment do
        if File.exists?("lib/tasks/artistsList.yml")
            artistsArray = YAML.load(File.read("lib/tasks/artistsList.yml"))
            artistsName = artistsArray['artists']
            artistsName.each do | artist | 
                if !Artist.exists?(name: artist.to_s)
                    artistsFound = RSpotify::Artist.search(artist.to_s)
                    artistApi = artistsFound.first
                    Artist.create( 
                        :name => artist.to_s,
                        :image => artistApi.images.first["url"],
                        :popularity => artistApi.popularity,
                        :spotify_url => artistApi.external_urls["spotify"],
                        :spotify_id => artistApi.id,
                        :genres => artistApi.genres
                    )
                    puts "#{artist.to_s} added"
                end
            end
        else
            puts "File artistsList.yml no exists, nothing to load"
        end     
        puts "End task" 
    end

    desc "Load albums from Artist"
    task :load_albums_from_artists => :environment do
        artistsArray = Artist.all
        artistsArray.each do | artist |
            artistFound = RSpotify::Artist.find(artist.spotify_id)
            albumsFound = artistFound.albums
            if albumsFound.count > 0
                albumsFound.each do | albumApi |
                    if !Album.exists?(spotify_id: albumApi.id)
                        urlImagen = ""
                        albumApi.images do | imagenes |
                            if !(imagenes["url"].presence?)
                                urlImagen = imagenes["url"]
                                break
                            end
                        end
                        Album.create(
                            :name => albumApi.name,
                            :image => albumApi.images.first["url"],
                            :spotify_url => albumApi.external_urls["spotify"],
                            :total_tracks => albumApi.total_tracks,
                            :spotify_id => albumApi.id,
                            :artist_id => artist.id
                        )
                        puts "id #{albumApi.id} - Album #{albumApi.name} added to #{artist.name}"
                    end      
                end
            end
        end 
    end

    desc "Load songs from Albums"
    task :load_songs_from_album => :environment do
        albumsArray = Album.all
        albumsArray.each do | album |
            albumFound = RSpotify::Album.find(album.spotify_id)
            songsFound = albumFound.tracks
            if songsFound.count > 0
                songsFound.each do | songsApi |
                    if !Song.exists?(spotify_id: songsApi.id)
                        Song.create(
                            :name => songsApi.name,
                            :spotify_url => songsApi.external_urls["spotify"],
                            :preview_url => songsApi.preview_url,
                            :duration_ms => songsApi.duration_ms,
                            :explicit => songsApi.explicit.to_s,
                            :spotify_id => songsApi.id,
                            :album_id => album.id
                        )
                        puts "id #{songsApi.id} - Song #{songsApi.name} added to #{album.name}"
                    end
                end
            end
        end
    end

    desc "Load artists, albums and songs from Spotify"
    task :loadAll => [:load_artists_from_yml, :load_albums_from_artists, :load_songs_from_album] do
        puts "Load Finished."
    end

end
