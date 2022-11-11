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
		const item = $(selector_edit).val();
		item.forEach(t => $(`${selector_edit} option[value=${t}]`).remove());
		userListArr("editor");
	});
	
	//宛先の削除
	$("#remove_receiver").on("click", function(){
		const item = $(selector_dest).val();
		item.forEach(t => $(`${selector_dest} option[value=${t}]`).remove());
		item.forEach(t => $(`${selector_edit} option[value=${t}]`).remove());
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
	const item = $(selector_A).val();
	const elements = $(`${selector_B} option`);
	//既に宛先に入っているユーザーは追加しない
	var existing_user = [];
	for(var i = 0; i < elements.length; i++){
		existing_user.push(elements[i].value);
	}
	//宛先のセレクトボックスに要素を追加
	var added_user = [];
	item.forEach(function(t){
		if(!existing_user.includes(t)){
			$("<option>", {
				value : t,
				text : $(`${selector_A} option[value=${t}]`).text()
			}).appendTo(selector_B);
			added_user.push(t);
		}
	})
	//追加したユーザーを選択状態にする
	$(selector_B).val(added_user);
	//hiden_fieldに格納
}