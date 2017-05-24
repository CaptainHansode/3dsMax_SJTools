/*******************************************************
System J Tools 
********************************************************
Name:SJ_Spark_LayerLaer.ms
Created By:CaptainHansode
WEB:www.sakaiden.com
E-Mail:sakaiden@live.CaptainHansode
*******************************************************/
	group "レイヤー　レイヤー"
	(
		button uselessLayerDeleteBt "未使用レイヤー削除" width:160
		
		button allLayerDeleteBt "全てのレイヤーを削除" width:160
		
		button layerDelByNameBt "名前でレイヤー削除" width:160
		editText layerDelByNameTxt "" width:160 height:16 align:#center;
		
		button allLayerPfxBt "全レイヤーにプレフィックス" width:160
		editText allLayerPfxTxt "" width:160 height:16 align:#center;
		button allLayerDlPxBt "全レイヤー対象文字を削除" width:160
		editText allLayerDlPxTxt "" width:160 height:16 align:#center;
	);

-----------------------------------------------------------------------------------------------------------
--未使用を削除
-----------------------------------------------------------------------------------------------------------
on uselessLayerDeleteBt pressed do
(

	Local layerCount, layer, layerRT;
	Local tagLayer = #();
	
	--レイヤーの数
	layerCount = (layermanager.count - 1);
	
	--レイヤー内にオブジェクトが無いレイヤーの名前を回収
	for i = 1 to layerCount do
	(
		--レイヤーを取得
		layer = layermanager.getlayer i;
		--refs.dependents用に登録
		layerRT = layer.layerAsRefTarg;
		
		--従属性がカウント3未満だった場合にその名前を回収
		if (refs.dependents layerRT).count < 3 then append tagLayer layer.name;

	);--for end
	
	--print tagLayer;
	--いざレイヤー削除	
	for i in tagLayer do layermanager.deleteLayerByName i
	
);

-----------------------------------------------------------------------------------------------------------
--全部削除
-----------------------------------------------------------------------------------------------------------
on allLayerDeleteBt pressed do
(

	Local layerCount, layer, layerRT;
	Local tagLayer = #();
	
	--レイヤーの数
	layerCount = (layermanager.count - 1);
	
	
	--基本レイヤーを確保
	layer = layermanager.getlayer 0;
	--カレントに設定
	layer.current = true;	
	
	--全オブジェクトをレイヤー0番に移動
	for i in objects do
	(
		--レイヤーに追加
		layer.addnode i;
	);--for end
	
	
	--レイヤー内にオブジェクトが無いレイヤーの名前を回収
	for i = 1 to layerCount do
	(
		--レイヤーを取得
		layer = layermanager.getlayer i;
		append tagLayer layer.name;
		
		/*
		--refs.dependents用に登録
		layerRT = layer.layerAsRefTarg;
		
		--従属性がカウント3未満だった場合にその名前を回収
		if (refs.dependents layerRT).count < 3 then append tagLayer layer.name;
		*/
		
	);--for end
	
	--print tagLayer;
	--いざレイヤー削除	
	for i in tagLayer do layermanager.deleteLayerByName i
	
);
-----------------------------------------------------------------------------------------------------------
--名前でレイヤーを削除
-----------------------------------------------------------------------------------------------------------
on layerDelByNameBt pressed do
(
	if (layerDelByNameTxt.text != "") then
	(
	
	--プログレス
	sj_functions.sj_progressBar_Fn();
	sj_progressBar_rol.processInfo.caption = "しばらくお待ちください";
	
	clearSelection();
	suspendEditing()--サスペンドモード
	max create mode--クリエートモードに変更
	with redraw off
	(--再描画禁止
	
	Local layerCount, layer, layerRT, layerRefs, hitText
	Local tagLayer = #(), tagObj = undefined;
	
	--レイヤーの数
	layerCount = (layermanager.count - 1);
	
	--////////////////////////////////////////////////
	--レイヤー0のオブジェクトを削除
	--////////////////////////////////////////////////
	if (queryBox("0レイヤーのオブジェクトを削除しますか?")title:"メッセージ") then
	(
	layer = layermanager.getlayer 0;
	layerRT = layer.layerAsRefTarg;
	layerRefs = refs.dependents layerRT;
	if layerRefs.count >= 3 then
	(
		--レイヤーを参照しているオブジェクトを回収
		layer.nodes &tagObj;
		delete tagObj;
		/**********************
		これは従属があるもの全てを選択してしまう
		たとえば、レイヤーが違うがコンストレイントで結ばれているオブジェクトなど
		--オブジェクトを削除
		for i = 1 to layerRefs.count do
		(
			--print i;
			--print layerRefs[i];
			--if (layerRefs[i] != ReferenceTarget:BaseLayer) or (layerRefs[i] != ReferenceTarget:Scene) then
			--(append tagObj layerRefs[i]);
			if isvalidnode layerRefs[i] then append tagObj layerRefs[i];
		);--for end
		***********************/
	);--if end
	);--if end
	--////////////////////////////////////////////////
	--ここまで
	--////////////////////////////////////////////////
	
	--初期化
	tagObj = undefined;
	
	--レイヤー内にオブジェクトが無いレイヤーの名前を回収
	for i = 1 to layerCount do
	(
		sj_progressBar_rol.progbar.value = ((100.0/layerCount) * i);
	
		--レイヤーを取得
		layer = layermanager.getlayer i;
		--refs.dependents用に登録
		layerRT = layer.layerAsRefTarg;
		--従属性がカウント3未満だった場合にその名前を回収
		if (refs.dependents layerRT).count < 3 then append tagLayer layer.name;
		--レイヤーの名前から見つけて削除
		hitText = findString layer.name layerDelByNameTxt.text;
		--文字が見つかったら！（検索結果undefindでなければ）
			if hitText != undefined then
			(
				append tagLayer layer.name;
				layerRefs = refs.dependents layerRT;
				
				--////////////////////////////////////////////////
				--ヒットしたレイヤーのオブジェクトを削除
				--////////////////////////////////////////////////
				if (queryBox(layer.name + "  はオブジェクトごと削除しますか?")title:"メッセージ") then
				(
				if layerRefs.count >= 3 then
				(
					layer.nodes &tagObj;
					delete tagObj;
					/**********************
					これは従属があるもの全てを選択してしまう
					たとえば、レイヤーが違うがコンストレイントで結ばれているオブジェクトなど
					--オブジェクトを削除
					for i = 1 to layerRefs.count do
					(
						--print i;
						--print layerRefs[i];
						if isvalidnode layerRefs[i] then append tagObj layerRefs[i];
					);--for end
					***********************/
				);--if end
				);--if end
				--////////////////////////////////////////////////
				--ここまで
				--////////////////////////////////////////////////	
			);--if end
		tagObj = undefined;
	);--for end
	--いざレイヤー削除	
	for i in tagLayer do try( layermanager.deleteLayerByName i )catch();
	try(destroydialog sj_progressBar_rol)catch();
	)--with redraw end	
	resumeEditing()--再びアクティブに
	);--if end
);

-----------------------------------------------------------------------------------------------------------
--全てのレイヤーにプレフィックス
-----------------------------------------------------------------------------------------------------------
on allLayerPfxBt pressed do
(
	--テキストはあるか？
	if (allLayerPfxTxt.text != "") then
	(

	Local layerCount, layer, layerRT;
	Local tagLayer = #();
	
	--レイヤーの数
	layerCount = (layermanager.count - 1);
	
	--レイヤー内にオブジェクトが無いレイヤーの名前を回収
	for i = 1 to layerCount do
	(
		--レイヤーを取得
		layer = layermanager.getlayer i;
		--レイヤーの名前を変える
		layer.setname (allLayerPfxTxt.text + layer.name);

	);--for end
	
	)else(messageBox"テキストが入力されていません"title:"エラー");--if end
);
-----------------------------------------------------------------------------------------------------------
--全てのレイヤーのプレフィックスを削除
-----------------------------------------------------------------------------------------------------------
on allLayerDlPxBt pressed do
(
	--テキストはあるか？
	if (allLayerDlPxTxt.text != "") then
	(

	Local layerCount, layer, layerRT, hitText, myText;
	Local tagLayer = #();
	
	--レイヤーの数
	layerCount = (layermanager.count - 1);
	
	--レイヤー内にオブジェクトが無いレイヤーの名前を回収
	for i = 1 to layerCount do
	(
		--レイヤーを取得
		layer = layermanager.getlayer i;
		--レイヤーの名前から見つけて削除
		hitText = findString layer.name allLayerDlPxTxt.text;
		--文字が見つかったら！（検索結果undefindでなければ）
				if hitText != undefined then
				(
					--文字列を空にはしない
					if (layer.name.count != allLayerDlPxTxt.text.count) then
					(
					--文字数分を空の文字に文字を置き換えます
					--<対象のString> <開始文字番号> <置き換える文字数> <置き換える文字>
					myText = replace layer.name hitText allLayerDlPxTxt.text.count "";
					layer.setname myText;
					);--if end
				);--ifend
	);--for end
	
	)else(messageBox"テキストが入力されていません"title:"エラー");--if end
);

