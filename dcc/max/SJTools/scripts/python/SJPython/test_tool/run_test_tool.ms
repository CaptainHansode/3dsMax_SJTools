-- local cmd = "echo F| xcopy /Y \"" + map.filename + "\" \"" + new_path + "\""
/*
cmd = "echo A"
ret = HiddenDOSCommand cmd exitCode:&exitcode;
ret = ShellLaunch "explorer.exe" @"..\test";
for i =1 to symbolicPaths.numPaths() do
(
	format "% : %\n" i (symbolicPaths.getPathName i);
	format "% : %\n" i (symbolicPaths.getPathValue i)
)
*/
function LauncherFile = 
(
	ms_path = getFilenamePath(getThisScriptFilename());
	print(ms_path);
	sys = python.import("sys");
    sys.path.append(ms_path);
	python.ExecuteFile (ms_path + @"\test_tools.py");
)

LauncherFile();
