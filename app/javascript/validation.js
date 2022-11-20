$(function(){
	error_msg("#message_submit", "#message_title")
});

$(function(){
	error_msg("#message_comment_submit", "#message_comment_body");
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

