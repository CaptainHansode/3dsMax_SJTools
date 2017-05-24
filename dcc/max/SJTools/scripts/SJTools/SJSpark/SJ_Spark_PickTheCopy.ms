/*******************************************************
System J Tools 
********************************************************
Name:SJ_Spark_PickTheCopy
Created By:CaptainHansode
WEB:www.sakaiden.com
E-Mail:sakaiden@live.jp
*******************************************************/
	group "Pick The Copy"
	(
		button pickCopyBt "ピックザコピー" width:160 hight:20
		button selCopyBt "セレクトザコピー" width:160 hight:20
	)
	
	/*
	on pickCopyBt rightclick do
	(
	);--end
	*/
	
	on pickCopyBt pressed do
	(
		
		if selection.count != 0 then
		(
			
			Local pickedObj = undefined;
			messageBox "コピー先の対象のオブジェクトを選択してください" title:"メッセージ"
			pickedObj = PickObject count:1 select:false message:"オブジェクトを選択してください" ForceListenerFocus:true;
		
			try(
			pickedObj.controller = copy selection[1].controller;
				
			--固有にする
			--obj.controller = prs (); 
				
			move pickedObj [0,0,0]; --リフレッシュ用　0距離移動
			--ATSOps.Refresh()
			
			)catch();
			
			--obj.Transform.controller = selection[1].Transform.controller
			--obj.Transform.controller = prs () --固有にする
		)
		else
		(
		messageBox("コピー元のオブジェクトを選んでください") title:"メッセージ";
		)--if end
	);--on end
	
	on selCopyBt pressed do
	(
		if selection.count >= 2 then
		(
			try(
			selection[2].controller = copy selection[1].controller;
				
				move selection[2] [0,0,0]; --リフレッシュ用　0距離移動
				sliderTime = (currenttime + 1);
				sliderTime = (currenttime - 1);
				
			--再描画
			max views redraw;
			
			)catch();--try end
		)
		else
		(
		messageBox("最初にコピー元、2番目にコピー先を選んでください") title:"メッセージ";
		)--if end
	);--end