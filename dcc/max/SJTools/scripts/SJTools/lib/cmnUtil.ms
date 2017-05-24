/**
 * -----------------------------------------------------------------------------
 *
 * SJTools common utility
 *
 * -----------------------------------------------------------------------------
 * @license MIT
 * @author CaptainHansode 半袖船長
 * @web http://www.sakaiden.com/
 * @email sakaiden@live.jp
 * @git https://github.com/CaptainHansode/SJTools
 *
 * 汎用ユーティリティ
 *
 */
struct SJCmnUtil
(
    /**
     * 拡張子なしのファイル名
     */
    function getSceneNameWithoutExtention = (
        fileName = (FilterString maxFileName ".")[1];
        if fileName == undefined do (
            fileName = "";
        )
        return fileName;
    ),

    /**
    * 小数点切り捨て
    */
    function decimalPointTruncation num digit =
    (
        digit = 0.1 * (pow 10 digit);
        return floor (num * digit) / digit;
    ),

    /**
    * 百分率
    * max値に対して現在何%なのか返す
    */
    function percentage maxVal cntVal =
    (
        return floor ((100.0 / maxVal) * cntVal);
    ),

    /**
    * ゼロ埋め
    */
    function zeroPadding num dig =
    (
        local zero = "0";
        for i=0 to dig do (
            zero = zero + "0";
        )
        result = zero + (num as String);
        local s = (result.count - dig) + 1;
        return substring result s -1;
    ),

    /**
    * undefined削除
    */
    function deleteUndefinedInArray inArray =
    (
        relust = #();
        for i in inArray do (
            if i != undefined do (
                append relust i;
            )
        )
        return relust;
    ),

    /**
    * get all
    */
    function getAllObjects =
    (
        return for i in objects collect i;
    ),

    /**
    * 構造全部を取得
    */
    function getBranch obj =
    (
        --変数を準備
        local objRoot = obj;
        local objectBranch = #(); -- 回収した子供
        local checkObj = undefined; -- チェックするオブジェクト
        local checkChildren = #(); -- チェックするオブジェクトの配列

        --選択したものの階層をさかのぼり、親オブジェクトが無くなったら回収
        while objRoot.parent != undefined do
        (
            objRoot = objRoot.parent;
        )

        append objectBranch objRoot;

        -- 初期回収
        for i =1 to objRoot.children.count do
        (
            append checkChildren objRoot.children[i];
            append objectBranch objRoot.children[i];
        )

        -- 0になるまで繰り返す
        numChild = objRoot.children.count;
        while numChild != 0 do
        (
            checkObj = checkChildren[numChild];
            -- チェック用配列からのおしりから削除
            deleteItem checkChildren numChild;
            numChild -= 1;
            -- 子はあるか？
            if (checkObj.children.count != 0) then
            (
                numChild += checkObj.children.count;--カウントアップ
                for i =1 to checkObj.children.count do
                (
                    append checkChildren checkObj.children[i];
                    append objectBranch checkObj.children[i];
                )
            )
        )
        return objectBranch;
    ),

    /**
    * 全部のbip
    */
    function getAllBip =
    (
        local bips = #();
        allBips = #();
        for i in objects do (
            if ((classOf i) == Biped_Object) do (
                appendIfUnique bips i.controller.rootNode;
            )
        )
        for i in bips do (
            join allBips (SJCmnUtil.getBranch i);
        )
        return allBips;
    ),

    /**
    * 全カメラオブジェクトを取得
    */
    function getAllCamera =
    (
        local allObj = SJCmnUtil.getAllObjects();
        cameraList = #();
        local typeList = #(Freecamera,
                           Physical,
                           Targetcamera,
                           VRayDomeCamera,
                           VRayPhysicalCamera
                           );
        for obj in allObj do
        (
            if findItem typeList (classOf obj) != 0 do (
                append cameraList obj;
            )
        )
        return cameraList;
    ),

    /**
    * 全ライトゲット
    */
    function getAllLight =
    (
        local allObj = SJCmnUtil.getAllObjects();
        lightList = #();
        -- なが！、なんか他に方法あった気が・・・
        local typeList = #(Target_Light,
                           Free_Light,
                           mr_Sky_Portal,
                           Sun_Positioner,
                           targetSpot,
                           freeSpot,
                           TargetDirectionallight,
                           Directionallight,
                           Omnilight,
                           Skylight,
                           miAreaLightomni,
                           miAreaLight,
                           VRayLight,
                           VRayIES,
                           VRayAmbientLight,
                           VRaySun
                           );
        for obj in allObj do
        (
            if findItem typeList (classOf obj) != 0 do (
                append lightList obj;
            )
        )
        return lightList;
    )
)
