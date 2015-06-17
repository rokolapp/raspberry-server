require 'net/http'
require 'uri'
class PlaylistController < ApplicationController

	def new
		req_ip = request.remote_ip
		songs = Playlist.all
		songs.each{|song| redirect_to '/playlist' if req_ip == song.ip}
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
	def save
		puts "\n\n LA IP ES ESTA WEY: #{request.remote_ip} \n\n"
		redirect_to '/playlist/new'
	end


end
