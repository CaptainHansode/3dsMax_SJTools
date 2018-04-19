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
function addSJToolsPyPath =
(
    sys = python.import("sys");
    scp = symbolicPaths.getPathValue "$scripts";
    sys.path.append(scp + "\\Python\\SJPython");
)

fn addSJToolsMene =
(
    --すでにメニューが合った場合は削除する
    try (
        myMenu = menuMan.findMenu "SJTools";
        menuMan.unRegisterMenu myMenu;
    ) catch ();

    --まず登録用のIDを用意しておく、IDが何かとかぶっていると登録できない
    myContextId = genClassID returnValue:true;
    --メニューIDを登録しながら作成
    if menuMan.registerMenuContext myContextId[1] == false then
    (
        return false;
    )

    --メインメニューを取得
    local mainMenuBar = menuMan.getMainMenuBar();
    local subMenu = menuMan.createMenu "SJTools";
    local mItem;
    local mParent;

    try (
        mItem = menuMan.createActionItem "SJRenamer" "SJTools";
        subMenu.addItem mItem -1;
    ) catch ();

    try (
        mItem = menuMan.createActionItem "SJSpark" "SJTools";
        subMenu.addItem mItem -1;
    ) catch ();

    try (
        mItem = menuMan.createActionItem "SJTimeMachine" "SJTools";
        subMenu.addItem mItem -1;
    ) catch ();

    try (
        mItem = menuMan.createActionItem "SJRendPathEdit" "SJTools";
        subMenu.addItem mItem -1;
    ) catch ();

    local subMenuItem = menuMan.createSubMenuItem "SJTools" subMenu;
    local subMenuIndex = mainMenuBar.numItems() - 1;
    mainMenuBar.addItem subMenuItem subMenuIndex;
    --更新
    menuMan.updateMenuBar();
)

addSJToolsPyPath();
addSJToolsMene();
