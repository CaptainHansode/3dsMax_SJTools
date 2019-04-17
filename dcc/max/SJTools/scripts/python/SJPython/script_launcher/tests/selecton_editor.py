# -*- coding:utf-8 -*-
# Copyright (C)
# Author:
# Contact:
r"""checkers
"""
from __future__ import absolute_import
from __future__ import division
from __future__ import print_function
from __future__ import unicode_literals
from collections import OrderedDict
from time import sleep

import winsound  # アラート音用
import MaxPlus
import os
import os.path

import checkers.checker_lib.check_func as chk_func
import checkers.checkers_result as check_ret
import checkers.config as cnfg
# import checkers.prog_bar as prog_bar
import checkers.default_config as def_cnfg
import grp_tools_lib.lic as lic

reload(def_cnfg)
reload(cnfg)
reload(chk_func)
reload(check_ret)
# reload(prog_bar)
reload(lic)

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
        if w.objectName() == wname:
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


class CheckersMain(QMainWindow):
    # QDockWidgetとするとドッキング可能になる QMainWindow
    def __init__(self, *args, **kw):
        QMainWindow.__init__(self, *args, **kw)

        self.tool_name = "Checkers"
        self.version = "0.0.4.0"
        self.auther = ""
        self.setObjectName(self.tool_name)
        self.setWindowTitle("{} v{}".format(self.tool_name, self.version))
        self.setMaximumSize(QSize(16777215, 840))

        if lic.check_limit() is False:
            # セントラルを作成
            self.centralwidget = QWidget(self)
            self.centralwidget.setObjectName("centralwidget")
            self.verticalLayout = QVBoxLayout(self.centralwidget)
            self.verticalLayout.setObjectName("verticalLayout")
            self.errllb = QLabel(self)
            self.errllb.setGeometry(QRect(4, 12, 120, 16))
            self.errllb.setObjectName("err_label")
            self.errllb.setText(u"Tools Expired")
            self.verticalLayout.addWidget(self.errllb)
            self.setCentralWidget(self.centralwidget)
            print("Tools Expired")
            return

        self.setup_config()
        self.ucode = UNICODE
        self.bth = self.config.data["bth"]
        self.lbh = self.config.data["lbh"]
        self.btwidth = self.config.data["width"]

        # セントラルを作成
        self.centralwidget = QWidget(self)
        self.centralwidget.setObjectName("centralwidget")
        # たてレイアウト追加
        self.verticalLayoutMain = QVBoxLayout(self.centralwidget)
        self.verticalLayoutMain.setObjectName("verticalLayoutMain")

        self.scrollArea = QScrollArea(self.centralwidget)
        self.scrollArea.setMinimumSize(QSize(0, 250))
        self.scrollArea.setMaximumSize(QSize(16777215, 840))
        self.scrollArea.setWidgetResizable(True)
        self.scrollArea.setObjectName("scrollArea")
        self.scrollAreaWidgetContents = QWidget()
        self.scrollAreaWidgetContents.setGeometry(QRect(0, 0, 542, 573))
        self.scrollAreaWidgetContents.setObjectName("scrollAreaWidgetContents")

        self.verticalLayout = QVBoxLayout(self.scrollAreaWidgetContents)
        self.verticalLayout.setObjectName("verticalLayout")

        self.setup_menu_ui()
        self.setup_ui()

        self.scrollArea.setWidget(self.scrollAreaWidgetContents)
        self.verticalLayoutMain.addWidget(self.scrollArea)

        # All Run Button
        self.all_check_bt = QPushButton(self)
        self.all_check_bt.setMinimumSize(QSize(0, 38))
        self.all_check_bt.setObjectName("all_check_bt")
        self.all_check_bt.setText("All Check")
        # self.all_check_bt.clicked.connect(
        #     lambda: check_def.test_man(1, 2, 3, 4))
        self.all_check_bt.clicked.connect(
            lambda: self.run_checkers(self.all_check_items))
        self.verticalLayoutMain.addWidget(self.all_check_bt)

        # イメージ用ラベル
        self.image_label = QLabel(self)
        self.image_label.setMinimumSize(QSize(0, 64))
        self.image_label.setAlignment(Qt.AlignCenter)
        self.image_label.setObjectName("image_label")
        self.verticalLayoutMain.addWidget(self.image_label)

        img = os.path.join(
            os.path.dirname(os.path.abspath(__file__)), "checkers.png")
        self.image_label.setPixmap(img)

        self.prog_bar = QProgressBar(self)
        self.prog_bar.setProperty("value", 0)
        self.prog_bar.setObjectName("progressBar")
        self.prog_bar.setMinimumSize(QSize(0, 16))
        self.verticalLayoutMain.addWidget(self.prog_bar)
        self.statusBar().showMessage("Ready")
        # self.statusBar().addPermanentWidget(self.prog_bar)
        # self.prog_label = QLabel(self)
        # self.prog_label.setText("")
        # self.verticalLayout.addWidget(self.prog_label)
        self.setCentralWidget(self.centralwidget)  # セントラルを最後に追加
        QMetaObject.connectSlotsByName(self)

        try:
            testval = self.config.data["height"]
        except:
            self.init_config()

        self.setGeometry(
            QRect(
                self.config.data["posx"],
                self.config.data["posy"],
                self.config.data["width"],
                self.config.data["height"]
                )
            )

        self.set_preset()

    def setup_config(self):
        # config 日本語ユーザー名対策
        try:
            userprofile = os.environ.get("USERPROFILE").decode("Shift_JIS")
        except UnicodeDecodeError:
            userprofile = os.environ.get("USERPROFILE")

        self.config_path = "{}\\{}\\{}\\{}\\{}".format(
            userprofile, "Documents", "GrpTools", "config", self.tool_name)

        self.def_config = {
            "last_select": "Default",
            "autorun": True,
            "bth": 32,
            "lbh": 32,
            "width": 140,
            "height": 250,
            "posx": 50,
            "posy": 50
        }
        self.config = cnfg.ToolConfig(
            self.config_path, "DefaultConfig.json", self.def_config)

        self.ui_config = cnfg.ToolConfig(
            self.config_path,
            "UiConfig.json",
            def_cnfg.default_config().default_bts
        )

    def setup_menu_ui(self):
        objname = str(self.objectName())
        # menu
        width = self.config.data["width"]

        self.menubar = QMenuBar(self)
        self.menubar.setGeometry(QRect(0, 0, width + 27, 24))
        self.menubar.setObjectName("menubar")

        self.menu = QMenu(self.menubar)
        self.menu.setObjectName("menu")
        self.menu.setTitle("Menu")
        self.menubar.addAction(self.menu.menuAction())

        self.m_init_config = QAction(self)
        self.m_init_config.setObjectName("m_init_config")
        self.m_init_config.setText(u"設定初期化")
        self.menu.addAction(self.m_init_config)
        self.m_init_config.triggered.connect(self.init_config)

        self.setMenuBar(self.menubar)

        # combo
        self.preset = QComboBox(self.centralwidget)
        self.preset.setGeometry(QRect(4, 22, self.btwidth, 22))
        self.preset.setObjectName("comboBox")
        self.verticalLayoutMain.addWidget(self.preset)  # たてレイアウト追加
        self.preset.currentIndexChanged.connect(self.change_preest)

        self.reload = QPushButton(self.centralwidget)
        self.reload.setGeometry(QRect(4, 48, self.btwidth, 22))
        self.reload.setObjectName("reload")
        self.reload.setText("Reload")
        self.verticalLayoutMain.addWidget(self.reload)  # たてレイアウト追加
        self.reload.clicked.connect(self.reload_ui)

    def setup_ui(self):
        objname = str(self.objectName())

        # コンフィグから最初に読んでおく
        if self.config.data["last_select"] != "":
            self.uis = self.ui_config.data[self.config.data["last_select"]]
        else:
            self.uis = self.ui_config.data["Default"]

        self.lbdict = {}
        self.chkbts = {}
        self.chkbxs = {}
        self.lbmenu = {}
        self.horizons = {}
        self.all_check_items = []

        for item in self.uis:
            uname = str(item)
            idata = self.uis[item]
            if idata["ui_type"] == "Separator":
                self.add_separator(idata, uname)
                continue
            self.add_check_menu(idata, uname)
            self.all_check_items.append(uname)

        # セパレーターを追加すると上詰めになる
        spacerItem = QSpacerItem(
            20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
        self.verticalLayout.addItem(spacerItem)

    def add_separator(self, idata, uname):
        objname = str(self.objectName())
        self.lbdict[uname] = QLabel(self)
        self.lbdict[uname].setGeometry(QRect(4, 20, self.btwidth, self.lbh))
        self.lbdict[uname].setStyleSheet(
            "background-color:rgb" + idata["color"])
        self.lbdict[uname].setAlignment(Qt.AlignCenter)
        self.lbdict[uname].setObjectName(uname + "_label")
        self.lbdict[uname].setText(
            QApplication.translate(objname, uname, None, self.ucode))
        self.verticalLayout.addWidget(self.lbdict[uname])
        self.lbdict[uname].show()

    def add_check_menu(self, idata, uname):
        objname = str(self.objectName())
        self.horizons[uname] = QHBoxLayout(self)
        self.horizons[uname].setObjectName(uname + "_horizon")
        self.horizons[uname].setContentsMargins(12, 0, 0, 0)

        # チェックボックス追加
        self.chkbxs[uname] = QCheckBox(self.centralwidget)
        self.chkbxs[uname].setMinimumSize(QSize(0, 0))
        self.chkbxs[uname].setMaximumSize(QSize(12, 16777215))
        self.chkbxs[uname].setChecked(idata["default"])
        self.chkbxs[uname].setText("")
        self.chkbxs[uname].setObjectName(uname + "_chkbx")
        self.horizons[uname].addWidget(self.chkbxs[uname])

        self.chkbts[uname] = QPushButton(self)
        self.chkbts[uname].setMaximumSize(QSize(46, 16777215))
        self.chkbts[uname].setObjectName(uname + "_bt")
        self.chkbts[uname].setText("Check")

        self.horizons[uname].addWidget(self.chkbts[uname])
        self.chkbts[uname].show()
        # # ラムダ式で引き数を渡す
        # self.btdict[uname].clicked.connect(
        #     lambda: check_def.test_man(1, 2, 3, 4))
        self.chkbts[uname].clicked.connect(
            lambda ms=[uname]: self.run_checkers(ms))

        # ラベル追加
        self.lbmenu[uname] = QLabel(self)
        self.lbmenu[uname].setObjectName(uname + "_label")
        self.lbmenu[uname].setStyleSheet("font-size: 14px")
        self.lbmenu[uname].setText(
            QApplication.translate(
                objname,
                idata["discription"].encode("utf-8"),
                None,
                self.ucode
                )
            )
        self.horizons[uname].addWidget(self.lbmenu[uname])
        self.lbmenu[uname].show()

        # 最後に追加
        self.verticalLayout.addLayout(self.horizons[uname])

    def closeEvent(self, event):
        r"""close event override"""
        self.config.data["posx"] = self.x() + 8
        self.config.data["posy"] = self.y() + 30
        self.config.data["width"] = self.width()
        self.config.data["height"] = self.height()
        self.config.data["last_select"] = self.preset.currentText()
        self.config.save()
        # 閉じる
        self.deleteLater()

    def init_config(self):
        self.config.clear()
        self.ui_config.clear()
        self.config.data = self.def_config
        self.ui_config.data = def_cnfg.default_config().default_bts
        self.config.save()
        self.ui_config.save()

    def change_preest(self):
        pass

    def run_checkers(self, checklist):
        funcname = ""
        results = OrderedDict()

        single = False
        if len(checklist) is 1:  # 単独実行
            single = True

        total = len(checklist) + 1  # progress用
        cnt = 0
        for item in checklist:
            cnt += 1
            self.statusBar().showMessage(self.uis[item]["discription"])
            self.prog_bar.setValue(((cnt / total) * 100))

            # チェックボックスが外れている
            if self.chkbxs[item].isChecked() is False and single is False:
                continue

            # TODO:いけてない
            funcname = "chk_func.{}()".format(self.uis[item]["checkfunc"])
            ret = eval(funcname)

            if ret is None:
                continue
            if len(ret) == 0:
                continue
            results[item] = ret

        # resultを作成
        close_tool_window("CheckersResult")
        dlg = check_ret.CheckersResult(get_parent_window())
        _GCProtector.widgets.append(dlg)
        dlg.move(self.x() + 50, self.y() + 50)
        dlg.resize(self.width(), self.height())
        dlg.setup_ui_by_results(results)
        dlg.show()

        self.statusBar().showMessage("Done")
        self.prog_bar.setValue(0)

        # アラート音
        # if len(results) == 0:
        #     winsound.PlaySound("SystemExit", winsound.SND_ALIAS)
        # else:
        #     winsound.PlaySound("SystemExclamation", winsound.SND_ALIAS)

    def run_ms(self, ms):
        """macroscript run"""
        MaxPlus.Core.EvalMAXScript(ms)

    def set_preset(self):
        for key in self.ui_config.data.keys():
            self.preset.addItem(key)

        last_sel = self.config.data["last_select"]
        for i in range(self.preset.count()):
            if self.preset.itemText(i) == last_sel:
                self.preset.setCurrentIndex(i)
                return

    def reload_ui(self):
        self.config.data["posx"] = self.x() + 8
        self.config.data["posy"] = self.y() + 30
        self.config.data["last_select"] = self.preset.currentText()
        self.config.save()

        for i in self.lbdict:
            self.lbdict[i].setParent(None)
            self.lbdict[i].deleteLater()
        for i in self.chkbts:
            self.chkbts[i].setParent(None)
            self.chkbts[i].deleteLater()
        for i in self.chkbxs:
            self.chkbxs[i].setParent(None)
            self.chkbxs[i].deleteLater()
        for i in self.lbmenu:
            self.lbmenu[i].setParent(None)
            self.lbmenu[i].deleteLater()
        for i in self.horizons:
            self.horizons[i].setParent(None)
            self.horizons[i].deleteLater()

        layout = self.verticalLayout.layout()
        self.verticalLayout.removeItem(layout.itemAt(0))  # セパレーター削除
        # for i in range(layout.count()):
        #     print(i)
        #     print(type(layout.itemAt(i)))

        self.setup_ui()
        self.update()
