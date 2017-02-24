var start = 16

$(document).ready(function() {

	createBoxes(start);
	whiteToBlack();

	$('#basic').click(function(){
		resetGrid();
		whiteToBlack();
	})

		$('#fade').click(function(){
		resetGrid();
		fade();
	})

		$('#color').click(function(){
		resetGrid();
		color();
	})

})

function createBoxes (side) {

	for (var i = 0; i < side*side; i++) {
		$('.container').append("<div class='box'></div>");
	}

	var newLength = 625 / side;
	$('.box').css('height', newLength);
	$('.box').css('width', newLength);
}


function whiteToBlack () {

	$('.box').hover(function(){
		$(this).css('background-color', 'black');
	})
} 

function fade () {

	$('.box').css('background-color', 'black');
	$('.box').css('opacity', '0');
	$('.box').hover(function(){
		$(this).css('opacity', '+=0.2');
	})
}

function color () {
	var safeColors = ['00','33','66','99','cc','ff']; //had major help with the setting of random colors. Was beyond me but won't be for long :p//
var rand = function() {
    return Math.floor(Math.random()*6);
};
var randomColor = function() {
    var r = safeColors[rand()];
    var g = safeColors[rand()];
    var b = safeColors[rand()];
    return "#"+r+g+b; //I understand what this genius did, I just couldn't come up with it myself :(//
};

  $('.box').hover(function(){
		$(this).css('background-color', randomColor());
	})

}

function resetGrid () {
	var newSide = prompt('What dimensions would you like master? (between 2 and 64)');
	if (newSide >= 1 && newSide <= 64) {
		$('.box').remove();
		createBoxes(newSide);
	} else {
		alert('That was not between 1 and 64! Try again please.');
		resetGrid();
	}
}