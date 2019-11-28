function RunPyFile = 
(
	ms_path = getFilenamePath(getThisScriptFilename());
	sys = python.import("sys");
    sys.path.append(ms_path);
	python.ExecuteFile (ms_path + @"\test_tools.py");
)

RunPyFile();
