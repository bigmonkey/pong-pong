$(document).ready(function () {

	$("#stateAL").css("background-color", "#0E8B4D");

	$("#selectorStateBox").mouseover(function(){
		$("#stateAL").css("background-color", "transparent");
	});

	$("#selectorStateBox").mouseout(function(){
		$("#stateAL").css("background-color", "#0E8B4D");
	});
});
