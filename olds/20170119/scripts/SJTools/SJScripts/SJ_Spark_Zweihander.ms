/*******************************************************
System J Tools 
********************************************************
Name:SJ_Spark_Zweihander.ms
Created By:CaptainHansode
WEB:www.sakaiden.com
E-Mail:sakaiden@live.jp
*******************************************************/
	group "簡易テクスチャパス置換"
	(
		button texPathChangeBt "テクスチャパスを置換" width:160
		editText texPathChangeTxt "" width:160 height:16 align:#center;
		button getTexPathBt "パスを取得" width:160 align:#center;
	)

-----------------------------------------------------------------------------------------------------------
--未使用を削除
-----------------------------------------------------------------------------------------------------------
on getTexPathBt pressed do
(
	Local tempLoadFile = undefined;
	tempLoadFile = getOpenFileName types:"ファイルは何でもかまいません|*.*";
	if (tempLoadFile != undefined) then texPathChangeTxt.text = getFilenamePath tempLoadFile;
);--end
on texPathChangeBt pressed do
(
	Local myBitMap = undefined, myFile = undefined, newPath = undefined, oldFile = undefined, oldPath = undefined;
	--シーンに使われているマテリアルはあるか？
	if (sceneMaterials.count == 0) then
	(messageBox("シーンに使われているマテリアルがありません") title:"メッセージ";
	)else(

		if (texPathChangeTxt.text == "") then
		(messageBox("パスが入力されていません") title:"メッセージ";
		)else(
		
		if (queryBox("この作業はアンドゥできません\n\nシーンのマテリアルのパスを置換しますか?")title:"メッセージ") then
		(
		/*************************************************
		#ここのファイルパスを書き換える↓↓		
		**************************************************/
		--newPath = "D:\\FFFF\\";
		newPath = texPathChangeTxt.text;
		
		for i in sceneMaterials do
		(
			--////////////////////////////////////////////////
			--diffuseMapマップ
			--////////////////////////////////////////////////
			try(
			--print i.name
			oldFile = i.diffuseMap.bitmap.fileName;
			oldPath = getFilenamePath oldFile;
			
			--パスを入れ替え
			--<対象のString> <開始文字番号> <置き換える文字数> <置き換える文字>
			myFile = replace oldFile 1 oldPath.count newPath;
			
			--ビットマップを取得
			myBitMap = openBitMap myFile;
			
			--ここで入れ替える
			i.diffuseMap.bitmap = myBitMap;
			)catch();
			
			--////////////////////////////////////////////////
			--opacityマップ
			--////////////////////////////////////////////////
			try(
			--print i.name
			oldFile = i.opacityMap.bitmap.fileName;
			oldPath = getFilenamePath oldFile;
			
			--パスを入れ替え
			--<対象のString> <開始文字番号> <置き換える文字数> <置き換える文字>
			myFile = replace oldFile 1 oldPath.count newPath;
			
			--ビットマップを取得
			myBitMap = openBitMap myFile;
			
			--ここで入れ替える
			i.opacityMap.bitmap = myBitMap;
			)catch();
		);--for end
			
		);--if end--入れ替えの問い合わせIF
		
		);--if end
		
	);--if end
);

