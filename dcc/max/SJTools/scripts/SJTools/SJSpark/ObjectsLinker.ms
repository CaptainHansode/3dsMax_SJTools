/*******************************************************
System J Tools 
********************************************************
Name:SJ_Spark_ObjectsLinker.ms
Created By:CaptainHansode
WEB:www.sakaiden.com
E-Mail:sakaiden@live.jp
*******************************************************/
	group "Objects Linker"
	(
		button nearGetTagBt "対象登録" width:160 hight:20
		button nearTagClearBt "クリア" width:160 hight:20
		button doppelLinkerBt "ドッペルリンカー" width:160 hight:20
		button nearSearchTagBt "一番近くのオブジェクトにリンク" width:160 hight:20
		button nearSearchTagCPBt "近に位置コンストレイント" width:160 hight:20
		checkbox posOffsetOLChk "オフセット" align:#left
		button nearSearchTagCRBt "近に回転コンストレイント" width:160 hight:20
		checkbox rotOffsetOLChk "オフセット" align:#left
	)
--////////////////////////////////////////////////
--確保
--////////////////////////////////////////////////
	on nearGetTagBt pressed do
	(
		NearSearchTagObj = for i in selection collect i;
		nearGetTagBt.caption = "登録済み";
	);--end
	on nearTagClearBt pressed do
	(
		NearSearchTagObj = #();
		nearGetTagBt.caption = "対象登録";
	)
--////////////////////////////////////////////////
--doppelLinker
--////////////////////////////////////////////////
	on doppelLinkerBt pressed do
	(
		Local dopObj, myObj = undifined;
	
	if selection.count != 0 then
	(
	if NearSearchTagObj != undefined then
	(
		for i in selection do
		(
			if i.parent != undefined then
			(
				dopObj = i.parent;
				i.parent = undefined;
				--再接続
				for k in NearSearchTagObj do
				(
					if k.name == dopObj.name then
					(
						if dopObj.inode.handle != k.inode.handle then i.parent = k;
					)--if end
				);--for end
			);--if end
		);--for end
	);--if end
	);--if end
	);--end

--////////////////////////////////////////////////
--実行
--////////////////////////////////////////////////
	on nearSearchTagBt pressed do
	(
	Local distanceA, distanceB, myObj = undifined;
	Local baseObj = selection[1];
	
	if NearSearchTagObj != undefined then
	(

	for k in selection do
	(
	 baseObj = k;
	 
		distanceA = distance baseObj NearSearchTagObj[1];
		myObj = NearSearchTagObj[1];

		--2移行距離が近ければ入れ替え
		for i = 2 to nearSearchTagObj.count do
		(
			distanceB = distance baseObj NearSearchTagObj[i];
			
			if distanceA > distanceB then
			(
				distanceA = distanceB;
				myObj = NearSearchTagObj[i];
			);--if end

		);--for end

		try(baseObj.parent = myObj)catch();

	);--for end

	);--if end
	
	)--on end
	
--////////////////////////////////////////////////
--コンストレイント
--////////////////////////////////////////////////
	on nearSearchTagCPBt pressed do
	(
	suspendEditing()--サスペンドモード
	--max create mode--クリエートモードに変更
	with redraw off
	(--再描画禁止
	
	Local distanceA, distanceB, myObj = undifined;
	Local baseObj = selection[1];
	if NearSearchTagObj != undefined then
	(

	for k in selection do
	(
	 baseObj = k;
	 
		distanceA = distance baseObj NearSearchTagObj[1];
		myObj = NearSearchTagObj[1];
		
		--2移行距離が近ければ入れ替え
		for i = 2 to nearSearchTagObj.count do
		(
			distanceB = distance baseObj NearSearchTagObj[i];
			if distanceA > distanceB then
			(
				distanceA = distanceB;
				myObj = NearSearchTagObj[i];
			);--if end
		);--for end

		--コンストレイントを実行
		try(
			baseObj.pos.controller = Position_XYZ ()--一旦リセット
			baseObj.pos.controller = position_list ();
			baseObj.pos.controller.enabled.controller = Position_Constraint ();
			baseObj.pos.controller.active = 2;
			baseObj.pos.controller.Position_Constraint.controller.appendTarget myObj 50.0
			if posOffsetOLChk.checked then baseObj.pos.controller.Position_Constraint.controller.relative = on
		)catch();

	);--for end

	);--if end
	
	
	)--with redraw end	
	resumeEditing()--再びアクティブに
	
	)--on end

--////////////////////////////////////////////////
--回転コンストレイント
--////////////////////////////////////////////////
	on nearSearchTagCRBt pressed do
	(
	suspendEditing()--サスペンドモード
	--max create mode--クリエートモードに変更
	with redraw off
	(--再描画禁止
	
	Local distanceA, distanceB, myObj = undifined;
	Local baseObj = selection[1];
	if NearSearchTagObj != undefined then
	(

	for k in selection do
	(
	 baseObj = k;
	 
		distanceA = distance baseObj NearSearchTagObj[1];
		myObj = NearSearchTagObj[1];
		
		--2移行距離が近ければ入れ替え
		for i = 2 to nearSearchTagObj.count do
		(
			distanceB = distance baseObj NearSearchTagObj[i];
			if distanceA > distanceB then
			(
				distanceA = distanceB;
				myObj = NearSearchTagObj[i];
			);--if end
		);--for end

		--コンストレイントを実行
		try(
			baseObj.rotation.controller = Euler_XYZ ();--一旦リセット
			baseObj.rotation.controller = rotation_list ();
			baseObj.rotation.controller.enabled.controller = Orientation_Constraint ();
			baseObj.rotation.controller.active = 2;
			baseObj.rotation.controller[2].controller.appendTarget myObj 50.0;
			if rotOffsetOLChk.checked then baseObj.rotation.controller[2].controller.relative = on;
		)catch();

	);--for end

	);--if end
	
	
	)--with redraw end	
	resumeEditing()--再びアクティブに
	
	)--on end
