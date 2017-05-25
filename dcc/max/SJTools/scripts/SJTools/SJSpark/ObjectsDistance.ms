/*******************************************************
System J Tools 
********************************************************
Name:SJ_Spark_ObjectsDistance.ms
Created By:CaptainHansode
WEB:www.sakaiden.com
E-Mail:sakaiden@live.jp
*******************************************************/
	group "Objects Distance"
	(
	button parentDistanceBt "親からの距離" width:160 height:20
	button measureObjectsBt "メジャー"  width:160 height:20
	)
	
	on parentDistanceBt pressed do
	(
	Local myFlag = false;
	if queryBox ("結果をメッセージボックスで表示しますか?") then myFlag = true;
	for i in selection do
	(
		Local parentObj = i.parent
		if parentObj != undefined then
		(
			myValue = distance i i.parent
			print (i.name + "  -->  " + i.parent.name + "の距離は  " + myValue as String + " ")
			print myValue;
			print "\n";
			if myFlag then messageBox (i.name + "  -->  " + i.parent.name + "の距離は  " + myValue as String + " ");
		)else(
			print ("親はありません\nポジションは  "+(i.pos as String))
			print "\n"
			if myFlag then messageBox ("親はありません\nポジションは  "+(i.pos as String));
		)--if end
	)--for end
	)--end
	
	on measureObjectsBt pressed do
	(
		if selection.count != 0 then
		(
			Local myObj = selection[1];
			Local targetObj = PickObject count:1 select:true message:"オブジェクトを選択してください。" Rubberband:selection[1].pos rubberBandColor:[0,0,0] ForceListenerFocus:False
			if targetObj != undefined then
			(
			myValue = distance myObj targetObj
			if queryBox ("結果をメッセージボックスで表示しますか?") then
			(
				print (myObj.name + "  -->  " + targetObj.name + "の距離は  " + myValue as String + " ")
				print myValue;
				print "\n"
				messageBox (myObj.name + "  -->  " + targetObj.name + "の距離は  " + myValue as String + " ");
			)else(
				print (myObj.name + "  -->  " + targetObj.name + "の距離は  " + myValue as String + " ")
				print myValue;
				print "\n"
			);--if end	
			);--ifend
		)else(messageBox("オブジェクトを選択してください"));--if end
	)