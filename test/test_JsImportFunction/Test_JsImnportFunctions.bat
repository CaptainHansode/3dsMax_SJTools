@if(0)==(0) ECHO OFF
rem �x���ݒ�
setlocal enabledelayedexpansion

cscript.exe //nologo //E:JScript "%~f0" %*

GOTO :EOF
@end

(function() {
/**-------------------------------------------------------------------------
 * �C���|�[�g
 */
var importRootPath = "F:\\Project_SJTools\\SJTools\\test\\test_JsImportFunction\\";
var importList = [
    importRootPath + "Test_functionsA.js",
    importRootPath + "Test_functionsB.js",
    importRootPath + "Test_functionsC.js"
];

var fso = WScript.CreateObject("Scripting.FileSystemObject");
for (i in importList) {
    eval(fso.OpenTextFile(importList[i], 1).ReadAll());
}

/**-------------------------------------------------------------------------
 *
 * @main
 *
 */
function main()
{
    // WScript.Sleep(1000);
    print("�O���֐��ǂݍ���");
    print("�����Z����" + testCal(5, 10));
    testSleep(3);
}

// run
main()

})();
