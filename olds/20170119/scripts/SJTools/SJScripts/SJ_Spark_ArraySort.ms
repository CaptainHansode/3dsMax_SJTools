/*******************************************************
System J Tools 
********************************************************
Name:SJ_Spark_ArraySort.ms
Created By:CaptainHansode
WEB:www.sakaiden.com
E-Mail:sakaiden@live.jp
*******************************************************/
	group "選択内容をソート"
	(
		button sortByParentBt "親子順にソート" width:160
		button sortByNameBt "名前順でソート" width:160
	)


on sortByParentBt pressed do
(

if selection != 0 then
(
	
--階層構造を全て取得
Local myObjAll = #(), delIndex = undefined;
Local selObj = for i in selection collect i;
--Local selObj = selection;
Local objLevel = 1;

--////////////////////////////////////////////////
--配列を準備
--////////////////////////////////////////////////
for i = 1 to 256 do
(
	append myObjAll #();
);--for end

--プログレスバー
sj_functions.sj_progressBar_Fn()

--////////////////////////////////////////////////
--親がないオブジェクトを検索
--////////////////////////////////////////////////
for i in selObj do
(
	myObj = #();
	if i.parent == undefined then
	(
		append myObjAll[1] i;
	);
);--for end

--親の無いオブジェクトを配列から排除
for i in myObjAll do
(
	for k in i do
	(
		delIndex = findItem selObj k;
		deleteItem selObj delIndex;
	);--for end	
);--for end

--////////////////////////////////////////////////
--階層レベルを評価
--////////////////////////////////////////////////

--プログレス処理
Local progCountAll = selObj.count;
Local progCount = 1;

for i in selObj do
(
	sj_progressBar_rol.processInfo.caption =  "構造を評価しています   " + (floor(((100.0/progCountAll) * progCount))as String) + "%";
	sj_progressBar_rol.progbar.value = ((100.0/progCountAll) * progCount);
	progCount += 1;
	
	myObj = #();
	objLevel = 1;
	obj = i;

	while obj.parent != undefined do
	(
		obj = obj.parent
		objLevel += 1;
	)--while end

		append myObjAll[objLevel] i;
		
);--for end


--////////////////////////////////////////////////
--選択をし直し
--////////////////////////////////////////////////

clearSelection()

progCountAll = myObjAll.count;
progCount = 1;

for i in myObjAll do
(
	sj_progressBar_rol.processInfo.caption =  "再選択しています   " + (floor(((100.0/progCountAll) * progCount))as String) + "%";
	sj_progressBar_rol.progbar.value = ((100.0/progCountAll) * progCount);
	progCount += 1;
	
	if i.count != 0 then selectMore i
);--for end

try(destroydialog sj_progressBar_rol)catch()
print "選択終了";


);--if end

);--end


--////////////////////////////////////////////////
--名前で並び替え
--////////////////////////////////////////////////
on sortByNameBt pressed do
(

if selection != 0 then
(

--階層構造を全て取得
Local myObj = #(), myObjAfter = #();
Local selObjName = for i in selection collect i.name;
Local selObjIh = for i in selection collect i.inode.handle;

Local progCountAll = selObjName.count;
Local progCount = 1;
sj_functions.sj_progressBar_Fn()

--ソート
sort selObjName;

clearSelection()

--////////////////////////////////////////////////
--選択をし直し
--////////////////////////////////////////////////
for i in selObjName do
(
--プログレスバー
	sj_progressBar_rol.processInfo.caption =  "名前順にソートしています   " + (floor(((100.0/progCountAll) * progCount))as String) + "%";
	sj_progressBar_rol.progbar.value = ((100.0/progCountAll) * progCount);
	progCount += 1;

	--その名前のオブジェクトを回収
	myObj = getNodeByName i all:true;

	--iハンドルで名前の重複を確認
	for k in myObj do
	(
		--見つかれば
		if (findItem selObjIh k.inode.handle) != 0 then append myObjAfter k;
	);--for end

);--for end

--再選択
select myObjAfter;

try(destroydialog sj_progressBar_rol)catch()
print "選択終了";

);--if end

);--end

