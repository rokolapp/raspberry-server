function readList(list){
	switch(list){
		case 'blacklist':
			return 'Black-list'
			break;
		case 'whitelist':
			return 'White-list'
			break;
		default:
			return 'ERROR "Favor de registrar de nuevo"'
	}
}
function post(id,list){
	token = $('#'+id+"_token").val();
	name = $('#'+id+"_name").val();
	uri = $('#'+id+"_uri").val();
	sId = $('#'+id+"_id").val();
	lista = list;
	if(confirm('¿Desea registrar la cancion?')){
		$.ajax({
			type: 'POST',
			url: '/track',
			data: {
				token: token,
				name: name,
				uri: uri,
				spotify_id: sId,
				list: lista,
			}
		}).done(function(){
			alert('Registro exitoso')
		}).fail(function(xhr, status, error){
			alert(xhr.getResponseHeader('errors'));
		});
	}
	else{}
}
function create_forms(data){
	tracksForms = $('#tracks_forms');
	tracksForms.html('');
	tracks = data.tracks.items;
	if(tracks.length == 0){
		tracksForms.append('<h1>No se encontraron coincidencias</h1>');
		return;
	}
	for(var i = 0; i < tracks.length; i++){

		name = tracks[i].name;
		if(tracks[i].album.images.length != 0){
			image = tracks[i].album.images[0].url;
		}
		else{
			image = '/no_image.png'
		}
		uri = tracks[i].uri;
		id = tracks[i].id
		autToken = $('#authenticity_tokens').val();
		tracksForms.append(
			"<hr>"+
			"<div class='track_forms' id='track_form_for_"+id+"'>"+
			"<input type='hidden' id='"+id+"_token'name='authenticity_token' value='"+autToken+"'>"+
				"<div class='track_image'>"+
					"<label>Imágen:</label><br>"+
					"<img src='"+image+"' width='100' height='200'>"+
				"</div>"+
				"<div>"+
					"<input type='hidden' id='"+id+"_name' value='"+name+"'>"+
					"<label>Nombre:</label><br>"+
						name+
				"</div>"+
				"<div>"+
					"<input type='hidden' id='"+id+"_uri' value='"+uri+"'>"+
					"<label>Uri:</label><br>"+
					uri+
				"</div>"+
				"<div>"+
					"<input type='hidden' id='"+id+"_id' value='"+id+"'>"+
					"<label>Spotify Id:</label><br>"+
					id+
				"</div>"+
				"<div>"+
					"<label>Lista:</label><br>"+
					"<button value='blacklist'  onclick=\"post('"+id+"',this.value)\">Black-list</button> <button value='whitelist'  onclick=\"post('"+id+"',this.value)\">White-list</button>"+
				"</div>"+
				"<hr>"+
			"</div>"
		);
	}
}
function searchTrack(criteria){

	name = $("#index_track_name").val();
	id = $("#index_track_spotify_id").val();
	tracksField = $('#tracks_index_field');

	$.ajax({
		type: 'GET',
		url: '/search_track',
		data: {
			criteria: criteria,
			name: name,
			spotify_id: id,
		}
	}).done(function(data){
		tracksField.html('');
		if(data.length > 0){
			for(var i = 0; i < data.length; i++){

				name = data[i].name;
				uri = data[i].uri;
				list = data[i].list;

				tracksField.append(
					"<hr>"+
					"<div>"+
						"<label>Nombre:</label>"+
						"<p>"+name+"</p>"+
					"</div>"+
					"<div>"+
						"<label>URI:</label>"+
						"<p>"+uri+"</p>"+
					"</div>"+
					"<div>"+
						"<label>Lista:</label>"+
						"<p>"+readList(list)+"</p>"+
					"</div>"+
					"<a data-confirm=\"Rlly m8?\" rel=\"nofollow\" data-method=\"delete\" href=\"/track/"+data[i].id+"\">Delete</a>"+
					"<hr>"
				);
			}
		}else{
			tracksField.html('<H1>No se encontraron resultados</>');
		}
	}).fail(function(xhr, status, error){
		alert(xhr.getResponseHeader('errors'));
	});

}
$(document).ready(function(){
	$('#search_tracks_btn').click(function(){
		spotify_query('search_tracks_txt','15','track',function(data){
			create_forms(data);
		});
		}
	);
	$('#search_tracks_txt').keyup(function (e) {
	    if (e.keyCode == 13) {
			spotify_query('search_tracks_txt','15','track',function(data){
				create_forms(data);
			});
	    }
	});
});