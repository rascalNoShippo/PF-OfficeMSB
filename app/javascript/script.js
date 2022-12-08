$(function(){
	// ヘッダーを最下部へ配置
	let header = $("header").outerHeight();
	let footer = $("footer").outerHeight();
	$("main").css({
		"min-height" : `calc(100vh - ${header + footer}px)`
	});
	$(".schedule_index").css({
		"height" : `calc(100vh - ${header + footer}px)`
	});
});

$(function(){
	// コメントの削除リンクをhover時に表示
	$(".comment").on("mouseover", function(){
	    $(this).find(".delete_comment").css({"display":"inline"});
	});
	$(".comment").on("mouseout", function(){
	    $(this).find(".delete_comment").css({"display":"none"});
	});
});

$(function(){
	//summernote 初期化
	$("#summernote").summernote({
		height: 300,
		lang: "ja-JP",
		placeholder: " ",
		fontSizes:["8", "9", "10", "11", "12", "13", "14", "16", "18", "24", "36"],
		toolbar: [
			// [groupName, [list of button]]
			["style", ["style"]],
			["style", ["bold", "italic", "underline", "clear"]],
			["font", ["strikethrough"]],
			["fontsize", ["fontsize"]],
			["color", ["color"]],
			["para", ["ul", "ol", "paragraph"]],
			["insert", ["link"]],
			["height", ["height"]]
		]
	});
});
