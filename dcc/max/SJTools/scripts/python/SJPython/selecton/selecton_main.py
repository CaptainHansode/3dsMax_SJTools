# -*- coding:utf-8 -*-
# Copyright (C)
# Author:半袖船長
# Contact:
r"""select - on
http://www.sakaiden.com
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
import collections
import json
import pymxs

import selecton.selecton_window as selecton_window
import selecton.selecton_editor as selecton_editor
import selecton.cmn_util as util
import selecton.config as cnfg

reload(selecton_window)
reload(selecton_editor)
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


# class ReiteratableWrapper(object):
#     r"""ジェネレーターをイテレーターとして扱うラッパー"""
#     def __init__(self, f):
#         self._f = f

#     def __iter__(self):
#         return self._f()


class SJSelectonList(QMainWindow):
    # QDockWidgetとするとドッキング可能になる QMainWindow
    def __init__(self, *args, **kw):
        QMainWindow.__init__(self, *args, **kw)
        self.setWindowFlags(Qt.Tool)
        self.tool_name = "SJSelectonList"
        self.version = "0.0.3.5"
        self.auther = ""
        self.setObjectName(self.tool_name)
        self.setWindowTitle("SJSelecton v{}".format(self.version))
        self.sel_helpers = []
        self.shift_pressed = False
        self.ctrl_pressed = False
        # self.setMaximumSize(QSize(16777215, 840))

        self.setup_config()

        self.bth = self.config.data["bth"]
        self.lbh = self.config.data["lbh"]
        self.btwidth = self.config.data["width"]

        # self.setup_menu_ui()
        self.setup_ui()

    def setup_ui(self):
        self.resize(168, 239)
        self.centralwidget = QWidget(self)
        self.centralwidget.setObjectName("centralwidget")
        self.verticalLayout_3 = QVBoxLayout(self.centralwidget)
        self.verticalLayout_3.setObjectName("verticalLayout_3")
        self.groupBox = QGroupBox(self.centralwidget)
        self.groupBox.setObjectName("groupBox")
        self.verticalLayout = QVBoxLayout(self.groupBox)
        self.verticalLayout.setObjectName("verticalLayout")
        self.reloadBt = QPushButton(self.groupBox)
        self.reloadBt.setObjectName("reloadBt")
        self.verticalLayout.addWidget(self.reloadBt)
        self.selectorList = QListWidget(self.groupBox)
        self.selectorList.setObjectName("selectorList")
        self.verticalLayout.addWidget(self.selectorList)
        self.verticalLayout_3.addWidget(self.groupBox)
        self.bthL = QHBoxLayout()
        self.bthL.setSpacing(2)
        self.bthL.setContentsMargins(-1, -1, -1, 0)
        self.bthL.setObjectName("bthL")
        self.openBt = QPushButton(self.centralwidget)
        self.openBt.setMinimumSize(QSize(0, 32))
        self.openBt.setMaximumSize(QSize(48, 16777215))
        self.openBt.setObjectName("openBt")
        self.bthL.addWidget(self.openBt)
        self.addBt = QPushButton(self.centralwidget)
        self.addBt.setMinimumSize(QSize(0, 32))
        self.addBt.setMaximumSize(QSize(48, 16777215))
        self.addBt.setObjectName("addBt")
        self.bthL.addWidget(self.addBt)
        self.editBt = QPushButton(self.centralwidget)
        self.editBt.setMinimumSize(QSize(0, 32))
        self.editBt.setMaximumSize(QSize(48, 16777215))
        self.editBt.setObjectName("editBt")
        self.bthL.addWidget(self.editBt)
        self.verticalLayout_3.addLayout(self.bthL)
        self.setCentralWidget(self.centralwidget)
        self.menubar = QMenuBar(self)
        self.menubar.setGeometry(QRect(0, 0, 168, 24))
        self.menubar.setObjectName("menubar")
        self.menuMenu = QMenu(self.menubar)
        self.menuMenu.setObjectName("menuMenu")
        self.setMenuBar(self.menubar)
        self.statusbar = QStatusBar(self)
        self.statusbar.setObjectName("statusbar")
        self.setStatusBar(self.statusbar)
        self.menubar.addAction(self.menuMenu.menuAction())
        QMetaObject.connectSlotsByName(self)

        self.groupBox.setTitle("selecton List")
        self.reloadBt.setText("Reload")
        self.openBt.setText("Open")
        self.addBt.setText("Add")
        self.editBt.setText("Edit")
        self.menuMenu.setTitle("Menu")

        ico = QIcon()
        img = os.path.join(
            os.path.dirname(os.path.abspath(__file__)), "images/bt_open.png")
        ico.addPixmap(QPixmap(img), QIcon.Normal, QIcon.Off)
        self.openBt.setIcon(ico)
        self.openBt.setIconSize(QSize(128, 32))

        ico = QIcon()
        img = os.path.join(
            os.path.dirname(os.path.abspath(__file__)), "images/bt_add.png")
        ico.addPixmap(QPixmap(img), QIcon.Normal, QIcon.Off)
        self.addBt.setIcon(ico)
        self.addBt.setIconSize(QSize(128, 32))

        ico = QIcon()
        img = os.path.join(
            os.path.dirname(os.path.abspath(__file__)), "images/bt_edit.png")
        ico.addPixmap(QPixmap(img), QIcon.Normal, QIcon.Off)
        self.editBt.setIcon(ico)
        self.editBt.setIconSize(QSize(128, 32))

        # Event
        self.reloadBt.clicked.connect(self.set_preset)
        self.selectorList.itemDoubleClicked.connect(self.open_selecton_window)
        self.openBt.clicked.connect(self.open_selecton_window)
        self.addBt.clicked.connect(self.add_selecton)
        self.editBt.clicked.connect(self.open_selecton_editor)

        self.setGeometry(
            QRect(
                self.config.data["posx"],
                self.config.data["posy"],
                self.config.data["width"],
                self.config.data["height"]
                )
            )

        # 初回
        self.set_preset()
        self.notification_register()

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

    def get_selecton_nodes_of_scene(self):
        nodes = self.get_all_nodes()
        result = []
        dct = {}
        for obj in nodes:
            if "selectonhelper" in obj.Object.GetClassName().lower():
                # 一度辞書に集めてソート
                if obj.Name in dct.keys():
                    dct[obj.Name].append(obj)
                else:
                    dct[obj.Name] = []
                    dct[obj.Name].append(obj)

        sorted_dct = sorted(dct.items())
        for k in sorted_dct:
            for i in k[1]:
                result.append(i)
        return result

    def set_preset(self):
        self.selectorList.clear()
        self.sel_helpers = self.get_selecton_nodes_of_scene()
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
        return json.loads(ret, object_pairs_hook=collections.OrderedDict)

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
        r"""selecton node を追加"""
        MaxPlus.Core.EvalMAXScript(
            "SJSelectonHelper pos:[0, 0, 0] isSelected:off")
        self.set_preset()

    def notification_register(self):
        r"""callbck"""
        mspath = os.path.join(
            os.path.dirname(os.path.abspath(__file__)), "registerCallback.mse")
        self.run_ms_file(mspath)
        print("Register callback")

    def is_valid_node(self, inode):
        r"""オブジェクトはあるか？"""
        #TODO:コレでいいらしんだけどうまくいかん
        # return inode.GetUnwrappedPtr() is not None
        # return pymxs.runtime.isValidNode(inode)
        try:
            _test = inode.Object.ParameterBlock.UiDict.Value
            return True
        except:
            return False

    def open_selecton_window(self):
        r"""ウィンドウ開く"""
        obj = self.get_sel_helper_of_list()
        if obj is None:
            return
        if self.is_valid_node(obj) is False:
            msg = u"オブジェクトが削除されています"
            util.MessageBox().show_msg(parent=self, msg_str=msg)
            self.set_preset()
            return

        idx = self.selectorList.currentIndex().row()
        wtitle = "{}_{}".format(obj.Name, idx)
        wname = "SJSelectonWindow_{}".format(wtitle)

        self.close_tool_window(wname)
        win = selecton_window.SJSelectonWindow(self.get_parent_window())
        _GCProtector.widgets.append(win)

        win.ui_dict = self.get_ui_dict_value(obj)  # 必要な要素を入れる
        win.helper_obj = obj
        win.setup_ui()
        win.setWindowTitle(wtitle)
        win.setObjectName(wname)
        win.show()
        if self.shift_pressed:
            win.move(self.x() + 50, self.y() + 50)

    def open_selecton_editor(self):
        r"""window open"""
        obj = self.get_sel_helper_of_list()
        if obj is None:
            return

        idx = self.selectorList.currentIndex().row()
        wtitle = "{}_{}".format(obj.Name, idx)
        wname = "SJSelectonWindow_{}".format(wtitle)

        self.close_tool_window(wname)
        win = selecton_window.SJSelectonWindow(self.get_parent_window())
        _GCProtector.widgets.append(win)

        editor = selecton_editor.SJSelectonEditor(self.get_parent_window())
        _GCProtector.widgets.append(editor)

        win.ui_dict = self.get_ui_dict_value(obj)  # 必要な要素を入れる
        win.helper_obj = obj
        win.edit_mode = True

        win.sel_editor = editor

        win.setup_ui()
        win.setWindowTitle(wtitle)
        win.setObjectName(wname)

        editor.ui_dict = self.get_ui_dict_value(obj)  # 必要な要素を入れる
        editor.helper_obj = obj
        editor.setup_ui()
        editor.set_bg_img_path()
        editor.setWindowTitle("{} Editor".format(wtitle))
        editor.setObjectName("{}Editor".format(wname))

        editor.sel_window = win

        win.show()
        editor.show()
        editor.activateWindow()

    def get_bt_dict(self):
        return {
            "bt_text": "Text",
            "pos": [150, 310],
            "size": [40, 16],
            "icon": "",
            "color": [0, 255, 128, 255],
            "style_sheet": "",
            "depth": 0,
            "tab_stop": 0,
            "select_obj": [],
            "scripts": "",
            "script_type": "ms"
        }

    def reload_ui(self):
        self.config.data["posx"] = self.x() + 8
        self.config.data["posy"] = self.y() + 30
        self.config.data["last_select"] = self.preset.currentText()
        self.config.save()

    def run_ms_file(self, fpath):
        r"""ファイルを実行する"""
        try:
            MaxPlus.Core.EvalMAXScript("filein @\"{}\"".format(fpath))
        except:
            import traceback
            traceback.print_exc()
