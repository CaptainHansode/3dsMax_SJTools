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
group "Make Lookat Point"
(
    button mLookatPBt "メイクルックアットポイント" width:160
    label mLookatLbl1 "ルックアット軸" align:#left
    radiobuttons mLookatAxisRb "" width:160 enabled:true labels:#("X", "Y","Z") default:3 columns:3 align:#center
    label mLookatLbl2 "基本軸" align:#left
    radiobuttons mLookatUpnodeRb "" width:160 enabled:true labels:#("X", "Y","Z") default:2 columns:3 align:#center
)
on mLookatAxisRb changed state do
(
    myState = state;
    case mLookatUpnodeRb.state of
    (
    1:(if mLookatUpnodeRb.state == myState do mLookatAxisRb.state = 2);
    2:(if mLookatUpnodeRb.state == myState do mLookatAxisRb.state = 1);
    3:(if mLookatUpnodeRb.state == myState do mLookatAxisRb.state = 2);
    )

);--end
on mLookatUpnodeRb changed state do
(
    myState = state;
    case mLookatAxisRb.state of
    (
    1:(if mLookatAxisRb.state == myState do mLookatUpnodeRb.state = 2);
    2:(if mLookatAxisRb.state == myState do mLookatUpnodeRb.state = 1);
    3:(if mLookatAxisRb.state == myState do mLookatUpnodeRb.state = 2);
    )

);--end
on mLookatPBt pressed do
(

    if selection.count != 0 and selection.count != 1 do
    (
    Local baseObj = selection[1];
    Local targetObj =  selection[2];
    Local myObj = point pos:baseObj.pos name:(baseObj.name + "_LookatPoint");
    Local myValue = 0;

    myObj.rotation.controller = LookAt_Constraint ();
    myObj.rotation.controller.appendTarget targetObj 50;
    myObj.rotation.controller.viewline_length_abs = off;
        case mLookatAxisRb.state of
        (
            1:(myObj.rotation.controller.target_axis = 0);
            2:(myObj.rotation.controller.target_axis = 1);
            3:(myObj.rotation.controller.target_axis = 2);
        )--end
        case mLookatUpnodeRb.state of
        (
            1:(myObj.rotation.controller.StoUP_axis = 0);
            2:(myObj.rotation.controller.StoUP_axis = 1);
            3:(myObj.rotation.controller.StoUP_axis = 2);
        )--end
        myValue = distance myObj targetObj;
    print myValue;
    );--if end
)