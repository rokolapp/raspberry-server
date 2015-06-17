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
			url: '/playlist',
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
	playlistsForms = $('#playlists_forms');
	playlistsForms.html('');
	playlists = data.playlists.items;
	if(playlists.length == 0){
		playlistsForms.append('<h1>No se encontraron coincidencias</h1>');
		return;
	}
	for(var i = 0; i < playlists.length; i++){

		name = playlists[i].name;
		if(playlists[i].album.images.length != 0){
			image = playlists[i].album.images[0].url;
		}
		else{
			image = '/no_image.png'
		}
		uri = playlists[i].uri;
		id = playlists[i].id
		autToken = $('#authenticity_tokens').val();
		playlistsForms.append(
			"<hr>"+
			"<div class='playlist_forms' id='playlist_form_for_"+id+"'>"+
			"<input type='hidden' id='"+id+"_token'name='authenticity_token' value='"+autToken+"'>"+
				"<div class='playlist_image'>"+
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
function searchAlbum(criteria){

	name = $("#index_playlist_name").val();
	id = $("#index_playlist_spotify_id").val();
	playlistsField = $('#playlists_index_field');

	$.ajax({
		type: 'GET',
		url: '/search_playlist',
		data: {
			criteria: criteria,
			name: name,
			spotify_id: id,
		}
	}).done(function(data){
		playlistsField.html('');
		if(data.length > 0){
			for(var i = 0; i < data.length; i++){

				name = data[i].name;
				uri = data[i].uri;
				list = data[i].list;

				playlistsField.append(
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
					"<a data-confirm=\"Rlly m8?\" rel=\"nofollow\" data-method=\"delete\" href=\"playlist/"+data[i].id+"\">Delete</a>"+
					"<hr>"
				);
			}
		}else{
			playlistsField.html('<H1>No se encontraron resultados</>');
		}
	}).fail(function(xhr, status, error){
		alert(xhr.getResponseHeader('errors'));
	});

}
$(document).ready(function(){
	$('#search_playlists_btn').click(function(){
		spotify_query('search_playlists_txt','15','playlist',function(data){
			create_forms(data);
		});
		}
	);
	$('#search_playlists_txt').keyup(function (e) {
	    if (e.keyCode == 13) {
			spotify_query('search_playlists_txt','15','playlist',function(data){
				create_forms(data);
			});
	    }
	});
});