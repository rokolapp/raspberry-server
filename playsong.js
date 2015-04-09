var http = require('http');
var url = require('url');

var lame = require('lame'),
		Speaker = require('speaker'),
		Spotify = require('spotify-web');

const PORT = 8080;

function handleRequest(req, res){
	if(req.url == '/favicon.ico')
		res.end();
	else{
		console.log(req.url)
		var paresedUrl = url.parse(req.url, true);
		var queryAsObject = paresedUrl.query; 

		console.log(queryAsObject.q);
		playsong(queryAsObject.q)

		res.end('Playing song');
	}
}

var server = http.createServer(handleRequest);

server.listen(PORT, function(){
	console.log('Server ready');
});

function playsong (track_uri)
{
	

	var url = track_uri || 'spotify:track:1ZBAee0xUblF4zhfefY0W1';

	var username = '12156614669',
		password = 'Getinhalo4';

	Spotify.login(username,password, function(err,spotify){
		if (err) throw err;
		//Get a track instance
		spotify.get(url, function(err,track){
			if (err) throw err;
			console.log('Playing %s - %s', track.artist[0].name, track.name);
			
			//play() return a readable stream of mp3 audio data
			track.play()
			.pipe(new lame.Decoder())
			.pipe(new Speaker())
			.on('finish', function(){
				spotify.disconnect();
				console.log('bye')
			});

		});
	});
}
