class Api::V1::AlbumsController < ApplicationController
    def songs
        if !(params[:id].nil?)
            @songs = Song.where("album_id = #{params[:id]}")
            if @songs.count > 0
                render json: { data: @songs }
            else
                render json: { data: []  }
            end
        else
            render json: { data: [] }
        end 
    end
end
