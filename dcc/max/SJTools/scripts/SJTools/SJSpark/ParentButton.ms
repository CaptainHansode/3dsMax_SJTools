/*******************************************************
System J Tools 
********************************************************
Name:SJ_Spark_ParentButton
Created By:CaptainHansode
WEB:www.sakaiden.com
E-Mail:sakaiden@live.jp
*******************************************************/
	group "Maya風親子づけボタン"
	(
		button setParentBt "ペアレント" width:160 hight:20
		button cutParentBt "カット" width:160 hight:20
		label parentButtonLbl "2番目以降の選択物を親子づけ" width:160 align:#center
	)
--////////////////////////////////////////////////
--setParentBt
--////////////////////////////////////////////////
	on setParentBt pressed do
	(
		if (selection.count > 1) do
		(

		for i=2 to selection.count do
		(
			try(selection[i].parent = selection[1])catch(print "Fail");
		);
		);--if end
	)--
	
--////////////////////////////////////////////////
--cutParentBt
--////////////////////////////////////////////////
	on cutParentBt pressed do
	(
		if (selection.count != 0) do
		(
		for i in selection do
		(
			try(i.parent = undefined)catch();
		);
		);--if end
	);--end