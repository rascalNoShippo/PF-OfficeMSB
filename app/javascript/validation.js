$(function(){
	error_msg("#message_submit", "#message_title")
});

$(function(){
	$("#message_comment_submit").on("click", function(){
		if($(".note-editable").text().length == 0){
			$(".note-editor").css({"border" : "3px solid red"});
			$(".note-placeholder").text("入力してください")
			return false;
		}else{
			return true;
		}
	});
});

$(function(){
	error_msg("#user_submit", "#user_password");
});

$(function(){
	error_msg("#user_submit", "#user_login_name");
});

$(function(){
	error_msg("#user_submit", "#user_name");
});

$(function(){
	error_msg("#password_submit", "#password_confirmation");
});

$(function(){
	error_msg("#password_submit", "#password");
});

$(function(){
	error_msg("#bulletin_board_submit", "#bulletin_board_title");
});

$(function(){
	error_msg("#bulletin_board_comment_submit", "#bulletin_board_comment_body");
});

$(function(){
	$("#password_submit").on("click", function(){
		if($("#password").val() != $("#password_confirmation").val()){
			$("#password_confirmation, #password").css({"border" : "2px solid red"});
			$("#password_confirmation").focus();
			$("#password_confirmation").val("");
			$("#password_confirmation").attr("placeholder", "パスワードが一致しません");
			return false;
		}else{
			return true;
		}
	});
});


function error_msg(selector_submit, selector_text){
	$(selector_submit).on("click", function(){
		if($(selector_text).val().length == 0){
			$(selector_text).css({"border" : "2px solid red"});
			$(selector_text).focus();
			$(selector_text).attr("placeholder", "入力してください")
			return false;
		}else{
			return true;
		}
	});
}

