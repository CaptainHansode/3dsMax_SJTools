function NewSaveAs =
(
    currentfile = maxFilepath + maxFileName;
    ret = getSaveFileName caption:"Save As" filename:currentfile types:".max" historyCategory:"MAXHistoryList";
    if ret == undefined do (
        return false;
    )
    if (findString ret ".max") == undefined do (
        ret = ret + ".max";
    )
    saveMaxFile ret;
)

NewSaveAs();
