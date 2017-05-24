/*******************************************************
System J Tools 
********************************************************
Name:SJ_Spark_Select.ms
Created By:CaptainHansode
WEB:www.sakaiden.com
E-Mail:sakaiden@live.jp
*******************************************************/
		group "Select"
		(
			button selectAllBranchBt "親子構造を全選択" width:160
		)
-----------------------------------------------------------------------------------------------------------
-- 以下処理
-----------------------------------------------------------------------------------------------------------
--////////////
--選択メッシュの選択頂点にNullを配置する
--///////////
	on selectAllBranchBt pressed do
	(
--新・構造を全部選択する
	with redraw off
	(--再描画禁止
	
	--階層構造を全て取得
	if selection.count != 0 then
	(
	--変数を準備
	Local objRoot = selection[1],
	obj = undefined;
	objectBranch = #();--回収した子供
	checkObj = undefined;--チェックするオブジェクト
	checkChildren = #();--チェックするオブジェクトの配列
		
		--選択したものの階層をさかのぼり、親オブジェクトが無くなったら回収
		while objRoot.parent != undefined do
		(
			 objRoot = objRoot.parent
		)--while end
	
		--配列に格納
		append objectBranch objRoot
		
		--子供の数を入れる
		numChild = objRoot.children.count;
		--初期回収
		for i =1 to objRoot.children.count do
		(
			--2つに回収
			append checkChildren objRoot.children[i];
			append objectBranch objRoot.children[i];
		);--for end
		
		--0になるまで繰り返す
		while numChild != 0 do
		(
			--deleteItem checkChildren 1;
			checkObj = checkChildren[numChild];
			
			--チェック用配列からのおしりから削除
			deleteItem checkChildren numChild;
			numChild -= 1;			
			
			--子はあるか？
			if (checkObj.children.count != 0) then
			(
				--print "有り";
				numChild += checkObj.children.count;--カウントアップ
				for i =1 to checkObj.children.count do
				(
					append checkChildren checkObj.children[i];
					append objectBranch checkObj.children[i];
				);--for end
			)else
			(
				--子が見つからなければ
				--print "無し"
			);--if end
			--checkObj += objRoot.children[numChild];
		);
		--最後に選択
		select objectBranch;
		print "選択終了";

	);--if end
	
	)--with redraw end
		
	/*************************旧式	
	with redraw off
	(--再描画禁止
	
	--階層構造を全て取得
	if selection.count != 0 then
	(
	--変数を準備
	Local objectBranch = #()
	allObj = for i in objects collect i;
	objRoot = selection[1];
	obj = undefined;
		
		--選択したものの階層をさかのぼり、親オブジェクトが無くなったら回収
		while objRoot.parent != undefined do
		(
			 objRoot = objRoot.parent
		)--while end
	
		--配列に格納
		append objectBranch objRoot
	
		--すべてのオブジェクトから
		for i in allObj do
		(
		 obj = i;
		
		--オブジェクトの親が見つかっていれば
		 while obj.parent != undefined do
		 (
			obj = obj.parent;
		 )--while end
		
		 --もっとも親の階層が同じならばオブジェクトを配列無いに回収
		 if obj == objRoot then append objectBranch i;
		)--for end
	
	--最後に選択
	select objectBranch
	
	);--if end
	
	)--with redraw end
	*****************************************/
	
	);

	