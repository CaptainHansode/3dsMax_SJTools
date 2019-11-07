# -*- coding:utf-8 -*-
# Copyright (C)
# Author:半袖船長
# Contact:
r"""select - on
自前ツールの転用です
元はこちら http://www.sakaiden.comf
"""
from __future__ import absolute_import
from __future__ import division
from __future__ import print_function
from __future__ import unicode_literals
from collections import OrderedDict

import xml.etree.ElementTree as ET  # xml用
import MaxPlus
import os
import os.path
import traceback
import collections
import json
import copy

import selecton.cmn_util as util
import selecton.config as cnfg


reload(util)
reload(cnfg)


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


class SJSelectonEditor(QMainWindow):
    r"""セレクタンエディター """
    def __init__(self, *args, **kwargs):
        super(SJSelectonEditor, self).__init__(*args, **kwargs)
        # QMainWindow.__init__(self, *args, **kw)
        # Frameless にするとフレームが無くなる
        # self.setWindowFlags(Qt.Tool|Qt.FramelessWindowHint)
        self.setWindowFlags(Qt.Tool)

        self.ui_dict = {}
        self.helper_obj = None
        self.on_ad_rig_node = False
        self.tool_name = "SJSelectonEditor"
        self.setup_config()
        self.setObjectName(self.tool_name)
        self.setWindowTitle(self.tool_name)

        self.shift_pressed = False
        self.ctrl_pressed = False
        self.sel_mode = 0
        self.all_objs = []

        self.lb_col = [80, 110, 120, 255]
        self.edit_name = ""
        self.changes = False
        self.sel_window = None
        self.xml_path = "D:\\"

        self.setup_ui()

        self.setGeometry(
            QRect(
                self.config.data["posx"],
                self.config.data["posy"],
                self.config.data["width"],
                self.config.data["height"]
                )
            )
        # フォーカスイベント# eventFilterの登録
        self.installEventFilter(self)

    def setup_config(self):
        # config 日本語ユーザー名対策
        try:
            userprofile = os.environ.get("USERPROFILE").decode("Shift_JIS")
        except UnicodeDecodeError:
            userprofile = os.environ.get("USERPROFILE")

        self.config_path = os.path.join(
            userprofile, "Documents", "SJTools", "config", self.tool_name)

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

    def setup_ui(self):
        self.centralwidget = QWidget(self)
        self.centralwidget.setObjectName("centralwidget")
        self.gridLayout = QGridLayout(self.centralwidget)
        self.gridLayout.setContentsMargins(6, 6, 6, 6)
        self.gridLayout.setHorizontalSpacing(6)
        self.gridLayout.setObjectName("gridLayout")
        self.bgImgGb = QGroupBox(self.centralwidget)
        self.bgImgGb.setMinimumSize(QSize(0, 52))
        self.bgImgGb.setMaximumSize(QSize(16777215, 52))
        self.bgImgGb.setObjectName("bgImgGb")
        self.horizontalLayout_8 = QHBoxLayout(self.bgImgGb)
        self.horizontalLayout_8.setSpacing(2)
        self.horizontalLayout_8.setObjectName("horizontalLayout_8")
        self.bgImgPath = QLineEdit(self.bgImgGb)
        self.bgImgPath.setObjectName("bgImgPath")
        self.horizontalLayout_8.addWidget(self.bgImgPath)
        self.bgImgBt = QToolButton(self.bgImgGb)
        self.bgImgBt.setObjectName("bgImgBt")
        self.horizontalLayout_8.addWidget(self.bgImgBt)
        self.delBgImgBt = QToolButton(self.bgImgGb)
        self.delBgImgBt.setObjectName("delBgImgBt")
        self.horizontalLayout_8.addWidget(self.delBgImgBt)
        self.gridLayout.addWidget(self.bgImgGb, 2, 0, 1, 1)
        self.scriptEditGb = QGroupBox(self.centralwidget)
        self.scriptEditGb.setMinimumSize(QSize(0, 180))
        self.scriptEditGb.setMaximumSize(QSize(16777215, 16777215))
        self.scriptEditGb.setObjectName("scriptEditGb")
        self.verticalLayout_3 = QVBoxLayout(self.scriptEditGb)
        self.verticalLayout_3.setObjectName("verticalLayout_3")
        self.rbHL = QHBoxLayout()
        self.rbHL.setContentsMargins(-1, -1, -1, 0)
        self.rbHL.setObjectName("rbHL")
        self.msRb = QRadioButton(self.scriptEditGb)
        self.msRb.setChecked(True)
        self.msRb.setObjectName("msRb")
        self.rbHL.addWidget(self.msRb)
        self.pyRb = QRadioButton(self.scriptEditGb)
        self.pyRb.setObjectName("pyRb")
        self.rbHL.addWidget(self.pyRb)
        self.verticalLayout_3.addLayout(self.rbHL)
        self.scriptSource = QTextEdit(self.scriptEditGb)
        self.scriptSource.setObjectName("scriptSource")
        self.verticalLayout_3.addWidget(self.scriptSource)
        self.testRunBt = QPushButton(self.scriptEditGb)
        self.testRunBt.setObjectName("testRunBt")
        self.verticalLayout_3.addWidget(self.testRunBt)
        self.gridLayout.addWidget(self.scriptEditGb, 5, 0, 1, 1)
        self.btEditLayout = QHBoxLayout()
        self.btEditLayout.setSpacing(2)
        self.btEditLayout.setContentsMargins(-1, -1, -1, 0)
        self.btEditLayout.setObjectName("btEditLayout")
        self.btStats = QGroupBox(self.centralwidget)
        self.btStats.setMinimumSize(QSize(0, 150))
        self.btStats.setMaximumSize(QSize(280, 240))
        self.btStats.setObjectName("btStats")
        self.verticalLayout_4 = QVBoxLayout(self.btStats)
        self.verticalLayout_4.setContentsMargins(0, -1, -1, -1)
        self.verticalLayout_4.setObjectName("verticalLayout_4")
        self.txtLayout = QHBoxLayout()
        self.txtLayout.setSpacing(2)
        self.txtLayout.setObjectName("txtLayout")
        self.txtLb = QLabel(self.btStats)
        self.txtLb.setObjectName("txtLb")
        self.txtLayout.addWidget(self.txtLb)
        self.btTxt = QLineEdit(self.btStats)
        self.btTxt.setMaximumSize(QSize(16777215, 16777215))
        self.btTxt.setObjectName("btTxt")
        self.txtLayout.addWidget(self.btTxt)
        self.verticalLayout_4.addLayout(self.txtLayout)
        self.sizeLayout = QHBoxLayout()
        self.sizeLayout.setSpacing(0)
        self.sizeLayout.setContentsMargins(-1, -1, -1, 0)
        self.sizeLayout.setObjectName("sizeLayout")
        self.xLb = QLabel(self.btStats)
        self.xLb.setMaximumSize(QSize(10, 16777215))
        self.xLb.setObjectName("xLb")
        self.sizeLayout.addWidget(self.xLb)
        self.btX = QSpinBox(self.btStats)
        self.btX.setMaximumSize(QSize(38, 16777215))
        self.btX.setMaximum(2048)
        self.btX.setObjectName("btX")
        self.sizeLayout.addWidget(self.btX)
        self.yLb = QLabel(self.btStats)
        self.yLb.setMaximumSize(QSize(10, 16777215))
        self.yLb.setObjectName("yLb")
        self.sizeLayout.addWidget(self.yLb)
        self.btY = QSpinBox(self.btStats)
        self.btY.setMaximumSize(QSize(38, 16777215))
        self.btY.setMaximum(2048)
        self.btY.setObjectName("btY")
        self.sizeLayout.addWidget(self.btY)
        self.wLb = QLabel(self.btStats)
        self.wLb.setMaximumSize(QSize(10, 16777215))
        self.wLb.setObjectName("wLb")
        self.sizeLayout.addWidget(self.wLb)
        self.btW = QSpinBox(self.btStats)
        self.btW.setMaximumSize(QSize(38, 16777215))
        self.btW.setMinimum(2)
        self.btW.setMaximum(2048)
        self.btW.setObjectName("btW")
        self.sizeLayout.addWidget(self.btW)
        self.hLb = QLabel(self.btStats)
        self.hLb.setMaximumSize(QSize(10, 16777215))
        self.hLb.setObjectName("hLb")
        self.sizeLayout.addWidget(self.hLb)
        self.btH = QSpinBox(self.btStats)
        self.btH.setMaximumSize(QSize(38, 16777215))
        self.btH.setMinimum(2)
        self.btH.setMaximum(2048)
        self.btH.setObjectName("btH")
        self.sizeLayout.addWidget(self.btH)
        self.verticalLayout_4.addLayout(self.sizeLayout)
        self.colLayout = QHBoxLayout()
        self.colLayout.setSpacing(0)
        self.colLayout.setObjectName("colLayout")
        self.colBt = QPushButton(self.btStats)
        self.colBt.setMinimumSize(QSize(0, 30))
        self.colBt.setObjectName("colBt")
        self.colLayout.addWidget(self.colBt)
        self.verticalLayout_4.addLayout(self.colLayout)

        # 透明度
        self.tpcLayout = QHBoxLayout()
        self.tpcLayout.setSpacing(2)
        self.tpcLayout.setContentsMargins(-1, -1, -1, 0)
        self.tpcLayout.setObjectName("tpyLayout")
        self.tpcLb = QLabel(self.btStats)
        self.tpcLb.setMaximumSize(QSize(67, 16777215))
        self.tpcLb.setObjectName("tpcLb")
        self.tpcLayout.addWidget(self.tpcLb)
        self.tpcSb = QSpinBox(self.btStats)
        self.tpcSb.setMaximum(255)
        self.tpcSb.setValue(255)
        self.tpcSb.setObjectName("tpcSb")
        self.tpcLayout.addWidget(self.tpcSb)
        self.verticalLayout_4.addLayout(self.tpcLayout)

        self.iconLayout = QHBoxLayout()
        self.iconLayout.setSpacing(2)
        self.iconLayout.setContentsMargins(-1, -1, -1, 0)
        self.iconLayout.setObjectName("iconLayout")
        self.iconLb = QLabel(self.btStats)
        self.iconLb.setObjectName("iconLb")
        self.iconLayout.addWidget(self.iconLb)
        self.iconPath = QLineEdit(self.btStats)
        self.iconPath.setObjectName("iconPath")
        self.iconLayout.addWidget(self.iconPath)
        self.iconBt = QToolButton(self.btStats)
        self.iconBt.setObjectName("iconBt")
        self.iconLayout.addWidget(self.iconBt)
        self.delIconBt = QToolButton(self.btStats)
        self.delIconBt.setObjectName("delIconBt")
        self.iconLayout.addWidget(self.delIconBt)
        self.verticalLayout_4.addLayout(self.iconLayout)

        self.toggleCb = QCheckBox(self.btStats)
        self.toggleCb.setObjectName("toggleCb")
        self.verticalLayout_4.addWidget(self.toggleCb)

        spacerItem = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
        self.verticalLayout_4.addItem(spacerItem)
        self.btEditLayout.addWidget(self.btStats)
        self.selObjGb = QGroupBox(self.centralwidget)
        self.selObjGb.setMinimumSize(QSize(0, 96))
        self.selObjGb.setMaximumSize(QSize(16777215, 240))
        self.selObjGb.setObjectName("selObjGb")
        self.verticalLayout_2 = QVBoxLayout(self.selObjGb)
        self.verticalLayout_2.setObjectName("verticalLayout_2")
        self.selList = QTextEdit(self.selObjGb)
        self.selList.setObjectName("selList")
        self.verticalLayout_2.addWidget(self.selList)
        self.selBtLayout = QHBoxLayout()
        self.selBtLayout.setContentsMargins(-1, -1, -1, 0)
        self.selBtLayout.setObjectName("selBtLayout")
        self.addSelListBt = QPushButton(self.selObjGb)
        self.addSelListBt.setObjectName("addSelListBt")
        self.selBtLayout.addWidget(self.addSelListBt)
        self.clearSelListBt = QPushButton(self.selObjGb)
        self.clearSelListBt.setMaximumSize(QSize(56, 16777215))
        self.clearSelListBt.setObjectName("clearSelListBt")
        self.selBtLayout.addWidget(self.clearSelListBt)
        self.verticalLayout_2.addLayout(self.selBtLayout)
        self.btEditLayout.addWidget(self.selObjGb)
        self.btEditLayout.setStretch(1, 1)
        self.gridLayout.addLayout(self.btEditLayout, 4, 0, 1, 1)
        self.saveLayout = QHBoxLayout()
        self.saveLayout.setContentsMargins(-1, -1, -1, 0)
        self.saveLayout.setObjectName("saveLayout")
        self.saveBt = QPushButton(self.centralwidget)
        self.saveBt.setMinimumSize(QSize(0, 38))
        self.saveBt.setObjectName("saveBt")
        self.saveLayout.addWidget(self.saveBt)
        self.closeBt = QPushButton(self.centralwidget)
        self.closeBt.setMinimumSize(QSize(0, 38))
        self.closeBt.setObjectName("closeBt")
        self.saveLayout.addWidget(self.closeBt)
        self.gridLayout.addLayout(self.saveLayout, 6, 0, 1, 1)
        self.createBtGb = QGroupBox(self.centralwidget)
        self.createBtGb.setObjectName("createBtGb")
        self.horizontalLayout = QHBoxLayout(self.createBtGb)
        self.horizontalLayout.setSpacing(2)
        self.horizontalLayout.setContentsMargins(0, 0, 0, 0)
        self.horizontalLayout.setObjectName("horizontalLayout")
        self.addBt = QPushButton(self.createBtGb)
        self.addBt.setMinimumSize(QSize(0, 28))
        self.addBt.setObjectName("addBt")
        self.horizontalLayout.addWidget(self.addBt)
        self.importBt = QPushButton(self.createBtGb)
        self.importBt.setMinimumSize(QSize(0, 28))
        self.importBt.setObjectName("importBt")
        self.horizontalLayout.addWidget(self.importBt)
        self.delBt = QPushButton(self.createBtGb)
        self.delBt.setMinimumSize(QSize(0, 28))
        self.delBt.setObjectName("delBt")
        self.horizontalLayout.addWidget(self.delBt)
        self.gridLayout.addWidget(self.createBtGb, 3, 0, 1, 1)
        self.gridLayout.setRowStretch(5, 1)
        self.setCentralWidget(self.centralwidget)
        self.menubar = QMenuBar(self)
        self.menubar.setGeometry(QRect(0, 0, 371, 24))
        self.menubar.setObjectName("menubar")
        self.menuMenu = QMenu(self.menubar)
        self.menuMenu.setObjectName("menuMenu")
        self.setMenuBar(self.menubar)
        self.statusbar = QStatusBar(self)
        self.statusbar.setObjectName("statusbar")
        self.setStatusBar(self.statusbar)
        self.menubar.addAction(self.menuMenu.menuAction())

        self.retranslateUi()
        self.event_connect()
        self.set_default()
        QMetaObject.connectSlotsByName(self)

    def retranslateUi(self):
        self.bgImgGb.setTitle("BG_Image")
        self.bgImgBt.setText("...")
        self.delBgImgBt.setText("X")
        self.btStats.setTitle("Button Setting")
        self.txtLb.setText("Text")
        self.xLb.setText("X")
        self.yLb.setText("Y")
        self.wLb.setText("W")
        self.hLb.setText("H")
        self.colBt.setText(u"ボタンカラー")
        self.tpcLb.setText(u"ボタン透明度")
        self.iconLb.setText(u"アイコン")
        self.iconBt.setText("...")
        self.delIconBt.setText("X")
        self.toggleCb.setText(u"ボタンをトグルにする")
        # self.selObjGb.setTitle("SelectList")
        self.selObjGb.setTitle(u"ボタンを押して選択するもの")
        self.addSelListBt.setText(u"選択を追加")
        self.clearSelListBt.setText(u"クリア")
        self.saveBt.setText("Save")
        self.closeBt.setText("Close")
        self.createBtGb.setTitle("Create Button")
        self.addBt.setText(u"ボタン追加")
        self.importBt.setText(u"ボタン読み込み")
        self.delBt.setText(u"ボタン削除")
        self.menuMenu.setTitle("Menu")
        self.scriptEditGb.setTitle(u"ボタンを押して実行するスクリプト")
        self.msRb.setText("MaxScript")
        self.pyRb.setText("Python")
        self.testRunBt.setText("TestRun")

    def set_default(self):
        self.colBt.setPalette(QPalette(QColor(80, 110, 120, 255)))
        self.colBt.setAutoFillBackground(True)
        self.scriptSource.setFontPointSize(14)

    def event_connect(self):
        self.btTxt.editingFinished.connect(self.update_sel_bt)
        self.selList.selectionChanged.connect(self.update_sel_bt)
        self.scriptSource.selectionChanged.connect(self.update_sel_bt)
        self.clearSelListBt.clicked.connect(self.clear_sel_list)
        self.addSelListBt.clicked.connect(self.add_obj_name_to_sel_list)
        self.testRunBt.clicked.connect(self.script_test_run)
        self.bgImgBt.clicked.connect(self.load_bg_img)
        self.delBgImgBt.clicked.connect(self.del_bg_img)
        self.iconBt.clicked.connect(self.load_icon)
        self.delIconBt.clicked.connect(self.del_icon)

        self.addBt.clicked.connect(self.add_button)
        self.importBt.clicked.connect(self.import_button)
        self.delBt.clicked.connect(self.del_button)
        self.colBt.clicked.connect(self.set_lb_color)

        self.btX.valueChanged.connect(self.update_sel_bt)
        self.btY.valueChanged.connect(self.update_sel_bt)
        self.btW.valueChanged.connect(self.update_sel_bt)
        self.btH.valueChanged.connect(self.update_sel_bt)
        self.tpcSb.valueChanged.connect(self.update_sel_bt)
        self.saveBt.clicked.connect(self.save_bt)
        self.closeBt.clicked.connect(self.close_editor)

    def eventFilter(self, object, event):
        # アクティブでなくなった時
        if event.type() == QEvent.WindowDeactivate:
            self.update_sel_bt()
        elif event.type() == QEvent.WindowActivate:
            self.update_ui()
        return super(SJSelectonEditor, self).eventFilter(object, event)

    def closeEvent(self, event):
        r"""close event override"""
        if self.changes:
            self.check_saving_changes()
        self.config.data["posx"] = self.x() + 8
        self.config.data["posy"] = self.y() + 30
        self.config.data["width"] = self.width()
        self.config.data["height"] = self.height()
        self.config.data["last_select"] = ""
        self.config.save()
        try:
            self.sel_window.close()
            self.sel_window.deleteLater()
        except:
            print("closeEvent:Error")
            traceback.print_exc()
        self.deleteLater()

    def get_temp_file(self, fname):
        fname = fname or "_tmp"
        return os.path.join(os.environ.get("Temp"), fname)

    def run_ms(self, ms):
        """macroscript run"""
        tmp_ms = self.get_temp_file("_tmp_macros.ms")
        file = open(tmp_ms, "w")
        file.write(ms.encode('utf8'))
        file.close()
        try:
            MaxPlus.Core.EvalMAXScript("filein \"{}\"".format(tmp_ms))
        except:
            print("Error:run_ms")
            traceback.print_exc()

    def run_py(self, py):
        """python run"""
        tmp_py = self.get_temp_file("_tmp_python.py")
        try:
            file = open(tmp_py, "w")
            file.write(py.encode('utf8'))
        except:
            print("can't write")
        finally:
            file.close()

        try:
            MaxPlus.Core.EvalMAXScript(
                "python.ExecuteFile \"{}\"".format(tmp_py))
        except:
            print("Error:run_py")
            traceback.print_exc()

    def script_test_run(self):
        s = self.scriptSource.toPlainText()
        if s == "":
            return
        if self.msRb.isChecked():
            self.run_ms(s)
        else:
            self.run_py(s)

    def open_file_path_dialog(
        self, titel="Select File", type_filter="", def_dir="C:\\"):
        r"""ファイル選択ダイアログ"""
        file_path = QFileDialog.getOpenFileName(
            self,
            titel,
            dir=def_dir,
            filter=type_filter
            # options=QFileDialog.DontUseNativeDialog
            )
        return file_path[0]

    def set_bg_img_path(self):
        self.bgImgPath.setText(self.ui_dict["bg_image"])

    def load_bg_img(self):
        r"""load"""
        load_path = self.bgImgPath.text()
        flt = "json config files (*.png);;All (*)"
        ret = self.open_file_path_dialog(type_filter=flt, def_dir=load_path)
        if ret is "":
            return
        self.set_change_sign_to_title()

        self.bgImgPath.setText(ret)
        self.ui_dict["bg_image"] = ret
        self.sel_window.ui_dict["bg_image"] = ret
        self.sel_window.update_bg_img()

    def del_bg_img(self):
        r"""load"""
        self.set_change_sign_to_title()

        self.bgImgPath.setText("")
        self.sel_window.ui_dict["bg_image"] = ""
        self.sel_window.update_bg_img()

    def load_icon(self):
        r"""load"""
        load_path = self.iconPath.text()
        flt = "png image files (*.png);;All (*)"
        ret = self.open_file_path_dialog(type_filter=flt, def_dir=load_path)
        if ret is "":
            return
        self.set_change_sign_to_title()

        self.iconPath.setText(ret)
        self.update_sel_bt()

    def del_icon(self):
        r"""load"""
        self.set_change_sign_to_title()
        self.iconPath.setText("")
        self.update_sel_bt()

    def set_change_sign_to_title(self, state=True):
        self.changes = state
        if state:
            if self.windowTitle().find("Changes") is not -1:
                return
            self.setWindowTitle("{} * Changes".format(self.windowTitle()))
        else:
            wtitle = self.windowTitle().replace(" * Changes", "")
            self.setWindowTitle(wtitle)

    def update_ui(self):
        r"""ボタン情報で自分のUIアップデート
        注意!
        setValueなどの値変更もChangeEventとして取得するので
        何処かのChangeEventを一時的に停止してから値変更すること
        """
        n = self.edit_name
        if n == "":
            return
        if (n in self.sel_window.ui_dict["buttons"]) is False:
            return

        self.set_change_sign_to_title()  # 更新サイン
        bt_dict = self.sel_window.ui_dict["buttons"][self.edit_name]
        self.btTxt.setText(bt_dict["bt_text"])
        input_txt = ""
        for n in bt_dict["select_obj"]:
            input_txt += "{}\n".format(n)
        self.selList.setText(input_txt)
        self.scriptSource.setText(bt_dict["scripts"])

        self.msRb.setChecked(True)
        if bt_dict["script_type"] == "py":
            self.pyRb.setChecked(True)

        col = bt_dict["color"]
        self.lb_col = col
        self.colBt.setPalette(QPalette(
            QColor(col[0], col[1], col[2], col[3])))
        self.tpcSb.setValue(col[3])
        self.iconPath.setText(bt_dict["icon"])

        self.btX.setValue(bt_dict["pos"][0])
        self.btY.setValue(bt_dict["pos"][1])
        self.btW.setValue(bt_dict["size"][0])
        self.btH.setValue(bt_dict["size"][1])

    def update_bt_dict(self):
        txt_list = self.selList.toPlainText().split("\n")
        input_list = []
        for i in txt_list:
            if i != "":
                input_list.append(i)

        col = [
            self.lb_col[0], self.lb_col[1], self.lb_col[2], self.tpcSb.value()]

        stype = "ms"
        if self.pyRb.isChecked():
            stype = "py"

        bt_dict = self.get_bt_dict()
        bt_dict["bt_text"] = self.btTxt.text()
        bt_dict["pos"] = [self.btX.value(), self.btY.value()]
        bt_dict["size"] = [self.btW.value(), self.btH.value()]
        bt_dict["icon"] = self.iconPath.text()
        bt_dict["color"] = col
        bt_dict["style_sheet"] = ""
        bt_dict["select_obj"] = input_list
        bt_dict["scripts"] = self.scriptSource.toPlainText()
        bt_dict["script_type"] = stype
        return bt_dict

    def show_window(self):
        self.sel_window.show()

    def exists_bt(self):
        n = self.edit_name
        if n == "":
            return False
        if (n in self.sel_window.ui_dict["buttons"]) is False:
            return False
        return True

    def update_sel_bt(self):
        if self.exists_bt() is False:
            return
        self.sel_window.ui_dict[
            "buttons"][self.edit_name] = self.update_bt_dict()
        self.sel_window.update_bt(self.edit_name)

    def check_saving_changes(self):
        msg = u"UIが変更されています\n保存しますか？"
        if util.MessageBox().query_box(parent=self, msg_str=msg):
            self.save_bt()

    def close_editor(self):
        if self.changes is False:
            self.close()
            return
        self.sel_window.edit_mode = False
        QApplication.restoreOverrideCursor()
        self.close()

    def save_bt(self):
        self.update_sel_bt()
        self.sel_window.save_bt_dict()
        self.set_change_sign_to_title(state=False)

    def add_obj_name_to_sel_list(self):
        # TODO:ちゃんとカーソルポジションとる
        txt_list = self.selList.toPlainText().split("\n")
        input_list = []
        for i in txt_list:
            if i != "":
                input_list.append(i)
        # self.selList.cursorForPosition(QPoint(999, 0))
        for obj in MaxPlus.SelectionManager.GetNodes():
            input_list.append(obj.Name)
            # self.selList.insertPlainText("{}\n".format(obj.Name))
        self.selList.setText("\n".join(input_list))
        self.update_sel_bt()

    def clear_sel_list(self):
        self.selList.setText("")
        self.update_sel_bt()

    def get_color_by_picker(self):
        # カラーピッカー起動
        return QColorDialog.getColor(Qt.green, self)

    def parse_rgba(self, rgbf):
        return [
            int(rgbf[0] * 255),
            int(rgbf[1] * 255),
            int(rgbf[2] * 255),
            int(rgbf[3] * 255)
        ]

    def set_lb_color(self):
        r"""ダイアログを出して色選択"""
        def_col = QColor(
            self.lb_col[0],
            self.lb_col[1],
            self.lb_col[2],
            self.lb_col[3]
        )
        color = QColorDialog.getColor(def_col, self)
        if color.isValid():
            self.lb_col = self.parse_rgba(color.getRgbF())
            self.colBt.setPalette(QPalette(color))
            self.colBt.setAutoFillBackground(True)
            # self.clearSelListBt.setPalette(QPalette(QColor(0, 0, 0, 0)))
            # self.clearSelListBt.setAutoFillBackground(True)
        self.update_sel_bt()

    def get_bt_dict(self):
        return {
            "bt_text": "new_button",
            "set_checkable": False,
            "checked": False,
            "pos": [0, 0],
            "size": [64, 32],
            "icon": "",
            "color": [100, 100, 100, 255],
            "style_sheet": "",
            # "depth": 0,
            # "tab_stop": 0,
            "select_obj": [],
            "scripts": "",
            "script_type": "ms"
        }

    def create_bt_key_name(self):
        bts = self.sel_window.ui_dict["buttons"]
        btname = "pushButton"
        cnt = 1
        while btname in bts:
            cnt += 1
            btname = "pushButton_{}".format(str(cnt))
        return btname

    def add_button(self):
        self.sel_window.show()
        self.set_change_sign_to_title()
        key_name = self.create_bt_key_name()
        self.sel_window.ui_dict["buttons"][key_name] = self.get_bt_dict()
        self.sel_window.add_buttons()

    def import_button(self):
        flt = "ui files (*.ui);;xml files (*.xml);;All (*)"
        ret = self.open_file_path_dialog(
            type_filter=flt, def_dir=self.xml_path)
        if ret is "":
            return
        self.xml_path = ret
        self.set_change_sign_to_title()
        self.import_bt_from_xml(ret)
        self.sel_window.add_buttons()
        self.sel_window.save_bt_dict()

    def del_button(self):
        if self.exists_bt() is False:
            return
        self.set_change_sign_to_title()
        self.sel_window.ui_dict["buttons"].pop(self.edit_name)
        # print(self.sel_window.ui_dict)
        self.sel_window.add_buttons()

    def import_bt_from_xml(self, xmlfile):
        tree = ET.parse(xmlfile)
        root = tree.getroot()

        bt_dict = self.sel_window.ui_dict["buttons"]
        for widgets in root.iter('widget'):
            if widgets.attrib["class"] != "QPushButton":
                continue
            key_name = widgets.attrib["name"]
            if (key_name in bt_dict) is False:
                bt_dict[key_name] = self.get_bt_dict()  # 辞書を直書き
            props = widgets.findall('property')
            for prop in props:
                rect = prop.find("rect")
                if rect is None:
                    continue
                x = int(rect.find("x").text)
                y = int(rect.find("y").text)
                w = int(rect.find("width").text)
                h = int(rect.find("height").text)
                bt_dict[key_name]["pos"] = [x, y]
                bt_dict[key_name]["size"] = [w, h]
        self.sel_window.ui_dict["buttons"] = bt_dict
