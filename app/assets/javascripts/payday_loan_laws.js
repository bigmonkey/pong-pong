$(document).ready(function () {

	$("#stateAL").css("background-color", "#669966");

	$("#selectorStateBox").mouseover(function(){
		$("#stateAL").css("background-color", "transparent");
	});

	$("#selectorStateBox").mouseout(function(){
		$("#stateAL").css("background-color", "#669966");
	});
});
