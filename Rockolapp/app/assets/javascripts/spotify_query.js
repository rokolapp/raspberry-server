function spotify_query(inputName,limit,type,callback){
	$.ajax({
		url: 'https://api.spotify.com/v1/search',
		data: {q: $('#' + inputName).val(),
				limit: limit,
				type: type
		},						
		type: 'GET',
		dataType: 'JSON'
	})
	.done(function(data){callback(data)})
	.error(function(data){callback(data)});
};