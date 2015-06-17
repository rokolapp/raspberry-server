

/*----------------SERVER CONFIG---------------- 
const PORT = 8080;
var server = http.createServer(handleRequest);

server.listen(PORT, function(){
	console.log('Servidor encendido');
});

/*----------------SERVER Controller----------------
var playlist = [];

function handleRequest(req, res){

	console.log(req.url)

	if(req.url == '/favicon.ico')
		res.end();


	if(req.url == '/playlist'){
		var jsonObject = {};
		jsonObject.playlist = playlist;
		res.write(JSON.stringify(jsonObject));
		res.end();
	}

	else{
		console.log('lol')
		var paresedUrl = url.parse(req.url, true);
		var queryAsObject = paresedUrl.query; 
		
		playlist.push(queryAsObject.q);
		
		if (playlist.length == 1)
			playsong()

		res.end('Playing song');
	}
}
*/
var http 	= require('http'),
	url 	= require('url'),
	lame 	= require('lame'),
	Speaker = require('speaker'),
	Spotify = require('spotify-web');
	firebase = require('firebase')

var playlist = [];
var old_songs = []

var ref = new firebase("https://rockolapp.firebaseio.com");

ref.on("child_added", function(snapshot, prevChildKey) {
	var track_uri = snapshot.val().track_uri
	console.log('##')
	console.log(prevChildKey)
	playlist.push(track_uri);
	old_songs.push(prevChildKey)

	if (playlist.length == 1)
		playsong()

  
});

function delete_song(prevChildKey){
	console.log('remove')
	console.log(prevChildKey)
	if(prevChildKey != null){
		child_ref = new firebase("https://rockolapp.firebaseio.com/"+prevChildKey)
		child_ref.remove();
	}
}

function playsong ()
{
	//var url = track_uri || 'spotify:track:1ZBAee0xUblF4zhfefY0W1';

	var username = '12156614669',
		password = 'Getinhalo4';



	Spotify.login(username,password, function(err,spotify){
		if (err) throw err;
		//Get a track instance
		var url = playlist[0];

		spotify.get(url, function(err,track){
			if (err) throw err;
			console.log('Playing %s - %s', track.artist[0].name, track.name);
			delete_song(old_songs[0])
			//play() return a readable stream of mp3 audio data			
			track.play()
			.pipe(new lame.Decoder())
			.pipe(new Speaker())
			.on('finish', function(){
				spotify.disconnect();
				console.log('end song')
				playlist.shift();	
				old_songs.shift();			
				if(playlist.length > 0)
					playsong();
			});

		});
	});
}
