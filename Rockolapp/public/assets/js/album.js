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
	genres = $('#'+id+'_genres').val();
	if(confirm('¿Desea registrar el album?')){
		$.ajax({
			type: 'POST',
			url: '/album',
			data: {
				token: token,
				name: name,
				uri: uri,
				spotify_id: sId,
				list: lista,
				genres : genres
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
	albumsForms = $('#albums_forms');
	albumsForms.html('');
	albums = data.albums.items;
	if(albums.length == 0){
		albumsForms.append('<h1>No se encontraron coincidencias</h1>');
		return;
	}
	for(var i = 0; i < albums.length; i++){

		name = albums[i].name;
		if(albums[i].images.length != 0){
			image = albums[i].images[0].url;
		}
		else{
			image = '/no_image.png'
		}
		uri = albums[i].uri;
		id = albums[i].id
		autToken = $('#authenticity_tokens').val();
		albumsForms.append(
			"<hr>"+
			"<div class='album_forms' id='album_form_for_"+id+"'>"+
			"<input type='hidden' id='"+id+"_token'name='authenticity_token' value='"+autToken+"'>"+
				"<div class='album_image'>"+
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

	name = $("#index_album_name").val();
	id = $("#index_album_spotify_id").val();
	albumsField = $('#albums_index_field');

	$.ajax({
		type: 'GET',
		url: '/search_album',
		data: {
			criteria: criteria,
			name: name,
			spotify_id: id,
		}
	}).done(function(data){
		albumsField.html('');
		if(data.length > 0){
			for(var i = 0; i < data.length; i++){

				name = data[i].name;
				uri = data[i].uri;
				list = data[i].list;

				albumsField.append(
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
					"<a data-confirm=\"Rlly m8?\" rel=\"nofollow\" data-method=\"delete\" href=\"album/"+data[i].id+"\">Delete</a>"+
					"<hr>"
				);
			}
		}else{
			albumsField.html('<H1>No se encontraron resultados</>');
		}
	}).fail(function(xhr, status, error){
		alert(xhr.getResponseHeader('errors'));
	});

}
$(document).ready(function(){
	$('#search_albums_btn').click(function(){
		spotify_query('search_albums_txt','15','album',function(data){
			create_forms(data);
		});
		}
	);
	$('#search_albums_txt').keyup(function (e) {
	    if (e.keyCode == 13) {
			spotify_query('search_albums_txt','15','album',function(data){
				create_forms(data);
			});
	    }
	});
});
