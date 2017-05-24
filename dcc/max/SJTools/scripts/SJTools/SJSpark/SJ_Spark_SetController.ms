/*******************************************************
System J Tools 
********************************************************
Name:SJ_Spark_SetController
Created By:CaptainHansode
WEB:www.sakaiden.com
E-Mail:sakaiden@live.jp
*******************************************************/
		group "Controller Add And Changes"
		(
			button nuAttachBt "Null セグメントアタッチ" width:160
			button addContPosBt "XYZ位置コントローラーを追加" width:160
			button posContAttBt "XYZ位置コントローラーに変換" width:160
			button addContRotBt "オイラーXYZ追加" width:160
			
			button scaContInstBt "スケールをインスタンス" width:160
			button scaContAttBt "XYZスケールに変換" width:160
			
			button xtosaBt "ターンアングル2XRot" width:160
		)
		
		group "Controll Breaker"
		(
		button scbPosBt "位置" width:160 height:20
		button scbPosOffsetBt "オフセット位置" width:160 height:20
		
		button scbRotBt "回転" width:160 height:20
		button scbRotOffsetBt "オフセット回転" width:160 height:20

		button scbScaBt "スケール" width:160 height:20
		button scbScaOffsetBt "オフセットスケール" width:160 height:20
		)
-----------------------------------------------------------------------------------------------------------
-- 以下処理
-----------------------------------------------------------------------------------------------------------
		
		
--////////////
--選択メッシュの選択頂点にNullを配置する
--///////////
	on nuAttachBt pressed do
	(
	if selection.count == 1 and classOf selection[1].baseobject == Editable_Mesh	 then	--選択物1つでが編集可能メッシュか？
	(
		local p = #()	--配列宣言
			for i = 1 to selection[1].selectedVerts.count do
			(
				print selection[1].selectedVerts[i].index	--ひとまずプリントしとこう
				p = Point pos:[0,0,0]	--Null作成
				p.position.controller = position_script()	--コントローラーを位置スクリプトにする
				p.position.controller.script = "pos = getvert $" + selection[1].name + " " + (selection[1].selectedVerts[i].index as String)	--スクリプト追加
				--progbar.value = ((100.00/selection[1].selectedVerts.count)*i)	--プログレスバー処理
			)--for end
		--progbar.value = 0
	)
	else(messageBox"ミスった")--if end
	)

--////////////
--選択物に一括でマクロスクリプトを実行・・・・ホントにコレでいいの？
--////////////
	on addContPosBt pressed do
	(
	try(
		local sl = for i in selection collect i;
		for i = 1 to sl.count do
		(
		select sl[i]
		macros.run "Controllers" "XYZ_P"	--マクロスクリプト部
		--clearSelection()
		)
	)catch(messageBox "失敗" title:"警告")--try end
	)--end


--////////////
--XYZポジションコントローラーに変換
--///////////
on PosContAttBt pressed do
(
	for i = 1 to selection.count do
	(
	selection[i].pos.controller = Position_XYZ ()
	)--for end
)

--////////////
--選択物に一括でマクロスクリプトを実行・・・・ホントにコレでいいの？
--////////////
	on addContRotBt pressed do
	(
	try(
		local sl = for i in selection collect i;
		for i = 1 to sl.count do
		(
		select sl[i]
		macros.run "Controllers" "EulerXYZ_R"	--マクロスクリプト部
		--progbar.value = ((100.00/sl.count)*i)
		clearSelection()
		)
	--progbar.value = 0
	)catch(messageBox "失敗" title:"警告")--try end
	)
	
	on scaContInstBt pressed do
	(
	try(
		for i in selection do
		(
			i.scale.controller = selection[1].scale.controller;
		)
	--progbar.value = 0
	)catch(messageBox "失敗" title:"警告")--try end
	);--end
	
	
	on scaContAttBt pressed do
	(
	try(
		for i in selection do
		(
			i.scale.controller = ScaleXYZ ();
		)
	--progbar.value = 0
	)catch(messageBox "失敗" title:"警告")--try end
	);--end
	
	
--////////////
--ターン角度を設定
--///////////
	on xtosaBt pressed do
	(
	try(
		for i = 1 to selection.count do
		(
		selection[i].transform.controller.swivelAngle.controller = float_script()	--実数スクリプトをターン角度に適応
		--selection[i].transform.controller.swivelAngle.controller.script = "--AAA\n"
		--selection[i].transform.controller.swivelAngle.controller.script += "2"
		--selection[i].transform.controller.swivelAngle.controller.script = "Local obj = nodeTransformMonitor node:selection[1] forwardTransformChangeMsgs:false;\n"
		--selection[i].transform.controller.swivelAngle.controller.script += "obj.node.transform.controller.IK_goal.controller.Rotation.controller.X_Rotation" + " / (1/tan(1))\n"
		selection[i].transform.controller.swivelAngle.controller.script = "$" + selection[i].name + ".transform.controller.IK_goal.controller.Rotation.controller.X_Rotation" + " / (1/tan(1))\n"
		selection[i].transform.controller.swivelAngle.controller.script += "--AAA\n"		
		)--for end
	)catch(messageBox "オブジェクト名を IK Chain など以外にしてみてください" title:"警告")--try end
	)

-----------------------------------------------------------------------------------------------------------
-- コントロールブレーカー
-----------------------------------------------------------------------------------------------------------
	on scbPosBt pressed do	
	(
	undo on(
		for i in selection do
		(
			i.pos.controller = position_list ();
			i.pos.controller.delete 1;
		);--for end
	);--undo end
	)--end

	on scbPosOffsetBt pressed do
	(
	undo on(
		for i in selection do
		(
			i.pos.controller = position_list ();
			i.pos.controller.enabled.controller = position_list ();
			i.pos.controller.active = 2;
		);--for end
	);--undo end
	)--end
	
	
	on scbRotBt pressed do
	(
	undo on(
		for i in selection do
		(
			i.rotation.controller = rotation_list ();
			i.rotation.controller.delete 1;
		);--for end
	);--undo end
	)--end
	
	on scbRotOffsetBt pressed do
	(
	undo on(
		for i in selection do
		(
			i.rotation.controller = rotation_list ();
			i.rotation.controller.enabled.controller = rotation_list ();
			i.rotation.controller.active = 2;
		);--for end
	);--undo end
	)--end
	
	on scbScaBt pressed do
	(
	undo on(
		for i in selection do
		(
			i.scale.controller = scale_list ();
			i.scale.controller.delete 1;
		);--for end
	);--undo end
	)--end
	
	on scbScaOffsetBt pressed do
	(
	undo on(
		for i in selection do
		(
			i.scale.controller = scale_list ();
			i.scale.controller.enabled.controller = scale_list ();
			i.scale.controller.active = 2;
		);--for end
	);--undo end
	)--end


	