$(function(){
	//コメント未入力かつファイル未選択時 submitでエラー表示
	$("#form").submit(function(){
		if(!$(".note-editable").text().length && !$("#comment_attachments")[0].files.length){
			$(".note-editor").css({"border" : "3px solid red"});
			$(".note-placeholder").text("入力してください (またはファイルを添付)")
			return false;
		}else{
			//入力済みなら summernoteへ submit時にhidden_fieldへコード格納
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
	//パスワード変更時 不一致でエラー表示
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

$(function(){
	//スケジュール登録・変更の際 日付の逆転を防止
	$("#schedule_form").submit(function(){
		const date_begin = $("#schedule_date_begin").val();
		const time_begin = $("#schedule_time_begin").val();
		const datetime_begin = date_begin + " " + time_begin;
		const date_end = $("#schedule_date_end").val();
		const time_end = $("#schedule_time_end").val();
		const datetime_end = date_end + " " + time_end;

		let reversal;

		if($("#schedule_is_all_day:checked").val()){
			reversal = new Date(date_begin) > new Date(date_end);
		}else{
			reversal = new Date(datetime_begin) > new Date(datetime_end);
		}

		if(reversal){
			$(".datetime_error").text("日時が逆転しています");
			$(".datetime *").css({
				"color" : "red",
				"font-weight" : "bold",
				"visibility" : "visible"
			});
			return false;
		}else{
			return true;
		}
	});
});
