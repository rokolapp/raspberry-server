function post(id,list){
	token = $('#'+id+"_token").val();
	name = $('#'+id+"_name").val();
	uri = $('#'+id+"_uri").val();
	sId = $('#'+id+"_id").val();
	lista = list;
	if(confirm('¿Desea registrar el artista?')){
		$.ajax({
			type: 'POST',
			url: '/artist',
			data: {
				token: token,
				name: name,
				uri: uri,
				spotify_id: sId,
				list: lista
			}
		}).done(function(){
			alert('Registro exitoso')
		}).fail(function(xhr, status, error){
			alert(xhr.getResponseHeader('errors'));
		});
	}
	else{}
}
function create_forms (data){
	artistsForms = $('#artists_forms');
	artistsForms.html('');
	artists = data.artists.items;
	if(artists.length == 0){
		artistsForms.append('<h1>No se encontraron coincidencias</h1>');
		return;
	}
	for(var i = 0; i < artists.length; i++){

		name = artists[i].name;
		if(artists[i].images.length != 0){
			image = artists[i].images[0].url;
		}
		else{
			image = '/no_image.png'
		}
		uri = artists[i].uri;
		id = artists[i].id
		autToken = $('#authenticity_tokens').val();
		artistsForms.append(
			"<hr>"+
			"<div class='artist_forms' id='artist_form_for_"+id+"'>"+
			"<input type='hidden' id='"+id+"_token'name='authenticity_token' value='"+autToken+"'>"+
				"<div class='artist_image'>"+
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
function searchArtist(criteria){

	name = $("#index_artist_name").val();
	id = $("#index_artist_spotify_id").val();
	list = $("#index_artist_list").val();

	$.ajax({
		type: 'GET',
		url: '/search_artist',
		data: {
			criteria: criteria,
			name: name,
			spotify_id: id,
			list: list
		}
	}).done(function(data){
		alert(data[0].id)
	}).fail(function(xhr, status, error){
		alert(xhr.getResponseHeader('errors'));
	});

}
$(document).ready(function(){
	$('#search_artists_btn').click(function(){
		spotify_query('search_artists_txt','5','artist',function(data){
			create_forms(data);
		});
		}
	);
	$('#search_artists_txt').keyup(function (e) {
	    if (e.keyCode == 13) {
			spotify_query('search_artists_txt','5','artist',function(data){
				create_forms(data);
			});
	    }
	});
});