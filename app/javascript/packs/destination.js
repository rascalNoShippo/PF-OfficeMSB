const selector = "select#destination_list";

$(document).on('turbolinks:load', function() {
	$("#add_receiver").on("click", function(){
		const selector_user_list = "select#user_list";
		const item = $(selector_user_list).val();
		const elements = $(`${selector} option`);
		var arr = [];
		for(var i = 0; i < elements.length; i++){
			arr.push(elements[i].value);
		}
		item.forEach(function(t){
			if(!arr.includes(t)){
				$("<option>", {
					value : t,
					text : $(`${selector_user_list} option[value=${t}]`).text()
				}).appendTo(selector);
			}
		})
	});
});

$(document).on('turbolinks:load', function() {
	$("#remove_receiver").on("click", function(){
		const item = $(selector).val();
		item.forEach(t => $(`${selector} option[value=${t}]`).remove());
	});
});