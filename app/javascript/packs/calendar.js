$(function(){
	$("#month_prev").on("click", function(){
		$("#month").val(+$("#month").val() - 1);
	});
});

$(function(){
	$("#month_next").on("click", function(){
		$("#month").val(+$("#month").val() + 1);
	});
});