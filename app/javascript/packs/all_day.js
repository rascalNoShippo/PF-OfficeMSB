$(function(){
	$("#schedule_is_all_day").change(function(){
	    if($("#schedule_is_all_day:checked").val()){
	        $("#schedule_time_begin, #schedule_time_end").attr("disabled", "disabled");
	        $("#schedule_time_begin, #schedule_time_end").val("");
	    }else{
	        $("#schedule_time_begin, #schedule_time_end").removeAttr("disabled");
	    }
	});
});