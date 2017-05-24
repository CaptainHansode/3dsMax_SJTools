/*******************************************************
System J Tools 
********************************************************
Name:SJ_Spark_AllBeyondArrayCheck
Created By:CaptainHansode
WEB:www.sakaiden.com
E-Mail:sakaiden@live.jp
*******************************************************/

	group "Text to Editable Mesh"
	(
		button t2EMeshBt "テキスト2メッシュ" width:160 hight:20
	)
	
	on t2EMeshBt pressed do
	(
		undo on(
		for i in selection do
		(
			if classOf i.baseobject == text do
			(
				maxOps.CollapseNode i on
				convertTo i TriMeshGeometry
			);--if end
		);--for end
		);--undo end
	);
