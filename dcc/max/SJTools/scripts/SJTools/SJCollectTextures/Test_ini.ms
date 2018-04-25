    function GetMyDocPath =
    (
        speFld = dotNetClass "System.Environment+specialFolder";
        sysEnv = dotNetClass "System.Environment";
        return sysEnv.getfolderPath speFld.MyDocuments;
    )

    function SetIniPath =
    (
        iniFilePath = GetMyDocPath() \
                + "\\SJTools" \
				+ "\\config" \
                + "\\SJCollectTextures" \
                + "\\SJCollectTextures.ini";
		if (doesFileExist iniFilePath) == False do (
			makeDir (getFilenamePath iniFilePath);
			copyFile "SJCollectTextures.ini" iniFilePath;
		)
    )
SetIniPath()
	