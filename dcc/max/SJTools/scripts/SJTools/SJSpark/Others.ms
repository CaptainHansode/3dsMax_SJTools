/*******************************************************
System J Tools 
********************************************************
Name:SJ_Spark_Others.ms
Created By:CaptainHansode
WEB:www.sakaiden.com
E-Mail:sakaiden@live.jp
*******************************************************/
	group "Corve Hide/UnHide"
	(
		button cvHideBt "表示切り替え" width:160
	)

	group "Boost Heap"
	(
		button boostHeapBt "限界までヒープ領域を確保" width:160;
		button heapSizeUpBt "値でヒープ領域を確保" width:160;
		spinner heapSizeUpSpn "単位はMです" range:[0.1,999,1] type:#integer width:160 align:#center;
	)

	group "Inode Handle Check"
	(
		button ihCheckBt "Inode Handle Call" width:160
	)

	group "Show Propaties & Class"
	(
		button showPBt "Show Properties " width:160
		editText showPTxt "プロパティ名" width:160 height:16
		label showLbl1 "baseObject--ベースオブジェクト" width:160
		label showLbl2 "modifiers[#Control]--モディファイア" width:160
		label showLbl3 "CustomNodes--任意" width:160	
		button showCBt "Show Class" width:160
		editText showCTxt "クラス名" width:160 height:16
		label showCLbl1 "path*--ワイルドカードっぽく" width:160
	)

/*
	group "nodeTransformMonitor"
	(
		pickbutton ntmAddBt "add"
		editText ntmNameTxt "変数名"--pos:[12,80] width:172 height:16 
		spinner ntmIndex "" range:[1,1000,1] type:#integer --pos:[220,116]  width:80 height:16 
	)
*/


--////////////////////////////////////////////////
--Action
--////////////////////////////////////////////////
--////////////
--カーブを表示
--///////////
	on cvHideBt pressed do
	(
		if selection.count != 0 then
		(
			actionMan.executeAction 0 "276"
		)
		else
		(
			messageBox ("オブジェクトを選択してから実行してください") title:"警告"
		)--if end
	)--

--////////////////////////
--ヒープ領域を確保
--////////////////////////
	on boostHeapBt pressed do
	(

	if queryBox ("
****************************************************************
警告

ヒープ領域を際限なく限度まで引き上げますが
Maxの動作が不安定になります
予期しないシャットダウンが起きる可能性があります

増やしたヒープ領域は減らすことが出来ません
ヒープ領域をリセットする場合はMaxを再起動してください

実行しますか?

****************************************************************
"
) == true do (
		Local bHError = false;
		while bHError == false do
		(	
			--10Mづつヒープサイズを上げる
			try(heapSize += 10000000)catch(bHError = true)
		);--while end
		
		messageBox ("以下のサイズまでヒープ領域を確保しました\n" + (heapSize as String)) title:"メッセージ"
		
);--if end
		
	);--end
	
--////////////////////////
--ヒープ領域を拡大
--////////////////////////
	on heapSizeUpBt pressed do
	(
		try(heapSize += (heapSizeUpSpn.value * 1000000);
		messageBox ("以下のサイズまでヒープ領域を確保しました\n" + (heapSize as String)) title:"メッセージ"
		)catch(messageBox"拡張に失敗しました。ヒープサイズが増やせません" title:"エラー");
	);--end
	

--////////////////////////
--InodeHandleCheck
--////////////////////////
	on ihCheckBt pressed do
	(
		Local ihNom = 0
		if selection.count != 0 do
		(
			for i = 1 to selection.count do
			(	
			ihNom = selection[i].inode.handle
			messageBox ((selection[i].name as String) + " is\n" + (ihNom as String))
			)
		--message "コンストレイント対象のオブジェクトを選択してください。"
		)
	)
	
--////////////////////////
--Show 
--////////////////////////
	on showPBt pressed do
	(
		if showPTxt.text != "" then(
			for i in selection do
			(
				temp = "$"+ i.name + "." + showPTxt.text;
				try(
				temp = execute(temp);
				ShowProperties temp;
				)catch();
			)--for end
		)
		else(
			for i in selection do ShowProperties i;
		)--if end
	)--end
	
	on showCBt pressed do
	(
		showClass showCTxt.text
	)--end

	
--////////////////////////
--選択ジオメトリ情報
--////////////////////////
	on srchnumBt pressed do
	(
		local float gnum = 0
		local float v = 0
		local float f = 0
		local float tmesh = 0
		--local float s = selection.count

			for i = 1 to selection.count do
			(
				try(	--オブジェクトがメッシュだった場合だけ以下を実行
				tmesh = snapshotAsMesh selection[i] --TriMesh スナップショットを作成します、TriMeshスナップショット化することで正確なポリゴン数などを得られます
				v += tmesh.numverts
				f += tmesh.numfaces
				gnum += 1
				--v += tmesh.verts.count　--コレでもいいよ
				--f += tmesh.faces.count
				)catch()--try end
			)--for end
			infoSelect.caption = gnum as string
			infoVers.caption = v as string
			infoFaces.caption =  f as string
	)
	
--////////////////////////
--エキスポート
--////////////////////////
	on makeFileBt pressed do
	(
		local float v = 0
		local float f = 0
		local float smesh = 0
		local float tmesh = 0
		local float num_verts = 0
		local float num_face = 0
		local float Selectnum = 0
		local out_name = getSaveFileName types:"Object Info(*.txt)|*.txt"	--Maxデフォルトのディレクトリ位置に設定する変数

		try(	

		out_file = createfile out_name	--out_nameでファイル名を指定したファイルを作成する変数を宣言

			--選択オブジェクトの情報をファイルに書き込む
			for i = 1 to selection.count do
			(
			
			try(	--オブジェクトがメッシュだった場合だけ以下を実行
			
				smesh = snapshotAsMesh selection[i]
				Selectnum += 1
				v += smesh.numverts
				f += smesh.numfaces
			
			)catch()
			
			)
			format "Total,%\nTotalVertex,%\nTotalFace,%" Selectnum v f to:out_file

			format "\n" to:out_file	--途中に改行を挟む
			format "\n" to:out_file	--途中に改行を挟む

			--ここから各ジオメトリ
			for i = 1 to selection.count do
			(
			
			try(	--オブジェクトがメッシュだった場合だけ以下を実行
			
				tmesh = snapshotAsMesh selection[i]
				Name = selection[i].name	--変数に代入
				num_verts = tmesh.numverts	--変数に代入
				num_faces = tmesh.numfaces	--変数に代
				format "Name,%\nVertex,%\nFace,%" Name num_verts num_faces to:out_file
				format "\n" to:out_file	--途中に改行を挟む
				--progbar.value = ((100.00/selection.count)*i)
			
			)catch()
			
			)
			close out_file
			--progbar.value = 0
		)catch()
		--edit out_name	--保存後に内容を確認したい場合はコメントアウトを外す
	)
