try:
    from PySide2.QtWidgets import *
    from PySide2.QtGui import *
    from PySide2.QtCore import *
except ImportError:
    from PySide.QtGui import *
    from PySide.QtCore import *


def update_sj_selecton_list():
    widgets = QApplication.allWidgets()
    for w in widgets:
        if w.objectName() == "SJSelectonList":
            w.set_preset()
            return


def close_sj_selecton_window():
    widgets = QApplication.allWidgets()
    for w in widgets:
        if w.objectName().find("SJSelectonWindow") is not -1:
            print("Closed : {}".format(w.objectName()))
            w.close()
