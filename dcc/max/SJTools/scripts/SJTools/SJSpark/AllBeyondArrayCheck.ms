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
group "全ての配列をチェック"
(
    button allBeyondArrayTestBt "全ての配列を確認" width:160
)
    on allBeyondArrayTestBt pressed do
    (
        --マスター
        for i=1 to $MasterSet.MasterNodes.count do
        (
        print i
        print $MasterSet.MasterNodes[i].node
        if isvalidnode $MasterSet.MasterNodes[i].node then
        (
        )
        else
        ()
        )

        --スキンオブジェクト
        for i=1 to $MasterSet.SkinObjectNodes.count do
        (
        print i
        print $MasterSet.SkinObjectNodes[i].node
        if isvalidnode $MasterSet.SkinObjectNodes[i].node then
        (
        )
        else
        ()
        )

        --その他
        for i=1 to $MasterSet.OtherNodes.count do
        (
        print i
        print $MasterSet.OtherNodes[i].node
        if isvalidnode $MasterSet.OtherNodes[i].node then
        (
        )
        else
        ()
        )

        --コントローラー
        for i=1 to $MasterSet.ControlNodes.count do
        (
        print i
        print $MasterSet.ControlNodes[i].node
        if isvalidnode $MasterSet.ControlNodes[i].node then
        (
        )
        else
        ()
        )

        --サブコントローラー表示非表示用、純粋にサブコントローラーノードのみ
        for i=1 to $MasterSet.SpineSubControlNodes.count do
        (
        print i
        print $MasterSet.SpineSubControlNodes[i].node
        if isvalidnode $MasterSet.SpineSubControlNodes[i].node then
        (
        )
        else
        ()
        )

        for i=1 to $MasterSet.NecSubControlNodes.count do
        (
        print i
        print $MasterSet.NecSubControlNodes[i].node
        if isvalidnode $MasterSet.NecSubControlNodes[i].node then
        (
        )
        else
        ()
        )

        for i=1 to $MasterSet.ArmSubControlNodes.count do
        (
        print i
        print $MasterSet.ArmSubControlNodes[i].node
        if isvalidnode $MasterSet.ArmSubControlNodes[i].node then
        (
        )
        else
        ()
        )

        for i=1 to $MasterSet.LegSubControlNodes.count do
        (
        print i
        print $MasterSet.LegSubControlNodes[i].node
        if isvalidnode $MasterSet.LegSubControlNodes[i].node then
        (
        )
        else
        ()
        )

        for i=1 to $MasterSet.Hand_RSubControlNodes.count do
        (
        print i
        print $MasterSet.Hand_RSubControlNodes[i].node
        if isvalidnode $MasterSet.Hand_RSubControlNodes[i].node then
        (
        )
        else
        ()
        )

        for i=1 to $MasterSet.Hand_LSubControlNodes.count do
        (
        print i
        print $MasterSet.Hand_LSubControlNodes[i].node
        if isvalidnode $MasterSet.Hand_LSubControlNodes[i].node then
        (
        )
        else
        ()
        )

        --デフォーム表示非表示用、純粋にデフォームに使うノードのみ
        for i=1 to $MasterSet.SpineDefNodes.count do
        (
        print i
        print $MasterSet.SpineDefNodes[i].node
        if isvalidnode $MasterSet.SpineDefNodes[i].node then
        (
        )
        else
        ()
        )

        for i=1 to $MasterSet.NecDefNodes.count do
        (
        print i
        print $MasterSet.NecDefNodes[i].node
        if isvalidnode $MasterSet.NecDefNodes[i].node then
        (
        )
        else
        ()
        )

        for i=1 to $MasterSet.ArmDefNodes.count do
        (
        print i
        print $MasterSet.ArmDefNodes[i].node
        if isvalidnode $MasterSet.ArmDefNodes[i].node then
        (
        )
        else
        ()
        )

        for i=1 to $MasterSet.LegDefNodes.count do
        (
        print i
        print $MasterSet.LegDefNodes[i].node
        if isvalidnode $MasterSet.LegDefNodes[i].node then
        (
        )
        else
        ()
        )

        --手だけは兼用
        for i=1 to $MasterSet.HandSubAndDefNodes.count do
        (
        print i
        print $MasterSet.HandSubAndDefNodes[i].node
        if isvalidnode $MasterSet.HandSubAndDefNodes[i].node then
        (
        )
        else
        ()
        )

        --ボーン
        for i=1 to $MasterSet.MainBoneNodes.count do
        (
        print i
        print $MasterSet.MainBoneNodes[i].node
        if isvalidnode $MasterSet.MainBoneNodes[i].node then
        (
        )
        else
        ()
        )

        for i=1 to $MasterSet.SubBoneNodes.count do
        (
        print i
        print $MasterSet.SubBoneNodes[i].node
        if isvalidnode $MasterSet.SubBoneNodes[i].node then
        (
        )
        else
        ()
        )

        for i=1 to $MasterSet.SpineBoneNodes.count do
        (
        print i
        print $MasterSet.SpineBoneNodes[i].node
        if isvalidnode $MasterSet.SpineBoneNodes[i].node then
        (
        )
        else
        ()
        )

        for i=1 to $MasterSet.NecBoneNodes.count do
        (
        print i
        print $MasterSet.NecBoneNodes[i].node
        if isvalidnode $MasterSet.NecBoneNodes[i].node then
        (
        )
        else
        ()
        )

        for i=1 to $MasterSet.UpperArm_LBoneNodes.count do
        (
        print i
        print $MasterSet.UpperArm_LBoneNodes[i].node
        if isvalidnode $MasterSet.UpperArm_LBoneNodes[i].node then
        (
        )
        else
        ()
        )

        for i=1 to $MasterSet.ForeArm_LBoneNodes.count do
        (
        print i
        print $MasterSet.ForeArm_LBoneNodes[i].node
        if isvalidnode $MasterSet.ForeArm_LBoneNodes[i].node then
        (
        )
        else
        ()
        )

        for i=1 to $MasterSet.Thigh_LBoneNodes.count do
        (
        print i
        print $MasterSet.Thigh_LBoneNodes[i].node
        if isvalidnode $MasterSet.Thigh_LBoneNodes[i].node then
        (
        )
        else
        ()
        )

        for i=1 to $MasterSet.Calf_LBoneNodes.count do
        (
        print i
        print $MasterSet.Calf_LBoneNodes[i].node
        if isvalidnode $MasterSet.Calf_LBoneNodes[i].node then
        (
        )
        else
        ()
        )

        for i=1 to $MasterSet.Hand_LBoneNodes.count do
        (
        print i
        print $MasterSet.Hand_LBoneNodes[i].node
        if isvalidnode $MasterSet.Hand_LBoneNodes[i].node then
        (
        )
        else
        ()
        )

        --SplinePos
        for i=1 to $MasterSet.SpineSplinePosNodes.count do
        (
        print i
        print $MasterSet.SpineSplinePosNodes[i].node
        if isvalidnode $MasterSet.SpineSplinePosNodes[i].node then
        (
        )
        else
        ()
        )

        for i=1 to $MasterSet.NecSplinePosNodes.count do
        (
        print i
        print $MasterSet.NecSplinePosNodes[i].node
        if isvalidnode $MasterSet.NecSplinePosNodes[i].node then
        (
        )
        else
        ()
        )

        for i=1 to $MasterSet.UpperArm_RSplinePosNodes.count do
        (
        print i
        print $MasterSet.UpperArm_RSplinePosNodes[i].node
        if isvalidnode $MasterSet.UpperArm_RSplinePosNodes[i].node then
        (
        )
        else
        ()
        )

        for i=1 to $MasterSet.ForeArm_RSplinePosNodes.count do
        (
        print i
        print $MasterSet.ForeArm_RSplinePosNodes[i].node
        if isvalidnode $MasterSet.ForeArm_RSplinePosNodes[i].node then
        (
        )
        else
        ()
        )

        for i=1 to $MasterSet.Thigh_RSplinePosNodes.count do
        (
        print i
        print $MasterSet.Thigh_RSplinePosNodes[i].node
        if isvalidnode $MasterSet.Thigh_RSplinePosNodes[i].node then
        (
        )
        else
        ()
        )

        for i=1 to $MasterSet.Calf_RSplinePosNodes.count do
        (
        print i
        print $MasterSet.Calf_RSplinePosNodes[i].node
        if isvalidnode $MasterSet.Calf_RSplinePosNodes[i].node then
        (
        )
        else
        ()
        )

        for i=1 to $MasterSet.UpperArm_LSplinePosNodes.count do
        (
        print i
        print $MasterSet.UpperArm_LSplinePosNodes[i].node
        if isvalidnode $MasterSet.UpperArm_LSplinePosNodes[i].node then
        (
        )
        else
        ()
        )

        for i=1 to $MasterSet.ForeArm_LSplinePosNodes.count do
        (
        print i
        print $MasterSet.ForeArm_LSplinePosNodes[i].node
        if isvalidnode $MasterSet.ForeArm_LSplinePosNodes[i].node then
        (
        )
        else
        ()
        )

        for i=1 to $MasterSet.Thigh_LSplinePosNodes.count do
        (
        print i
        print $MasterSet.Thigh_LSplinePosNodes[i].node
        if isvalidnode $MasterSet.Thigh_LSplinePosNodes[i].node then
        (
        )
        else
        ()
        )

        for i=1 to $MasterSet.Calf_LSplinePosNodes.count do
        (
        print i
        print $MasterSet.Calf_LSplinePosNodes[i].node
        if isvalidnode $MasterSet.Calf_LSplinePosNodes[i].node then
        (
        )
        else
        ()
        )

        /***********ここれはCollectには含まない***********/
        for i=1 to $MasterSet.SpineSubAndDefNodes.count do
        (
        print i
        print $MasterSet.SpineSubAndDefNodes[i].node
        if isvalidnode $MasterSet.SpineSubAndDefNodes[i].node then
        (
        )
        else
        ()
        )

        for i=1 to $MasterSet.NecSubAndDefNodes.count do
        (
        print i
        print $MasterSet.NecSubAndDefNodes[i].node
        if isvalidnode $MasterSet.NecSubAndDefNodes[i].node then
        (
        )
        else
        ()
        )

        for i=1 to $MasterSet.ArmSubAndDefNodes.count do
        (
        print i
        print $MasterSet.ArmSubAndDefNodes[i].node
        if isvalidnode $MasterSet.ArmSubAndDefNodes[i].node then
        (
        )
        else
        ()
        )

        for i=1 to $MasterSet.LegSubAndDefNodes.count do
        (
        print i
        print $MasterSet.LegSubAndDefNodes[i].node
        if isvalidnode $MasterSet.LegSubAndDefNodes[i].node then
        (
        )
        else
        ()
        )
    )

    on sortByNameBt pressed do
    (
        Local tempObjArray = #()
            for i=1 to selection.count do
            (
                append tempObjArray selection[i].name
            )
            print tempObjArray.count
            sort tempObjArray
            sort tempObjArray
            sort tempObjArray
            for i=1 to tempObjArray.count do
            (
                print selection[i].name
            )
        tempObjArray = #()
    )

    on ntmAddBt picked obj do
    (
        tempObj = execute("$." + ntmNameTxt.text)
        --print tempObj
        tempObj[ntmIndex.value] = nodeTransformMonitor()
        tempObj[ntmIndex.value].node = obj
        --append $.SkinObjectNodes (nodeTransformMonitor node:$ forwardTransformChangeMsgs:false)
    )

