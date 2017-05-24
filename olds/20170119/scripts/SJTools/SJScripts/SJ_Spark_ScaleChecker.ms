/*******************************************************
System J Tools 
********************************************************
Name:SJ_Spark_PolyMan.ms
Created By:CaptainHansode
WEB:www.sakaiden.com
E-Mail:sakaiden@live.jp
*******************************************************/
	group "Scale Checker"
	(
		button scaleCheckBt "スケールチェック" width:160 hight:20
	)
	
-----------------------------------------------------------------------------------------------------------
-- 以下処理
-----------------------------------------------------------------------------------------------------------
	on scaleCheckBt pressed do
	(
		with redraw off
		(--再描画禁止
  
			searchTime = animationRange.end - animationRange.start;
			sT = animationRange.start;
			eT = animationRange.end;
			currentScale = undefined;
			falseScale = [0,0,0];
			falseScaleObjects = #();
  
			--Local obj = box pos:[0,0,0];
  
			for k = sT to eT do
			(
			for i in objects do
			(		
				--代価
				--animate off (at time k obj.transform = i.transform);
				
				--一端代入
				currentScale = (at time k i.scale);
				
				if ((currentScale == falseScale)) then
				(
					append falseScaleObjects i;
				);
				--print falseScale;
				--print (at time k i.scale);
				--print i
				--print k
				
				);--for end
				);--for end
				
				--delete obj;
				
				if falseScaleObjects.count != 0 do
				(
					messageBox "スケールが不正なオブジェクトがありました";
					select falseScaleObjects;
				);--if end
				);--end redraw

	);--end


