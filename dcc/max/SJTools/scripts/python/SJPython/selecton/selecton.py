r"""selecton
自前ツールの転用です

"""
from __future__ import absolute_import
from __future__ import division
from __future__ import print_function
from __future__ import unicode_literals

import os
import MaxPlus

import selecton.config as cnfg
import selecton.selecton_main as selecton
# import selecton.default_config as def_cnfg

reload(cnfg)
reload(selecton)
# reload(def_cnfg)

try:
    from PySide2.QtWidgets import *
    from PySide2.QtGui import *
    from PySide2.QtCore import *
    UNICODE = -1

except ImportError:
    from PySide.QtGui import *
    from PySide.QtCore import *
    UNICODE = QApplication.UnicodeUTF8


class _GCProtector(object):
    r"""maxの場合は必要"""
    widgets = []


def close_tool_window(wname):
    widgets = QApplication.allWidgets()
    for w in widgets:
        if w.objectName().find(wname) is not -1:
            print("Closed : {}".format(w.objectName()))
            w.close()


def get_parent_window():
    r"""親となるウィンドウを取得する
    Max2018の場合はMaxPlus.GetQMaxMainWindow()で取得
    """
    ver = MaxPlus.Core.GetMaxVersion()
    if ver < 1300000000:
        parent_window = MaxPlus.GetQMaxWindow()
    else:
        parent_window = MaxPlus.GetQMaxMainWindow()
    return parent_window


def main():
    r"""main"""
    app = QApplication.instance()
    if not app:
        app = QApplication([])

    close_tool_window("SJSelectonList")
    close_tool_window("SJSelectonWindow")
    dlg = selecton.SJSelectonList(get_parent_window())
    _GCProtector.widgets.append(dlg)
    # MaxPlus.MakeQWidgetDockable(dlg, 4)  # Maxではこれでドッキング可能になる
    # dlg.setFloating(True)  # dockingwidgetの場合はfloatをtrueにすると切り離しが出来る
    dlg.show()


if __name__ == '__main__':
    main()
