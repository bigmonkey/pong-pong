$(document).ready(function () {

	$("#stateAL").css("background-color", "#4A661B");

	$("#selectorStateBox").mouseover(function(){
		$("#stateAL").css("background-color", "transparent");
	});

	$("#selectorStateBox").mouseout(function(){
		$("#stateAL").css("background-color", "#4A661B");
	});
});
