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
    group "Camera Converter"
    (
        button bakeFovBt "FovアニメをPlot" width:160
        button hTovFovBt "Fovを垂直値で置換" width:160
        button fovToFocalLengthBt "焦点距離をBake" width:160
        label CamConvLbl01 "設定は垂直でアパーチャーは 1 : 1 " width:160 align:#center
    )

--////////////////////////////////////////////////
--bakeFov
--////////////////////////////////////////////////
    on bakeFovBt pressed do
    (

    ccPointA = undefined;
    ccPointB = undefined;

    undo on
    (
    suspendEditing()--サスペンドモード
    with redraw off
    (--再描画禁止

    Local tempFrameRange = AnimationRange.end - AnimationRange.start;
    Local tempFrame = #();
    append tempFrame AnimationRange.start;
    for i = 1 to tempFrameRange do append tempFrame (AnimationRange.start + i);

    for i in selection do
    (
            if (classOf i.baseobject == Targetcamera) or (classOf i.baseobject == Freecamera) and (i.fov.controller != undefined) then
            (
            ccPointA = Point pos:[0,0,0];
            ccPointB = Point pos:[0,0,0];

                ccPointA.rotation.controller.X_Rotation.controller = copy i.fov.controller;

                for k in tempFrame do
                (
                animate on (at time k ccPointB.transform = ccPointA.transform);
                );--for end

                i.fov.controller = Copy ccPointB.rotation.controller.X_Rotation.controller;

            delete ccPointA;
            delete ccPointB;
    ccPointA = undefined;
    ccPointB = undefined;
            );--if end
        );--fpr end

    );--redraw off
    ResumeEditing();
    );--undo on
    );--end

--////////////////////////////////////////////////
--horizen to verocity bake
--////////////////////////////////////////////////
    on hTovFovBt pressed do
    (
    Local V = 0, Fl = 0, r_aspect = ( renderWidth as float )/( renderHeight as float );
    Local allssObj = #();

    ccPointA = undefined;
    ccPointB = undefined;

    undo on
    (
    suspendEditing()--サスペンドモード
    with redraw off
    (--再描画禁止

    Local tempFrameRange = AnimationRange.end - AnimationRange.start;
    Local tempFrame = #();
    append tempFrame AnimationRange.start;
    for i = 1 to tempFrameRange do append tempFrame (AnimationRange.start + i);

        for i in selection do
        (
            if (classOf i.baseobject == Targetcamera) or (classOf i.baseobject == Freecamera) and (i.fov.controller != undefined) then
            (

            ccPointA = Point pos:[0,0,0];
            ccPointB = Point pos:[0,0,0];

                ccPointA.rotation.controller.X_Rotation.controller = copy i.fov.controller;

                for k in tempFrame do
                (

                --////////////////////////////////////////////////
                --計算部

                --垂直設定に変更
                V = 2.0*atan( tan((at time k ccPointA.rotation.x_rotation)/2.0) * r_aspect );

                --Fl = (1/(tan(V/2.0)/25.4))*0.5;
                animate on (at time k ccPointB.rotation.controller.X_Rotation = V);
                );--for end

                i.fov.controller = Copy ccPointB.rotation.controller.X_Rotation.controller;

            delete ccPointA;
            delete ccPointB;
    ccPointA = undefined;
    ccPointB = undefined;

            );--if end
        );--for end

    );--redraw off
    ResumeEditing();
    );--undo on
    );--end

--////////////////////////////////////////////////
--fovToFocalLengthBt
--////////////////////////////////////////////////
    on fovToFocalLengthBt pressed do
    (
    Local V = 0, Fl = 0, r_aspect = ( renderWidth as float )/( renderHeight as float );
    Local allssObj = #();

    ccPointA = undefined;
    ccPointB = undefined;

    undo on
    (
    suspendEditing()--サスペンドモード
    with redraw off
    (--再描画禁止

    Local tempFrameRange = AnimationRange.end - AnimationRange.start;
    Local tempFrame = #();
    append tempFrame AnimationRange.start;
    for i = 1 to tempFrameRange do append tempFrame (AnimationRange.start + i);

        for i in selection do
        (
            if (classOf i.baseobject == Targetcamera) or (classOf i.baseobject == Freecamera) and (i.fov.controller != undefined) then
            (

            ccPointA = Point pos:[0,0,0];
            ccPointB = Point pos:[0,0,0];
            ccPointB.name = i.name+"_ConvFocalLength"

                ccPointA.rotation.controller.X_Rotation.controller = copy i.fov.controller;

                for k in tempFrame do
                (

                --////////////////////////////////////////////////
                --計算部

                --垂直設定に変更
                V = 2.0*atan( tan((at time k ccPointA.rotation.x_rotation)/2.0) / r_aspect );

                --ForcalLengthで
                Fl = (1/(tan(V/2.0)/25.4))*0.5;
                animate on (at time k ccPointB.pos.x = Fl);
                );--for end

                --i.fov.controller = Copy ccPointB.rotation.controller.X_Rotation.controller;

            delete ccPointA;
            --delete ccPointB;
            append allssObj ccPointB;

    ccPointA = undefined;
    ccPointB = undefined;

            );--if end


        );--for end

        select allssObj;

    );--redraw off
    ResumeEditing();
    );--undo on
    );--end