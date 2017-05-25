/**
 * -----------------------------------------------------------------------------
 *
 * SJ Tools
 *
 * -----------------------------------------------------------------------------
 * @license MIT
 * @author CaptainHansode 半袖船長
 * @web http://www.sakaiden.com/
 * @email sakaiden@live.jp
 * @github https://github.com/CaptainHansode/SJTools
 *
 */
group "簡易プロサウンド管理"
(
    button soundCntAllDelBt "全サウンドを削除" width:160  hight:20
    button soundCntSaveBt "サウンド設定を保存" width:160  hight:20
    button soundCntLoadBt "サウンド設定を開く" width:160  hight:20
)

on soundCntAllDelBt pressed do
(
    --変数
    local sndCount = 0;

    --アクティブか?
    if (prosound.isActive()) then
    (
        sndCount = prosound.NumTracks();
        --サウンドトラックを全部削除
        for i = 1 to sndCount do
        (
            prosound.delete 1;
        )
    )
    --初期化
    ProSound.Init(true);
)


on soundCntSaveBt pressed do
(
    --変数
    local sndCount = 0;

    --アクティブか?
    if (prosound.isActive()) then
    (
        --forループ回数を設定
        sndCount = prosound.NumTracks();
        --保存は全設定を書き出す
        local saveFile = getSaveFileName types:"Setting File (*.txt)|*.txt|All(*.*)|*.*" caption:"サウンド設定を保存";
        --保存ファイルが設定されていれば
        if saveFile != undefined do
        (
            --保存ファイルを作成
            saveFileList = createFile saveFile;

            --トラックの数を書き出し
            format "%\n" sndCount to:saveFileList;

                --サウンドトラック設定を書き出し
                for i = 1 to sndCount do
                (
                    --上から順にファイル、エンド時間、スタート時間
                    format "%\n" (prosound.name i) to:saveFileList;
                    format "%\n" (prosound.end i) to:saveFileList;
                    format "%\n" (prosound.start i) to:saveFileList;
                )
            --ファイルを閉じる
            close saveFileList
        )
    )
)

on soundCntLoadBt pressed do
(
    --まず一旦初期化してから実行する
    ProSound.Init(true);

    --変数
    local sndCount = 0;

    --アクティブか?
    if (prosound.isActive()) then
    (
        --最後のものはサウンドファイルがあるかチェックする
        local loadItemCount = 0, checkFile = true;
        local loadFile = getOpenFileName types:"Setting File (*.txt)|*.txt|All(*.*)|*.*" caption:"サウンド設定を開く";

        if loadFile != undefined do
        (
            --ファイルを取得
            loadFileList = openFile loadFile;

            --最初の1行に読み込む回数が書かれている
            loadItemCount = readValue loadFileList;

            for i=1 to loadItemCount do
            (
                --リターン値である評価を入れる、失敗ならfalse
                checkFile = prosound.append (( readLine loadFileList ) as String);

                if checkFile then
                (
                    --追加した最後のIDのファイルを設定するので、1ループおきに最後のIDを入れる
                    sndCount = prosound.NumTracks();
                    --設定はエンドタイムから
                    prosound.Setend sndCount (readValue loadFileList);
                    prosound.Setstart sndCount (readValue loadFileList);
                    --prosound.shift sndCount (readValue loadFileList);
                )else(
                    --2行分の読み込み結果は破棄
                    sndCount = readValue loadFileList;
                    sndCount = readValue loadFileList;
                )
            )
            close loadFileList
        )
    )
)
