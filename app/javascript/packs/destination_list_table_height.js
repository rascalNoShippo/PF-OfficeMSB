$(function(){
  // 宛先一覧のテーブルの高さ
  $(".receivers tbody").css({"max-height" : `calc(100vh - ${$("body").height() - ($("main>div").height() - ($("main>div .back").outerHeight(true) + $("main>div h3").outerHeight(true) + $("caption").outerHeight(true)))}px)`});
});
