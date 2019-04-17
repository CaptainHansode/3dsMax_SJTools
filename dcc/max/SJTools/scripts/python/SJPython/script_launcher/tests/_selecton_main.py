# -*- coding:utf-8 -*-
# Copyright (C)
# Author:半袖船長
# Contact:
r"""select - on
自前ツールの転用です
元はこちら http://www.sakaiden.com
"""
from __future__ import absolute_import
from __future__ import division
from __future__ import print_function
from __future__ import unicode_literals
from collections import OrderedDict
from time import sleep

import winsound  # アラート音用
import xml.etree.ElementTree as ET  # xml用
import MaxPlus
import os
import os.path
import collections
import json
import copy

import selecton.cmn_util as util
import selecton.config as cnfg
import grp_tools_lib.lic as lic
import functools


reload(util)
reload(cnfg)
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


class ReiteratableWrapper(object):
    r"""ジェネレーターをイテレーターとして扱うラッパー"""
    def __init__(self, f):
        self._f = f

    def __iter__(self):
        return self._f()


class FocusOutEventFilter(QObject):
    def eventFilter(self, widget, event):
        if event.type() == QEvent.FocusOut:
            print('focus out')
        return False


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

        self.shift_pressed = False
        self.ctrl_pressed = False
        self.sel_mode = 0
        self.all_objs = []

        self.lb_col = [0, 200, 160, 255]
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

    def eventFilter(self, object, event):
        # アクティブでなくなった時
        if event.type() == QEvent.WindowDeactivate:
            self.update_sel_bt()
        # フォーカスが外れた時
        # elif event.type() == QEvent.FocusOut:
        #     print("Out")
        # それ以外は、通常のeventFilterを実行
        # else:
        #     return super(self).eventFilter(object, event)

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
        except:
            import traceback
            traceback.print_exc()
        self.deleteLater()

    def setup_ui(self):
        self.centralwidget = QWidget(self)
        self.centralwidget.setObjectName("centralwidget")
        self.gridLayout = QGridLayout(self.centralwidget)
        self.gridLayout.setObjectName("gridLayout")
        self.bgImgGb = QGroupBox(self.centralwidget)
        self.bgImgGb.setMinimumSize(QSize(0, 52))
        self.bgImgGb.setMaximumSize(QSize(16777215, 52))
        self.bgImgGb.setObjectName("bgImgGb")
        self.horizontalLayout_8 = QHBoxLayout(self.bgImgGb)
        self.horizontalLayout_8.setObjectName("horizontalLayout_8")
        self.bgImgPath = QLineEdit(self.bgImgGb)
        self.bgImgPath.setObjectName("bgImgPath")
        self.horizontalLayout_8.addWidget(self.bgImgPath)
        self.bgImgBt = QToolButton(self.bgImgGb)
        self.bgImgBt.setObjectName("bgImgBt")
        self.horizontalLayout_8.addWidget(self.bgImgBt)
        self.gridLayout.addWidget(self.bgImgGb, 2, 0, 1, 1)
        self.scriptEditGb = QGroupBox(self.centralwidget)
        self.scriptEditGb.setMinimumSize(QSize(0, 180))
        self.scriptEditGb.setMaximumSize(QSize(16777215, 16777215))
        self.scriptEditGb.setObjectName("scriptEditGb")
        self.verticalLayout_3 = QVBoxLayout(self.scriptEditGb)
        self.verticalLayout_3.setObjectName("verticalLayout_3")
        self.horizontalLayout_5 = QHBoxLayout()
        self.horizontalLayout_5.setContentsMargins(-1, -1, -1, 0)
        self.horizontalLayout_5.setObjectName("horizontalLayout_5")
        self.msRb = QRadioButton(self.scriptEditGb)
        self.msRb.setChecked(True)
        self.msRb.setObjectName("msRb")
        self.horizontalLayout_5.addWidget(self.msRb)
        self.pyRb = QRadioButton(self.scriptEditGb)
        self.pyRb.setObjectName("pyRb")
        self.horizontalLayout_5.addWidget(self.pyRb)
        self.verticalLayout_3.addLayout(self.horizontalLayout_5)
        self.scriptSource = QTextEdit(self.scriptEditGb)
        self.scriptSource.setObjectName("scriptSource")
        self.verticalLayout_3.addWidget(self.scriptSource)
        self.testRunBt = QPushButton(self.scriptEditGb)
        self.testRunBt.setObjectName("testRunBt")
        self.verticalLayout_3.addWidget(self.testRunBt)
        self.gridLayout.addWidget(self.scriptEditGb, 5, 0, 1, 1)
        self.btEditLayout = QHBoxLayout()
        self.btEditLayout.setContentsMargins(-1, -1, -1, 0)
        self.btEditLayout.setObjectName("btEditLayout")
        self.btStats = QGroupBox(self.centralwidget)
        self.btStats.setMinimumSize(QSize(0, 120))
        self.btStats.setMaximumSize(QSize(280, 240))
        self.btStats.setObjectName("btStats")
        self.verticalLayout_4 = QVBoxLayout(self.btStats)
        self.verticalLayout_4.setObjectName("verticalLayout_4")
        self.horizontalLayout_10 = QHBoxLayout()
        self.horizontalLayout_10.setObjectName("horizontalLayout_10")
        self.label_3 = QLabel(self.btStats)
        self.label_3.setObjectName("label_3")
        self.horizontalLayout_10.addWidget(self.label_3)
        self.btTxt = QLineEdit(self.btStats)
        self.btTxt.setObjectName("btTxt")
        self.horizontalLayout_10.addWidget(self.btTxt)
        self.verticalLayout_4.addLayout(self.horizontalLayout_10)
        self.horizontalLayout_3 = QHBoxLayout()
        self.horizontalLayout_3.setContentsMargins(-1, -1, -1, 0)
        self.horizontalLayout_3.setObjectName("horizontalLayout_3")
        self.label_4 = QLabel(self.btStats)
        self.label_4.setObjectName("label_4")
        self.horizontalLayout_3.addWidget(self.label_4)
        self.btX = QSpinBox(self.btStats)
        self.btX.setMaximum(2048)
        self.btX.setObjectName("btX")
        self.horizontalLayout_3.addWidget(self.btX)
        self.label_5 = QLabel(self.btStats)
        self.label_5.setObjectName("label_5")
        self.horizontalLayout_3.addWidget(self.label_5)
        self.btY = QSpinBox(self.btStats)
        self.btY.setMaximum(2048)
        self.btY.setObjectName("btY")
        self.horizontalLayout_3.addWidget(self.btY)
        self.label_6 = QLabel(self.btStats)
        self.label_6.setObjectName("label_6")
        self.horizontalLayout_3.addWidget(self.label_6)
        self.btW = QSpinBox(self.btStats)
        self.btW.setMinimum(2)
        self.btW.setMaximum(2048)
        self.btW.setObjectName("btW")
        self.horizontalLayout_3.addWidget(self.btW)
        self.label_7 = QLabel(self.btStats)
        self.label_7.setObjectName("label_7")
        self.horizontalLayout_3.addWidget(self.label_7)
        self.btH = QSpinBox(self.btStats)
        self.btH.setMinimum(2)
        self.btH.setMaximum(2048)
        self.btH.setObjectName("btH")
        self.horizontalLayout_3.addWidget(self.btH)
        self.verticalLayout_4.addLayout(self.horizontalLayout_3)
        self.horizontalLayout_11 = QHBoxLayout()
        self.horizontalLayout_11.setObjectName("horizontalLayout_11")
        self.coloCb = QCheckBox(self.btStats)
        self.coloCb.setMaximumSize(QSize(48, 16777215))
        self.coloCb.setObjectName("coloCb")
        self.horizontalLayout_11.addWidget(self.coloCb)
        self.colLbl = QLabel(self.btStats)
        self.colLbl.setMinimumSize(QSize(0, 0))
        self.colLbl.setObjectName("colLbl")
        self.horizontalLayout_11.addWidget(self.colLbl)
        self.colBt = QToolButton(self.btStats)
        self.colBt.setObjectName("colBt")
        self.horizontalLayout_11.addWidget(self.colBt)
        self.verticalLayout_4.addLayout(self.horizontalLayout_11)
        #Icon
        self.iconLayout = QHBoxLayout()
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
        self.verticalLayout_4.addLayout(self.iconLayout)
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
        self.horizontalLayout_2 = QHBoxLayout()
        self.horizontalLayout_2.setContentsMargins(-1, -1, -1, 0)
        self.horizontalLayout_2.setObjectName("horizontalLayout_2")
        self.addSelListBt = QPushButton(self.selObjGb)
        self.addSelListBt.setObjectName("addSelListBt")
        self.horizontalLayout_2.addWidget(self.addSelListBt)
        self.clearSelListBt = QPushButton(self.selObjGb)
        self.clearSelListBt.setMaximumSize(QSize(56, 16777215))
        self.clearSelListBt.setObjectName("clearSelListBt")
        self.horizontalLayout_2.addWidget(self.clearSelListBt)
        self.verticalLayout_2.addLayout(self.horizontalLayout_2)
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
        self.menubar.setGeometry(QRect(0, 0, 465, 24))
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
        self.scriptEditGb.setTitle("Script Edit")
        self.msRb.setText("MaxScript")
        self.pyRb.setText("Python")
        self.coloCb.setText(u"カラー")
        self.colLbl.setText(u"ボタンカラー")
        self.testRunBt.setText("TestRun")
        self.btStats.setTitle("Button Setting")
        self.label_3.setText("Text")
        self.label_4.setText("X")
        self.label_5.setText("Y")
        self.label_6.setText("W")
        self.label_7.setText("H")
        self.colBt.setText("...")
        self.iconLb.setText(u"アイコン")
        self.iconBt.setText("...")
        self.selObjGb.setTitle("SelectList")
        self.addSelListBt.setText(u"選択を追加")
        self.clearSelListBt.setText(u"クリア")
        self.saveBt.setText("Save")
        self.closeBt.setText("Close")
        self.createBtGb.setTitle("Create Button")
        self.addBt.setText(u"ボタン追加")
        self.importBt.setText(u"ボタン読み込み")
        self.delBt.setText(u"ボタン削除")
        self.menuMenu.setTitle("Menu")

    def set_default(self):
        self.colLbl.setPalette(QPalette(QColor(0, 200, 160, 255)))
        self.colLbl.setAutoFillBackground(True)

    def event_connect(self):
        self.btTxt.editingFinished.connect(self.update_sel_bt)
        self.selList.selectionChanged.connect(self.update_sel_bt)
        self.scriptSource.selectionChanged.connect(self.update_sel_bt)
        self.clearSelListBt.clicked.connect(self.clear_sel_list)
        self.addSelListBt.clicked.connect(self.add_obj_name_to_sel_list)
        self.testRunBt.clicked.connect(self.script_test_run)
        self.bgImgBt.clicked.connect(self.load_bg_img)

        self.addBt.clicked.connect(self.add_button)
        self.importBt.clicked.connect(self.import_button)
        self.delBt.clicked.connect(self.del_button)
        self.colBt.clicked.connect(self.set_lb_color)

        self.btX.valueChanged.connect(self.update_sel_bt)
        self.btY.valueChanged.connect(self.update_sel_bt)
        self.btW.valueChanged.connect(self.update_sel_bt)
        self.btH.valueChanged.connect(self.update_sel_bt)
        self.coloCb.stateChanged.connect(self.update_sel_bt)
        self.saveBt.clicked.connect(self.save_bt)
        self.closeBt.clicked.connect(self.close_editor)

    def get_temp_file(self, fname):
        fname = fname or "_tmp"
        return os.path.join(os.environ.get("Temp"), fname)

    def run_ms(self, ms):
        """macroscript run"""
        # return MaxPlus.Core.EvalMAXScript(ms)
        tmp_ms = self.get_temp_file("_tmp_macros.ms")
        file = open(tmp_ms, "w")
        file.write(ms)
        file.close()
        try:
            MaxPlus.Core.EvalMAXScript("filein \"{}\"".format(tmp_ms))
        except:
            import traceback
            traceback.print_exc()

    def run_py(self, py):
        """python run"""
        tmp_py = self.get_temp_file("_tmp_python.py")
        file = open(tmp_py, "w")
        file.write(py)
        file.close()
        try:
            MaxPlus.Core.EvalMAXScript(
                "python.ExecuteFile \"{}\"".format(tmp_py))
        except:
            import traceback
            traceback.print_exc()

    def script_test_run(self):
        s = self.scriptSource.toPlainText()
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
        self.changes = True
        self.set_change_sign_to_title()

        self.bgImgPath.setText(ret)
        self.ui_dict["bg_image"] = ret
        self.sel_window.ui_dict["bg_image"] = ret
        self.sel_window.update_bg_img()

    def set_change_sign_to_title(self, changes=True):
        if changes:
            if self.windowTitle().find("Changes") is not -1:
                return
            self.setWindowTitle("{} * Changes".format(self.windowTitle()))
        else:
            wtitle = self.windowTitle().replace(" * Changes", "")
            self.setWindowTitle(wtitle)

    def update_ui(self):
        r"""ボタン情報でUIアップデート
        注意!
        setValueなどの値変更もChangeEventとして取得するので
        何処かのChangeEventを一時的に停止してから値変更すること
        """
        if self.edit_name == "":
            return

        self.changes = True
        self.set_change_sign_to_title()

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
        if col is None:
            self.coloCb.setChecked(False)
        else:
            self.coloCb.setChecked(True)
            self.lb_col = col
            self.colLbl.setPalette(QPalette(
                    QColor(col[0], col[1], col[2], col[3])))

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
        col = None
        if self.coloCb.isChecked():
            col = [
                self.lb_col[0], self.lb_col[1], self.lb_col[2], self.lb_col[3]]

        stype = "ms"
        if self.pyRb.isChecked():
            stype = "py"

        bt_dict = self.get_bt_dict()
        bt_dict["bt_text"] = self.btTxt.text()
        bt_dict["pos"] = [self.btX.value(), self.btY.value()]
        bt_dict["size"] = [self.btW.value(), self.btH.value()]
        bt_dict["icon"] = ""
        bt_dict["color"] = col
        bt_dict["transparency"] = 255
        bt_dict["style_sheet"] = ""
        # bt_dict["depth"] = self.btTxt.text()
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
        # print("bt update")
        self.sel_window.ui_dict["buttons"][self.edit_name] = self.update_bt_dict()
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
        self.close()

    def save_bt(self):
        self.update_sel_bt()
        self.sel_window.save_bt_dict()
        self.changes = False
        self.set_change_sign_to_title(changes=False)

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
            self.colLbl.setPalette(QPalette(color))
            self.colLbl.setAutoFillBackground(True)
            # self.clearSelListBt.setPalette(QPalette(QColor(0, 0, 0, 0)))
            # self.clearSelListBt.setAutoFillBackground(True)
        self.update_sel_bt()

    def get_bt_dict(self):
        return {
            "obj_name": "button",
            "name": "button",
            "bt_text": "new_button",
            "pos": [0, 0],
            "size": [64, 32],
            "icon": "",
            "color": None,
            "transparency": "",
            "style_sheet": "",
            "depth": 0,
            "tab_stop": 0,
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
        self.changes = True
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
        self.changes = True
        self.set_change_sign_to_title()
        self.import_bt_from_xml(ret)
        self.sel_window.add_buttons()
        self.sel_window.save_bt_dict()

    def del_button(self):
        if self.exists_bt() is False:
            return
        self.changes = True
        self.set_change_sign_to_title()
        self.sel_window.ui_dict["buttons"].pop(self.edit_name)
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


class SJSelectonWindow(QMainWindow):
    def __init__(self, *args, **kwargs):
        super(SJSelectonWindow, self).__init__(*args, **kwargs)
        self.setWindowFlags(Qt.Tool)
        self.ui_dict = {}
        self.helper_obj = None
        self.on_ad_rig_node = False
        self.tool_name = "SJSelecton"
        self.shift_pressed = False
        self.ctrl_pressed = False
        self.sel_mode = 0
        self.all_objs = []
        self.bts = {}

        self.edit_mode = False
        self.sel_editor = None

    def setup_ui(self):
        # セントラルを作成
        self.centralwidget = QWidget(self)
        self.centralwidget.setObjectName("centralwidget")
        self.verticalLayout_3 = QVBoxLayout(self.centralwidget)
        self.verticalLayout_3.setObjectName("verticalLayout_3")
        self.mainArea = QScrollArea(self.centralwidget)
        self.mainArea.setWidgetResizable(True)
        self.mainArea.setObjectName("mainArea")
        self.mainAreaWidgetContents = QWidget()
        self.mainAreaWidgetContents.setGeometry(QRect(0, 0, 468, 468))
        self.mainAreaWidgetContents.setObjectName("mainAreaWidgetContents")
        self.verticalLayout = QVBoxLayout(self.mainAreaWidgetContents)
        self.verticalLayout.setObjectName("verticalLayout")
        self.frame = QFrame(self.mainAreaWidgetContents)
        self.frame.setFrameShape(QFrame.StyledPanel)
        self.frame.setFrameShadow(QFrame.Raised)
        self.frame.setObjectName("frame")

        self.set_bg_img()
        self.update_bg_img()
        self.add_buttons()

        self.verticalLayout.addWidget(self.frame)
        self.mainArea.setWidget(self.mainAreaWidgetContents)
        self.verticalLayout_3.addWidget(self.mainArea)

        # Snd Area
        self.scrollArea = QScrollArea(self.centralwidget)
        self.scrollArea.setMinimumSize(QSize(0, 96))
        self.scrollArea.setWidgetResizable(True)
        self.scrollArea.setObjectName("scrollArea")
        self.subAreaWidgetContents = QWidget()
        self.subAreaWidgetContents.setGeometry(QRect(0, 0, 357, 94))
        self.subAreaWidgetContents.setObjectName("subAreaWidgetContents")
        self.verticalLayout_2 = QVBoxLayout(self.subAreaWidgetContents)
        self.verticalLayout_2.setObjectName("verticalLayout_2")
        self.selModeGb = QGroupBox(self.subAreaWidgetContents)
        self.selModeGb.setObjectName("selModeGb")
        self.verticalLayout_5 = QVBoxLayout(self.selModeGb)
        self.verticalLayout_5.setSpacing(6)
        self.verticalLayout_5.setContentsMargins(0, 0, 0, 0)
        self.verticalLayout_5.setObjectName("verticalLayout_5")
        self.hint = QLabel(self.selModeGb)
        self.hint.setMaximumSize(QSize(16777215, 12))
        self.hint.setObjectName("hint")
        self.verticalLayout_5.addWidget(self.hint)
        self.horizontalRbLayout = QHBoxLayout()
        self.horizontalRbLayout.setContentsMargins(-1, -1, -1, 0)
        self.horizontalRbLayout.setObjectName("horizontalRbLayout")
        self.nameSelRb = QRadioButton(self.selModeGb)
        self.nameSelRb.setChecked(True)
        self.nameSelRb.setObjectName("nameSelRb")
        self.horizontalRbLayout.addWidget(self.nameSelRb)
        self.searchSelRb = QRadioButton(self.selModeGb)
        self.searchSelRb.setObjectName("searchSelRb")
        self.horizontalRbLayout.addWidget(self.searchSelRb)
        self.searchTreeSelRb = QRadioButton(self.selModeGb)
        self.searchTreeSelRb.setObjectName("searchTreeSelRb")
        self.horizontalRbLayout.addWidget(self.searchTreeSelRb)
        self.verticalLayout_5.addLayout(self.horizontalRbLayout)
        self.runCb = QCheckBox(self.selModeGb)
        self.runCb.setStyleSheet("background:rgb(234, 64, 0);\n"
"font:rgb(32, 32, 32)")
        self.runCb.setChecked(True)
        self.runCb.setObjectName("runCb")
        self.verticalLayout_5.addWidget(self.runCb)
        self.verticalLayout_2.addWidget(self.selModeGb)
        self.scrollArea.setWidget(self.subAreaWidgetContents)
        self.verticalLayout_3.addWidget(self.scrollArea)
        self.verticalLayout_3.setStretch(0, 1)
        self.setCentralWidget(self.centralwidget)
        self.menubar = QMenuBar(self)
        self.menubar.setGeometry(QRect(0, 0, 377, 24))
        self.menubar.setObjectName("menubar")
        self.setMenuBar(self.menubar)
        self.statusbar = QStatusBar(self)
        self.statusbar.setObjectName("statusbar")
        self.setStatusBar(self.statusbar)

        # ここからオリジナル設定
        self.hint.setText(u"Ctrlを押しながらで追加選択するです")
        self.searchTreeSelRb.setText(u"ツリーから検索")
        self.nameSelRb.setText(u"名前で選択")
        self.searchSelRb.setText(u"シーンから検索")
        self.runCb.setText(u"ボタンの内容を実行")
        self.runCb.hide()

        # RarioButton Group これでidを拾える
        self.selModeBtGroup = QButtonGroup()
        self.selModeBtGroup.addButton(self.nameSelRb, 0)
        self.selModeBtGroup.addButton(self.searchSelRb, 1)
        self.selModeBtGroup.addButton(self.searchTreeSelRb, 2)
        self.set_sel_mode(
            self.helper_obj.Object.ParameterBlock.LastSelMode.Value)
        self.change_sel_mode()  # 初回回収

        self.nameSelRb.toggled.connect(self.change_sel_mode)
        self.searchSelRb.toggled.connect(self.change_sel_mode)
        self.searchTreeSelRb.toggled.connect(self.change_sel_mode)

        self.scrollArea.show()
        self.centralwidget.show()
        QMetaObject.connectSlotsByName(self)

        obj_param = self.helper_obj.Object.ParameterBlock
        self.setGeometry(QRect(
            obj_param.LastPosX.Value,
            obj_param.LastPosY.Value,
            obj_param.LastWidth.Value,
            obj_param.LastHeight.Value))
        print("Finish Set Up!")

    def keyPressEvent(self, event):
        key = event.key()
        if key == Qt.Key.Key_Shift:
            self.shift_pressed = True
        if key == Qt.Key.Key_Control:
            self.ctrl_pressed = True

    def keyReleaseEvent(self, event):
        self.shift_pressed = False
        self.ctrl_pressed = False

    def closeEvent(self, event):
        r"""close event override"""
        obj_param = self.helper_obj.Object.ParameterBlock
        obj_param.LastPosX.Value = self.x() + 8
        obj_param.LastPosY.Value = self.y() + 30
        obj_param.LastWidth.Value = self.width()
        obj_param.LastHeight.Value = self.height()
        obj_param.LastSelMode.Value = self.selModeBtGroup.checkedId()
        # UIが沢山あるとクッソ重いのでJson書き込み禁止
        # self.set_ui_dict_value(self.helper_obj, self.ui_dict)
        if self.edit_mode is False:
            self.deleteLater()

    def set_bg_img(self):
        self.bg_img = QLabel(self.frame)
        self.bg_img.setAlignment(
            Qt.AlignLeading|Qt.AlignLeft|Qt.AlignTop)
        self.bg_img.setObjectName("bg_img")

    def get_img_size(self, img):
        """画像の幅と高さ情報を採取"""
        pic = QGraphicsPixmapItem(QPixmap(img))
        w = pic.boundingRect().width()
        h = pic.boundingRect().height()
        return [w, h]

    def update_bg_img(self):
        img = self.ui_dict["bg_image"]
        if img == "":
            return
        if os.path.exists(img) is False:
            print("No Found Path {}".format(img))
            return
        size = self.get_img_size(img)

        self.ui_dict["width"] = size[0]
        self.ui_dict["height"] = size[1]

        self.frame.setMinimumSize(QSize(size[0], size[1]))
        self.bg_img.setMinimumSize(QSize(size[0], size[1]))
        self.bg_img.setGeometry(QRect(0, 0, size[0], size[1]))
        self.bg_img.setPixmap(img)
        self.bg_img.show()

    def get_color_icon(self, col, size):
        # 埋め尽くしてしまうと見えなくなるのでちょっと小さくする
        image = QImage(size[0], size[1], QImage.Format_ARGB32_Premultiplied)
        painter = QPainter(image)
        painter.begin(image)
        painter.fillRect(
            0, 0, size[0], size[1], QColor(col[0], col[1], col[2], col[3]))
        painter.end()
        # image.save(r'D:/test.png', 'PNG')
        icon = QIcon()
        icon.addPixmap(QPixmap(image), QIcon.Normal, QIcon.Off)
        return icon

    def set_bt_palette_col(self):
        self.colLbl.setPalette(QPalette(color))

    def add_buttons(self):
        for bt in self.bts:
            self.bts[bt].setParent(None)
            self.bts[bt].deleteLater()

        self.bts = {}
        self.bts_dict = self.ui_dict["buttons"]
        for item in self.bts_dict:
            uname = str(item)
            self.bts[uname] = QPushButton(self.frame)
            self.update_bt(uname)

            self.bts[uname].clicked.connect(
                lambda ms=uname: self.run_bt(ms))

    def update_bt(self, uname):
        bt_text = self.bts_dict[uname]["bt_text"]
        pos = self.bts_dict[uname]["pos"]
        size = copy.deepcopy(self.bts_dict[uname]["size"])
        col = self.bts_dict[uname]["color"]
        stl_sheet = self.bts_dict[uname]["style_sheet"]
        icon = ""

        self.bts[uname].setGeometry(
            QRect(pos[0], pos[1], size[0], size[1])
            )
        self.update()

        # Maxはスタイルシートが効かないので変わりにアイコンを載せる
        self.bts[uname].setText(bt_text)
        if col is None:
            self.bts[uname].setPalette(
                QPalette(QColor(36, 36, 36, 255)))
        elif icon == "":
            # if size[0] > 7:
            #     size[0] = size[0] - 6
            # if size[1] > 7:
            #     size[1] = size[1] - 6
            # ico = self.get_color_icon(color, size)
            # self.bts[uname].setIcon(ico)
            # self.bts[uname].setIconSize(QSize(size[0], size[1]))
            self.bts[uname].setPalette(
                QPalette(QColor(col[0], col[1], col[2], col[3])))
        self.bts[uname].show()

    def get_temp_file(self, fname):
        fname = fname or "_tmp"
        return os.path.join(os.environ.get("Temp"), fname)

    def run_ms(self, ms):
        """macroscript run"""
        # return MaxPlus.Core.EvalMAXScript(ms)
        tmp_ms = self.get_temp_file("_tmp_macros.ms")
        file = open(tmp_ms, "w")
        file.write(ms)
        file.close()
        try:
            MaxPlus.Core.EvalMAXScript("filein \"{}\"".format(tmp_ms))
        except:
            import traceback
            traceback.print_exc()

    def run_py(self, py):
        """python run"""
        tmp_py = self.get_temp_file("_tmp_python.py")
        file = open(tmp_py, "w")
        file.write(py)
        file.close()
        try:
            MaxPlus.Core.EvalMAXScript(
                "python.ExecuteFile \"{}\"".format(tmp_py))
        except:
            import traceback
            traceback.print_exc()

    def set_ui_dict_value(self, obj, dict_data):
        r"""set dict data
        Jsonを書き込み
        """
        # Jsonで書き込み
        obj.Object.ParameterBlock.UiDict.Value = json.dumps(
            dict_data, indent=4)

    def save_bt_dict(self):
        self.set_ui_dict_value(self.helper_obj, self.ui_dict)

    def set_ui_dict(self, ui_dict, obj):
        self.ui_dict = ui_dict
        self.helper_obj = obj

    def change_sel_mode(self):
        self.sel_mode = self.selModeBtGroup.checkedId()
        if self.sel_mode is 0:
            return
        self.all_objs = []
        if self.sel_mode is 1:
            # TODO:イテレーターに直すやり方変える
            # itr_nodes = functools.partial(self.get_all_nodes)
            # self.all_objs = ReiteratableWrapper(itr_nodes)
            for obj in self.get_all_nodes():
                self.all_objs.append(obj)
        if self.sel_mode is 2:
            this_root = self.get_root(self.helper_obj)
            self.all_objs = self.get_all_children(this_root)

    def set_sel_mode(self, id):
        self.selModeBtGroup.button(id).setChecked(True)

    def run_bt(self, uname):
        bt_dict = self.bts_dict[uname]
        if self.edit_mode:
            self.sel_editor.edit_name = uname
            self.sel_editor.update_ui()
            if self.runCb.isChecked() is False:
                return

        sel_obj_names = bt_dict["select_obj"]
        if self.selModeBtGroup.checkedId() is 0:
            nodes = self.get_node_by_name(sel_obj_names)
        else:
            nodes = self.get_node_by_search(sel_obj_names)
        if self.ctrl_pressed is False:  # siftが押されていないとクリア
            MaxPlus.SelectionManager.ClearNodeSelection()
        MaxPlus.SelectionManager.SelectNodes(self.get_inode_tab(nodes))

        # Script実行
        sc = bt_dict["scripts"]
        if sc == "":
            return
        if bt_dict["script_type"] == "ms":
            self.run_ms(sc)
        else:
            self.run_py(sc)

    def get_node_by_name(self, names):
        result = []
        # names = ["RuriA_Haru_Bip001 Head"]
        for n in names:
            node = MaxPlus.INode.GetINodeByName(n)
            if node:
                result.append(node)
        return result

    def get_node_by_search(self, names):
        result = []
        if len(names) is 0:
            return result
        for n in names:
            for obj in self.all_objs:
                if obj.Name.find(n) is not -1:
                    result.append(obj)
                    break
        if len(result) is 0:
            print("Not found objects")
        return result

    def select_nodes(self, nodes):
        inodetab = MaxPlus.INodeTab()
        for n in nodes:
            inodetab.Append(n)
        MaxPlus.SelectionManager.SelectNodes(inodetab)

    def get_inode_tab(self, nodes):
        inodetab = MaxPlus.INodeTab()
        for n in nodes:
            inodetab.Append(n)
        return inodetab

    def serch_and_select_obj(self, sel_list):
        nodes = []
        if self.shift_pressed is False:  # ctrlが押されていないとクリア
            MaxPlus.SelectionManager.ClearNodeSelection()
        # for ly in self.layers_dict[lyname]:
        #     nodes.extend(ly.GetNodes())
        MaxPlus.SelectionManager.SelectNodes(self.get_inode_tab(nodes))

    def descendants(self, node):
        for c in node.Children:
            yield c
            for d in self.descendants(c):
                yield d

    def get_all_nodes(self):
        return iter(self.descendants(MaxPlus.Core.GetRootNode()))

    def get_all_children(self, node, ret=[]):
        result = []
        result.append(node)
        # 再起しながら
        for c in node.Children:
            result.extend(self.get_all_children(c, result))
        return result

    def get_root(self, obj):
        r"""get root"""
        parent = obj.GetParent()
        result = obj
        while parent.GetClassName() != "Root Node":
            result = parent
            parent = parent.GetParent()
        return result


class SJSelectonList(QMainWindow):
    # QDockWidgetとするとドッキング可能になる QMainWindow
    def __init__(self, *args, **kw):
        QMainWindow.__init__(self, *args, **kw)
        self.setWindowFlags(Qt.Tool)
        self.tool_name = "SJSelectonList"
        self.version = "0.0.0.1"
        self.auther = ""
        self.setObjectName(self.tool_name)
        self.setWindowTitle("{} v{}".format(self.tool_name, self.version))

        self.sel_helpers = []
        self.shift_pressed = False
        # self.setMaximumSize(QSize(16777215, 840))

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

        # self.setup_menu_ui()
        self.setup_ui()

    def setup_ui(self):
        self.resize(170, 374)
        self.centralwidget = QWidget(self)
        self.centralwidget.setObjectName("centralwidget")
        self.verticalLayout_3 = QVBoxLayout(self.centralwidget)
        self.verticalLayout_3.setObjectName("verticalLayout_3")
        self.horizontalLayout = QHBoxLayout()
        self.horizontalLayout.setContentsMargins(6, -1, -1, 6)
        self.horizontalLayout.setObjectName("horizontalLayout")
        self.groupBox = QGroupBox(self.centralwidget)
        self.groupBox.setObjectName("groupBox")
        self.groupBox.setTitle("selecton List")
        self.verticalLayout = QVBoxLayout(self.groupBox)
        self.verticalLayout.setObjectName("verticalLayout")

        self.reloadBt = QPushButton(self.groupBox)
        self.reloadBt.setObjectName("reloadBt")
        self.reloadBt.setText("Reload")
        self.verticalLayout.addWidget(self.reloadBt)

        self.selectorList = QListWidget(self.groupBox)
        self.selectorList.setObjectName("selectorList")
        self.verticalLayout.addWidget(self.selectorList)

        self.openBt = QPushButton(self.groupBox)
        self.openBt.setMinimumSize(QSize(0, 32))
        self.openBt.setObjectName("openBt")
        self.openBt.setText("Open")
        self.verticalLayout.addWidget(self.openBt)

        ico = QIcon()
        img = os.path.join(
            os.path.dirname(os.path.abspath(__file__)), "images/bt_open.png")
        ico.addPixmap(QPixmap(img), QIcon.Normal, QIcon.Off)
        self.openBt.setIcon(ico)
        self.openBt.setIconSize(QSize(128, 32))

        self.addBt = QPushButton(self.groupBox)
        self.addBt.setObjectName("addBt")
        self.addBt.setText("Add")
        self.verticalLayout.addWidget(self.addBt)

        ico = QIcon()
        img = os.path.join(
            os.path.dirname(os.path.abspath(__file__)), "images/bt_add.png")
        ico.addPixmap(QPixmap(img), QIcon.Normal, QIcon.Off)
        self.addBt.setIcon(ico)
        self.addBt.setIconSize(QSize(128, 32))

        self.editBt = QPushButton(self.groupBox)
        self.editBt.setObjectName("editBt")
        self.editBt.setText("Edit")
        self.verticalLayout.addWidget(self.editBt)

        ico = QIcon()
        img = os.path.join(
            os.path.dirname(os.path.abspath(__file__)), "images/bt_edit.png")
        ico.addPixmap(QPixmap(img), QIcon.Normal, QIcon.Off)
        self.editBt.setIcon(ico)
        self.editBt.setIconSize(QSize(128, 32))

        # self.debugBt = QPushButton(self.groupBox)
        # self.debugBt.setObjectName("debugBt")
        # self.debugBt.setText("Debug")
        # self.verticalLayout.addWidget(self.debugBt)

        self.horizontalLayout.addWidget(self.groupBox)
        self.verticalLayout_3.addLayout(self.horizontalLayout)
        self.setCentralWidget(self.centralwidget)

        self.menubar = QMenuBar(self)
        self.menubar.setGeometry(QRect(0, 0, 170, 24))
        self.menubar.setObjectName("menubar")
        self.menuMenu = QMenu(self.menubar)
        self.menuMenu.setObjectName("menuMenu")
        self.menuMenu.setTitle("Menu")
        self.setMenuBar(self.menubar)

        self.statusbar = QStatusBar(self)
        self.statusbar.setObjectName("statusbar")
        self.setStatusBar(self.statusbar)
        self.menubar.addAction(self.menuMenu.menuAction())
        QMetaObject.connectSlotsByName(self)

        self.reloadBt.clicked.connect(self.set_preset)
        self.selectorList.itemDoubleClicked.connect(self.open_selecton_window)
        self.openBt.clicked.connect(self.open_selecton_window)
        self.addBt.clicked.connect(self.add_selecton)
        self.editBt.clicked.connect(self.open_selecton_editor)
        # self.debugBt.clicked.connect(self._test_edit)

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

    def closeEvent(self, event):
        r"""close event override"""
        self.config.data["posx"] = self.x() + 8
        self.config.data["posy"] = self.y() + 30
        self.config.data["width"] = self.width()
        self.config.data["height"] = self.height()
        self.config.data["last_select"] = ""
        self.config.save()
        # 閉じる
        self.deleteLater()

    def init_config(self):
        self.config.clear()
        self.config.data = self.def_config
        self.config.save()

    def keyPressEvent(self, event):
        key = event.key()
        if key == Qt.Key.Key_Shift:
            self.shift_pressed = True

    def keyReleaseEvent(self, event):
        self.shift_pressed = False

    def run_ms(self, ms):
        """macroscript run"""
        MaxPlus.Core.EvalMAXScript(ms)

    def descendants(self, node):
        for c in node.Children:
            yield c
            for d in self.descendants(c):
                yield d

    def get_all_nodes(self):
        return self.descendants(MaxPlus.Core.GetRootNode())

    def get_adrignodes_of_scene(self):
        nodes = self.get_all_nodes()
        result = []
        for obj in nodes:
            if "selectorhelper" in obj.Object.GetClassName().lower():
                result.append(obj)
        return result

    def set_preset(self):
        self.selectorList.clear()
        self.sel_helpers = self.get_adrignodes_of_scene()
        for obj in self.sel_helpers:
            self.selectorList.addItem(obj.Name)

    def get_sel_helper_of_list(self):
        sel = self.selectorList.currentIndex().row()
        if sel == -1:
            return None
        return self.sel_helpers[sel]

    def get_ui_dict_value(self, obj):
        r"""get dict data
        Jsonを読み込み
        """
        ret = obj.Object.ParameterBlock.UiDict.Value
        if ret == "":
            return {}
        return json.loads(ret)

    def set_ui_dict_value(self, obj, dict_data):
        r"""set dict data
        Jsonを書き込み
        """
        # Jsonで書き込み
        obj.Object.ParameterBlock.UiDict.Value = json.dumps(
            dict_data, indent=4)

    def close_tool_window(self, wname):
        widgets = QApplication.allWidgets()
        for w in widgets:
            if w.objectName() == wname:
                print("Closed : {}".format(w.objectName()))
                w.close()

    def close_tool_window(self, wname):
        widgets = QApplication.allWidgets()
        for w in widgets:
            if w.objectName() == wname:
                w.close()

    def get_parent_window(self):
        r"""親となるウィンドウを取得する
        Max2018の場合はMaxPlus.GetQMaxMainWindow()で取得
        """
        ver = MaxPlus.Core.GetMaxVersion()
        if ver < 1300000000:
            parent_window = MaxPlus.GetQMaxWindow()
        else:
            parent_window = MaxPlus.GetQMaxMainWindow()
        return parent_window

    def add_selecton(self):
        MaxPlus.Core.EvalMAXScript(
            "SelectorHelper pos:[0, 0, 0] isSelected:off")
        self.set_preset()

    def open_selecton_window(self):
        obj = self.get_sel_helper_of_list()
        if obj is None:
            return
        win = SJSelectonWindow(self.get_parent_window())
        _GCProtector.widgets.append(win)

        win.ui_dict = self.get_ui_dict_value(obj)  # 必要な要素を入れる
        win.helper_obj = obj
        win.setup_ui()
        win.setWindowTitle(obj.Name)
        win.setObjectName(obj.Name)
        win.show()

    def open_selecton_editor(self):
        if self.shift_pressed:
            self._test_edit()
            print("debug_edit")
            return

        obj = self.get_sel_helper_of_list()
        if obj is None:
            return
        self.close_tool_window(obj.Name)

        win = SJSelectonWindow(self.get_parent_window())
        _GCProtector.widgets.append(win)

        editor = SJSelectonEditor(self.get_parent_window())
        _GCProtector.widgets.append(editor)

        win.ui_dict = self.get_ui_dict_value(obj)  # 必要な要素を入れる
        win.helper_obj = obj
        win.setup_ui()
        win.setWindowTitle(obj.Name)
        win.setObjectName(obj.Name)

        win.edit_mode = True
        win.sel_editor = editor
        win.runCb.show()

        editor.ui_dict = self.get_ui_dict_value(obj)  # 必要な要素を入れる
        editor.helper_obj = obj
        editor.setup_ui()
        editor.set_bg_img_path()
        editor.setWindowTitle("{} Editor".format(obj.Name))
        editor.setObjectName("{}Editor".format(obj.Name))

        editor.sel_window = win

        win.show()
        editor.show()
        editor.activateWindow()

    def get_bt_dict(self):
        return {
            "obj_name": "button",
            "name": "button",
            "bt_text": "Text",
            "pos": [150, 310],
            "size": [40, 16],
            "icon": "",
            "color": [0, 255, 128, 255],
            "transparency": "",
            "style_sheet": "",
            "depth": 0,
            "tab_stop": 0,
            "select_obj": [],
            "scripts": "",
            "script_type": "ms"
        }

    def get_def_main_dict(self):
        return {
            "obj_name": "SelWindow",
            "name": "Ruri_Selector",
            "posx": 150,
            "posy": 150,
            "width": 480,
            "height": 480,
            "maxsize": [640, 640],
            "minsize": [100, 100],
            "last_select": "",
            "bg_image": "D:\\Project_TA\\GrpTools\\dcc\\common\\max\\maxscript\\scripts\\Python\\GrpPython\\selecton\\images\\ruri_selector_test.png",
            "sel_from_tree": True,
            "select_mode": 0,
            "buttons": {}
        }

    def _test_edit(self):
        obj = self.get_sel_helper_of_list()
        if obj is None:
            return
        main_ui = self.get_def_main_dict()
        main_ui["buttons"] = OrderedDict()
        main_ui["buttons"]["pushButton"] = self.get_bt_dict()
        main_ui["buttons"]["pushButton"]["select_obj"] = ["RuriA_Haru_R_eye_CTRLALL"]

        main_ui["buttons"]["pushButton_2"] = self.get_bt_dict()
        main_ui["buttons"]["pushButton_2"]["pos"] = [290, 310]
        main_ui["buttons"]["pushButton_2"]["color"] = None
        main_ui["buttons"]["pushButton_2"]["select_obj"] = ["RuriA_Haru_L_eye_CTRLALL"]
        main_ui["buttons"]["pushButton_2"]["scripts"] = """print(\"Hellow Python Run\")"""
        main_ui["buttons"]["pushButton_2"]["script_type"] = "py"

        main_ui["buttons"]["pushButton_3"] = self.get_bt_dict()
        main_ui["buttons"]["pushButton_3"]["pos"] = [10, 10]
        main_ui["buttons"]["pushButton_3"]["size"] = [128, 32]
        main_ui["buttons"]["pushButton_3"]["bt_text"] = "HellowButton"
        main_ui["buttons"]["pushButton_3"]["color"] = None
        main_ui["buttons"]["pushButton_3"]["select_obj"] = []
        main_ui["buttons"]["pushButton_3"]["scripts"] = """
            MessageBox(\"Hellow!\")
        """
        # i = 4
        # for i in range(7):
        #     btname = "butons{}".format(str(i))
        #     main_ui["buttons"][btname] = self.get_bt_dict()
        #     main_ui["buttons"][btname]["pos"] = [10, (i*10)]
        self.set_ui_dict_value(obj, main_ui)

    def reload_ui(self):
        self.config.data["posx"] = self.x() + 8
        self.config.data["posy"] = self.y() + 30
        self.config.data["last_select"] = self.preset.currentText()
        self.config.save()
