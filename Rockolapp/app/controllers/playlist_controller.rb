require 'net/http'
require 'uri'
class PlaylistController < ApplicationController
	def index
		@playlists = Playlist.all
	end
	def new
		req_ip = request.remote_ip
		songs = Playlist.all
		songs.each{|song| redirect_to '/playlist' if req_ip == song.ip}
	end
	def save
		req_ip = request.remote_ip
		songs = Playlist.all
		songs.each do |song| 
			if req_ip == song.ip
				redirect_to '/playlist' 
				return
			end
		end
		attrs = playlist_params
		attrs[:ip] = req_ip
		@playlist = Playlist.new(attrs)
		if @playlist.save
			redirect_to '/playlist'
		else
			redirect_to '/playlist/new'
		end
	end	
	def search
		q = params[:q]
		limit = params[:limit]
		url = "https://api.spotify.com/v1/search"
		params = "?q=#{q}&type=track&limit=#{limit}"
		uri = URI(URI.encode(url+params))
		res = Net::HTTP.get(uri)
		json = JSON.parse(res)
		route = File.join(Rails.root, 'config', 'list-mode.xlu')
		list = File.foreach(route).first.chomp

		if list.eql? "whitelist" and json

			tracks = json["tracks"]
			items = json["tracks"]["items"]
			puts "Longitud de items: #{items.length}"
			items.delete_if do |item|
				album = Album.exists?(uri: item["album"]["uri"])
				puts "Album: #{album}"
				artists = item["artists"]
				artist = false
				artists.each{|art| artist = Artist.exists?(uri: art["uri"])}
				puts "Artist: #{artist}"
				track_uri = Track.exists?(uri: item["uri"])
				puts "Track #{track_uri}"
				if item and (album or artist or track_uri)
					puts "true"
					false
				else
					puts "false"
					true
				end
			end
			render json: json.to_json
		elsif list.eql? "blacklist" and json

			tracks = json["tracks"]
			items = json["tracks"]["items"]
			puts "Longitud de items: #{items.length}"
			items.delete_if do |item|
				album = Album.exists?(uri: item["album"]["uri"])
				puts "Album: #{album}"
				artists = item["artists"]
				artist = false
				artists.each{|art| artist = Artist.exists?(uri: art["uri"])}
				puts "Artist: #{artist}"
				track_uri = Track.exists?(uri: item["uri"])
				puts "Track #{track_uri}"
				if item and (album or artist or track_uri)
					puts "true"
					true
				else
					puts "false"
					false
				end
			end
			render json: json.to_json
		elsif list.eql? "freeforall" and json
			render json: json.to_json
		else
			render json: '{error: "Hubo problemas"}'
		end	
	end
	private
	def playlist_params
		params.permit(:name, :uri, :id, :img_src)
	end
end
