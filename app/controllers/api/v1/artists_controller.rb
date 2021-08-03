class Api::V1::ArtistsController < ApplicationController
    
    def index       
        @artists = Artist.order('popularity desc')
        if @artists.count > 0 
            render json: { data: @artists }
        else
            render json: { data: []  }
        end
    end

    def albums
        if !(params[:id].nil?)
            @albums = Album.where("artist_id = #{params[:id]}")
            if @albums.count > 0
                render json: { data: @albums }
            else
                render json: { data: []  }
            end
        else
            render json: { data: [] }
        end 
    end
end
