$(function(){
	// ヘッダーを最下部へ配置
	let header = $("header")[0].offsetHeight;
	let footer = $("footer")[0].offsetHeight;
	$("main").css({
		"min-height" : `calc(100vh - ${header + footer}px)`
	});
});

