/**
 * -----------------------------------------------------------------------------
 *
 * SJTools poly utility
 *
 * -----------------------------------------------------------------------------
 * @license MIT
 * @author CaptainHansode 半袖船長
 * @web http://www.sakaiden.com/
 * @email sakaiden@live.jp
 * @git https://github.com/CaptainHansode/SJTools
 *
 * ポリゴンユーティリティ
 *
 */
struct SJPolyUtil
(
    /**
    * 重複面の取得
    */
    function getOverlappedFacies obj =
    (
        local facies = #();
        local ovrFacies = #{};
        for i=1 to (polyop.getNumFaces obj) do (
            local cpos = polyop.getFaceCenter obj i;

            cpos.x = SJCmnUtil.decimalPointTruncation cpos.x 2;
            cpos.y = SJCmnUtil.decimalPointTruncation cpos.y 2;
            cpos.z = SJCmnUtil.decimalPointTruncation cpos.z 2;
            local result = appendIfUnique facies cpos;
            if result == false then (
                append ovrFacies i;
            )
        )
        return ovrFacies;
    ),

    /**
    * 重複面削除
    */
    function deleteOverlappedFacies obj =
    (
        local delFacies = grpPolyUtil.getOverlappedFacies obj;
        if delFacies.isEmpty == false then (
            polyop.deleteFaces obj delFacies;
        )
    )

)
