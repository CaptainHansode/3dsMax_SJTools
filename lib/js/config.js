/**
* -----------------------------------------------------------------------------
*
*  Config jsx
*
* -----------------------------------------------------------------------------
* (c) Copyright 2018 SAKAIDEN and CaptainHansode. All rights reserved.
* @License MIT
* @Auther 半袖船長
* @Web http://www.sakaiden.com
* @Email sakaiden@live.jp
*
*/


/**
 * @CommonConfig
 */
function CommonConfig(fpath, fname, default_data)
{
    /**
     * @include
     */
    var tools_current = Folder.startup.fsName + "\\Scripts\\GrpTools";
    var import_list = [
        "\\lib\\JSON4Jsx.js"
    ]
    for (var i=0; i<import_list.length; i++) {
        $.evalFile(tools_current + import_list[i]);
    }

    var fpath = fpath || Folder.myDocuments.fsName;
    var fname = fname || "config.json";
    var default_data = default_data || {};

    this.name = "Configer";
    this.path = [fpath, fname].join("\\");
    this.data = default_data;
    this.JSONForJsx = new JSON4Jsx();


    /**
     * 設定保存
     */
    this.Save = function()
    {
        var fileObj = new File(this.path);
        var ret = fileObj.open("w");
        if (ret) {
            fileObj.write(this.JSONForJsx.stringify(this.data));
            fileObj.close();
        } else {
            alert("ファイルが開けませんでした");
        }
    }

    /**
     * コンフィグ読み込み
     */
    this.Load = function()
    {
        var fileObj = new File(this.path);
        if (fileObj.exists == false) {
            this.CreateConfigDir();
        }
        var ret = fileObj.open("r");
        if (ret) {
            this.data = this.JSONForJsx.parse(fileObj.read());
            fileObj.close();
        } else {
            alert("ファイルが開けませんでした");
        }
    }

    /**
     * コンフィグ用のフォルダ作成
     */
    this.CreateConfigDir = function()
    {
        var fpath = this.path;
        var dirPath = fpath.split("\\");
        dirPath = dirPath.slice(0, dirPath.length - 1).join("\\");

        var folderObj = new Folder(dirPath);
        try {
            var flag = folderObj.create();
            if (flag) {
                result = true;
            }
        } catch(e) {
            alert(e.message)
        }

        var fileObj = new File(fpath);
        if (fileObj.exists == false) {
            this.Save();
        }
        return;
    }
}
