require 'em-websocket'
class SocketController < ApplicationController
	def run 
		EM.run do |t|
			EM::WebSocket.run(:host => "localhost", :port => 3000) do |ws|
				ws.onopen do |handshake|
					puts "WebSocket connection open"

					ws.send "Hello Client, you connected to #{handshake.path}"	
				end
			end
		end
	end				
end
