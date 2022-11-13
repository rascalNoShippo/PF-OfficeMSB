$(function(){
	$("#message_submit").on("click", function(){
		if($("#message_title").val().length == 0){
			$("#message_title").css({"border" : "2px solid red"});
			$("#message_title").focus();
			$("#title_error").text("入力してください");
			return false;
		}else{
			return true;
		}
	});
});

$(function(){
	$("#message_comment_submit").on("click", function(){
		if($("#message_comment_body").val().length + $("#message_comment_attachments")[0].files.length == 0 ){
			$("#message_comment_body").css({"border" : "2px solid red"});
			$("#message_comment_body").focus();
			$("#comment_error").text("入力してください");
			return false;
		}else{
			return true;
		}
	});
});
