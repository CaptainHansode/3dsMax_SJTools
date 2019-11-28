r"""
"""
import imp
import MaxPlus

import test_tools_main
reload(test_tools_main)


class _GCProtector(object):
    r"""maxの場合は必要"""
    widgets = []


def close_tool_window(wname):
    widgets = QtWidgets.QApplication.allWidgets()
    for w in widgets:
        if w.objectName() == wname:
            print("Closed : {}".format(w.objectName()))
            w.close()


def get_parent_window():
    r"""親となるウィンドウを取得する
    Max2018の場合はMaxPlus.GetQMaxMainWindow()で取得
    """
    parent_window = MaxPlus.GetQMaxMainWindow()
    return parent_window


def main():
    r"""main"""
    app = QtWidgets.QApplication.instance()
    if not app:
        app = QtWidgets.QApplication([])

    # 開いていたら閉じる
    close_tool_window("TestTool")

    # ツールウィンドウを立ち上げる
    dlg = test_tools_main.TestTool(get_parent_window())
    _GCProtector.widgets.append(dlg)
    dlg.show()

if __name__ == '__main__':
    main()

# test_tools_main.TestClassRun()

print("tool run!")
