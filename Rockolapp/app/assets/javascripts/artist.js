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
		artistsForms.append(
			"<hr>"+
			"<form id='artist_form_for_"+id+"' style='cursor:pointer' method='POST' action='/artist'>"+
				"<div class='artist_image'>"+
					"<label>Imágen</label><br>"+
					"<img src='"+image+"' width='100' height='200'>"+
				"</div>"+
				"<div id='artist_name_"+name+"'>"+
					"<label>Nombre</label><br>"+
						name+
				"</div>"+
				"<div id='artist_uri_"+uri+"''>"+
					"<label>Uri</label><br>"+
					uri+
				"</div>"+
				"<div id='artist_id'>"+
					"<label>Spotify Id</label><br>"+
					id+
				"</div>"+
				"<hr>"+
			"</form>"
		);
	}
}

$(document).ready(function(){
	$('#search_artists_btn').click(function(){
		spotify_query('search_artists_txt','5','artist',function(data){
			create_forms(data);
		});
		}
	);
});