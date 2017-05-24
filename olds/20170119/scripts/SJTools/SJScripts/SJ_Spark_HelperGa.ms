/*******************************************************
System J Tools 
********************************************************
Name:SJ_Spark_HelperGa
Created By:CaptainHansode
WEB:www.sakaiden.com
E-Mail:sakaiden@live.jp
*******************************************************/
	group "ヘルパーが ....."
	(
	button helperGaParentBt "親" width:160  hight:20
	button helperGaChildrenBt "子供" width:160 height:20
	button helperGaGroupBt "グループ" width:160 height:20
	)
	
	on helperGaParentBt pressed do
	(
	for i in selection do
	(
	local obj = Point pos:[0,0,0]
	obj.name = i.name + "_Parent"
	obj.parent = undefined
	
	obj.transform = i.transform
	obj.wirecolor = i.wirecolor
	i.parent = undefined
	i.parent = obj
	)--for end
	)
	
	on helperGaChildrenBt pressed do
	(
	for i in selection do
	(
	local obj = Point pos:[0,0,0]
	obj.name = i.name + "_Children"
	obj.transform = i.transform
	obj.parent = i
	)--for end
	)
	
	on helperGaGroupBt pressed do
	(
		if (selection.count != 0 ) do
		(
		local obj = Point pos:[0,0,0];
		obj.name = selection[1].name + "_Group";
		
		for i in selection do
		(
			i.parent = obj;
		)--for end
		);--if end
	)