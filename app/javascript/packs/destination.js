const selector_edit = "select#editor_list";
const selector_dest = "select#destination_list";
const selector_user = "select#user_list";

$(function(){

	userListArr("editor");
	userListArr("destination");

	//宛先の追加
	$("#add_receiver").on("click", function (){
		addList(selector_user, selector_dest);
		userListArr("destination");
	});

	//編集権限の追加
	$("#add_editor").on("click", function (){
		addList(selector_dest, selector_edit);
		userListArr("editor");
	});

	//編集権限の削除
	$("#remove_editor").on("click", function(){
		const item = $(selector_edit);
		item.find("option:selected").each(function(i){
			$(this).remove();
		});
		userListArr("editor");
	});

	//宛先の削除
	$("#remove_receiver").on("click", function(){
		const item = $(selector_dest);
		const elements = $(`${selector_edit} option`)
		const editors = [];
		elements.each(function(i){
			editors.push($(this).val());
		});
		item.find("option:selected").each(function(i){
			if(editors.includes($(this).val())){
				elements.filter(`[value=${$(this).val()}]`).remove();
			}
			$(this).remove();
		});
		userListArr("editor");
		userListArr("destination");
	});
});






function userListArr(kind){
	//宛先リストをhidden_fieldに格納している (半角ｽﾍﾟｰｽ区切り)
	var value_list = "";
	$(`${kind == "editor" ? selector_edit : selector_dest} option`).each(function(){
		value_list += `${$(this).val()} `;
	});
	$(`#message_${kind == "editor" ? "editor" : "destination"}`).val(value_list);
}

function addList(selector_A, selector_B){//add from A to B
	const item = $(selector_A);
	const add_to = $(selector_B);
	const item_selected = $(`${selector_A} option:selected`);
	const elements = $(`${selector_B} option`);
	//既に宛先に入っているユーザーは追加しない
	var existing_user = [];
	elements.each(function(i){
		existing_user.push($(this).val());
	});
	//宛先のセレクトボックスに要素を追加
	item_selected.each(function(i){
		if(!existing_user.includes($(this).val())){
			add_to.append($(this).prop("outerHTML"));
			// $("<option>", {
			// 	value : $(this).val(),
			// 	text : $(this).text()
			// }).appendTo(selector_B);
		}
	})
	//追加したユーザーを選択状態にする
	$(selector_B).val(item.val());
	//hiden_fieldに格納
}