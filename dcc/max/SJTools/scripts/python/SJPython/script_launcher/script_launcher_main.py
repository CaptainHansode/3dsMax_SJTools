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
import re
import os
import os.path
import collections
import json
import copy

import script_launcher.cmn_util as util
import script_launcher.config as cfg
import script_launcher.dos_cmd as dos_cmd
# import script_launcher.tool_ui as tool_ui
import functools

reload(util)
reload(cfg)

try:
    from PySide2.QtWidgets import *
    from PySide2.QtGui import *
    from PySide2.QtCore import *
    UNICODE = -1

except ImportError:
    from PySide.QtGui import *
    from PySide.QtCore import *
    UNICODE = QApplication.UnicodeUTF8


class SJScriptLauncher(QMainWindow):
    r"""UI Class
    """
    def __init__(self, *args, **kwargs):
        super(SJScriptLauncher, self).__init__(*args, **kwargs)
        self.tool_name = "SJScriptLauncher"
        self.version = "0.0.0.5"
        self.auther = ""
        self.setObjectName(self.tool_name)

        # config 日本語ユーザー名対策
        try:
            userprofile = os.environ.get("USERPROFILE").decode("Shift_JIS")
        except UnicodeDecodeError:
            userprofile = os.environ.get("USERPROFILE")

        self.config_path = os.path.join(
            userprofile,
            "Documents",
            "SJTools",
            "config",
            self.tool_name
            )

        self.def_config_name = "SJScriptLauncherConfig.json"
        self.def_config = {
            "posx": 120,
            "posy": 120,
            "width": 300,
            "height": 200,
            "last_select": 0,
            "items": []
        }

        self.config = cfg.ToolConfig(
            self.config_path, self.def_config_name, self.def_config)

        """set up ui"""
        self.setupUi()
        self.setWindowTitle("{} {}".format(self.tool_name, self.version))
        self.setObjectName(self.tool_name)

        self.items = self.config.data["items"]
        self.setAcceptDrops(True)  # Drop許可
        self.get_exclusion_types = {
            ".ms": True,
            ".mrc": True,
            ".py": True
        }

        self.set_list()

        self.scList.itemClicked.connect(self.select_list)
        self.scList.itemDoubleClicked.connect(self.on_explorer)
        self.delBt.clicked.connect(self.delete_item)
        self.clearBt.clicked.connect(self.clear_list)
        self.runBt.clicked.connect(self.run_file)
        self.encryptBt.clicked.connect(self.encrypt_ms)
        self.encryptAllBt.clicked.connect(self.encrypt_all_ms)

        self.setGeometry(
            QRect(
                self.config.data["posx"],
                self.config.data["posy"],
                self.config.data["width"],
                self.config.data["height"]
                )
            )
        # self.setGeometry(QRect(0,0,300,300))

    def setupUi(self):
        self.centralwidget = QWidget(self)
        self.centralwidget.setObjectName("centralwidget")
        self.verticalLayout = QVBoxLayout(self.centralwidget)
        self.verticalLayout.setObjectName("verticalLayout")
        self.path = QLineEdit(self.centralwidget)
        self.path.setObjectName("path")
        self.verticalLayout.addWidget(self.path)
        self.scList = QListWidget(self.centralwidget)
        self.scList.setObjectName("scList")
        self.verticalLayout.addWidget(self.scList)
        self.delBt = QPushButton(self.centralwidget)
        self.delBt.setObjectName("delBt")
        self.verticalLayout.addWidget(self.delBt)
        self.runBt = QPushButton(self.centralwidget)
        self.runBt.setObjectName("runBt")
        self.runBt.setMinimumSize(QSize(0, 48))
        self.verticalLayout.addWidget(self.runBt)
        self.encryptBt = QPushButton(self.centralwidget)
        self.encryptBt.setObjectName("encryptBt")
        self.encryptBt.setMinimumSize(QSize(0, 32))
        self.verticalLayout.addWidget(self.encryptBt)

        self.encryptAllBt = QPushButton(self.centralwidget)
        self.encryptAllBt.setObjectName("encryptAllBt")
        self.encryptAllBt.setMinimumSize(QSize(0, 32))
        self.verticalLayout.addWidget(self.encryptAllBt)

        self.clearBt = QPushButton(self.centralwidget)
        self.clearBt.setObjectName("clearBt")
        self.verticalLayout.addWidget(self.clearBt)
        self.setCentralWidget(self.centralwidget)
        self.menubar = QMenuBar(self)
        self.menubar.setGeometry(QRect(0, 0, 381, 24))
        self.menubar.setObjectName("menubar")
        self.setMenuBar(self.menubar)
        self.statusbar = QStatusBar(self)
        self.statusbar.setObjectName("statusbar")
        self.setStatusBar(self.statusbar)

        self.retranslateUi()
        QMetaObject.connectSlotsByName(self)

    def retranslateUi(self):
        self.delBt.setText("Delete")
        self.clearBt.setText("Clear")
        self.runBt.setText("Run")
        self.encryptBt.setText("Encrypt Maxscript")
        self.encryptAllBt.setText("Encrypt All sMaxscript")
        # self.delBt.setText(QApplication.translate("SJScriptLauncher", "Delete", None, -1))
        # self.runBt.setText(QApplication.translate("SJScriptLauncher", "Run", None, -1))
        # self.encryptBt.setText(QApplication.translate("SJScriptLauncher", "EncryptMaxscript", None, -1))

    def closeEvent(self, event):
        r"""close event override"""
        self.save_config()
        self.deleteLater()

    def dropEvent(self, event):
        r"""
        ドラッグされたオブジェクトの、ドロップ許可がおりた場合の処理
        """
        mimedata = event.mimeData()
        urllist = mimedata.urls()
        # self.items = []
        for i in urllist:
            fpath = re.sub("^file:///", "", i.url())
            if os.path.isdir(fpath):
                return
            if self.is_exclusion(fpath):
                print("No Type")
                return
            print(fpath)
            self.items.append(fpath)
        self.set_list()

    def dragEnterEvent(self, event):
        r"""
        ドラッグされたオブジェクトを許可するかどうかを決める
        ドラッグされたオブジェクトが、ファイルなら許可する
        """
        mime = event.mimeData()

        if mime.hasUrls() is True:
            event.accept()
        else:
            event.ignore()

    def keyPressEvent(self, event):
        key = event.key()
        print(key)
        # if key == Qt.Key.Key_Shift:
        #     self.shift_pressed = True
        # if key == Qt.Key.Key_Control:
        #     self.ctrl_pressed = True
        # if key == Qt.Key.Key_Enter:
        # if key == Qt.Key.Key_Return:
        # if key == Qt.Key.Key_E:
        if key == Qt.Key.Key_F5:
            self.run_file()
        if key == Qt.Key.Key_Delete:
            self.delete_item()

    def keyReleaseEvent(self, event):
        self.ctrl_pressed = False

    def save_config(self):
        r"""save config"""
        self.config.data["posx"] = self.x() + 8
        self.config.data["posy"] = self.y() + 30
        self.config.data["width"] = self.width()
        self.config.data["height"] = self.height()
        self.config.data["items"] = self.items
        self.config.save()

    def is_exclusion(self, fpath):
        r"""除外する場合はTrue"""
        if os.path.isdir(fpath):  # ディレクトリは拡張子チェック除外
            return False

        exclusion_types = self.get_exclusion_types
        root, ext = os.path.splitext(fpath)
        ext = ext.lower()
        if ext in exclusion_types.keys():
            return False
        else:
            return True
        return False

    def is_py_file(self, fpath):
        root, ext = os.path.splitext(fpath)
        ext = ext.lower()
        if ext == ".py":
            return True
        return False

    def set_list(self):
        self.scList.clear()
        for path in self.items:
            self.scList.addItem(path)

    def get_sel_list_item(self):
        sel = self.scList.currentIndex().row()
        if sel == -1:
            return ""
        return self.items[sel]

    def select_list(self):
        self.path.setText(self.get_sel_list_item())

    def delete_item(self):
        sel = self.scList.currentIndex().row()
        if sel == -1:
            return None
        del self.items[sel]
        self.set_list()
        self.path.setText("")

    def clear_list(self):
        if util.MessageBox().query_box(msg_str="Are you alright?") is False:
            return
        self.items = []
        self.set_list()
        self.path.setText("")

    def on_explorer(self):
        r"""エクスプローラー"""
        file_path = self.scList.currentItem().text()
        if file_path is "":
            return
        if os.path.exists(file_path) is False:
            print("Not found path")

        dos = dos_cmd.CommonCmd()

        if os.path.isfile(file_path):
            ret = dos.explorer_at_cmd(file_path, select=True)
        else:
            ret = dos.explorer_at_cmd(file_path)
        if ret is False:
            print("Open Failed")

    def encrypt_ms(self):
        file_path = self.scList.currentItem().text()
        if file_path is "":
            return
        if os.path.exists(file_path) is False:
            print("Not found path")

        MaxPlus.Core.EvalMAXScript("encryptScript @\"{}\"".format(file_path))
        print("Encrypt Finish")

    def encrypt_all_ms(self):
        for f in self.items:
            if os.path.exists(f) is False:
                print("Not found path")
            if self.is_py_file(f):
                continue
            MaxPlus.Core.EvalMAXScript("encryptScript @\"{}\"".format(f))
        # util.MessageBox().show_msg(msg_str="Encrypt Finish")
        print("Encrypt Finish")

    def run_file(self):
        self.save_config()
        fpath = self.get_sel_list_item()
        if fpath == "":
            return
        if self.is_py_file(fpath):
            self.run_py(fpath)
        else:
            self.run_ms(fpath)

    def get_temp_file(self, fname):
        fname = fname or "_tmp"
        return os.path.join(os.environ.get("Temp"), fname)

    def run_ms(self, ms):
        """macroscript run"""
        # return MaxPlus.Core.EvalMAXScript(ms)
        try:
            MaxPlus.Core.EvalMAXScript("filein \"{}\"".format(ms))
        except:
            import traceback
            traceback.print_exc()

    def run_py(self, py):
        """python run"""
        try:
            MaxPlus.Core.EvalMAXScript(
                "python.ExecuteFile \"{}\"".format(py))
        except:
            import traceback
            traceback.print_exc()