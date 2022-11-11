$(function(){
	//ヘッダーの高さを取得しmenu位置を調整
	$(".header_user_menu").css({"top" : $("header")[0].offsetHeight})
});

$(function(){
	//ユーザーボタンがclickされたらメニューを表示
	$(".header_user").on("click", function(){
		$(this).toggleClass("clicked");
		$(".header_user_menu").toggleClass("d-none");
	});
});

$(function(){
	$(document).on("mousedown", function (e){
		//ユーザーボタン・メニュー以外をクリックするとメニューを閉じる
		if($(e.target).closest(".header_user, .header_user_menu").length == 0) {
			$(".header_user").removeClass("clicked");
			$(".header_user_menu").addClass("d-none");
		}
	});
});