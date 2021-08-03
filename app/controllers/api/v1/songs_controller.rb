class Api::V1::SongsController < ApplicationController
    def songs
        if !(params[:id].nil?)
            @artists = Artist.select{ |artist| artist.genres.include? "#{params[:id]}" }
            if @artists.count > 0
                @randomArtist =  @artists[rand(@artists.length)]
                @randomAlbum = Album.where("artist_id = #{@randomArtist.id}")
                @randomAlbum = @randomAlbum[rand(@randomAlbum.length)]
                @randomSong = Song.where("album_id = #{@randomAlbum.id}")
                @randomSong = @randomSong[rand(@randomSong.length)]
                if !(@randomSong.nil?)
                    render json: { data: @randomSong }
                else
                    render json: { data: [] }
                end
            else
                render json: { data: [] }
            end
        else
            render json: { data: [] }
        end 
    end
end