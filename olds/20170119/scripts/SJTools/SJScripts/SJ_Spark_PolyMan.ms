/*******************************************************
System J Tools 
********************************************************
Name:SJ_Spark_PolyMan.ms
Created By:CaptainHansode
WEB:www.sakaiden.com
E-Mail:sakaiden@live.jp
*******************************************************/
	group "簡易ポリゴン管理"
	(
		button countPAndVBt "ポリゴン頂点カウント" width:160 hight:20
		button fiveGonSelectBt "5角形以上を選択" width:160 hight:20
/*
		button nearTagClearBt "クリア" width:160 hight:20
		button doppelLinkerBt "ドッペルリンカー" width:160 hight:20
		button nearSearchTagBt "一番近くのオブジェクトにリンク" width:160 hight:20
		button nearSearchTagCPBt "近に位置コンストレイント" width:160 hight:20
		checkbox posOffsetOLChk "オフセット" align:#left
		button nearSearchTagCRBt "近に回転コンストレイント" width:160 hight:20
		checkbox rotOffsetOLChk "オフセット" align:#left
*/
	)
--////////////////////////////////////////////////
--ポリゴンカウント
--////////////////////////////////////////////////	
	on countPAndVBt pressed do
	(
		Local myMesh = undefined, totalFaces = 0, totalVerts = 0;
		for i in selection do
		(
			myMesh = snapshotAsMesh i;
			messageBox(i.name+"\n" + (myMesh.faces.count as String) + "\n" + (myMesh.verts.count as String)) title:"Count stats";
			totalFaces += myMesh.faces.count;
			totalVerts +=  myMesh.verts.count;
			delete myMesh;
		);--for end
			messageBox("Total\n" + (totalFaces as String) + "\n" + (totalVerts as String)) title:"Count stats";

	);--end
--////////////////////////////////////////////////
--確保
--////////////////////////////////////////////////
	on fiveGonSelectBt pressed do
	(
	Local selectBitArray = #{};
		for i in selection do
		(
			--Edit_Polyだった場合に
			if classOf i.baseobject != Editable_Poly then
			(
				 if (queryBox ("編集可能ポリゴンではありません\nすぐに編集可能ポリゴンに変換しますか？")title:"メッセージ") then
				 (
				 	convertto i editable_poly;
				 )else();--if end
			)else
			(
				for j = 1 to i.faces.count do
				(
					if (polyOp.getFaceDeg i j) >= 5 then append selectBitArray j;
				);--for end
				
			--最後に選択
			--print selectBitArray
			if (selectBitArray.numberSet != 0) then
			(
			try(
				i.EditablePoly.SetSelection #Face selectBitArray;
				--messageBox(i.name + "に5角形以上のポリゴンは\n" + (i.selectedFaces.count as String) + "  ポリゴンありました")title:"メッセージ";
				messageBox(i.name + "に5角形以上のポリゴンは\n" + (selectBitArray.numberSet as String) + "  ポリゴンありました")title:"メッセージ";
			)catch(messageBox(i.name + "のポリゴン選択に失敗しました")title:"メッセージ");--try end
			)else(messageBox("5角形以上のポリゴンはありません")title:"メッセージ");--if end
			
			);--if end
		
			selectBitArray = #{};
			
		);--for end
	);--end
