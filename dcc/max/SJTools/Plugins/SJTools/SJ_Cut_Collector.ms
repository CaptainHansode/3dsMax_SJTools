/*******************************************************
System J Tools 
********************************************************
Name:SJ_Cut_Collector
Created By:CaptainHansode
WEB:www.sakaiden.com
E-Mail:sakaiden@live.jp
*******************************************************/

--global sjAHValue = #()

plugin modifier 'SJ_Cut_Collector'
	name:"SJ_Cut_Collector"
	classID:#(0x5b733fd8, 0xa052070)
	version:1 --バージョン管理
(
-----------------------------------------------------------------------------------------------------------
-- 言語初期化
-----------------------------------------------------------------------------------------------------------
--基本言語ファイル
Local languageFile = openFile (getINISetting ((getDir #scripts) + "\SJTools\SJTools.ini") "SJTools" "LanguageFile");
/*
言語ファイルは、一度readするとStringStream値が移動してしまうので
設定ごとに読み込みをすること！！
*/
--Version etc
--skipToString languageFile "[SJ_Cut_Collector.ms]";--必ず対象のツールまで一度飛ばす
--skipToString languageFile "SJ_Cut_CollectorNameAndVersion ="
--Local nameAndVersion = (readLine languageFile);
Local nameAndVersion = "SJ Cut Collector";
-----------------------------------------------------------------------------------------------------------
	--カメラをほじするnodeTransformMonitor配列
	Local tempCameraList = #(), tempArray =#();
	--さっきさわったリストのIndex
	Local lastCheck = undefined;
	
	--Locals
	Local Values = #(), cut_list_rol;
	Local defaultNameStr = "Group", NumStr = "01";
	
	/*
	parameters SJ_Cut_CollectorParam
	(
		presetName_str type:#stringTab tabSize:0 tabSizeVariable:true;
		preset_str type:#stringTab tabSize:0 tabSizeVariable:true;
	);
	*/
	parameters  SJ_Cut_CollectorParam rollout:cut_list_rol
	(
		cameraListNTF type:#maxObjectTab tabSize:0 tabSizeVariable:true animatable:false;
		startList type:#intTab tabSize:0 tabSizeVariable:true animatable:false;
		endList type:#intTab tabSize:0 tabSizeVariable:true animatable:false;
		cutListOn type:#boolean ui:cutListOnCb default:false animatable:false;
		--faderValue type:#percent ui:(faderCa_Sl,faderSpn) animatable:false;
	);
-----------------------------------------------------------------------------------------------------------
-- ファンクション
-----------------------------------------------------------------------------------------------------------
--////////////////////////////////////////////////
--メニュー
--////////////////////////////////////////////////
	fn menus =
	(
		rcMenu menuBar
		(
			local modInst --Local instance of the scripted modifier
				menuItem helpMi "ヘルプ!"
				menuItem aboutMi "About"
				menuItem emailMi  "E-Mail"

			on helpMi picked do shellLaunch "http://www.sakaiden.com/?page_id=5885" ""
			on emailMi picked do shellLaunch "mailTo:sakaiden@live.jp" ""
			on aboutMi picked do sj_functions.sjtools_about_Fn();
		)
		menuBar.modInst=this --get the modifier and create an instance for the menu because of scope and contex issues.
		return menuBar --Return the menu
	);--fn end

--////////////////////////////////////////////////
--ロールアウト
--////////////////////////////////////////////////
rollout cut_list_rol "Cut List"
(
--////////////////////////////////////////////////
--
--
--
--リストとその編集
--
--
--
--////////////////////////////////////////////////

--////////////////////////////////////////////////
--リストを作成するファンクション
/*
アクティブxでリストを作るopen時にこのファンクションを実行
*/
--////////////////////////////////////////////////
fn makeListView_Fn list =
(
	
	/*ビューの種類*/
	--list.View = #lvwReport;
	/*グリッドラインの有無*/
	--list.gridLines = true;
	/*上のヘッドラインを表示するか?*/
	--list.View = #lvwReport;
	/*選択時に行全体を選択するかの有無*/
	list.fullRowSelect = true;
	/*マルチセレクト*/
	list.MultiSelect = true;
	
	/*レイアウト*/
	list.Appearance = #ccFlat;
	list.BorderStyle = #ccNone;
	--リストの背景色
	--list.backColor = color 255 255 255;
	
	--チェックボックスを有効にする
	list.checkboxes = false;
	--リストのヘッダーと幅、リストは多次元配列
	Local layout_def = #(#("Camera",70), #("Start",40), #("End",40));
	--layout_def = #(#("On",40), #("Object Name",120), #("Object Class",80), #("Verts",45), #("Faces",45), #("Material",120));

	--設定した配列を追加
	for i in layout_def do
	(
		column = list.ColumnHeaders.add();
		column.text = i[1];
	);

	/*
	ユーザー変数を2種作成、アドレスと、列の幅
	windowsHandleに送るidが含まれている
	windowsのActiveXコントロールのプログラミングなので、詳しくはWindowsActiveXを参照する
	*/
	LV_FIRST = 0x1000;
	LV_SETCOLUMNWIDTH = (LV_FIRST + 30);
	/*MaxScriptの配列Indexが1で始まるのに対し、ActiveX側が0で始まる不都合を取り除く*/
	for i = 0 to layout_def.count-1 do windows.sendMessage list.hwnd LV_SETCOLUMNWIDTH i layout_def[1+i][2];
);--fn end

--////////////////////////////////////////////////
--リストのテスト用
--////////////////////////////////////////////////
fn addTest_Fn list =
(
	/*リストをすべてくりあ*/
	--.ListSubItemsリストのサブアイテムにアクセスできる
	list.ListItems.clear()
	 
	/*1から順にリストに追加*/
	temp = undefined;
	sub_li = undefined;
	for i = 1 to 12 do
	(
		temp = list.ListItems.add();
		--temp.checked = true;
		temp.text = "Group01";

		sub_li = temp.ListSubItems.add();
		sub_li.text = i;
		
		sub_li = temp.ListSubItems.add();
		sub_li.text = i + 100;
	);--for end
);--fn end

--////////////////////////////////////////////////
--プリセットを追加のフレーム処理
--////////////////////////////////////////////////
fn addList_Fn =
(
	--カメラを登録した直後なので、カウントが1かどうかで配列のはじめか分かる
	--下はカメラが1つめだった場合
	if (cameraListNTF.count == 1) then
	(
		append startList 1;
		append endList 2;
	)else(
	--配列全体のカウントから
	--print cameraListNTF.count
		append startList (endList[(endList.count)] + 1);
		append endList (startList[(endList.count)+1] + 1);
	);--if end
						
)-- end fn
	
--////////////////////////////////////////////////
--Del
--////////////////////////////////////////////////
fn delList_Fn listName listFrame i = 
(
	deleteItem cameraListNTF i;
	deleteItem startList i;
	deleteItem endList i;
);--fn end

--////////////////////////////////////////////////
--clear
--////////////////////////////////////////////////
fn clearList_Fn listName listFrame = 
(
	--名前のリスト、本体のリスト、flagを処理
	cameraListNTF = #();
	startList = #();
	endList = #();
	listName.items = #();
	listFrame.items = #();
);--fn end

--////////////////////////////////////////////////
--save
--////////////////////////////////////////////////
fn saveList_Fn =
(
--ファイル名などを変数に入れておく
--typeの部分はこんな感じ  types:"Transform File(*.file)|*.file|Text(*.txt)|*.txt"
local saveName = getSaveFileName types:"Text(*.txt)|*.txt" caption:"保存";

	--キャンセルなどで変数がｕｎｄｅｆｉｎｅｄだった場合は実行しない	
	if (saveName != undefined) do
	(
		--取得したファイル名などでファイルを作成
		saveFile = createfile saveName;
		
		for i=1 to cameraListNTF.count do
		(
		--cut_list_rol
		
		--カメラ名を書き出し
		format "%," cut_list_rol.cutList.items[i] to:saveFile;
		--開始フレーム
		format "%," startList[i] to:saveFile;
		--終了フレーム
		format "%\n" endList[i] to:saveFile;
		
		);--for end
		close saveFile;
	);--if end
);--fn end


--////////////////////////////////////////////////
--load
--////////////////////////////////////////////////
fn  loadList_Fn =
(
local loadStr = "", str = "";
local loadName = getOpenFileName types:"Text(*.txt)|*.txt" caption:"読み込み";

	if loadName != undefined do
	(
		--ファイルを開く
		loadFile = openFile loadName;
		--読み込み行が無くなるまで
		while not eof loadFile do
		(
			loadStr = readLine loadFile;
			
			--一度StringStreamに変換
			loadStr = (loadStr as stringStream);
			
			--ファイルは名前,start,end,の順で書き込まれているので3回ずつ
			str = (readDelimitedString loadStr ",");
			
			if isvalidnode (obj = (getNodeByName str)) then
			(
			
			if (classOf obj == Freecamera or classOf obj == Targetcamera or classOf obj == VRayPhysicalCamera) then
			(
			append cameraListNTF (nodeTransformMonitor node:(execute("$"+str)) forwardTransformChangeMsgs:false);
			)else(
			--カメラでなかった場合でも空を登録しておく
			--アップデートが空だった場合に勝手に削除してくれる
			messageBox("以下の対象が登録できません\nカメラではない可能性があります\n\n"+str) title:"メッセージ";
			append cameraListNTF (nodeTransformMonitor node:undefined forwardTransformChangeMsgs:false);
			);			
			
			)else(
			--オブジェクトが無い場合でも空を登録しておく
			--アップデートが空だった場合に勝手に削除してくれる
			messageBox("以下の対象のカメラがありません\n\n"+str) title:"メッセージ";
			append cameraListNTF (nodeTransformMonitor node:undefined forwardTransformChangeMsgs:false);
			);
			
			str = (readDelimitedString loadStr ",");
			append startList (str as Integer);
		
			str = (readDelimitedString loadStr ",");
			append endList (str as Integer);

		);--while end
		close loadFile;
	);

);--fn end

--////////////////////////////////////////////////
--アップダウン
--////////////////////////////////////////////////
fn upList_Fn Index =
(
	next = cameraListNTF[Index-1];
	cameraListNTF[Index - 1 ] = cameraListNTF[Index];
	cameraListNTF[Index] = next;
);--fn end

fn downList_Fn Index =
(
	next = cameraListNTF[Index + 1];
	cameraListNTF[Index + 1] = cameraListNTF[Index];
	cameraListNTF[Index] = next;
);--fn end

--////////////////////////////////////////////////
--リストアップデート
--////////////////////////////////////////////////
fn updateList_Fn listName listFrame =
(
	Local k = 1, i = 1;--カウント用
	tempArray = #();

	--一端クリア
	listName.items = #();
	listFrame.items = #();
	listName.items = listName.items;
	listFrame.items = listFrame.items;
	
	for i in cameraListNTF do
	(
		--nodeは無くなっていないか？
		if not (isvalidnode i.node) then
		(
			append tempArray k;
		);--if end
		k += 1;
	);--for end
	
	--以下は無くなっていた部分のカメラなどを削除
	if ( tempArray.count != 0 ) then
	(
		i = tempArray.count;
		while i > 0 do
		(
			deleteItem cameraListNTF tempArray[i];
			deleteItem startList tempArray[i];
			deleteItem endList tempArray[i];
			--list.ListItems.Remove i;
			i -= 1;
		);--while ends
	);--if end

	--リストの名前を更新
	k = 1;--カウント用
	for i in cameraListNTF do
	(
		listName.items[k] = i.node.name;
		listFrame.items[k] = (startList[k] as String) + " -> " + (endList[k] as String);
		--表示更新
		listName.items = listName.items;
		listFrame.items = listFrame.items;
		--sub_li.text = startList[k];
		--sub_li.text = endList[k];
		
		k += 1;
	);--for end


	
	
	
/*リストをすべてくりあ*/
--list.ListItems.clear();
--tempArray = #();

/*1から順にリストに追加*/
--temp = undefined;
--sub_li = undefined;
/*
Local k = 1, i = 1;
	for i in cameraListNTF do
	(
	--nodeは無くなっていないか？
	if not (isvalidnode i.node) then
	(
		append tempArray k;
	);--if end
		k += 1;
	);--for end
	
	--以下は無くなっていた部分のカメラなどを削除
	if ( tempArray.count != 0 ) then
	(
		i = tempArray.count;
		while i > 0 do
		(
			deleteItem cameraListNTF tempArray[i];
			deleteItem startList tempArray[i];
			deleteItem endList tempArray[i];
			--list.ListItems.Remove i;
			i -= 1;
		);--while ends
	);--if end

	--多項リストに追加
	k = 1;
	for i in cameraListNTF do
	(
		temp = list.ListItems.add();
		temp.text = i.node.name;

		sub_li = temp.ListSubItems.add();
		sub_li.text = startList[k];
		
		sub_li = temp.ListSubItems.add();
		sub_li.text = endList[k];
		
		k += 1;
	);--for end
*/
)--end updateList_Fn

--////////////////////////////////////////////////
--
--
--
--普通のファンクション
--
--
--
--////////////////////////////////////////////////
--////////////////////////////////////////////////
--pickObject時のためのフィルター、nodeを除外する
--////////////////////////////////////////////////
fn pickFilter_Fn o =
(
--カメラ以外は除外
(classOf o == Freecamera or classOf o == Targetcamera or classOf o == VRayPhysicalCamera);
--(o != selection[1]);
-- or selection[1] != o
);
--fn pickFilter_Fn o = ((findItem allNodes o) == 0);

--////////////////////////////////////////////////
--フレーム設定
--////////////////////////////////////////////////
fn changeFrameSet_Fn start end Index =
(
	--配列を入れ替え
	startList[Index] = start;
	endList[Index] = end;
	
	for i = Index to cameraListNTF.count do
	(
		--選択したIndexが1の場合は行わない
		if (i != 1) then
		(
			--ひとつ前のエンドよりスタートが大きいことを確認する
			if ((endList[i-1] < startList[i]) == false) then
			(
				startList[i] = (endList[i-1] + 1);
			);--if end
			
			--エンドがスタートよりも大きいことを確認する
			if ((startList[i] < endList[i]) == false) then
			(
				endList[i] = startList[i] + 1;
			);--if end
		);--if end	
		
	);--for end
);--fn end

--////////////////////////////////////////////////
--選択状態をチェック
--////////////////////////////////////////////////
fn cameraRename_Fn Str Index =
(
	cameraListNTF[Index].node.name = Str;
);--fn end

--////////////////////////////////////////////////
--選択状態をチェック
--////////////////////////////////////////////////
fn selectionCheck_Fn obj =
(
	--選択しているか?
	--if selection.count !=0 then
	--(
	--選択物は
		if ((classOf obj == Freecamera) or (classOf obj == Targetcamera)) then
		(	
			--チェック結果が良好なら
			return true;
		);--if end
	--)--if end
	--チェック結果は気まずい
	return false;
);--fn end

--////////////////////////////////////////////////
--トランスフォーム用のスクリプトを追加
--////////////////////////////////////////////////
fn addTransformScript_Fn =
(
Local scritpStr = "try(
Local obj = $" + selection[1].name + ";
if (obj.modifiers[#SJ_Cut_Collector].cutListOn) then
(
Local myValue = obj.modifiers[#SJ_Cut_Collector].cameraListNTF[1].node.transform;
Local lastIndex = obj.modifiers[#SJ_Cut_Collector].cameraListNTF.count;
for i=1 to lastIndex do
(
if ( F >= obj.modifiers[#SJ_Cut_Collector].startList[i] ) then myValue = obj.modifiers[#SJ_Cut_Collector].cameraListNTF[i].node.transform;
);
myValue;
)else(matrix3 [1,0,0] [0,1,0] [0,0, 1] [0,0,0]);--if end
)catch(matrix3 [1,0,0] [0,1,0] [0,0, 1] [0,0,0]);
"
	--コントローラーを変換スクリプト追加
	selection[1].Transform.controller = transform_script ();
	--一端クリアして入れる
	selection[1].Transform.controller.script = "matrix3 [1,0,0] [0,1,0] [0,0, 1] [0,0,0]";
	selection[1].Transform.controller.script = scritpStr;
);--fn end

--////////////////////////////////////////////////
--FOV用のスクリプトを追加
--////////////////////////////////////////////////
fn addFovScript_Fn =
(
Local scritpStr = "try(
Local obj = $" + selection[1].name + ";
if (obj.modifiers[#SJ_Cut_Collector].cutListOn) then
(
Local myValue = obj.modifiers[#SJ_Cut_Collector].cameraListNTF[1].node.fov;
Local lastIndex = obj.modifiers[#SJ_Cut_Collector].cameraListNTF.count;
for i=1 to lastIndex do
(
if ( F >= obj.modifiers[#SJ_Cut_Collector].startList[i] ) then myValue = obj.modifiers[#SJ_Cut_Collector].cameraListNTF[i].node.fov;
);
degToRad(myValue);
)else(0.785398);--if end
)catch(0.785398);
"
	--コントローラーを変換スクリプト追加
	selection[1].fov.controller = float_script ();
	--一端クリアして入れる
	selection[1].fov.controller.script = "0";
	selection[1].fov.controller.script = scritpStr;
);--fn end

--Vray用、Vrayはラジアンではないので、ラジアンの変更の必要は無い
fn addFovScriptVray_Fn =
(
Local scritpStr = "try(
Local obj = $" + selection[1].name + ";
if (obj.modifiers[#SJ_Cut_Collector].cutListOn) then
(
Local myValue = obj.modifiers[#SJ_Cut_Collector].cameraListNTF[1].node.fov;
Local lastIndex = obj.modifiers[#SJ_Cut_Collector].cameraListNTF.count;
for i=1 to lastIndex do
(
if ( F >= obj.modifiers[#SJ_Cut_Collector].startList[i] ) then myValue = obj.modifiers[#SJ_Cut_Collector].cameraListNTF[i].node.fov;
);
myValue;
)else(45.0);--if end
)catch(45.0);
"
	--コントローラーを変換スクリプト追加
	selection[1].fov.controller = float_script ();
	--一端クリアして入れる
	selection[1].fov.controller.script = "0";
	selection[1].fov.controller.script = scritpStr;
);--fn end

--////////////////////////////////////////////////
--レイアウト
--////////////////////////////////////////////////
	GroupBox cutListGrp "Cut List" pos:[4,4] width:154 height:340
	--listbox presetsCbx "" pos:[12,68] width:120 height:8 selection:1
	
	checkbutton addListBt "" pos:[12,20] width:20 height:20 toolTip:"追加" images:#("$Scripts/SJTools/Images//SJ_button_add.png", "$Scripts/SJTools/Images//SJ_button_add_a.png", 2, 1, 1, 2, 2)
	button allSelBt "" pos:[36,20] width:20 height:20 images:#("$Scripts/SJTools/Images//SJ_button_allSel.png", "$Scripts/SJTools/Images//SJ_button_allSel_a.png", 2, 1, 1, 2, 2) toolTip:"全て選択"
	button deleteBt "" pos:[60,20] width:20 height:20 enabled:true images:#("$Scripts/SJTools/Images//SJ_button_delete.png", "$Scripts/SJTools/Images//SJ_button_delete_a.png", 2, 1, 1, 2, 2) toolTip:"削除"
	button clearBt "" pos:[84,20] width:20 height:20 enabled:true images:#("$Scripts/SJTools/Images//SJ_button_clear.png", "$Scripts/SJTools/Images//SJ_button_clear_a.png", 2, 1, 1, 2, 2) toolTip:"クリア"
	button helpBt "" pos:[108,20] width:20 height:20 images:#("$Scripts/SJTools/Images//SJ_button_help.png", "$Scripts/SJTools/Images//SJ_button_help_a.png", 2, 1, 1, 2, 2) toolTip:"ヘルプ"
	button upBt "" pos:[12,44] width:20 height:20 images:#("$Scripts/SJTools/Images//SJ_button_up.png", "$Scripts/SJTools/Images//SJ_button_up_a.png", 2, 1, 1, 2, 2) toolTip:"項目をアップ"
	button downBt "" pos:[36,44] width:20 height:20 images:#("$Scripts/SJTools/Images//SJ_button_down.png", "$Scripts/SJTools/Images//SJ_button_down_a.png", 2, 1, 1, 2, 2) toolTip:"項目をダウン"
	checkbutton replaceBt "" pos:[60,44] width:20 height:20 toolTip:"項目を入れ替え" images:#("$Scripts/SJTools/Images//SJ_button_replace.png", "$Scripts/SJTools/Images//SJ_button_replace_a.png", 2, 1, 1, 2, 2)
	button saveBt "" pos:[84,44] width:20 height:20 images:#("$Scripts/SJTools/Images//SJ_button_save.png", "$Scripts/SJTools/Images//SJ_button_save_a.png", 2, 1, 1, 2, 2) toolTip:"リストを保存"
	button loadBt "" pos:[108,44] width:20 height:20 images:#("$Scripts/SJTools/Images//SJ_button_open.png", "$Scripts/SJTools/Images//SJ_button_open_a.png", 2, 1, 1, 2, 2) toolTip:"リストを読み込み"
	edittext cutEdt "" pos:[8,68] width:140 height:16
	listbox cutList "" pos:[12,84] width:60 height:17 selection:1 --items:#("cut01","cut02","cut03");
	listbox cutFrameList "" pos:[72,84] width:76 height:17 selection:1 --items:#("cut01","cut02","cut03");
	
	GroupBox settingGrp "Frame Setting" pos:[4,352] width:154 height:56
	label startLbl "Start" pos:[12,368] width:48 height:16
	label endLbl "End" pos:[76,368] width:48 height:16
	spinner startSpn "" pos:[9,384] width:56 height:16 range:[-1e+009,1e+009,0] type:#integer scale:1
	spinner endSpn "" pos:[73,384] width:56 height:16 range:[-1e+009,1e+009,1] type:#integer scale:1
	checkbutton cutListOnCb "On / Off" pos:[12,316] width:120 height:20 toolTip:"カメラのトレースの切り替え" --highlightColor:[0,255,0]

-----------------------------------------------------------------------------------------------------------
-- アクション
-----------------------------------------------------------------------------------------------------------
	on cutListOnCb changed state do
	(
		if (cameraListNTF.count == 0) then
		(
			messageBox ("カメラが登録されていません") titel:"メッセージ";
		);--if end
	);--end
	

	on addListBt changed state do
	(
		if state == on then
		(
			tempCameraList = #();
			Local picObj = undefined;
			picObj = pickObject message:"オブジェクトを選択してください:" count:1 select:false forceListenerFocus:false filter:pickFilter_Fn;
			--picObj = pickObject message:"オブジェクトを選択してください:" count:#multiple forceListenerFocus:false filter:pickFilter_Fn
			
			if ((picObj == selection[1]) or (picObj == undefined)) then
			(	messageBox ("登録出来ません") titel:"メッセージ";
			)else(
				append cameraListNTF (nodeTransformMonitor node:picObj forwardTransformChangeMsgs:false);
				addList_Fn();
				updateList_Fn cutList cutFrameList;
			);--if end
			addListBt.state = off;
			cutListOnCb.enabled = true;
			max select;
		)else(
			--モードを切り替えることでバグ回避
			max move;
			max select;
		)--if end
	);--end

	on  clearBt pressed do
	(
		cutListOnCb.checked = false;
		cutListOnCb.enabled = false;
		clearList_Fn cutList cutFrameList;
		updateList_Fn cutList cutFrameList;
	);
	
	on deleteBt pressed do
	(
		--リストは空か？
		if ( cutList.items.count != 0 ) then
		(
		delList_Fn cutList cutFrameList cutList.selection;
		if (cameraListNTF.count == 0) then
		(
		cutListOnCb.checked = false;
		cutListOnCb.enabled = false;
		);--if end
		updateList_Fn cutList cutFrameList;
		);--if end
	);
	
	on allSelBt pressed do
	(
		tempArray = #();
		--リストは空か？
		if ( cutList.items.count != 0 ) then
		(
			for i in cameraListNTF do
			(
				append tempArray i.node;
			);--for end
			undo on (select tempArray);
		);--if end
	);--end
	
	on upBt pressed do
	(
		--リストは空か？
		if ( cutList.items.count != 0 ) then
		(
			--選択したIndexが1でなく、項目が選択されていれば
			if  (cutList.selection != 1) then
			(
				--一端Index値を格納して
				tempIndex = cutList.selection;
				upList_Fn cutList.selection;
				updateList_Fn cutList cutFrameList;
				--格納したIndex値から選択し直す
				cutList.selection = tempIndex-1;
				cutFrameList.selection = tempIndex-1;
			);--if end
		);--if end
	);--end
	
	on downBt pressed do
	(
		--リストは空か？
		if ( cutList.items.count != 0 ) then
		(
			--選択したIndexが最後でなく選択されていれば
			if  (cutList.selection != cutList.items.count) then
			(
				--一端Index値を格納して
				tempIndex = cutList.selection;
				downList_Fn cutList.selection;
				updateList_Fn cutList cutFrameList;
				--格納したIndex値から選択し直す
				--格納したIndex値から選択し直す
				cutList.selection = tempIndex+1;
				cutFrameList.selection = tempIndex+1;
			);--if end
		);--if end
	);--if end
	
	on replaceBt changed state do
	(
		--リストは空か？
		if ( cutList.items.count != 0 ) then
		(
		
		if (cutList.selection != 0) then
		(

		if state == on then
		(
			tempCameraList = #();
			Local picObj = undefined;
			picObj = pickObject message:"オブジェクトを選択してください:" count:1 select:false forceListenerFocus:false filter:pickFilter_Fn;
			
			if ((picObj == selection[1]) or (picObj == undefined)) then
			(	messageBox ("登録出来ません") titel:"メッセージ";
			)else(
				--入れ替え
				cameraListNTF[cutList.selection] = (nodeTransformMonitor node:picObj forwardTransformChangeMsgs:false);
				updateList_Fn cutList cutFrameList;
			);--if end
			
			replaceBt.state = off;
			cutListOnCb.enabled = true;
			max move;
			max select;
		)else(
			--モードを切り替えることでバグ回避
			max move;
			max select;
		)--if end
		
		);--if end
		
		)else(
			replaceBt.state = off;
			max move;
			max select;
		);--if end
		
	);--end
	
	on saveBt pressed do
	(
		--リストは空か？
		if ( cutList.items.count != 0 ) then
		(
			saveList_Fn();
			--リストのテキストを出力
			/*
			for i in cameraList.ListItems do
			(
			print i.text;
			--cameraList.ListItems[1].text;
			);--for end
			*/
		);--if end
	);--end
	
	on loadBt pressed do
	(
		clearList_Fn cutList cutFrameList;
		loadList_Fn();
		updateList_Fn cutList cutFrameList;
	);--end
	
	on helpBt pressed do
	(
		menuSys=menus()
		popUpMenu menuSys rollout:cut_list_rol
	);--on end
	
	--////////////////////////////////////////////////
	--リスト編集
	--////////////////////////////////////////////////
	/*チェックボックスが有効なときだけ
	on cameraList ItemCheck item do
	(
	);--end
	*/
	
	--左右のリストの選択を同期
	on cutList selected sel do
	(
		if (sel != 0) do
		(
			cutFrameList.selection = cutList.selection;
			cutEdt.text = cutList.selected;
			--スピナーの値を入力
			startSpn.value = startList[cutList.selection];
			endSpn.value = endList[cutList.selection];
		);--if end
		--hideEdt.text = hideCbx.selected;
	);--on end
	on cutFrameList selected sel do
	(
		if (sel != 0) do
		(
			cutList.selection = cutFrameList.selection;
			cutEdt.text = cutList.selected;
			--スピナーの値を入力
			startSpn.value = startList[cutList.selection];
			endSpn.value = endList[cutList.selection];
		);--if end
		--hideEdt.text = hideCbx.selected;
	);--on end
	
	--名前更新
	on cutEdt entered str do
	(
		
		--空でなければ
		if (str != "" and cutList.items.count != 0) then
		(
			cutList.selected = str;
			--表示更新
			cutList.items = cutList.items;
			cutEdt.text = str;
			
			--カメラの名前を直接変更する
			cameraListNTF[cutList.selection].node.name = str;
			
		);--if end
	);--end
	--変更されたとき
	on cutEdt changed str do
	(
		--空でなければ
		if (str != "" and cutList.items.count != 0) then
		(
			cutList.selected = str;
			--表示更新
			cutList.items = cutList.items;
			cutEdt.text = str;
		);--if end
	);--end
	
	--ダブルクリックで選択、アンドゥ対象
	on cutList doubleclicked sel do
	(
		--空じゃなければ
		if (cutList.items.count != 0) do
		(
			undo on(select cameraListNTF[sel].node);
		);--if end
	);
	--ダブルクリックで選択、アンドゥ対象
	on cutFrameList doubleclicked sel do
	(
		--空じゃなければ
		if (cutList.items.count != 0) do
		(
			undo on(select cameraListNTF[sel].node);
		);--if end
	);	

-----------------------------------------------------------------------------------------------------------
--フレーム設定
-----------------------------------------------------------------------------------------------------------
		on startSpn changed val inSpin do
		(
			--空かどうか
			if ( cameraListNTF.count != 0 and  cutList.selection != 0) then
			(
				--inSpineとはマウスが使われて値が変更されたかどうかである
				--値が小さかったら実行する
				if ( val < endSpn.value ) then
				(
					changeFrameSet_Fn val endSpn.value cutList.selection;
				)else(
					--endよりも大きくなるならendの値に1を足す
					endSpn.value = val + 1;
					changeFrameSet_Fn val endSpn.value cutList.selection;
				);--if end
				updateList_Fn cutList cutFrameList;
			);--if end
		);--on end
		on endSpn changed val inSpin do
		(
			--空かどうか
			if ( cameraListNTF.count != 0 and  cutList.selection != 0) then
			(
				--inSpineとはマウスが使われて値が変更されたかどうかである
				--値が大きかったら
				if ( val > startSpn.value ) then
				(
					changeFrameSet_Fn startSpn.value val cutList.selection;
				)else(
					startSpn.value = val - 1;
					changeFrameSet_Fn startSpn.value val cutList.selection;
				);--if end
				updateList_Fn cutList cutFrameList;
			);--if end
		);--end
	
		on startSpn entered inSpine inCancel do
		(
			--空かどうか
			if ( cameraListNTF.count != 0 and  cutList.selection != 0) then
			(
				--inSpineとはマウスが使われて値が変更されたかどうかである
				--値が小さかったら実行する
				if ( startSpn.value < endSpn.value ) then
				(
					changeFrameSet_Fn startSpn.value endSpn.value cutList.selection;
				)else(
					--endよりも大きくなるならendの値に1を足す
					endSpn.value = endSpn.value + 1;
					changeFrameSet_Fn startSpn.value endSpn.value cutList.selection;
				);--if end
				updateList_Fn cutList cutFrameList;
			);--if end
		);--on end
		on endSpn entered inSpine inCancel do
		(
			--空かどうか
			if ( cameraListNTF.count != 0 and  cutList.selection != 0) then
			(
				--inSpineとはマウスが使われて値が変更されたかどうかである
				--値が大きかったら
				if ( endSpn.value > startSpn.value ) then
				(
					changeFrameSet_Fn startSpn.value endSpn.value cutList.selection;
				)else(
					startSpn.value = startSpn.value - 1;
					changeFrameSet_Fn startSpn.value endSpn.value cutList.selection;
				);--if end
				updateList_Fn cutList cutFrameList;
			);--if end
		);--end
		
		
		
		
		----------------------
		--ロールアウトアクション
		on cut_list_rol open do
		(
			--フリーカメラか？V-Rayのカメラか
			if ((classOf selection[1] != Freecamera) and (classOf selection[1] != VRayPhysicalCamera)) then 
			(
				messageBox("このモディファイアはフリーカメラ専用です\nモディファイアを削除してください")title:"メッセージ";
				--clearSelection()
				cutListOnCb.checked = false;
				cutListOnCb.enabled = false;
				addListBt.enabled = false;
				allSelBt.enabled = false;
				clearBt.enabled = false;
				deleteBt.enabled = false;
			)else(
				lastCheck = undefined;
				--makeListView_Fn cameraList;
				
				--V-Rayのカメラがターゲットカメラだったら、ターゲットを無効にする
				if (classOf selection[1] == VRayPhysicalCamera) do
				(
					--ターゲットカメラか？（ベースオブジェクトで検索）
					 if (selection[1].targeted == true) do
					(
					selection[1].targeted = false;
					messageBox("V-Rayカメラをフリーカメラに変更しました。\nターゲットカメラは使用出来ません。")title:"メッセージ";
					);--if end
					
					--V-rayカメラだった場合はfovに変更する
					selection[1].specify_fov = on
					
					--V-rayカメラだった場合フィルムゲートを一致させる
					--if (queryBox("カメラのフィルムゲートをレンダリング設定に一致させますか?")) do selection[1].film_width = getRendApertureWidth();
					selection[1].film_width = getRendApertureWidth();
					
					--VRayだった場合のFOVスクリプト
					addFovScriptVray_Fn();
					
				);--if end
				
				--updateList_Fn cameraList;
				
				--スクリプトを追加
				addTransformScript_Fn();
				--フリーカメラの場合のFOV
				if (classOf selection[1] == Freecamera) do addFovScript_Fn();
				
				--リストは空か？
				if ( cameraListNTF.count != 0 ) then
				(
					--messageBox "aaa"
					cutListOnCb.enabled = true
					--選択1のフレームを代入する
					startSpn.value = startList[1];
					endSpn.value = endList[1];
					)else(
					cutListOnCb.enabled = false
					);--if end

				addListBt.enabled = true;
				allSelBt.enabled = true;
				clearBt.enabled = true;
				deleteBt.enabled = true;
				updateList_Fn cutList cutFrameList;
				
				--スピナーの値を入れておく、リストを選択しておく
				cutFrameList.selection = 1;
				cutList.selection = 1;
				
			);--if end
		)--end on open
		
	)-- end cut_list_rol
	--////////////////////////////////////////////////
	-- アップデート
	--////////////////////////////////////////////////
	on update do
	(
		if version == 1 then
		(
			--print "Version 1 updated"
		)
	)--end on update	

	fn rollouts = (#(cut_list_rol))
)--end Plugin


/*

*/