$(document).on('turbolinks:load', function () {
	//ヘッダーの高さを取得しmenu位置を
	$(".header_user_menu").css({"top" : $("header")[0].offsetHeight})
});

$(document).on('turbolinks:load', function () {
	//ユーザーボタンがclickされたらメニューを表示
	$(".header_user").on("click", function(){
		$(this).toggleClass("clicked");
		$(".header_user_menu").toggleClass("d-none");
	});
});

$(document).on("turbolinks:load", function () {
	$(document).on("mousedown", function (e){
		//ユーザーボタン・メニュー以外をクリックするとメニューを閉じる
		if($(e.target).closest(".header_user, .header_user_menu").length == 0) {
			$(".header_user").removeClass("clicked");
			$(".header_user_menu").addClass("d-none");
		}
	});
});