/*******************************************************
System J Tools 
********************************************************
Name:SJ_Spark_ExportBatch.ms
Created By:CaptainHansode
WEB:www.sakaiden.com
E-Mail:sakaiden@live.jp
*******************************************************/
	group "ExportBatch"
	(
		button exportBatchBt "書き出しバッチ" width:160
		editText exportBatchTxt "" width:160 height:16 align:#center;
		button getExportPathBt "パスを取得" width:160 align:#center;
	)

-----------------------------------------------------------------------------------------------------------
--テキストを書き出し
-----------------------------------------------------------------------------------------------------------
on getExportPathBt pressed do
(
	Local tempLoadFile = undefined;
	tempLoadFile = getOpenFileName types:"ファイルは何でもかまいません|*.*";
	if (tempLoadFile != undefined) then exportBatchTxt.text = getFilenamePath tempLoadFile;
);--end

--ひとまずFBXの書き出しテスト
on exportBatchBt pressed do
(
	if (exportBatchTxt.text != undefined) then
	(
		--選択ぶつのみ
		exportFile (exportBatchTxt.text + "Test") selectedOnly:true using:fbx;
	)
	else
	(
		messageBox "パスが空です" title:"エラー";
	);--if end
);--end

