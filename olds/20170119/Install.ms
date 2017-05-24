/*******************************************************
System J Tools 
********************************************************
Name:SJ_Install
Created By:CaptainHansode
WEB:www.sakaiden.com
E-Mail:sakaiden@live.jp
*******************************************************/
(
-----------------------------------------------------------------------------------------------------------
-- グローバル周り
-----------------------------------------------------------------------------------------------------------
--ロールアウト用
global sj_install_rol
--Version etc
Local nameAndVersion = "SJ Tools Install"
Local prosCount= 1
Local errorMesStr = "";
-----------------------------------------------------------------------------------------------------------
-- Rollouts
-----------------------------------------------------------------------------------------------------------
try(cui.FloatDialogBar sj_install_rol)catch()
try(cui.unRegisterDialogBar sj_install_rol)catch()
try( CloseRolloutFloater sj_install_rol) catch()
try(destroydialog sj_install_rol)catch()

rollout sj_install_rol "" width:452 height:300
(
-----------------------------------------------------------------------------------------------------------
-- ファンクション
-----------------------------------------------------------------------------------------------------------
	fn installTest_fn =
	(
		return true;
	);
-----------------------------------------------------------------------------------------------------------
-- ファンクション
-----------------------------------------------------------------------------------------------------------
	fn install_fn =
	(
		local  installErrorMes = "
ディレクトリを生成できませんでした!
アクセスが制限されている可能性があります
詳しくは下記のURLを参照してください
http://www.sakaiden.com/?p=10778

インストールを中断します

Install Error!

"
			--なぜかこっちは$指定のパス、意味はない
			--ファイルを削除する
			print "削除しています Delete"
		
			--try(
				
				--スクリプト本体
				files = getFiles "$max\scripts\SJTools\*.*";
				for i in files do deleteFile i;
					
				files = getFiles "$max\scripts\SJTools\SJScripts\*.*";
				for i in files do deleteFile i;
					
				files = getFiles "$max\scripts\SJTools\Images\*.*";
				for i in files do deleteFile i;
				
				--プラグイン
				files = getFiles "$max\plugins\SJTools\*.*";
				for i in files do deleteFile i;

				--スタートアッププラグイン
				files = getFiles "$max\stdplugs\stdscripts\SJTools\*.*";
				for i in files do deleteFile i;
				
				/************************************
				max2010 - 2012旧アイコンファイル
				*************************************/
				--マクロ
				deleteFile "$ui\macroscripts\SJTools.mcr";
				--アイコン
				deleteFile "$ui\Icons\SJTools_Icon_16a.bmp";
				deleteFile "$ui\Icons\SJTools_Icon_16i.bmp";
				deleteFile "$ui\Icons\SJTools_Icon_24a.bmp";
				deleteFile "$ui\Icons\SJTools_Icon_24i.bmp";
				
				/************************************
				max2013旧アイコンファイル
				*************************************/
				--マクロ
				deleteFile ("$max\Macroscripts\SJTools.mcr");
				--各言語
				deleteFile ("$max\ja-JP\MacroScripts\SJTools.mcr.res");
				deleteFile ("$max\de-DE\MacroScripts\SJTools.mcr.res");
				deleteFile ("$max\en-US\MacroScripts\SJTools.mcr.res");
				deleteFile ("$max\fr-FR\MacroScripts\SJTools.mcr.res");
				deleteFile ("$max\ko-KR\MacroScripts\SJTools.mcr.res");
				deleteFile ("$max\zh-CN\MacroScripts\SJTools.mcr.res");
				
				--アイコン
				deleteFile ("$max\UI_ln\Icons\SJTools_Icon_16a.bmp");
				deleteFile ("$max\UI_ln\Icons\SJTools_Icon_16i.bmp");
				deleteFile ("$max\UI_ln\Icons\SJTools_Icon_24a.bmp");
				deleteFile ("$max\UI_ln\Icons\SJTools_Icon_24i.bmp");
				--Dark用
				deleteFile ("$max\UI_ln\IconsDark\SJTools_Icon_16a.bmp");
				deleteFile ("$max\UI_ln\IconsDark\SJTools_Icon_16i.bmp");
				deleteFile ("$max\UI_ln\IconsDark\SJTools_Icon_24a.bmp");
				deleteFile ("$max\UI_ln\IconsDark\SJTools_Icon_24i.bmp");
				
				/************************************
				max2010 - 2012
				*************************************/
				--マクロ
				deleteFile "$ui\macroscripts\SJTools.mcr";
				--アイコン
				deleteFile "$ui\Icons\SJTools_Icon01_16a.bmp";
				deleteFile "$ui\Icons\SJTools_Icon01_16i.bmp";
				deleteFile "$ui\Icons\SJTools_Icon01_24a.bmp";
				deleteFile "$ui\Icons\SJTools_Icon01_24i.bmp";
				deleteFile "$ui\Icons\SJTools_Icon02_16a.bmp";
				deleteFile "$ui\Icons\SJTools_Icon02_16i.bmp";
				deleteFile "$ui\Icons\SJTools_Icon02_24a.bmp";
				deleteFile "$ui\Icons\SJTools_Icon02_24i.bmp";
				
				/************************************
				max2013
				*************************************/
				--マクロ
				deleteFile ("$max\Macroscripts\SJTools.mcr");
				--アイコン
				deleteFile ("$max\UI_ln\Icons\SJTools_Icon01_16a.bmp");
				deleteFile ("$max\UI_ln\Icons\SJTools_Icon01_16i.bmp");
				deleteFile ("$max\UI_ln\Icons\SJTools_Icon01_24a.bmp");
				deleteFile ("$max\UI_ln\Icons\SJTools_Icon01_24i.bmp");
				deleteFile ("$max\UI_ln\Icons\SJTools_Icon02_16a.bmp");
				deleteFile ("$max\UI_ln\Icons\SJTools_Icon02_16i.bmp");
				deleteFile ("$max\UI_ln\Icons\SJTools_Icon02_24a.bmp");
				deleteFile ("$max\UI_ln\Icons\SJTools_Icon02_24i.bmp");
				--Dark用
				deleteFile ("$max\UI_ln\IconsDark\SJTools_Icon01_16a.bmp");
				deleteFile ("$max\UI_ln\IconsDark\SJTools_Icon01_16i.bmp");
				deleteFile ("$max\UI_ln\IconsDark\SJTools_Icon01_24a.bmp");
				deleteFile ("$max\UI_ln\IconsDark\SJTools_Icon01_24i.bmp");
				deleteFile ("$max\UI_ln\IconsDark\SJTools_Icon02_16a.bmp");
				deleteFile ("$max\UI_ln\IconsDark\SJTools_Icon02_16i.bmp");
				deleteFile ("$max\UI_ln\IconsDark\SJTools_Icon02_24a.bmp");
				deleteFile ("$max\UI_ln\IconsDark\SJTools_Icon02_24i.bmp");
				
		--	)catch()
			
			
			
				/************************************
				max2010 - 2013
				*************************************/
			print "ファイルをコピーしています"
			--エラー対策
			Local errorFlag = true;
			Local errorMesStr = undefined ;
			Local errorCheck = #();
			
			--ファイルをコピーする
				--スクリプト本体
				dir = getDir #scripts
				--ディレクトリを作る
				errorFlag = makeDir (dir + "\SJTools");
				--ディレクトリの生成に失敗している場合は、書き込み権限がないと判断する
				if (errorFlag == false ) do errorMesStr = "Error Make Dir Scripts/SJTools\n";
				--コピー、ディレクトリ生成に失敗している場合はコピーも失敗する
				files = getFiles "$temp\SJTools_temp\Scripts\SJTools\*.*";
				for i in files do copyFile i (dir + "\SJTools\\" + (getFileNameFile i) + (getFileNameType i));
					
				--Sparkなどのインクルード式スクリプト
				dir = getDir #scripts
				--ディレクトリを作る
				errorFlag = makeDir (dir + "\SJTools\SJScripts");
				--ディレクトリの生成に失敗している場合は、書き込み権限がないと判断する
				if (errorFlag == false ) do errorMesStr += "Error Make Dir Scripts/SJTools/SJScripts\n";
				--実際のコピー
				files = getFiles "$temp\SJTools_temp\Scripts\SJTools\SJScripts\*.*";
				for i in files do copyFile i (dir + "\SJTools\SJScripts\\" + (getFileNameFile i) + (getFileNameType i));
					
				--image
				dir = getDir #scripts
				--ディレクトリを作る
				errorFlag = makeDir (dir + "\SJTools\Images");
				--ディレクトリの生成に失敗している場合は、書き込み権限がないと判断する
				if (errorFlag == false ) do errorMesStr += "Error Make Dir Scripts/SJTools/Images\n";
				--コピー
				files = getFiles "$temp\SJTools_temp\Scripts\SJTools\Images\*.*";
				for i in files do copyFile i (dir + "\SJTools\Images\\" + (getFileNameFile i) + (getFileNameType i));
					
			--プラグイン
				--スクリプト本体
				dir = getDir #maxroot
				--ディレクトリを作る
				errorFlag = makeDir (dir + "\plugins\SJTools");
				--ディレクトリの生成に失敗している場合は、書き込み権限がないと判断する
				if (errorFlag == false ) do errorMesStr += "Error Make Dir plugins/SJTools\n";
				--コピー
				files = getFiles "$temp\SJTools_temp\Plugins\SJTools\*.*";
				for i in files do copyFile i (dir + "\plugins\SJTools\\" + (getFileNameFile i) + (getFileNameType i));
					
			--スタートアップ
				--スクリプト本体
				dir = getDir #maxroot
				--ディレクトリを作る
				errorFlag = makeDir (dir + "\stdplugs\stdscripts\SJTools");
				--ディレクトリの生成に失敗している場合は、書き込み権限がないと判断する
				if (errorFlag == false ) do errorMesStr += "Error Make Dir stdplugs/stdscripts/SJTools\n\n";
				--コピー
				files = getFiles "$temp\SJTools_temp\stdplugs\stdscripts\SJTools\*.*";
				for i in files do copyFile i (dir + "\stdplugs\stdscripts\SJTools\\" + (getFileNameFile i) + (getFileNameType i));
					
				/************************************
				強制的なエラーストップ
				*************************************/
				if errorMesStr != undefined do
				(
					--messageBox (errorMesStr + installErrorMes) title:"Install Error!!"
					prosCount = -1;
					
					return false;--return();
				);--if end					
					
				/************************************
				max2010 - 2012
				*************************************/
				--マクロ
				dir = getDir #maxroot;
				copyFile "$temp\SJTools_temp\MacroScripts\SJTools.mcr" (dir + "ui\macroscripts\SJTools.mcr");
				
				/************************************
				max2013
				*************************************/
				--マクロ
				dir = getDir #maxroot;
				copyFile "$temp\SJTools_temp\MacroScripts\SJTools.mcr" (dir + "\MacroScripts\SJTools.mcr");
					
				/************************************
				max2011-2012
				アイコン
				*************************************/				
				dir = getDir #maxroot;
				--tempファイルからではなくコピー済みのディレクトリからコピー
				copyFile "$max\scripts\SJTools\Images\SJTools_Icon01_16i.bmp" (dir + "ui\icons\SJTools_Icon01_16i.bmp");
				copyFile "$max\scripts\SJTools\Images\SJTools_Icon02_16i.bmp" (dir + "ui\icons\SJTools_Icon02_16i.bmp");
				copyFile "$max\scripts\SJTools\Images\SJTools_Icon01_24i.bmp" (dir + "ui\icons\SJTools_Icon01_24i.bmp");
				copyFile "$max\scripts\SJTools\Images\SJTools_Icon02_24i.bmp" (dir + "ui\icons\SJTools_Icon02_24i.bmp");
				copyFile "$max\scripts\SJTools\Images\SJTools_Icon01_16a.bmp" (dir + "ui\icons\SJTools_Icon01_16a.bmp");
				copyFile "$max\scripts\SJTools\Images\SJTools_Icon02_16a.bmp" (dir + "ui\icons\SJTools_Icon02_16a.bmp");
				copyFile "$max\scripts\SJTools\Images\SJTools_Icon01_24a.bmp" (dir + "ui\icons\SJTools_Icon01_24a.bmp");
				copyFile "$max\scripts\SJTools\Images\SJTools_Icon02_24a.bmp" (dir + "ui\icons\SJTools_Icon02_24a.bmp");
				
				/************************************
				max2013
				アイコン
				*************************************/
				--マクロ
				dir = getDir #maxroot;
				--tempファイルからではなくコピー済みのディレクトリからコピー
				--アイコン
				copyFile "$max\scripts\SJTools\Images\SJTools_Icon01_16i.bmp" (dir + "\UI_ln\Icons\SJTools_Icon01_16i.bmp");
				copyFile "$max\scripts\SJTools\Images\SJTools_Icon02_16i.bmp" (dir + "\UI_ln\Icons\SJTools_Icon02_16i.bmp");
				copyFile "$max\scripts\SJTools\Images\SJTools_Icon01_24i.bmp" (dir + "\UI_ln\Icons\SJTools_Icon01_24i.bmp");
				copyFile "$max\scripts\SJTools\Images\SJTools_Icon02_24i.bmp" (dir + "\UI_ln\Icons\SJTools_Icon02_24i.bmp");
				copyFile "$max\scripts\SJTools\Images\SJTools_Icon01_16a.bmp" (dir + "\UI_ln\Icons\SJTools_Icon01_16a.bmp");
				copyFile "$max\scripts\SJTools\Images\SJTools_Icon02_16a.bmp" (dir + "\UI_ln\Icons\SJTools_Icon02_16a.bmp");
				copyFile "$max\scripts\SJTools\Images\SJTools_Icon01_24a.bmp" (dir + "\UI_ln\Icons\SJTools_Icon01_24a.bmp");
				copyFile "$max\scripts\SJTools\Images\SJTools_Icon02_24a.bmp" (dir + "\UI_ln\Icons\SJTools_Icon02_24a.bmp");
				--Dark用
				copyFile "$max\scripts\SJTools\Images\SJTools_Icon01_16i.bmp" (dir + "\UI_ln\IconsDark\SJTools_Icon01_16i.bmp");
				copyFile "$max\scripts\SJTools\Images\SJTools_Icon02_16i.bmp" (dir + "\UI_ln\IconsDark\SJTools_Icon02_16i.bmp");
				copyFile "$max\scripts\SJTools\Images\SJTools_Icon01_24i.bmp" (dir + "\UI_ln\IconsDark\SJTools_Icon01_24i.bmp");
				copyFile "$max\scripts\SJTools\Images\SJTools_Icon02_24i.bmp" (dir + "\UI_ln\IconsDark\SJTools_Icon02_24i.bmp");
				copyFile "$max\scripts\SJTools\Images\SJTools_Icon01_16a.bmp" (dir + "\UI_ln\IconsDark\SJTools_Icon01_16a.bmp");
				copyFile "$max\scripts\SJTools\Images\SJTools_Icon02_16a.bmp" (dir + "\UI_ln\IconsDark\SJTools_Icon02_16a.bmp");
				copyFile "$max\scripts\SJTools\Images\SJTools_Icon01_24a.bmp" (dir + "\UI_ln\IconsDark\SJTools_Icon01_24a.bmp");
				copyFile "$max\scripts\SJTools\Images\SJTools_Icon02_24a.bmp" (dir + "\UI_ln\IconsDark\SJTools_Icon02_24a.bmp");
					
			--アイコン、スクリプトをロード
			colorman.reInitIcons();
			
			macros.load((getDir #maxroot) + "\plugins\*.ms");
			macros.load((getDir #maxroot) + "\plugins\\");
			macros.load((getDir #maxroot) + "\stdplugs\stdscripts\SJTools\*.*");
			macros.load((getDir #maxroot) + "\stdplugs\stdscripts\SJTools\\");
			macros.load(getDir #ui);
			
			--2011-2012
			try(macros.load("$ui\macroscripts\\"))catch();
			--2013-
			try(macros.load((getDir #maxroot) + "\Macroscripts\\"))catch();
				
			--一時ファイルを掃除
			print "一時ファイルを削除"
				files = getFiles "$temp\SJTools_temp\Scripts\SJTools\*.*";
				for i in files do deleteFile i;
				files = getFiles "$temp\SJTools_temp\Scripts\SJTools\SJScripts\*.*";
				for i in files do deleteFile i;
				files = getFiles "$temp\SJTools_temp\Scripts\SJTools\Images\*.*";
				for i in files do deleteFile i;
				files = getFiles "$temp\SJTools_temp\Plugins\SJTools\*.*";
				for i in files do deleteFile i;			
				files = getFiles "$temp\SJTools_temp\stdplugs\stdscripts\SJTools\*.*";
				for i in files do deleteFile i;
				files = getFiles "$temp\SJTools_temp\MacroScripts\*.*";
				for i in files do deleteFile i;
				files = getFiles "$temp\SJTools_temp\*.*";
				for i in files do deleteFile i;
					
				
			print "完了 Complate"
			
			return true;
	);--fn end
-----------------------------------------------------------------------------------------------------------
-- インストール案内
-----------------------------------------------------------------------------------------------------------
	fn installGuide_fn = 
	(
		local rol = sj_install_rol;
		if (prosCount == 1) then
		(
			-----------------------------------------------------------------------------------------------------------
			--案内1
			-----------------------------------------------------------------------------------------------------------
			rol.mesLbl.text = "SJTools をダウンロードして頂きありがとうございます!
ツールをインストールしますか?

Thank you download this SJTools.
Continue installation?";
		
			--rol.backBt.caption = "aa"
			rol.backBt.pos = [-200,-200];
			--rol.instEdt.pos = [-200,-200];
			rol.instLbx.pos = [-200,-200]
			rol.mesLbl.pos = [25,68];
			rol.nextBt.caption = "次へ Next"
			
		)else if (prosCount == 2) then
		(
			-----------------------------------------------------------------------------------------------------------
			--案内2
			-----------------------------------------------------------------------------------------------------------
			/*
			rol.instEdt.text = "ご使用にあたり
			
			
このプラグインの使用によって
いかなる問題が生じた場合も、著作者はその責任を負いません。
バージョンアップや不具合に対する対応の責任も負わないものとします。

二次配布はご遠慮ください。
万が一、二次で配布されたこのプラグインを
使用して問題が生じても、著作者はその責任を負いません。
			
			
Upon use

			
Through the use of this plug-in
Even if there is any problem, the author is not responsible for it.
I shall not be liable for failure to respond to or upgrade.

Please refrain from the secondary distribution.
This plug-in that was distributed by any chance, in the secondary
Even if there is a problem using the author is not responsible for it.
			";*/
			
			local mesList = #();
			append mesList "ご使用にあたり  Precautions for use";
			append mesList "";
			append mesList "";			
			append mesList "このプラグインの使用によって";
			append mesList "いかなる問題が生じた場合も、著作者はその責任を負いません。";
			append mesList "バージョンアップや不具合に対する対応の責任も負わないものとします。";
			append mesList "";
			append mesList "改変や二次配布はご遠慮ください。";
			append mesList "万が一、二次配布されたこのプラグインを";
			append mesList "使用して問題が生じても、著作者はその責任を負いません。";
			append mesList "また、改変されたコードを使用して問題が生じても";
			append mesList "著作者はその責任を負いません。";
			append mesList "";
			append mesList "Through the use of this plug-in";
			append mesList "Even if there is any problem, the author is not responsible for it.";
			append mesList "I shall not be liable for failure to respond to or upgrade.";
			append mesList "";			
			append mesList "Please refrain from the secondary distribution.";
			append mesList "This plug-in that was distributed by any chance, in the secondary";
			append mesList "Even if there is a problem using the author is not responsible for it.";
			append mesList "";
			
			rol.mesLbl.pos = rol.instLinkA.pos = rol.instLinkB.pos = rol.instLinkC.pos = [-200,-200];
			--rol.instEdt.pos = [20,64];
			rol.instLbx.pos = [20,65];
			rol.backBt.pos = [120,252];
			rol.instLbx.items = mesList;
			
			rol.nextBt.caption = "同意 I Agree"

		)else if (prosCount == 3) then
		(
			-----------------------------------------------------------------------------------------------------------
			--案内3
			-----------------------------------------------------------------------------------------------------------
			rol.mesLbl.text = "Windows8でのご注意  Note in Windows8
			
Windows8の場合、ツールや3dsMaxにエラーが発生する可能性があります。
エラーが出る場合は、幾つか設定をする必要があります。
			
If Windows8, there is a possibility that the error occurs in 3dsMax.
If an error occurs, it is necessary to set several.";
			
			--ユーザーアカウントの制御の設定
		
			--rol.backBt.caption = "aa"
			--rol.backBt.pos = [-200,-200];
			--rol.instEdt.pos = [-200,-200];
			rol.instLbx.pos = [-200,-200]
			rol.mesLbl.pos = [25,68];
			rol.nextBt.caption = "次へ Next"
			
			rol.instLinkA.pos = [25,172];
			rol.instLinkB.pos = [25,185];
			rol.instLinkC.pos = [25,198];
		)else if (prosCount == 4) then
		(
			-----------------------------------------------------------------------------------------------------------
			--案内4
			-----------------------------------------------------------------------------------------------------------
			rol.mesLbl.text = "旧バージョンのファイルを削除します
現在の設定ファイルなどは失われますのでご注意下さい
インストールを続行しますか?

Remove the old version of the file.
Please note that will be lost the current configuration file.
Continue installation?";
			
			rol.instLinkA.pos = rol.instLinkB.pos = rol.instLinkC.pos = [-200,-200];
		)else if (prosCount == 5) then
		(
			-----------------------------------------------------------------------------------------------------------
			--案内5インストール
			-----------------------------------------------------------------------------------------------------------
			rol.backBt.pos = rol.nextBt.pos = rol.cancelBt.pos = [-200,-200]
			
			rol.mesLbl.text = "インストールしています。
しばらくお待ちください。
			
Start Installation.
Please wait.";
			
			
			
			if (install_fn()) then
			(
				--インストール成功
rol.mesLbl.text = "インストールが完了しました!
メインメニューにSJToolsを登録しますか?

Install complete.
Create a Main menu?";
				
				 rol.yesBt.pos = [224,252];
				 rol.noBt.pos = [328,252];
				/*
				--rol.backBt.pos = [120,252];
				rol.cancelBt.caption = "終了 Exit"
				rol.nextBt.caption = "はい Yes"
				rol.nextBt.pos = [224,252];
				rol.cancelBt.pos = [328,252];
				*/
			)else
			(
				--インストール失敗
			rol.mesLbl.text = "ディレクトリを生成できませんでした!  Install Error!
インストールを中断します。 Stop Installation.
				
アクセスが制限されている可能性があります
Windows8の場合、ツールや3dsMaxにエラーが発生する可能性があります。
エラーが出る場合は、幾つか設定をする必要があります。
";
				rol.instLinkA.pos = [25,172];
				rol.instLinkB.pos = [25,185];
				rol.instLinkC.pos = [25,198];
				
				rol.cancelBt.caption = "終了 Exit"
				rol.cancelBt.pos =[328,252];
			);--if end
			
		)else if (prosCount == 6) then
		(
			-----------------------------------------------------------------------------------------------------------
			--案内6
			-----------------------------------------------------------------------------------------------------------
			/*
ツールの設定画面を開きますか?

Do you open Customize User Interface?
*/
			rol.mesLbl.text = "インストール後はMaxの再起動をお願い致します。

Please, Reboot 3dsMax.

			
			
ツールバーなどへの登録は
[カスタマイズ] --> [ユーザインタフェースをカスタマイズ] から行います。
			
Registration to conduct such a toolbar
from the [Customize] --> [Customize User Interface].
	"
				rol.yesBt.pos = [-200,-200];
				rol.noBt.pos = [-200,-200];
				rol.cancelBt.caption = "終了 Exit"
				rol.cancelBt.pos =[328,252];
		)else 
		(
			-----------------------------------------------------------------------------------------------------------
			--案内エラー
			-----------------------------------------------------------------------------------------------------------
			rol.mesLbl.text = "インストールに失敗しました。
ディレクトリーを作成できません。
			
Start Installation.";
			
			rol.backBt.pos = rol.nextBt.pos = rol.cancelBt.pos = [-200,-200]
			rol.cancelBt.caption = "終了 Exit"
			rol.cancelBt.pos =[328,252];
		);--if end
		
	);--fn end
	

-----------------------------------------------------------------------------------------------------------
-- メニューバー関連
-----------------------------------------------------------------------------------------------------------
	fn installMenu_fn = 
	(
			--すでにメニューが合った場合は削除する
			try(
				--メニューはあるか？
				myMenu = menuMan.findMenu "SJTools";
				--メニューを削除
				menuMan.unRegisterMenu myMenu;
			)catch();

			--まず登録用のIDを用意しておく、IDが何かとかぶっていると登録できない
			myContextId = genClassID returnValue:true;
			
			try(

			--メニューIDを登録しながら作成
				if menuMan.registerMenuContext myContextId[1] then
				(
				--メインメニューを取得
				local mainMenuBar = menuMan.getMainMenuBar();
				
				--メインメニューに新しい項目をを作成する
				local subMenu = menuMan.createMenu "SJTools";
				--メニューにアクションを追加する
				local testItem = menuMan.createActionItem "SJ_PBake" "SJTools";
				--作ったアイテムを先のメニューに追加する
				subMenu.addItem testItem -1;					
				testItem = menuMan.createActionItem "SJ_Renamer" "SJTools";
				subMenu.addItem testItem -1;					
				testItem = menuMan.createActionItem "SJ_Selector" "SJTools";
				subMenu.addItem testItem -1;					
				testItem = menuMan.createActionItem "SJ_Time_Machine" "SJTools";
				subMenu.addItem testItem -1;					
				testItem = menuMan.createSeparatorItem()
				subMenu.addItem testItem -1;
					
					
				testItem = menuMan.createActionItem "SJ_LayerLayer" "SJTools";
				subMenu.addItem testItem -1;			
				testItem = menuMan.createActionItem "SJ_Spark" "SJTools";
				subMenu.addItem testItem -1;
				testItem = menuMan.createActionItem "SJ_Bio_Skin_Plus" "SJTools";
				subMenu.addItem testItem -1;
				testItem = menuMan.createActionItem "SJ_Key_Machine" "SJTools";
				subMenu.addItem testItem -1;
				testItem = menuMan.createSeparatorItem()
				subMenu.addItem testItem -1;
				
				testItem = menuMan.createActionItem "SJ_Hider" "SJTools";
				subMenu.addItem testItem -1;
				testItem = menuMan.createActionItem "SJ_Scene_Slicer" "SJTools";
				subMenu.addItem testItem -1;
				testItem = menuMan.createActionItem "SJ_Roller" "SJTools";
				subMenu.addItem testItem -1;
				testItem = menuMan.createActionItem "SJ_AnimKey_Preview" "SJTools";
				subMenu.addItem testItem -1;
				testItem = menuMan.createSeparatorItem()
				subMenu.addItem testItem -1;
				
				testItem = menuMan.createActionItem "SJ_Adjuster" "SJTools";
				subMenu.addItem testItem -1;
				testItem = menuMan.createActionItem "SJ_Poser" "SJTools";
				subMenu.addItem testItem -1;
				testItem = menuMan.createSeparatorItem()
				subMenu.addItem testItem -1;
				
				testItem = menuMan.createActionItem "SJ_Language_Setting" "SJTools";
				subMenu.addItem testItem -1;
				testItem = menuMan.createActionItem "SJ_Icon_Setting" "SJTools";
				subMenu.addItem testItem -1;
				
				--そのメニューをサブメニューとして作成する
				local subMenuItem = menuMan.createSubMenuItem "SJTools" subMenu;
				
				--メニュー追加用にメインメニューのindexを取得しておく
				local subMenuIndex = mainMenuBar.numItems() - 1;
				
				--メニューをメインメニューに追加
				mainMenuBar.addItem subMenuItem subMenuIndex;
				
				--更新
				menuMan.updateMenuBar();
				);--if end
				
			)catch(
				--messageBox"メニュー追加に失敗しました\n\nFailed to add menu..." title:"Confirmation"
				--return false;
				);
				
			return true;
	);--fn end
		
-----------------------------------------------------------------------------------------------------------
-- Layout
-----------------------------------------------------------------------------------------------------------
	GroupBox instGrp "" pos:[8,8] width:437 height:282
	label instLbl "SJ Tools Install" pos:[191,32] width:72 height:24
	GroupBox instMesGrp "" pos:[18,56] width:417 height:174
	listbox instLbx "" items:#() pos:[-200,-200] width:413 height:12 readOnly:true --listbox instLbx "" items:#() pos:[20,65] width:412 height:12
	--edittext instEdt "" pos:[-200,-200] width:417 height:164 readOnly:true--editText instEdt "" pos:[16,64] width:417 height:164;
	
	label mesLbl "" pos:[25,68] width:396 height:152--editText instEdt "" pos:[16,64] width:417 height:164;
	
	button backBt "戻る Back" pos:[120,252] width:104 height:24--	button backBt "戻る Back" pos:[224,252] width:104 height:24;
	button nextBt "次へ Next" pos:[224,252] width:104 height:24
	button cancelBt "キャンセル Cancel" pos:[328,252] width:104 height:24
	
	button yesBt "はい Yes" pos:[-200,-200] width:104 height:24
	button noBt "いいえ No" pos:[-200,-200] width:104 height:24	


hyperLink instLinkA "詳しくはこちらをご覧ください。http://wp.me/pyh1l-2NQ\nDescription of setting\n" pos:[-200,-200]  color:(color 248 123 0) hoverColor:(color 33 144 255) address:"http://www.sakaiden.com/?p=10778"
	hyperLink instLinkB "ファイルのアクセス権限の設定" pos:[-200,-200] color:(color 248 123 0) hoverColor:(color 33 144 255) address:"http://www.youtube.com/watch?feature=player_embedded&v=S-EsH55m0AA" pos:[28,252] ;
	hyperLink instLinkC "ユーザーアカウントの制御の設定"pos:[-200,-200] color:(color 248 123 0) hoverColor:(color 33 144 255) address:"http://www.youtube.com/watch?feature=player_embedded&v=t6mli9dtMag" pos:[28,252] ;

	on sj_install_rol open do
	(
		installGuide_fn();
	);
	on backBt pressed do
	(
		prosCount -= 1;
		installGuide_fn();
	);
	on nextBt pressed do
	(
		prosCount += 1;
		installGuide_fn();
	);
	on yesBt pressed do
	(
		prosCount += 1;
		installMenu_fn();
		installGuide_fn();
	);
	on noBt pressed do
	(
		prosCount += 1;
		installGuide_fn();
	);	
	on cancelBt pressed do
	(
		try(cui.FloatDialogBar sj_install_rol)catch()
		try(cui.unRegisterDialogBar sj_install_rol)catch()
		try( CloseRolloutFloater sj_install_rol) catch()
		try(destroydialog sj_install_rol)catch()
	);
)
--end rollout
-----------------------------------------------------------------------------------------------------------
-- End of rollout & Create Dialog / Floater
-----------------------------------------------------------------------------------------------------------
CreateDialog sj_install_rol style:#(#style_border, /*#style_titlebar,*/#style_toolwindow, #style_sysmenu, /*#style_resizing*/ #style_minimizebox);

);--end