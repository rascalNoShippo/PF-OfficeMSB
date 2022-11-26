$(function(){
	// ヘッダーを最下部へ配置
	let header = $("header")[0].offsetHeight;
	let footer = $("footer")[0].offsetHeight;
	$("main").css({
		"min-height" : `calc(100vh - ${header + footer}px)`
	});
});

$(function(){
	//summernote 初期化
	$("#summernote").summernote({
    height: 300,
    lang: "ja-JP",
    placeholder: " ",
    fontSizes:['8', '9', '10', '11', '12', '13','14', '18', '24', '36'],
    toolbar: [
    // [groupName, [list of button]]
    	["style", ["style"]],
	    ['style', ['bold', 'italic', 'underline', 'clear']],
	    ['font', ['strikethrough', 'superscript', 'subscript']],
	    ['fontsize', ['fontsize']],
	    ['color', ['color']],
	    ['table', ['table']],
	    ['para', ['ul', 'ol', 'paragraph']],
	    ['height', ['height']]
  	]
  });
});


$(function() {
	//summernote用 hidden_fieldへコード格納
	$("#message_submit").on("mousedown", function() {
		$("#summernote").val($(".note-editable").html());
	});
});

