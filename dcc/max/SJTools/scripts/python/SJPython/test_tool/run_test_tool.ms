
function LauncherFile = 
(
	ms_path = getFilenamePath(getThisScriptFilename());
	sys = python.import("sys");
	exists_path = False;
	for i=1 to sys.path.count do (
		if (sys.path[i] == ms_path) do (
			exists_path = True;
			print("path exists")
			exit;
		)
		
	)
	if (exists_path == False) do (
		print("add path");
		sys.path.append(ms_path);
	)
	python.ExecuteFile (ms_path + @"\test_tools.py");
)

LauncherFile();
