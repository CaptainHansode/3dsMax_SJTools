/*******************************************************
System J Tools 
********************************************************
Name:SJ_Spark_AnimKeyDelete.ms
Created By:CaptainHansode
WEB:www.sakaiden.com
E-Mail:sakaiden@live.jp
*******************************************************/

	group "Delete All Keys"
	(
		button delOutRangeKeysBt "範囲外キーを削除" width:160
		label delAllKeysLdl1"Transform" width:160
		button delAllPosKeysBt "全ての位置キーを削除" width:160
		button delAllRotKeysBt "全ての回転キーを削除" width:160
		button delAllScanKeysBt "全てのスケールキーを削除" width:160
	)

--////////////////////////////////////////////////
--del
--////////////////////////////////////////////////
	on delOutRangeKeysBt pressed do
	(
		for i in objects do
		(
			--キー選択を解除	
			deselectKeys i;
			--範囲外のキーを選択
			selectkeys i (interval -100000 (animationRange.start-1));			
			--選択したキーを削除
			deleteKeys i #selection;
			
			--キー選択を解除	
			deselectKeys i;
			--範囲外のキーを選択
			selectkeys i (interval (animationRange.end+1) 100000);
			--選択したキーを削除
			deleteKeys i #selection;
		);--for end
	);--end
	
--////////////////////////////////////////////////
--del
--////////////////////////////////////////////////
	on delAllPosKeysBt pressed do
	(
		Local oldTransform = undefined;
		Local j = 0;
		try(
		for i in selection do
		(
		oldTransform = i.transform;
		j = i.pos.controller.keys.count;
		--キーカウントがなくなるまで
		--配列のお尻から削除
		while j > 0 do
		(
			deleteKey i.pos.controller.keys j;
			j -= 1;
		);--while end
		
		--transformを戻す
		i.transform = oldTransform;
		);--for end
		)catch()--try end
		/*
		--まず一度キーを適当なコントローラーに変え潰す
		$.pos.controller = Position_Expression ()
		--元に戻す
		$.pos.controller = Position_XYZ ()
		*/
	);--end

	on delAllRotKeysBt pressed do
	(
		Local oldTransform = undefined;
		Local j = 0;
		try(
		for i in selection do
		(
		oldTransform = i.transform;
		j = i.rotation.controller.keys.count;
		--キーカウントがなくなるまで
		--配列のお尻から削除
		while j > 0 do
		(
			deleteKey i.rotation.controller.keys j;
			j -= 1;
		);--while end
		i.transform = oldTransform;
		);--for end
		)catch()--try end
	);--end
	
	on delAllScanKeysBt pressed do
	(
		Local oldTransform = undefined;
		Local j = 0;
		
		try(
		for i in selection do
		(
		oldTransform = i.transform;
		j = i.scale.controller.keys.count;
		--キーカウントがなくなるまで
		--配列のお尻から削除
		while j > 0 do
		(
			deleteKey i.scale.controller.keys j;
			j -= 1;
		);--while end
		i.transform = oldTransform;
		);--for end
		)catch()--try end
	);--end