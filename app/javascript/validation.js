$(function(){
	//コメント未入力かつファイル未選択時
	$("#form").submit(function(){
		if(!$(".note-editable").text().length && !$("#comment_attachments")[0].files.length){
			$(".note-editor").css({"border" : "3px solid red"});
			$(".note-placeholder").text("入力してください (またはファイルを添付)")
			return false;
		}else{
			//summernote用 submit時にhidden_fieldへコード格納
			$("#summernote").val(
				$(".note-editable").text().length ? $(".note-editable").html() : ""
			);
			return true;
		}
	});
});

$(function(){
	
});

$(function(){
	//パスワード変更時
	$("#password_form").submit(function(){
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

$(function(){
	//ログイン名は半角英数字または“.”に制限
	$("#user_form").submit(function(){
		if($("#user_login_name").val().match(/^[A-Za-z0-9.]*$/)){
			return true;
		}else{
			$("#user_login_name").attr("placeholder", "半角英数字または“.”のみ使用可能です");
			$("#user_login_name").css({"border" : "2px solid red"});
			$("#user_login_name").val("");
			$("#user_login_name").focus();
			return false;
		}
	});
});