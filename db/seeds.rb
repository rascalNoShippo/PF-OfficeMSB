# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = [""]

user.push(User.create(name: "佐藤 昇 部長（情報システム部）", login_name: "satos", password: "satos", employee_number: "10001", is_admin: true))
user.push(User.create(name: "山田 隆志 支店長（大阪支店）", login_name: "yamadat", employee_number: "11001", password: "yamadat"))
user.push(User.create(name: "鈴木 拓也 支店次長（大阪支店）", login_name: "suzukit", employee_number: "12012", password: "suzukit"))
user.push(User.create(name: "三上 司 営業課長（大阪支店）", login_name: "mikamit", employee_number: "13037", password: "mikamit"))
user.push(User.create(name: "井戸 環奈（大阪支店）", login_name: "idok", employee_number: "27021", password: "idok"))
user.push(User.create(name: "小林 慎吾 支店長（東京支店）", login_name: "kobayashis", employee_number: "17021", password: "kobayashis"))
user.push(User.create(name: "古川 敬之 支店次長（東京支店）", login_name: "furukawan", employee_number: "16201", password: "furukawan"))
user.push(User.create(name: "斉藤 健太 営業課長（東京支店）", login_name: "saitok", employee_number: "18801", password: "saitok"))
user.push(User.create(name: "宮本 秀樹 （東京支店）", login_name: "miyamotoh", employee_number: "19761", password: "miyamotoh"))
user.push(User.create(name: "赤坂 剛 部長（人事部）", login_name: "akasakat", employee_number: "20090", password: "akasakat"))
user.push(User.create(name: "小川 由紀 次長（人事部）", login_name: "ogaway", employee_number: "22193", password: "ogaway"))
user.push(User.create(name: "加藤 美咲 部長（総務部）", login_name: "katom", employee_number: "03442", password: "katom"))
user.push(User.create(name: "赤松 昴希（総務部）", login_name: "akamatsuk", employee_number: "30042", password: "akamatsuk"))

user[1].image.attach(io: File.open(Rails.root.join("public/default/model_1.png")), filename: "1.png")
user[2].image.attach(io: File.open(Rails.root.join("public/default/model_2.png")), filename: "2.png")
user[3].image.attach(io: File.open(Rails.root.join("public/default/model_3.png")), filename: "3.png")
user[4].image.attach(io: File.open(Rails.root.join("public/default/model_4.png")), filename: "4.png")
user[5].image.attach(io: File.open(Rails.root.join("public/default/model_5.png")), filename: "5.png")
user[10].image.attach(io: File.open(Rails.root.join("public/default/model_10.png")), filename: "10.png")
user[11].image.attach(io: File.open(Rails.root.join("public/default/model_11.png")), filename: "11.png")
user[12].image.attach(io: File.open(Rails.root.join("public/default/model_12.png")), filename: "12.png")

User.all.each do |user|
	UserConfig.create(user_id: user.id)
end

message = [""]

message.push(user[12].messages.new)
message[1].title =  "【全社員宛】年末調整資料の提出"
message[1].body = '<div>【令和４年　年末調整資料のご案内】</div><div><br></div><div><strong style="color:rgb( 255 , 0 , 0 )">11月21（月）本社必着　</strong></div><div><strong style="color:rgb( 255 , 0 , 0 )">10月末までに入社したアルバイトも含む全従業員が対象です！</strong></div><div><br></div><div><span style="font-size:16px">※個人の</span><span style="font-size:16px;color:rgb( 255 , 0 , 0 )">添付証明書などが紛失しないよう</span><span style="font-size:16px">確認して下さい。</span></div><div><span style="font-size:16px">※</span><span style="font-size:16px;color:rgb( 255 , 0 , 0 )">必ず</span><span style="color:rgb( 255 , 0 , 0 )">1拠点一纏め</span>にして<span style="color:rgb( 255 , 0 , 0 )">1回で送付</span>をお願い致します。</div><div><br></div><div>【※ 確定申告対象者の方へ注意点 ※】</div><div>・<span style="color:rgb( 255 , 0 , 0 )">所得2,000万以上</span>で確定申告をする予定の方</div><div>・<span style="color:rgb( 255 , 0 , 0 )">住宅を購入して</span>確定申告をする予定の方</div><div>・<span style="color:rgb( 255 , 0 , 0 )">ふるさと納税を複数行い</span>確定申告をする予定の方</div><div>・<span style="color:rgb( 255 , 0 , 0 )">その他確定申告を行う</span>予定がある方</div><div>上記確定申告を行う予定の方でも必ず下記2つの申告書は提出をお願いします。</div><div>①給与所得者の扶養控除等（異動）申告書</div><div>②給与所得者の配偶者控除等申告書　の提出をお願い致します。</div><div><span style="color:rgb( 255 , 0 , 0 )">※</span><span style="color:rgb( 255 , 0 , 0 );font-size:16px">①②申告書に記入のみして頂きご提出お願いします。</span></div><div><span style="color:rgb( 255 , 0 , 0 );background-color:rgb( 255 , 255 , 0 )">確定申告時に必要な証明書類は絶対に送付しないでください。</span></div>'
message[1].created_at = Time.new(2022, 11, 1, 15, 11, 28, "+09:00")
message[1].update_content_at = Time.new(2022, 11, 1, 15, 18, 41, "+09:00")
message[1].last_update_user_id = user[13].id
message[1].save
message[1].attachments.attach(io: File.open(Rails.root.join("public/default/年末調整.docx")), filename: "年末調整.docx")

message[1].message_destinations.create(receiver_id: user[1].id, finished_reading: Time.new(2022, 11, 3, 9, 0, 0, "+09:00"))
message[1].message_destinations.create(receiver_id: user[2].id, finished_reading: Time.new(2022, 11, 3, 10, 0, 0, "+09:00"))
message[1].message_destinations.create(receiver_id: user[3].id, finished_reading: Time.new(2022, 11, 3, 11, 0, 0, "+09:00"))
message[1].message_destinations.create(receiver_id: user[4].id, finished_reading: Time.new(2022, 11, 3, 11, 30, 0, "+09:00"))
message[1].message_destinations.create(receiver_id: user[5].id, finished_reading: Time.new(2022, 11, 3, 11, 0, 0, "+09:00"))
message[1].message_destinations.create(receiver_id: user[6].id)
message[1].message_destinations.create(receiver_id: user[7].id)
message[1].message_destinations.create(receiver_id: user[8].id)
message[1].message_destinations.create(receiver_id: user[9].id)
message[1].message_destinations.create(receiver_id: user[10].id)
message[1].message_destinations.create(receiver_id: user[11].id)
message[1].message_destinations.create(receiver_id: user[12].id, is_editable: true, finished_reading: message[1].created_at)
message[1].message_destinations.create(receiver_id: user[13].id, is_editable: true)

message[1].update(number_of_comments: message[1].number_of_comments + 1)
message[1].comments.create(comment_id: message[1].number_of_comments, commenter_id: user[2].id, body: "<p>大阪支店<br>承知致しました。</p>", created_at: Time.new(2022, 11, 2, 10, 5, 0, "+09:00"))
message[1].update(number_of_comments: message[1].number_of_comments + 1)
message[1].comments.create(comment_id: message[1].number_of_comments, commenter_id: user[6].id, body: "<p>東京支店<br>承知致しました。</p>", created_at: Time.new(2022, 11, 2, 14, 25, 0, "+09:00"))
message[1].update(number_of_comments: message[1].number_of_comments + 1)
message[1].comments.create(comment_id: message[1].number_of_comments, commenter_id: user[1].id, body: "<p>情報システム部<br>承知致しました。</p>", created_at: Time.new(2022, 11, 2, 15, 0, 0, "+09:00"))
message[1].update(number_of_comments: message[1].number_of_comments + 1)
comment = message[1].comments.create(comment_id: message[1].number_of_comments, commenter_id: user[10].id, body: "<p>人事部<br>承知致しました。</p>", created_at: Time.new(2022, 11, 3, 9, 47, 0, "+09:00"))
message[1].update(updated_at: comment.created_at)


message.push(user[2].messages.new)
message[2].title = "大阪支店 連絡事項"
message[2].body = '<h1><span style="font-size: 36px; background-color: rgb(255, 255, 0);"><b><font color="#0000ff">大阪支店連絡網</font></b></span></h1><p><br></p><p>共有事項、連絡事項等あればこちらに書き込みをお願いします。</p>'
message[2].created_at = Time.new(2022, 9, 1, 9, 44, 0, "+09:00")
message[2].save

message[2].message_destinations.create(receiver_id: user[2].id, is_editable: true, finished_reading: message[2].created_at)
message[2].message_destinations.create(receiver_id: user[3].id, is_editable: true, finished_reading: Time.new(2022, 9, 1, 10, 7, 20, "+09:00"))
message[2].message_destinations.create(receiver_id: user[4].id, finished_reading: Time.new(2022, 9, 1, 10, 27, 30, "+09:00"))
message[2].message_destinations.create(receiver_id: user[5].id)

message[2].update(number_of_comments: message[2].number_of_comments + 1)
message[2].comments.create(comment_id: message[2].number_of_comments,commenter_id: user[3].id, body: '<p>昨日の売上実績です。</p><p>宜しくお願い致します。</p>', created_at: Time.new(2022, 9, 1, 10, 7, 20, "+09:00")).attachments.attach(io: File.open(Rails.root.join("public/default/売上実績.xlsx")), filename: "売上実績.xlsx")
message[2].update(number_of_comments: message[2].number_of_comments + 1)
comment = message[2].comments.create(comment_id: message[2].number_of_comments,commenter_id: user[4].id, body: '<p><span style="font-size: 24px;"><b style=""><font color="#ff9c00">有難う御座います！</font></b></span><br></p>', created_at: Time.new(2022, 9, 1, 10, 27, 30, "+09:00"))
message[2].update(updated_at: comment.created_at)

message.push(user[10].messages.new)
message[3].title = "【大阪】人事考課について"
message[3].body = '<p>山田支店長</p><p>お疲れ様です。</p><p><br></p><p>今期の人事考課に際し、営業実績資料の提出が必要となります。</p><p>各スタッフごとにPDF形式で作成のうえ、<span style="font-size: 1rem;"><font color="#ff0000"><b><span style="font-size: 16px;">11月28日（月）15時</span></b></font>までにこちらに添付をお願い致します。</span></p>'
message[3].created_at = Time.new(2022, 11, 1, 10, 7, 20, "+09:00")
message[3].save

message[3].message_destinations.create(receiver_id: user[2].id, finished_reading: Time.new(2022, 11, 1, 13, 45, 20, "+09:00"))
message[3].message_destinations.create(receiver_id: user[10].id, finished_reading: Time.new(2022, 11, 1, 10, 7, 20, "+09:00"), is_editable: true)
message[3].message_destinations.create(receiver_id: user[11].id, finished_reading: Time.new(2022, 11, 1, 10, 10, 0, "+09:00"), is_editable: true)

message[3].update(number_of_comments: message[3].number_of_comments + 1)
message[3].comments.create(comment_id: message[3].number_of_comments,commenter_id: user[2].id, body: '<p>承知致しました。</p>', created_at: Time.new(2022, 11, 1, 13, 47, 20, "+09:00"))
message[3].update(number_of_comments: message[3].number_of_comments + 1)
comment = message[3].comments.create(comment_id: message[3].number_of_comments,commenter_id: user[2].id, body: '<p>提出致します。<br>ご確認のほど宜しくお願い致します。</p>', created_at: Time.new(2022, 11, 27, 17, 1, 20, "+09:00"))
message[3].update(updated_at: comment.created_at)
comment.attachments.attach(io: File.open(Rails.root.join("public/default/テスト.pdf")), filename: "考課資料_山田隆志.pdf")
comment.attachments.attach(io: File.open(Rails.root.join("public/default/テスト.pdf")), filename: "考課資料_鈴木拓也.pdf")
comment.attachments.attach(io: File.open(Rails.root.join("public/default/テスト.pdf")), filename: "考課資料_三上司.pdf")
comment.attachments.attach(io: File.open(Rails.root.join("public/default/テスト.pdf")), filename: "考課資料_井戸環奈.pdf")

message.push(user[1].messages.new)
message[4].title = "PC周辺機器の発注に関して"
message[4].body = '<div>業務に使用する以下の機材に関しては、こちらのメッセージを利用して発注してください。</div><div><br></div><ol><li>PC（ノート型、デスクトップ型）</li><li>ディスプレイ</li><li>マウス、ポインター</li><li>デジタルカメラ</li><li>プロジェクタ</li></ol><div><br></div><div>よろしくお願いします。</div>'
message[4].created_at = Time.new(2022, 10, 11, 18, 45, 20, "+09:00")
message[4].updated_at = message[4].created_at
message[4].save

message[4].message_destinations.create(receiver_id: user[1].id, is_editable: true, finished_reading: message[4].created_at)
message[4].message_destinations.create(receiver_id: user[2].id)
message[4].message_destinations.create(receiver_id: user[6].id)
message[4].message_destinations.create(receiver_id: user[10].id)
message[4].message_destinations.create(receiver_id: user[12].id)


article = [""]

article.push(user[1].bulletin_boards.new)
article[1].title = "メッセージ機能の使い方"
article[1].body = '<ul><li>一覧画面</li></ul><p style="margin-left: 25px;">自分が宛先に指定されているメッセージが<span style="font-size: 1rem;">更新日時の新しい順に</span><span style="font-size: 1rem;">表示されます。</span></p><p style="margin-left: 25px;">「更新日時」は、メッセージの内容変更・コメント投稿または削除のいずれかが行われると更新されます。<br></p><p style="margin-left: 25px;"><b><font color="#efc631">☆</font></b>/<b><font color="#efc631">★</font></b>マークを押すとお気に入り登録/解除ができます。</p><p style="margin-left: 25px;">「送信箱」は自分が送信したメッセージのみ表示します。</p><p style="margin-left: 25px;">「ごみ箱」には受信箱から削除したメッセージが入っています。</p><p><br></p><ul><li>新規投稿</li></ul><p style="margin-left: 25px;">「<b><font color="#3984c6">メッセージを送る</font></b>」ボタンより新規作成ができます。</p><p style="margin-left: 25px;">作成画面で<font color="#ff0000">標題</font>・<font color="#ff0000">本文</font>を入力します（本文は<u style=""><i style="background-color: rgb(206, 231, 247);"><font color="#a54a7b">書式設定</font></i></u>ができます）。</p><p style="margin-left: 25px;">添付ファイルを選択します（複数可・未選択可）。</p><p style="margin-left: 25px;">ユーザーリストから<font color="#ff0000"><b>宛先を指定</b></font>します。さらに宛先の中から<font color="#ff0000"><b>編集権限をつけるユーザーを選択</b></font>できます。</p><p style="margin-left: 25px;">必要に応じて「<font color="#ff0000">コメントを許可する</font>」のチェックを外します（コメントできなくなります）。</p><p style="margin-left: 25px;">「<span style="background-color: rgb(107, 165, 74);"><font color="#ffffff">送信する</font></span>」を押すと送信後のメッセージ画面に移動します。</p><p style="margin-left: 25px;"><br></p><ul><li>メッセージ画面</li></ul><p style="margin-left: 25px;">タイトルの横の<span style="font-size: 1rem; font-weight: bolder;"><font color="#efc631">☆</font></span><span style="font-size: 1rem;">/</span><span style="font-size: 1rem; font-weight: bolder;"><font color="#efc631">★</font></span><span style="font-size: 1rem;">マークを押すとお気に入り登録/解除ができます。</span></p><p style="margin-left: 25px;">差出人・最終更新者（内容が更新されている場合）・宛先が表示されます。各ユーザーをクリックするとユーザーデータに遷移します（自分のアイコンは<b><font color="#6ba54a">緑</font></b>で表示）。</p><p style="margin-left: 25px;">前回閲覧した後に内容が更新されていた場合、本文が<span style="background-color: blanchedalmond;border: 1px solid orange;padding: 2px 5px;">ハイライト表示</span><span style="font-size: 1rem;">されます。</span></p><p style="margin-left: 25px;">コメントの書き込みも可能です。</p><p style="margin-left: 25px;">コメントは新しい順に表示されます。まだ確認していないコメントは<span style="background-color: blanchedalmond;border: 1px solid orange;padding: 2px 5px;">ハイライト表示</span>されます。</p><p style="margin-left: 25px;">「<font color="#ce0000"><b>削除する</b></font>」を押すとごみ箱に移動できます。編集権限があるユーザーは<font color="#ce0000"><b>完全に削除</b></font>することもできます。</p><p style="margin-left: 25px;"><span style="font-size: 1rem;">編集権限があるユーザーは</span>「変更する」ボタンが表示されます。</p><p style="margin-left: 25px;"><br></p><ul><li>編集画面</li></ul><p style="margin-left: 25px;">新規投稿時と大体同じです。</p><p style="margin-left: 25px;">添付ファイルの削除ができます。</p>'

article.push(user[1].bulletin_boards.new)
article[2].title  = "掲示板機能の使い方"
article[2].body = "<p>メッセージ機能とほぼ同じですが、宛先の指定はできません（全ユーザー閲覧可）。</p><p>差出人・管理者は<b>編集</b>・<b>削除</b>が可能です。</p>"

article.push(user[1].bulletin_boards.new)
article[3].title  = "ユーザー編集機能の使い方"
article[3].body = '<p>ヘッダー右上に名前が表示されている部分をクリックするとメニューが表示されます。</p><p><br></p><ul><li>ユーザーデータ編集</li></ul><p style="margin-left: 25px;">名前・E-mail等、個人情報を変更できます。</p><p style="margin-left: 25px;"><br></p><ul><li>パスワード変更</li></ul><p style="margin-left: 25px;">パスワードの変更をします。</p><p style="margin-left: 25px;"><br></p><ul><li>他ユーザーの追加・編集</li></ul><p style="margin-left: 25px;"><u><font color="#B56308"><b>管理者のみ操作可能</b></font></u>です。</p><p style="margin-left: 25px;">新しいユーザーを追加したり、他ユーザーのデータやパスワードを変更できます。</p><p style="margin-left: 25px;"></p>'

article[3].save
article[2].save
article[1].save

user[2].favorites.create(class_name: "Message", item_id: message[2].id)
user[2].favorites.create(class_name: "BulletinBoard", item_id: article[1].id)

user[1].favorites.create(class_name: "Message", item_id: message[1].id)
user[1].favorites.create(class_name: "BulletinBoard", item_id: article[1].id)