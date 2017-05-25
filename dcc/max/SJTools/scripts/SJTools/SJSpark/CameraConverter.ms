/*******************************************************
System J Tools 
********************************************************
Name:SJ_Spark_CameraConverter.ms
Created By:CaptainHansode
WEB:www.sakaiden.com
E-Mail:sakaiden@live.jp
*******************************************************/

	group "Camera Converter"
	(
		button bakeFovBt "Fov�A�j����Plot" width:160
		
		button hTovFovBt "Fov�𐂒��l�Œu��" width:160
		
		button fovToFocalLengthBt "�œ_������Bake" width:160
		label CamConvLbl01 "�ݒ�͐����ŃA�p�[�`���[�� 1 : 1 " width:160 align:#center
	)

--////////////////////////////////////////////////
--bakeFov
--////////////////////////////////////////////////
	on bakeFovBt pressed do
	(

	ccPointA = undefined;
	ccPointB = undefined;

	undo on
	(
	suspendEditing()--�T�X�y���h���[�h
	with redraw off
	(--�ĕ`��֎~

	Local tempFrameRange = AnimationRange.end - AnimationRange.start;
	Local tempFrame = #();
	append tempFrame AnimationRange.start;
	for i = 1 to tempFrameRange do append tempFrame (AnimationRange.start + i);
	
	for i in selection do
	(
			if (classOf i.baseobject == Targetcamera) or (classOf i.baseobject == Freecamera) and (i.fov.controller != undefined) then
			(
			ccPointA = Point pos:[0,0,0];
			ccPointB = Point pos:[0,0,0];
			
				ccPointA.rotation.controller.X_Rotation.controller = copy i.fov.controller;
				
				for k in tempFrame do
				(
				animate on (at time k ccPointB.transform = ccPointA.transform);
				);--for end
				
				i.fov.controller = Copy ccPointB.rotation.controller.X_Rotation.controller;
				
			delete ccPointA;
			delete ccPointB;
	ccPointA = undefined;
	ccPointB = undefined;
			);--if end
		);--fpr end

	);--redraw off
	ResumeEditing();
	);--undo on
	);--end

--////////////////////////////////////////////////
--horizen to verocity bake
--////////////////////////////////////////////////
	on hTovFovBt pressed do
	(
	Local V = 0, Fl = 0, r_aspect = ( renderWidth as float )/( renderHeight as float );
	Local allssObj = #();
	
	ccPointA = undefined;
	ccPointB = undefined;

	undo on
	(
	suspendEditing()--�T�X�y���h���[�h
	with redraw off
	(--�ĕ`��֎~

	Local tempFrameRange = AnimationRange.end - AnimationRange.start;
	Local tempFrame = #();
	append tempFrame AnimationRange.start;
	for i = 1 to tempFrameRange do append tempFrame (AnimationRange.start + i);
		
		for i in selection do
		(
			if (classOf i.baseobject == Targetcamera) or (classOf i.baseobject == Freecamera) and (i.fov.controller != undefined) then
			(
			
			ccPointA = Point pos:[0,0,0];
			ccPointB = Point pos:[0,0,0];
			
				ccPointA.rotation.controller.X_Rotation.controller = copy i.fov.controller;
				
				for k in tempFrame do
				(
				
				--////////////////////////////////////////////////
				--�v�Z��

				--�����ݒ�ɕύX
				V = 2.0*atan( tan((at time k ccPointA.rotation.x_rotation)/2.0) * r_aspect );
				
				--Fl = (1/(tan(V/2.0)/25.4))*0.5;
				animate on (at time k ccPointB.rotation.controller.X_Rotation = V);
				);--for end
				
				i.fov.controller = Copy ccPointB.rotation.controller.X_Rotation.controller;
				
			delete ccPointA;
			delete ccPointB;
	ccPointA = undefined;
	ccPointB = undefined;
			
			);--if end
		);--for end

	);--redraw off
	ResumeEditing();
	);--undo on
	);--end

--////////////////////////////////////////////////
--fovToFocalLengthBt
--////////////////////////////////////////////////
	on fovToFocalLengthBt pressed do
	(
	Local V = 0, Fl = 0, r_aspect = ( renderWidth as float )/( renderHeight as float );
	Local allssObj = #();

	ccPointA = undefined;
	ccPointB = undefined;

	undo on
	(
	suspendEditing()--�T�X�y���h���[�h
	with redraw off
	(--�ĕ`��֎~

	Local tempFrameRange = AnimationRange.end - AnimationRange.start;
	Local tempFrame = #();
	append tempFrame AnimationRange.start;
	for i = 1 to tempFrameRange do append tempFrame (AnimationRange.start + i);
		
		for i in selection do
		(
			if (classOf i.baseobject == Targetcamera) or (classOf i.baseobject == Freecamera) and (i.fov.controller != undefined) then
			(
			
			ccPointA = Point pos:[0,0,0];
			ccPointB = Point pos:[0,0,0];
			ccPointB.name = i.name+"_ConvFocalLength"
			
				ccPointA.rotation.controller.X_Rotation.controller = copy i.fov.controller;
				
				for k in tempFrame do
				(
				
				--////////////////////////////////////////////////
				--�v�Z��

				--�����ݒ�ɕύX
				V = 2.0*atan( tan((at time k ccPointA.rotation.x_rotation)/2.0) / r_aspect );
				
				--ForcalLength��
				Fl = (1/(tan(V/2.0)/25.4))*0.5;
				animate on (at time k ccPointB.pos.x = Fl);
				);--for end
				
				--i.fov.controller = Copy ccPointB.rotation.controller.X_Rotation.controller;
				
			delete ccPointA;
			--delete ccPointB;
			append allssObj ccPointB;
			
	ccPointA = undefined;
	ccPointB = undefined;
	
			);--if end
			
			
		);--for end

		select allssObj;

	);--redraw off
	ResumeEditing();
	);--undo on
	);--end