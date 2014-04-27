$(document).ready(function() {
	$(document).on('click', '#hit-form input', function() {
		$.ajax({
			type: 'POST',
			url: '/game/hit'
		}).done(function(response) {
			$("#game").replaceWith(response);
		});
		return false;
	});
	$(document).on('click', '#stay-form input', function() {
		$.ajax({
			type: 'POST',
			url: '/game/stay'
		}).done(function(response) {
			$("#game").replaceWith(response);
		});
		return false;
	});
	$(document).on('click', '#dealer-form input', function() {
		$.ajax({
			type: 'POST',
			url: '/game/dealer/turn'
		}).done(function(response) {
			$("#game").replaceWith(response);
		});
		return false;
	});
});