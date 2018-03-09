
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
    --メインメニューに新しい項目をを作成する
    local subMenu = menuMan.createMenu "SJTools";
    --メニューにアクションを追加する--作ったアイテムを先のメニューに追加する
    local mItem;

    local mParent;

    try (
        mItem = menuMan.createActionItem "Renamer" "SJTools";
        subMenu.addItem mItem -1;
    ) catch ();

    try (
        mItem = menuMan.createActionItem "SJSpark" "SJTools";
        subMenu.addItem mItem -1;
    ) catch ();

    try (
        mItem = menuMan.createActionItem "Spark" "SJTools";
        subMenu.addItem mItem -1;
    ) catch ();

    --そのメニューをサブメニューとして作成する
    local subMenuItem = menuMan.createSubMenuItem "SJTools" subMenu;
    --メニュー追加用にメインメニューのindexを取得しておく
    local subMenuIndex = mainMenuBar.numItems() - 1;

    --メニューをメインメニューに追加
    mainMenuBar.addItem subMenuItem subMenuIndex;

    --更新
    menuMan.updateMenuBar();
)

addSJToolsMene();
