/*******************************************************
System J Tools 
********************************************************
Name:SJ_Spark_ParamerLinker.ms
Created By:CaptainHansode
WEB:www.sakaiden.com
E-Mail:sakaiden@live.jp
*******************************************************/
	group "Parameter Linker"
	(
		button paramLinkerBt "パラメーターリンカー" width:160 hight:20
		spinner paramLinkerSpn "" range:[1,54,1] type:#integer width:160 align:#center
		radiobuttons paramLinkerRb "" width:160 enabled:true labels:#("Pos", "Rot","Sca") default:1 columns:3 align:#center
	)

--////////////////////////////////////////////////
--確保
--////////////////////////////////////////////////
	on paramLinkerBt pressed do
	(
		
Local parameterLinkerStr1 = "
アトリビュートがあるオブジェクトを選んでください

通常、アトリビュートパラメーターは以下のようなプロパティになります
$.modifiers[#SJ_Attribute_Holder].params.**.controller
(**はパラメーター名)
上記の以外のパラメータにはリンクできません
	
"

Local parameterLinkerStr2 = "
対象オブジェクトを選択してください
パラメーターはベジエ実数でなければなりません
それ以外のパラメーターは貼り付けられません
	
"
		messageBox parameterLinkerStr1 title:"パラメーターオブジェクトを選択"
		Local pLinkerA = PickObject count:1 select:true message:"オブジェクトを選択してください。" ForceListenerFocus:False

		messageBox parameterLinkerStr2 title:"対象オブジェクトを選択"
		Local pLinkerB = PickObject count:1 select:true message:"オブジェクトを選択してください。" Rubberband:selection[1].pos rubberBandColor:white ForceListenerFocus:False

		Local pLinkerTagX = undefined, pLinkerTagY = undefined, pLinkerTagZ = undefined;

		case paramLinkerRb.state of
		(
			1:(
				pLinkerTagX = "$"+ pLinkerA.name +".modifiers[#SJ_Attribute_Holder].params.X" + (paramLinkerSpn.value as String) + ".controller"
				pLinkerTagY = "$"+ pLinkerA.name +".modifiers[#SJ_Attribute_Holder].params.Y" + (paramLinkerSpn.value as String) + ".controller"
				pLinkerTagZ = "$"+ pLinkerA.name +".modifiers[#SJ_Attribute_Holder].params.Z" + (paramLinkerSpn.value as String) + ".controller"
					try(pLinkerB.pos.controller.X_Position.controller = execute(pLinkerTagX))catch(messageBox"Xの貼り付けに失敗しました");
					try(pLinkerB.pos.controller.Y_Position.controller = execute(pLinkerTagY))catch(messageBox"Yの貼り付けに失敗しました");
					try(pLinkerB.pos.controller.Z_Position.controller = execute(pLinkerTagZ))catch(messageBox"Zの貼り付けに失敗しました");
			)--1end
			2:(
				pLinkerTagX = "$"+ pLinkerA.name +".modifiers[#SJ_Attribute_Holder].params.X" + (paramLinkerSpn.value as String) + ".controller"
				pLinkerTagY = "$"+ pLinkerA.name +".modifiers[#SJ_Attribute_Holder].params.Y" + (paramLinkerSpn.value as String) + ".controller"
				pLinkerTagZ = "$"+ pLinkerA.name +".modifiers[#SJ_Attribute_Holder].params.Z" + (paramLinkerSpn.value as String) + ".controller"
					try(pLinkerB.rotation.controller.X_Rotation.controller = execute(pLinkerTagX))catch(messageBox"Xの貼り付けに失敗しました");
					try(pLinkerB.rotation.controller.Y_Rotation.controller = execute(pLinkerTagY))catch(messageBox"Yの貼り付けに失敗しました");
					try(pLinkerB.rotation.controller.Z_Rotation.controller = execute(pLinkerTagZ))catch(messageBox"Zの貼り付けに失敗しました");
			)--2end
			3:(
				pLinkerTagX = "$"+ pLinkerA.name +".modifiers[#SJ_Attribute_Holder].params.X" + (paramLinkerSpn.value as String) + ".controller"
				pLinkerTagY = "$"+ pLinkerA.name +".modifiers[#SJ_Attribute_Holder].params.Y" + (paramLinkerSpn.value as String) + ".controller"
				pLinkerTagZ = "$"+ pLinkerA.name +".modifiers[#SJ_Attribute_Holder].params.Z" + (paramLinkerSpn.value as String) + ".controller"
					try(pLinkerB.scale.controller.X_Scale.controller = execute(pLinkerTagX))catch(messageBox"Xの貼り付けに失敗しました");
					try(pLinkerB.scale.controller.Y_Scale.controller = execute(pLinkerTagY))catch(messageBox"Yの貼り付けに失敗しました");
					try(pLinkerB.scale.controller.Z_Scale.controller = execute(pLinkerTagZ))catch(messageBox"Zの貼り付けに失敗しました");
			);--3end

		);--case end
		
		pLinkerA = undefined;
		pLinkerB = undefiend;
	);--end