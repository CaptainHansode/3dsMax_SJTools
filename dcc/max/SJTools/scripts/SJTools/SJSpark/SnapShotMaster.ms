/*******************************************************
System J Tools 
********************************************************
Name:SJ_Spark_SnapShotMaster
Created By:CaptainHansode
WEB:www.sakaiden.com
E-Mail:sakaiden@live.jp
*******************************************************/
	group "�X�i�b�v�V���b�g�}�X�^�["
	(
		button snapShotBt "�X�i�b�v�V���b�g!" width:160 hight:20
		button helperShotBt "�|�C���g�X�i�b�v�V���b�g" width:160 hight:20
		button selectShotBt "�Z���N�g�X�i�b�v�V���b�g" width:160 hight:20
		button mirrorSnapShotBt "�~���[�����O�X�i�b�v�V���b�g" width:160 hight:20
		radiobuttons ssTypeRb "" width:160 enabled:true labels:#("�|�C���g", "�I���W�i��") default:1 columns:2 align:#center
		label sSMLbl "�ݒ��YZ���ʃ~���[X�t���b�v" width:160 align:#center
		--checkbox sSTypePointCkb "�|�C���g"
		--checkbox sSTypeOriginalCkb "�I���W�i��"
	)
--////////////////////////////////////////////////
--snapShotBt
--////////////////////////////////////////////////
	on snapShotBt pressed do
	(
		Local allssObj = #();
		if sj_functions.sj_SelectCheck_Fn() do
		(
			for i in selection do
			(
			ssObj = Undefined
			ssObj = snapShot i
			ssObj.name = i.name + "_SnapShot";
			ssObj.parent = Undefined;
			ssObj.wirecolor = i.wirecolor;
			append allssObj ssObj;
			)--for end
			
			clearSelection()
			select allssObj;
		)--if end
	)--
	
--////////////////////////////////////////////////
--helperShotBt
--////////////////////////////////////////////////
	on helperShotBt pressed do
	(
		if sj_functions.sj_SelectCheck_Fn() do
		(
			
		Local allssObj = #();
		for i in selection do
		(
		Local obj = point pos:[0,0,0]
		obj.transform = i.transform
		obj.name = i.name+"_PointCopy"
		obj.wirecolor = i.wirecolor
		append allssObj obj;
		);--for end
			clearSelection()
			select allssObj;
		)--if end
	);--end


--////////////////////////////////////////////////
--selectShot
--////////////////////////////////////////////////
	on selectShotBt pressed do
	(
		if sj_functions.sj_SelectCheck_Fn() do
		(
		Local obj = for i in selection collect i;
		messageBox "�R�s�[��̑Ώۂ̃I�u�W�F�N�g��I�����Ă�������" title:"���b�Z�[�W"
		Local targetObj = PickObject count:1 select:true message:"�I�u�W�F�N�g��I�����Ă�������" ForceListenerFocus:False
		
		Local allssObj = #();
		
		if targetObj != undefined then
		(
		for i in obj do
		(
			copyTagObj = copy targetObj;
			copyTagObj.pos.controller = Position_XYZ ();
			copyTagObj.rotation.controller = Euler_XYZ ();
			copyTagObj.scale.controller = ScaleXYZ ();
			
			copyTagObj.transform = i.transform;		
			copyTagObj.name = i.name+"_SelectCopy";
			append allssObj copyTagObj;
		)--for end
		)--if end
			clearSelection()
			select allssObj;
		);--if end
	);--end

--////////////////////////////////////////////////
--Mirroring copy
--////////////////////////////////////////////////
	on mirrorSnapShotBt pressed do
	(
		if sj_functions.sj_SelectCheck_Fn() do
		(
		Local allssObj = #();
		
		for i in selection do
		(
			case ssTypeRb.state of
			(
				1:(Local obj = Point pos:[0,0,0]);
				2:(
					Local obj = copy i;
					obj.pos.controller = Position_XYZ ();
					obj.rotation.controller = Euler_XYZ ();
					obj.scale.controller = ScaleXYZ ();
				);
			)--case end
		
		obj.transform = i.transform;
		obj.name = i.name + "_Mirror";
		obj.parent = undefined;
		obj.wirecolor = i.wirecolor;
		append allssObj obj;
		
		obj.transform =
		  (
		  matrix3 \
		   [obj.transform[1][1],-obj.transform[1][2],-obj.transform[1][3]]\
		   [-obj.transform[2][1],obj.transform[2][2],obj.transform[2][3]]\
		   [-obj.transform[3][1],obj.transform[3][2],obj.transform[3][3]]\
		   [-obj.transform[4][1],obj.transform[4][2],obj.transform[4][3]]
		  )

		);--for end
			clearSelection()
			select allssObj;
		)--if end
	);