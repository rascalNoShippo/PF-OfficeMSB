$(function(){
	//ページ遷移警告
	window.onbeforeunload = function(e){
	    return "";
	}
	
	$("form").on("submit", function(e){
    window.onbeforeunload = null;
	});
});