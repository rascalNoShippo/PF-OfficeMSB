$(function(){
	//前月へ
	$("#month_prev").on("click", function(){
		$("#month").val(+$("#month").val() - 1);
		loading();
	});
});

$(function(){
	//次月へ
	$("#month_next").on("click", function(){
		$("#month").val(+$("#month").val() + 1);
		loading();
	});
});

$(function(){
	// 今月を表示
	$("#this_month_btn").on("click", function(){
		$("#month").val(0);
		loading();
	});
});

function loading(){
	//Loadingを表示
	$("#calendar>div").css({
		"background-color" : "rgba(0, 0, 0, 0.1)"
	});
	$("#calendar .d-none").addClass("d-flex");
	$("#calendar .d-none").removeClass("d-none");
}

$(function(){
	//日付ダブルクリックで予定追加confimを表示→OKで作成画面へ
	$(document).on("dblclick", "#calendar td", function(){
		const object = $(this);
		object.addClass("selected");
		setTimeout(function(){
			if(confirm(`${object.attr("data-date-i18n")}の予定を作成しますか？`)){
				location.assign(`/schedules/new?date=${object.attr("data-date")}`);
			}else{
				object.removeClass("selected");
			}
		}, 1);
	});
});

$(function(){
	//各行の高さを固定
	$("#calendar tbody tr").css({
		"height" : `calc((100vh - ${($("body").height() - $("#calendar tbody").height())}px) / ${$("#calendar tbody tr").length}`
	});
});

