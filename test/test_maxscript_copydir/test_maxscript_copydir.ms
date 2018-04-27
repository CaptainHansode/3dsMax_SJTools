
fromPath = "D:\\test";
toPath = "D:\\test_copy";

-- ファイルであればcopyFileで問題なし ただし事前にコピー先消しておくこと
-- copyFile fromPath toPath;

/**
 * pythonを使う shutil.copytreeは既にディレクトリがあるとコピー失敗する
 * distutilsはコピーしたものの一覧を返してくれる
 */
function CopyDirByPy fromPath toPath =
(
    if (doesFileExist toPath) then (
        distutils = python.Import("distutils.dir_util");
        distutils.copy_tree fromPath toPath;
    ) else (
        shutil = python.Import("shutil");
        shutil.copytree fromPath toPath;
    )
)

/**
 * コマンドとxcopyを使う
 */
function CopyDirByCmd fromPath toPath =
(
    -- 上書きでなく完全一致させるならrobocopyを使っちゃう
    cmd = "echo D| xcopy /Y /E \"" \
        + fromPath \
        + "\" \"" \
        + toPath \
        + "\"";
    HiddenDOSCommand cmd donotwait:false;
)

-- CopyDirByPy fromPath toPath;
CopyDirByCmd fromPath toPath;