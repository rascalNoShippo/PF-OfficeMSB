$(function(){
  orgListArr();

  $("#add_org").on("click", function(){
    // 追加ボタンが押されたとき
    var org = $("select#organizations option:selected");
    var position = $("select#positions option:selected");
    var org_list;
    var org_text;
    if(org.val() == ""){
      return
    }
    if(position.val() == ""){
      org_list = org.val();
      org_text = org.text();
    }else{
      org_list = `${org.val()},${position.val()}`;
      org_text = `${org.text()}（${position.text()}）`;
    }

    //既に入っている組織は追加しない
    var existing_org = [];
    $("select#org_list option").each(function(i){
      existing_org.push($(this).val());
    });

    //要素を追加
    if(!existing_org.includes(org_list)){
			$("<option>", {
				value : org_list,
				text : org_text
			}).appendTo("select#org_list, select#user_preferred_org_id");
    }
    
    $("select#org_list").val([org_list]);
    orgListArr();
  });
  
  $("#remove_org").on("click", function(){
    // 削除ボタンが押されたとき
    $("select#org_list option:selected").each(function(i){
      var item = $(this);
      var item_val = item.val();
      item.remove();
      $(`select#user_preferred_org_id option[value="${item_val}"]`).remove();
    });
    orgListArr();
  });
  
});


function orgListArr(){
  var arr = [];
  $("select#org_list option").each(function(i){
    arr.push($(this).val());
  });
  $("#user_organizations").val(arr.join(";"));
}