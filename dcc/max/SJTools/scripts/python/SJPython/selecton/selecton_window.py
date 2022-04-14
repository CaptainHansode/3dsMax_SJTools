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


try:
    from PySide2.QtWidgets import *
    from PySide2.QtGui import *
    from PySide2.QtCore import *

except ImportError:
    from PySide.QtGui import *
    from PySide.QtCore import *


import xml.etree.ElementTree as ET  # xml用
import MaxPlus
import os
import os.path
import json
import copy
import traceback
import re

import selecton.cmn_util as util
import selecton.config as cnfg


reload(util)
reload(cnfg)


class SJSelectonButton(QPushButton):
    def __init__(self, *args, **kwargs):
        super(SJSelectonButton, self).__init__(*args, **kwargs)
        self.edit_mode = False
        self.resize_on = False
        self.snap_val = 4
        self.setMouseTracking(True)
        self.installEventFilter(self)
        # self.entered.connect(self.mouseEnter)

    def grid_point(self, grid, i):
        r"""インプット値をグリッド値に補正"""
        q = i // grid
        x = (q * grid) + (grid / 2.0)
        if i > x:
            output = grid * (q + 1)
        else:
            output = grid * q
        return output

    def eventFilter(self, object, event):
        if self.edit_mode is False:  # エディットモード以外は抜ける
            return super(SJSelectonButton, self).eventFilter(object, event)
        if event.type() == QEvent.MouseMove:
            area_x = self.width() - 10
            area_y = self.height() - 10
            if (area_x < event.x()) and (area_y < event.y()):
                QApplication.setOverrideCursor(Qt.SizeFDiagCursor)  # icon変える
            else:
                QApplication.restoreOverrideCursor()
        elif event.type() == QEvent.HoverLeave:
            QApplication.restoreOverrideCursor()

        return super(SJSelectonButton, self).eventFilter(object, event)

    def mousePressEvent(self, event):
        if self.edit_mode is False:  # エディットモード以外は抜ける
            return super(SJSelectonButton, self).mousePressEvent(event)
        # 座標はevent.x() event.y()でひろう
        area_x = self.width() - 10
        area_y = self.height() - 10
        if (area_x < event.x()) and (area_y < event.y()):
            QApplication.setOverrideCursor(Qt.SizeFDiagCursor)  # icon変える
            self.resize_on = True
        return super(SJSelectonButton, self).mousePressEvent(event)

    def mouseReleaseEvent(self, event):
        if self.edit_mode is False:  # エディットモード以外は抜ける
            return super(SJSelectonButton, self).mouseReleaseEvent(event)
        if self.resize_on:
            size_x = self.grid_point(self.snap_val, event.x() + 10)
            size_y = self.grid_point(self.snap_val, event.y() + 10)
            if size_x < 16:
                size_x = 16
            if size_y < 16:
                size_y = 16
            self.resize(size_x, size_y)
        QApplication.restoreOverrideCursor()
        self.resize_on = False
        return super(SJSelectonButton, self).mouseReleaseEvent(event)

    def mouseMoveEvent(self, event):
        r"""端っこをつかんだらリサイズ"""
        if self.edit_mode is False:
            return super(SJSelectonButton, self).mouseMoveEvent(event)
        # print(event.x(), event.y())
        if self.resize_on:
            size_x = self.grid_point(self.snap_val, event.x() + 10)
            size_y = self.grid_point(self.snap_val, event.y() + 10)
            if size_x < 16:
                size_x = 16
            if size_y < 16:
                size_y = 16
            self.resize(size_x, size_y)
        # 元のクラスのオーバーライドを呼び出し
        return super(SJSelectonButton, self).mouseMoveEvent(event)


class SJSelectonWindow(QMainWindow):
    def __init__(self, *args, **kwargs):
        super(SJSelectonWindow, self).__init__(*args, **kwargs)
        # self.setWindowFlags(Qt.Tool)
        self.ui_dict = {}
        self.helper_obj = None
        self.on_ad_rig_node = False
        self.tool_name = "SJSelecton"
        self.setObjectName(self.tool_name)

        self.shift_pressed = False
        self.ctrl_pressed = False
        self.sel_mode = 0
        self.all_objs = []
        self.bts = {}

        self.edit_mode = False
        self.sel_editor = None
        self.edit_name = ""
        self.s_pos = [0, 0]
        self.e_pos = [64, 18]

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
        self.mainAreaWidgetContents.setGeometry(QRect(0, 0, 468, 168))
        self.mainAreaWidgetContents.setObjectName("mainAreaWidgetContents")

        self.mainAreaWidgetContents.setMouseTracking(True)

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
        self.optionArea = QScrollArea(self.centralwidget)
        self.optionArea.setMinimumSize(QSize(0, 0))
        self.optionArea.setWidgetResizable(True)
        self.optionArea.setObjectName("optionArea")
        self.scrollAreaWidgetContents = QWidget()
        self.scrollAreaWidgetContents.setGeometry(QRect(0, 0, 324, 106))
        self.scrollAreaWidgetContents.setObjectName("scrollAreaWidgetContents")
        self.gridLayout = QGridLayout(self.scrollAreaWidgetContents)
        self.gridLayout.setObjectName("gridLayout")
        self.optionGb = QGroupBox(self.scrollAreaWidgetContents)
        self.optionGb.setStyleSheet("")
        self.optionGb.setObjectName("optionGb")
        self.verticalLayout_5 = QVBoxLayout(self.optionGb)
        self.verticalLayout_5.setSpacing(2)
        self.verticalLayout_5.setContentsMargins(0, 0, 0, 0)
        self.verticalLayout_5.setObjectName("verticalLayout_5")
        self.hint = QLabel(self.optionGb)
        self.hint.setMaximumSize(QSize(16777215, 12))
        self.hint.setObjectName("hint")
        self.verticalLayout_5.addWidget(self.hint)

        self.seltypeLayout = QHBoxLayout()
        self.seltypeLayout.setSpacing(2)
        self.seltypeLayout.setContentsMargins(-1, -1, -1, 0)
        self.seltypeLayout.setObjectName("seltypeLayout")

        self.nameSelRb = QRadioButton(self.optionGb)
        self.nameSelRb.setChecked(True)
        self.nameSelRb.setObjectName("nameSelRb")
        self.seltypeLayout.addWidget(self.nameSelRb)
        self.searchSelRb = QRadioButton(self.optionGb)
        self.searchSelRb.setObjectName("searchSelRb")
        self.seltypeLayout.addWidget(self.searchSelRb)
        self.searchTreeSelRb = QRadioButton(self.optionGb)
        self.searchTreeSelRb.setObjectName("searchTreeSelRb")
        self.seltypeLayout.addWidget(self.searchTreeSelRb)
        self.verticalLayout_5.addLayout(self.seltypeLayout)

        self.runCb = QCheckBox(self.optionGb)
        self.runCb.setStyleSheet("")
        self.runCb.setChecked(True)
        self.runCb.setObjectName("runCb")
        self.verticalLayout_5.addWidget(self.runCb)
        self.editOptionLayout = QHBoxLayout()
        self.editOptionLayout.setContentsMargins(-1, -1, -1, 0)
        self.editOptionLayout.setObjectName("editOptionLayout")
        self.gridLb = QLabel(self.optionGb)
        self.gridLb.setMaximumSize(QSize(68, 16777215))
        self.gridLb.setObjectName("gridLb")
        self.editOptionLayout.addWidget(self.gridLb)
        self.gridSb = QSpinBox(self.optionGb)
        self.gridSb.setMaximumSize(QSize(48, 16777215))
        self.gridSb.setMinimum(0)
        self.gridSb.setMaximum(64)
        self.gridSb.setSingleStep(2)
        self.gridSb.setProperty("value", 4)
        self.gridSb.setObjectName("gridSb")
        self.editOptionLayout.addWidget(self.gridSb)
        self.correctMPLb = QLabel(self.optionGb)
        self.correctMPLb.setMaximumSize(QSize(56, 16777215))
        self.correctMPLb.setObjectName("correctMPLb")
        self.editOptionLayout.addWidget(self.correctMPLb)
        self.crtMPXLb = QLabel(self.optionGb)
        self.crtMPXLb.setMaximumSize(QSize(10, 16777215))
        self.crtMPXLb.setObjectName("crtMPXLb")
        self.editOptionLayout.addWidget(self.crtMPXLb)
        self.crtMPXSb = QSpinBox(self.optionGb)
        self.crtMPXSb.setMaximumSize(QSize(36, 16777215))
        self.crtMPXSb.setProperty("value", 10)
        self.crtMPXSb.setObjectName("crtMPXSb")
        self.editOptionLayout.addWidget(self.crtMPXSb)
        self.crtMPYLb = QLabel(self.optionGb)
        self.crtMPYLb.setMaximumSize(QSize(10, 16777215))
        self.crtMPYLb.setObjectName("crtMPYLb")
        self.editOptionLayout.addWidget(self.crtMPYLb)
        self.crtMPYSb = QSpinBox(self.optionGb)
        self.crtMPYSb.setMaximumSize(QSize(36, 16777215))
        self.crtMPYSb.setObjectName("crtMPYSb")
        self.editOptionLayout.addWidget(self.crtMPYSb)
        self.posLb = QLabel(self.optionGb)
        self.posLb.setObjectName("posLb")
        self.editOptionLayout.addWidget(self.posLb)
        self.verticalLayout_5.addLayout(self.editOptionLayout)
        self.gridLayout.addWidget(self.optionGb, 0, 0, 1, 1)
        self.optionArea.setWidget(self.scrollAreaWidgetContents)
        self.verticalLayout_3.addWidget(self.optionArea)
        self.verticalLayout_3.setStretch(0, 1)

        self.setCentralWidget(self.centralwidget)
        self.menubar = QMenuBar(self)
        self.menubar.setGeometry(QRect(0, 0, 385, 24))
        self.menubar.setObjectName("menubar")
        self.menu = QMenu(self.menubar)
        self.menu.setObjectName("menu")
        self.menu_sel = QMenu(self.menubar)  # 選択方法メニュー
        self.menu_sel.setObjectName("menu_sel")
        self.menu_srh = QMenu(self.menubar)  # サーチ方法メニュー
        self.menu_srh.setObjectName("menu_srh")

        self.setMenuBar(self.menubar)

        self.statusbar = QStatusBar(self)
        self.statusbar.setObjectName("statusbar")
        self.setStatusBar(self.statusbar)

        self.actLoad = QAction(self)
        self.actLoad.setObjectName("actLoad")
        self.actSave = QAction(self)
        self.actSave.setObjectName("actSave")
        self.actMarge = QAction(self)
        self.actMarge.setObjectName("actMarge")

        self.actForward = QAction(self)
        self.actForward.setObjectName("actForward")
        self.actForward.setCheckable(True)
        self.actMiddleword = QAction(self)
        self.actMiddleword.setObjectName("actMiddleword")
        self.actMiddleword.setCheckable(True)
        self.actBackword = QAction(self)
        self.actBackword.setObjectName("actBackword")
        self.actBackword.setCheckable(True)

        self.actSelByName = QAction(self)
        self.actSelByName.setObjectName("actSelByName")
        self.actSelByName.setCheckable(True)
        self.actSelByScne = QAction(self)
        self.actSelByScne.setObjectName("actSelByScne")
        self.actSelByScne.setCheckable(True)
        self.actSelByTree = QAction(self)
        self.actSelByTree.setObjectName("actSelByTree")
        self.actSelByTree.setCheckable(True)

        self.menu.addAction(self.actLoad)
        self.menu.addAction(self.actSave)
        self.menu.addAction(self.actMarge)

        self.menu_sel.addAction(self.actSelByName)
        self.menu_sel.addAction(self.actSelByScne)
        self.menu_sel.addAction(self.actSelByTree)
        self.menu_srh.addAction(self.actForward)
        self.menu_srh.addAction(self.actMiddleword)
        self.menu_srh.addAction(self.actBackword)

        self.menubar.addAction(self.menu.menuAction())
        self.menubar.addAction(self.menu_sel.menuAction())
        self.menubar.addAction(self.menu_srh.menuAction())

        # ここからオリジナル設定
        self.hint.setText(u"Ctrlを押しながらで追加選択するです")
        self.searchTreeSelRb.setText(u"ツリーから検索")
        self.nameSelRb.setText(u"名前で選択")
        self.searchSelRb.setText(u"シーンから検索")
        self.gridLb.setText(u"グリッドスナップ")
        self.runCb.setText(u"ボタンの内容を実行")
        self.correctMPLb.setText(u"マウス補正")
        self.crtMPXLb.setText("X")
        self.crtMPYLb.setText("Y")
        self.menu.setTitle(u"ファイル")
        self.menu_sel.setTitle(u"選択設定")
        self.menu_srh.setTitle(u"検索設定")
        self.actLoad.setText("Load")
        self.actSave.setText("Save")
        self.actMarge.setText("Marge")
        self.actForward.setText(u"前方一致")
        self.actMiddleword.setText(u"中央一致")
        self.actBackword.setText(u"後方一致")
        self.actSelByName.setText(u"名前で選択")
        self.actSelByScne.setText(u"シーンから検索して選択")
        self.actSelByTree.setText(u"ツリーから検索して選択")

        self.gridSb.setValue(8)
        self.snap_val = 8

        # ボタン作るよう
        self.makeBtLb = QLabel(self.frame)
        self.makeBtLb.setPalette(QPalette(QColor(140, 170, 210, 255)))
        self.makeBtLb.setGeometry(QRect(4, 12, 120, 16))
        self.makeBtLb.setAutoFillBackground(True)
        self.makeBtLb.hide()

        if self.edit_mode is False:
            self.gridLb.hide()
            self.gridSb.hide()
            self.posLb.hide()
            self.runCb.hide()
            self.correctMPLb.hide()
            self.crtMPXLb.hide()
            self.crtMPXSb.hide()
            self.crtMPYLb.hide()
            self.crtMPYSb.hide()
            self.optionArea.hide()
            # self.grid_img.hide()
        else:
            # win.hint.setPalette(QPalette(QColor(234, 64, 0, 255)))
            self.hint.setText(u"編集モードです パネルをドラッグするとボタンを作るよ")
            self.hint.setMinimumSize(QSize(16777215, 20))
            self.hint.setStyleSheet(
                "background:rgb(234, 64, 0);font:rgb(32, 32, 32)")
            self.optionGb.setTitle(u"Edit Mode")

        # パラメーターブロックを登録しておく
        obj_param = self.helper_obj.Object.ParameterBlock

        self.gridSb.valueChanged.connect(self.change_spin_val)

        self.actLoad.triggered.connect(self.load_bt_json)
        self.actSave.triggered.connect(self.save_bt_json)
        self.actMarge.triggered.connect(self.marge_bt_json)

        self.actForward.triggered.connect(lambda: self.change_srch_mode(0))
        self.actMiddleword.triggered.connect(lambda: self.change_srch_mode(1))
        self.actBackword.triggered.connect(lambda: self.change_srch_mode(2))
        self.srch_mode = obj_param.LastSrchMode.Value
        self.change_srch_mode(self.srch_mode)

        # forcusイベント
        self.gridSb.focusInEvent = self.ui_forcus_in
        self.gridSb.focusOutEvent = self.ui_forcus_out
        self.crtMPXSb.focusInEvent = self.ui_forcus_in
        self.crtMPXSb.focusOutEvent = self.ui_forcus_out
        self.crtMPYSb.focusInEvent = self.ui_forcus_in
        self.crtMPYSb.focusOutEvent = self.ui_forcus_out

        # RarioButton Group これでidを拾える
        self.selModeBtGroup = QButtonGroup()
        self.selModeBtGroup.addButton(self.nameSelRb, 0)
        self.selModeBtGroup.addButton(self.searchSelRb, 1)
        self.selModeBtGroup.addButton(self.searchTreeSelRb, 2)

        # メニュー化したのでとりあえず見えないようにしておく
        self.nameSelRb.hide()
        self.searchSelRb.hide()
        self.searchTreeSelRb.hide()

        self.nameSelRb.toggled.connect(self.change_sel_mode)
        self.searchSelRb.toggled.connect(self.change_sel_mode)
        self.searchTreeSelRb.toggled.connect(self.change_sel_mode)
        self.actSelByName.triggered.connect(
            lambda: self.change_sel_mode_by_menu(0))
        self.actSelByScne.triggered.connect(
            lambda: self.change_sel_mode_by_menu(1))
        self.actSelByTree.triggered.connect(
            lambda: self.change_sel_mode_by_menu(2))
        self.set_sel_mode(obj_param.LastSelMode.Value)
        self.change_sel_mode_by_menu(obj_param.LastSelMode.Value)

        self.change_sel_mode()  # 初回回収

        # self.scrollArea.show()
        self.centralwidget.show()
        QMetaObject.connectSlotsByName(self)

        self.setGeometry(QRect(
            obj_param.LastPosX.Value,
            obj_param.LastPosY.Value,
            obj_param.LastWidth.Value,
            obj_param.LastHeight.Value))
        print("Finish Set Up!")

    def closeEvent(self, event):
        r"""close event override"""
        if self.is_valid_node(self.helper_obj):
            obj_param = self.helper_obj.Object.ParameterBlock
            obj_param.LastPosX.Value = self.x() + 8
            obj_param.LastPosY.Value = self.y() + 30
            obj_param.LastWidth.Value = self.width()
            obj_param.LastHeight.Value = self.height()
            obj_param.LastSelMode.Value = self.selModeBtGroup.checkedId()
            obj_param.LastSrchMode.Value = self.srch_mode
            # マクロレコーダーがONだとJson書き込みがクッソ遅い
            self.set_ui_dict_value(self.helper_obj, self.ui_dict)

        # QApplication.restoreOverrideCursor()
        if self.edit_mode is False:
            self.deleteLater()
        # return super(SJSelectonWindow, self).closeEvent(event)

    def keyPressEvent(self, event):
        key = event.key()
        print(key)
        if key == Qt.Key.Key_Shift:
            self.shift_pressed = True
        if key == Qt.Key.Key_Control:
            self.ctrl_pressed = True
        if key == Qt.Key.Key_Delete:
            print("name? = ", self.edit_name, " ?")
            self.del_button()
        if key == Qt.Key.Key_Backspace:
            self.del_button()

    def keyReleaseEvent(self, event):
        self.shift_pressed = False
        self.ctrl_pressed = False

    def ui_forcus_in(self, event):
        r"""フォーカスイベント発生時にアクセレーターを外す"""
        MaxPlus.CUI.DisableAccelerators()

    def ui_forcus_out(self, event):
        MaxPlus.CUI.EnableAccelerators()

    def is_valid_node(self, inode):
        r"""オブジェクトはあるか？"""
        # TODO:作り直し
        try:
            _test = inode.Object.ParameterBlock.UiDict.Value
            return True
        except:
            return False

    def change_srch_mode(self, idx):
        flgs = {
            0: [True, False, False],
            1: [False, True, False],
            2: [False, False, True]
        }
        self.actForward.setChecked(flgs[idx][0])
        self.actMiddleword.setChecked(flgs[idx][1])
        self.actBackword.setChecked(flgs[idx][2])
        self.srch_mode = idx

    def set_bg_img(self):
        self.bg_img = QLabel(self.frame)
        self.bg_img.setAlignment(
            Qt.AlignLeading|Qt.AlignLeft|Qt.AlignTop)
        self.bg_img.setObjectName("bg_img")

        # self.grid_img = QLabel(self.frame)
        # self.grid_img.setAlignment(
        #     Qt.AlignLeading|Qt.AlignLeft|Qt.AlignTop)
        # self.grid_img.setObjectName("bg_img")

    def get_img_size(self, img):
        r"""画像の幅と高さ情報を採取"""
        pic = QGraphicsPixmapItem(QPixmap(img))
        w = pic.boundingRect().width()
        h = pic.boundingRect().height()
        return [w, h]

    def update_bg_img(self):
        img = self.ui_dict["bg_image"]
        if img == "":
            self.bg_img.setPixmap("")
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

    def set_icon_to_bt(self, bt, ico_file):
        ico = QIcon()
        ico.addPixmap(QPixmap(ico_file), QIcon.Normal, QIcon.Off)
        bt.setIcon(ico)
        size = self.get_img_size(ico_file)
        bt.setIconSize(QSize(size[0], size[1]))

    def add_buttons(self):
        for bt in self.bts:
            self.bts[bt].setParent(None)
            self.bts[bt].deleteLater()

        self.bts = {}
        self.bts_dict = self.ui_dict["buttons"]
        for item in self.bts_dict:
            uname = str(item)
            # self.bts[uname] = QPushButton(self.frame)

            self.bts[uname] = SJSelectonButton(self.frame)
            self.bts[uname].edit_mode = self.edit_mode
            self.update_bt(uname)
            self.bts[uname].clicked.connect(lambda ms=uname: self.run_bt(ms))
            self.bts[uname].released.connect(lambda ms=uname: self.sel_bt(ms))
        self.update()

    def _change_old_dict_to_new(self, uname):
        r"""古い仕様のトグルボタンがない場合の対処"""
        if ("set_checkable" in self.bts_dict[uname]) is False:
            # print("add key set_checkable")
            self.bts_dict[uname]["set_checkable"] = False
        if ("checked" in self.bts_dict[uname]) is False:
            # print("add key checked")
            self.bts_dict[uname]["checked"] = False
        if "depth" in self.bts_dict[uname]:
            # print("del key depth")
            self.bts_dict[uname].pop("depth")  # 不要仕様削除
        if "tab_stop" in self.bts_dict[uname]:
            # print("tab_stop key depth")
            self.bts_dict[uname].pop("tab_stop")  # 不要仕様削除

    def update_bt(self, uname):
        r"""ボタン内容をアップデート"""
        self._change_old_dict_to_new(uname)
        self.bts_dict[uname]["set_checkable"] = False
        self.bts_dict[uname]["checked"] = False

        bt_text = self.bts_dict[uname]["bt_text"]
        pos = self.bts_dict[uname]["pos"]
        size = copy.deepcopy(self.bts_dict[uname]["size"])
        col = self.bts_dict[uname]["color"]
        stl_sheet = self.bts_dict[uname]["style_sheet"]
        icon = self.bts_dict[uname]["icon"]

        self.bts[uname].setGeometry(
            QRect(pos[0], pos[1], size[0], size[1])
            )
        self.bts[uname].setText(bt_text)
        self.bts[uname].setPalette(
                QPalette(QColor(col[0], col[1], col[2], col[3])))
        if icon != "":
            self.set_icon_to_bt(self.bts[uname], icon)
        else:
            self.bts[uname].setIcon(QIcon())  # 空アイコンをつけて消す
        # print("-----------")
        # print(self.bts_dict[uname]["set_checkable"])
        # ボタンをトグル化
        if self.bts_dict[uname]["set_checkable"]:
            self.bts[uname].setCheckable(True)
            # self.bts[uname].toggled.connect(lambda ms=uname: self.toggle_bt(ms))
            if self.bts_dict[uname]["checked"]:
                self.bts[uname].toggle()

        self.bts[uname].show()

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
            # "depth": 0,  # TODO:現状不要
            # "tab_stop": 0,  # TODO:現状不要
            "select_obj": [],
            "scripts": "",
            "script_type": "ms"
        }

    def get_temp_file(self, fname):
        fname = fname or "_tmp"
        return os.path.join(os.environ.get("Temp"), fname)

    def create_bt_key_name(self):
        bts = self.ui_dict["buttons"]
        btname = "pushButton"
        cnt = 1
        while btname in bts:
            cnt += 1
            btname = "pushButton_{}".format(str(cnt))
        return btname

    def get_click_size(self):
        w = self.e_pos[0] - self.s_pos[0]
        h = self.e_pos[1] - self.s_pos[1]
        return [w, h]

    def add_button_to_click_pos(self):
        new_bt = self.create_bt_key_name()
        size = self.get_click_size()
        if size[0] < 10 or size[1] < 10:  # 多少大きくないとボタンを作らせない
            return
        self.ui_dict["buttons"][new_bt] = self.get_bt_dict()
        self.ui_dict["buttons"][new_bt]["bt_text"] = new_bt
        self.ui_dict["buttons"][new_bt]["pos"] = self.s_pos
        self.ui_dict["buttons"][new_bt]["size"] = [size[0], size[1]]
        self.ui_dict["buttons"][new_bt]["color"] = self.sel_editor.lb_col
        self.add_buttons()

        self.sel_editor.set_change_sign_to_title()
        self.sel_editor.edit_name = new_bt
        self.sel_editor.update_ui()

    def change_spin_val(self):
        self.snap_val = self.gridSb.value()
        if self.snap_val is 0:
            self.snap_val = 1

    def grid_point(self, grid, i):
        r"""インプット値をグリッド値に補正"""
        q = i // grid
        x = (q * grid) + (grid / 2.0)
        if i > x:
            output = grid * (q + 1)
        else:
            output = grid * q
        return output

    def get_mouse_coordinate(self, ex, ey):
        r"""座標を取得"""
        # 座標を補正
        posx = self.grid_point(self.snap_val, ex) - self.crtMPXSb.value()
        posy = self.grid_point(self.snap_val, ey) - self.crtMPYSb.value()
        self.posLb.setText("{}*{}".format(posx, posy))
        return [posx, posy]

    def mousePressEvent(self, event):
        if self.edit_mode is False:
            return
        QApplication.setOverrideCursor(Qt.CrossCursor)  # icon変える
        # self.update_ui_dict_all()

        # 座標はevent.x() event.y()でひろう
        mpos = self.get_mouse_coordinate(event.x(), event.y())
        # self.s_pos = [mpos[0], mpos[1]]
        self.s_pos = [mpos[0], mpos[1]]
        self.makeBtLb.show()  # ボタン作成用ガイドの移動
        self.makeBtLb.resize(0, 0)
        self.makeBtLb.move(self.s_pos[0], self.s_pos[1])
        self.sel_editor.update_ui()

    def mouseReleaseEvent(self, event):
        QApplication.restoreOverrideCursor()
        if self.edit_mode is False:
            return
        # self.update_ui_dict_all()

        mpos = self.get_mouse_coordinate(event.x(), event.y())
        self.e_pos = [mpos[0], mpos[1]]
        self.makeBtLb.hide()

        if self.edit_name == "":
            self.add_button_to_click_pos()  # 作っておわり
            return
        self.ui_dict["buttons"][self.edit_name]["pos"] = [mpos[0], mpos[1]]
        self.edit_name = ""
        self.sel_editor.set_change_sign_to_title()
        self.sel_editor.update_ui()

    def mouseMoveEvent(self, event):
        r"""座標の誤差はsizeとボタンの移動で違うので注意"""
        mpos = self.get_mouse_coordinate(event.x(), event.y())
        size = [mpos[0] - self.s_pos[0], mpos[1] - self.s_pos[1]]
        self.makeBtLb.resize(size[0], size[1])

        if self.edit_mode is False:
            return
        if self.edit_name == "":
            return
        # QtCore.QPoint(0, 0)
        # pos = QPoint(0, 0)
        pos = QPoint(mpos[0], mpos[1])
        self.bts[self.edit_name].move(pos)
        # self.bts[self.edit_name].move(self.mapToParent(pos))
        # self.bts[self.edit_name].move(mpos[0], mpos[1])
        self.sel_editor.update_ui()

    def update_ui_dict(self, uname):
        if uname == "":
            return
        self.ui_dict["buttons"][uname]["pos"] = [
            self.bts[uname].x(), self.bts[uname].y()]
        self.ui_dict["buttons"][uname]["size"] = [
            self.bts[uname].width(), self.bts[uname].height()]

    def update_ui_dict_all(self):
        for uname in self.bts:
            self.ui_dict["buttons"][uname]["pos"] = [
                self.bts[uname].x(), self.bts[uname].y()]
            self.ui_dict["buttons"][uname]["size"] = [
                self.bts[uname].width(), self.bts[uname].height()]

    def exists_bt(self):
        n = self.edit_name
        if n == "":
            return False
        if (n in self.sel_window.ui_dict["buttons"]) is False:
            return False
        return True

    def del_button(self):
        if self.exists_bt() is False:
            return
        self.sel_editor.set_change_sign_to_title()
        self.ui_dict["buttons"].pop(self.edit_name)
        self.add_buttons()

    def run_ms(self, ms):
        r"""macroscript run"""
        tmp_ms = self.get_temp_file("_tmp_macros.ms")
        file = open(tmp_ms, "w")
        file.write(ms.encode('utf8'))
        file.close()
        try:
            MaxPlus.Core.EvalMAXScript("filein @\"{}\"".format(tmp_ms))
        except:
            print("Error:run_ms")
            traceback.print_exc()

    def run_py(self, py):
        r"""python run"""
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
                "python.ExecuteFile @\"{}\"".format(tmp_py))
        except:
            print("Error:run_py")
            traceback.print_exc()

    def set_ui_dict_value(self, obj, dict_data):
        r"""set dict data
        Jsonを書き込み
        """
        # Jsonで書き込み indent使うとクッソ遅いので禁止
        obj.Object.ParameterBlock.UiDict.Value = json.dumps(dict_data)
        # obj.Object.ParameterBlock.UiDict.Value = json.dumps(
        #     dict_data, indent=4)

    def save_bt_dict(self):
        self.update_ui_dict_all()
        self.set_ui_dict_value(self.helper_obj, self.ui_dict)

    def set_ui_dict(self, ui_dict, obj):
        self.ui_dict = ui_dict
        self.helper_obj = obj

    def change_sel_mode_by_menu(self, idx):
        flgs = {
            0: [True, False, False],
            1: [False, True, False],
            2: [False, False, True]
        }
        self.actSelByName.setChecked(flgs[idx][0])
        self.actSelByScne.setChecked(flgs[idx][1])
        self.actSelByTree.setChecked(flgs[idx][2])
        self.sel_mode = idx
        self.selModeBtGroup.button(idx).setChecked(True)

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
        return

    def set_sel_mode(self, id):
        self.selModeBtGroup.button(id).setChecked(True)

    def sel_bt(self, uname):
        r"""編集モードのときに選択された"""
        if self.edit_mode is False:
            return
        # self.update_ui_dict(uname)
        self.update_ui_dict_all()
        # self.sel_editor.update_ui()
        self.edit_name = uname
        self.sel_editor.edit_name = uname

    def regit_globla_variavle(self):
        r"""このウィンドウのinodehandleを拾えるようにしておく"""
        ms = "global SJSelectonCurrentNodeHandle = {}".format(
            self.helper_obj.GetHandle())
        MaxPlus.Core.EvalMAXScript(ms)

    def run_bt(self, uname):
        r"""ボタン実行メイン"""
        if self.edit_mode:
            self.sel_editor.update_ui()
        if self.runCb.isChecked() is False:
            return
        self.edit_name = ""
        self.regit_globla_variavle()

        bt_dict = self.bts_dict[uname]
        sel_obj_names = bt_dict["select_obj"]
        if self.selModeBtGroup.checkedId() is 0:
            nodes = self.get_node_by_name(sel_obj_names)
        else:
            nodes = self.get_node_by_search(sel_obj_names)
        # siftが押されていないとクリア and ゼロじゃなかったら
        if self.ctrl_pressed is False and len(sel_obj_names) != 0:
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

        self.redraw_views()  # redraw 重かったら切る

    def toggle_bt(self, checked, uname):
        r"""トグル実行"""
        print(checked)

    def get_node_by_name(self, names):
        result = []
        # names = ["RuriA_Haru_Bip001 Head"]
        for n in names:
            node = MaxPlus.INode.GetINodeByName(n)
            if node:
                result.append(node)
        return result

    def is_match_str(self, ptn, nstr):
        match = re.search(ptn, nstr)
        if match:
            return True
        else:
            return False

    def find_name_by_srch_mode(self, src_str, name_str):
        r"""サーチモードで名前検索"""
        result = False
        if self.srch_mode is 0:  # 前方一致
            if name_str.find(src_str) is not -1:
                result = True
        elif self.srch_mode is 1:  # 中央一致  TODO:formatが使えない
            if self.is_match_str(".+" + src_str + ".+", name_str):
                result = True
        elif self.srch_mode is 2:  # 後方一致
            if self.is_match_str(".+" + src_str + "$", name_str):
                result = True
        return result

    def get_node_by_search(self, names):
        result = []
        if len(names) is 0:
            return result

        for n in names:
            if self.srch_mode is 1:  # 中央一致  TODO:formatが使えない
                _src_str = ".+" + n + ".+"
            elif self.srch_mode is 2:  # 後方一致
                _src_str = ".+" + n + "$"
            for obj in self.all_objs:
                if self.srch_mode is 0:  # 前方一致
                    if obj.Name.find(n) is not -1:
                        result.append(obj)
                        break
                else:
                    if self.is_match_str(_src_str, obj.Name):
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

    def redraw_views(self):
        crnt_time = MaxPlus.Animation.GetTime()
        MaxPlus.ViewportManager_RedrawViews(crnt_time)

    def save_file_path_dialog(
            self, titel="Save File", type_filter="", def_dir="C:\\"):
        r"""ファイル選択ダイアログ"""
        file_path = QFileDialog.getSaveFileName(
            self,
            titel,
            # dir=def_dir,
            filter=type_filter
            # options=QFileDialog.DontUseNativeDialog
            )
        return file_path[0]

    def open_file_path_dialog(
        self, titel="Select File", type_filter="", def_dir="C:\\"):
        r"""ファイル選択ダイアログ"""
        history = ["C:\\", "D:\\", "D:\\Project_HW", "D:\\Project_TA"]
        file_path = QFileDialog().getOpenFileName(
            self,
            titel,
            # dir=def_dir,
            filter=type_filter
            # options=QFileDialog.DontUseNativeDialog
            )
        return file_path[0]

    def save_bt_json(self):
        r"""save as
        """
        flt = "json config files (*.json);;All (*)"
        ret = self.save_file_path_dialog(type_filter=flt)
        if ret is "":
            return

        if ret.find(".json") is -1:
            ret = "{}.json".format(ret)

        file_path = os.path.dirname(ret)
        file_name = os.path.basename(ret)
        tc = cnfg.ToolConfig(file_path, file_name)
        tc.data = self.ui_dict
        tc.save()

    def load_bt_json(self):
        r"""load"""
        msg = u"現在のボタン失われますがよろしいですか？"
        if util.MessageBox().query_box(parent=self, msg_str=msg) is False:
            return
        flt = "json config files (*.json);;All (*)"
        ret = self.open_file_path_dialog(type_filter=flt)
        if ret is "":
            return

        file_path = os.path.dirname(ret)
        file_name = os.path.basename(ret)
        tc = cnfg.ToolConfig(file_path, file_name)
        old_data = self.ui_dict
        self.ui_dict = tc.data
        try:
            self.set_bg_img()
            self.update_bg_img()
            self.add_buttons()
        except:
            msg = u"このファイルは読み込めません"
            util.MessageBox().show_msg(parent=self, msg_str=msg)
            self.ui_dict = old_data
            self.add_buttons()
        self.set_ui_dict_value(self.helper_obj, self.ui_dict)

    def marge_bt_json(self):
        flt = "json config files (*.json);;All (*)"
        ret = self.open_file_path_dialog(type_filter=flt)
        if ret is "":
            return

        file_path = os.path.dirname(ret)
        file_name = os.path.basename(ret)
        tc = cnfg.ToolConfig(file_path, file_name)
        for bt in tc.data["buttons"]:
            new_bt = self.create_bt_key_name()
            self.ui_dict["buttons"][new_bt] = tc.data["buttons"][bt]
        self.add_buttons()