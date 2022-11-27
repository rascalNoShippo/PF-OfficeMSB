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
