/**
 * 重複面の削除テスト
 */


/**
 * 小数点切り捨て
 */
function decimalPointTruncation num digit =
(
    digit = 0.1 * (pow 10 digit);
    return floor (num * digit) / digit;
)


/**
* 重複面の取得
*/
function getOverlappedFacies obj =
(
    local facies = #();
    local ovrFacies = #{};
    for i=1 to (polyop.getNumFaces obj) do (
        local cpos = polyop.getFaceCenter obj i;

        cpos.x = decimalPointTruncation(cpos.x, 2);
        cpos.y = decimalPointTruncation(cpos.y, 2);
        cpos.z = decimalPointTruncation(cpos.z, 2);
        local result = appendIfUnique facies cpos;
        if result == false then (
            append ovrFacies i;
        )
    )
    return ovrFacies;
)


/**
* 重複面削除
*/
function deleteOverlappedFacies obj =
(
    local delFacies = getOverlappedFacies(obj);
    if delFacies.isEmpty == false then (
        polyop.deleteFaces obj delFacies;
    )
)


getOverlappedFacies($);
deleteOverlappedFacies($);