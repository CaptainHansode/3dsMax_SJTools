/*******************************************************
System J Tools 
********************************************************
Name:SJ_Language_Settig
Created By:CaptainHansodea
WEB:www.sakaiden.com
E-Mail:sakaiden@live.jp
*******************************************************/
-----------------------------------------------------------------------------------------------------------
-- 言語初期化
-----------------------------------------------------------------------------------------------------------
--基本言語ファイル
Local language = getINISetting ("$scripts/SJTools/SJTools.ini") "SJTools" "Language";

--パスの切り分け
if  (language == "JP") then
(
	--日本語
	Local languageFilePath = "$scripts/SJTools/SJTools_JP.ini";
)else(
	--日本語以外は基本英語
	Local languageFilePath = "$scripts/SJTools/SJTools_EN.ini";
);

--全てのツールで共通の文字列

Local MesseTitleInfoStr = (getINISetting(languageFilePath) "SJ_Tools_Common" "MesseTitleInfoStr");
Local MesseTitleWngStr = (getINISetting(languageFilePath) "SJ_Tools_Common" "MesseTitleWngStr");
Local MesseTitleCtnStr = (getINISetting(languageFilePath) "SJ_Tools_Common" "MesseTitleCtnStr");
Local MesseTitleErrStr = (getINISetting(languageFilePath) "SJ_Tools_Common" "MesseTitleErrStr");
Local MesseTitleChkStr = (getINISetting(languageFilePath) "SJ_Tools_Common" "MesseTitleChkStr");

--iniの改行コードを使いたい場合はexecuteをつかい、さらにiniは"を二重に設置する
Local MesseCmnErrStr = (getINISetting(languageFilePath) "SJ_Tools_Common" "MesseCmnErrStr");
Local MesseCmnChkStr = (getINISetting(languageFilePath) "SJ_Tools_Common" "MesseCmnChkStr");
Local MesseCmnFileErrStr = execute(getINISetting(languageFilePath) "SJ_Tools_Common" "MesseCmnFileErrStr");
Local MesseCmnProgStr = (getINISetting(languageFilePath) "SJ_Tools_Common" "MesseCmnProgStr");