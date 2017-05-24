/*******************************************************
System J Tools 
********************************************************
Name:SJ_Spark_DummyBoxSizeChange
Created By:CaptainHansode
WEB:www.sakaiden.com
E-Mail:sakaiden@live.jp
*******************************************************/
	group "ダミーの大きさを変更"
	(
		button dummySizeChangeBt "サイズ変更" width:160 hight:20
		spinner dummySizeSpn "サイズ:" range:[0,01e+009,1] type:#float width:160 align:#center
	);
	
	on dummySizeChangeBt pressed do
	(
		try(
			for i in selection do i.boxsize = [dummySizeSpn.value,dummySizeSpn.value,dummySizeSpn.value];
		)catch();
	);