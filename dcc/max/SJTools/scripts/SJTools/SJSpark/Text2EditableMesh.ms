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
group "Text to Editable Mesh"
(
    button t2EMeshBt "テキスト2メッシュ" width:160 hight:20
)

on t2EMeshBt pressed do
(
    undo on
    (
        for i in selection do
        (
            if classOf i.baseobject == text do
            (
                maxOps.CollapseNode i on
                convertTo i TriMeshGeometry
            )
        )
    )
)
