# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'D:\Project_TA\GrpTools\dcc\common\max\maxscript\scripts\Python\GrpPython\selecton\edit_ui.ui'
#
# Created: Fri Jul  6 19:22:17 2018
#      by: pyside2-uic  running on PySide2 2.0.0~alpha0
#
# WARNING! All changes made in this file will be lost!

from PySide2 import QtCore, QtGui, QtWidgets

class Ui_MainWindow(object):
    def setupUi(self, MainWindow):
        MainWindow.setObjectName("MainWindow")
        MainWindow.resize(465, 566)
        self.centralwidget = QtWidgets.QWidget(MainWindow)
        self.centralwidget.setObjectName("centralwidget")
        self.gridLayout = QtWidgets.QGridLayout(self.centralwidget)
        self.gridLayout.setObjectName("gridLayout")
        self.bgImgGb = QtWidgets.QGroupBox(self.centralwidget)
        self.bgImgGb.setMinimumSize(QtCore.QSize(0, 52))
        self.bgImgGb.setMaximumSize(QtCore.QSize(16777215, 52))
        self.bgImgGb.setObjectName("bgImgGb")
        self.horizontalLayout_8 = QtWidgets.QHBoxLayout(self.bgImgGb)
        self.horizontalLayout_8.setObjectName("horizontalLayout_8")
        self.bgImgPath = QtWidgets.QLineEdit(self.bgImgGb)
        self.bgImgPath.setObjectName("bgImgPath")
        self.horizontalLayout_8.addWidget(self.bgImgPath)
        self.bgImgBt = QtWidgets.QToolButton(self.bgImgGb)
        self.bgImgBt.setObjectName("bgImgBt")
        self.horizontalLayout_8.addWidget(self.bgImgBt)
        self.delBgImgBt = QtWidgets.QToolButton(self.bgImgGb)
        self.delBgImgBt.setObjectName("delBgImgBt")
        self.horizontalLayout_8.addWidget(self.delBgImgBt)
        self.gridLayout.addWidget(self.bgImgGb, 2, 0, 1, 1)
        self.scriptEditGb = QtWidgets.QGroupBox(self.centralwidget)
        self.scriptEditGb.setMinimumSize(QtCore.QSize(0, 180))
        self.scriptEditGb.setMaximumSize(QtCore.QSize(16777215, 16777215))
        self.scriptEditGb.setObjectName("scriptEditGb")
        self.verticalLayout_3 = QtWidgets.QVBoxLayout(self.scriptEditGb)
        self.verticalLayout_3.setObjectName("verticalLayout_3")
        self.horizontalLayout_5 = QtWidgets.QHBoxLayout()
        self.horizontalLayout_5.setContentsMargins(-1, -1, -1, 0)
        self.horizontalLayout_5.setObjectName("horizontalLayout_5")
        self.msRb = QtWidgets.QRadioButton(self.scriptEditGb)
        self.msRb.setChecked(True)
        self.msRb.setObjectName("msRb")
        self.horizontalLayout_5.addWidget(self.msRb)
        self.pyRb = QtWidgets.QRadioButton(self.scriptEditGb)
        self.pyRb.setObjectName("pyRb")
        self.horizontalLayout_5.addWidget(self.pyRb)
        self.verticalLayout_3.addLayout(self.horizontalLayout_5)
        self.scriptSource = QtWidgets.QTextEdit(self.scriptEditGb)
        self.scriptSource.setObjectName("scriptSource")
        self.verticalLayout_3.addWidget(self.scriptSource)
        self.testRunBt = QtWidgets.QPushButton(self.scriptEditGb)
        self.testRunBt.setObjectName("testRunBt")
        self.verticalLayout_3.addWidget(self.testRunBt)
        self.gridLayout.addWidget(self.scriptEditGb, 5, 0, 1, 1)
        self.btEditLayout = QtWidgets.QHBoxLayout()
        self.btEditLayout.setContentsMargins(-1, -1, -1, 0)
        self.btEditLayout.setObjectName("btEditLayout")
        self.btStats = QtWidgets.QGroupBox(self.centralwidget)
        self.btStats.setMinimumSize(QtCore.QSize(0, 120))
        self.btStats.setMaximumSize(QtCore.QSize(280, 240))
        self.btStats.setObjectName("btStats")
        self.verticalLayout_4 = QtWidgets.QVBoxLayout(self.btStats)
        self.verticalLayout_4.setObjectName("verticalLayout_4")
        self.horizontalLayout_10 = QtWidgets.QHBoxLayout()
        self.horizontalLayout_10.setObjectName("horizontalLayout_10")
        self.label_3 = QtWidgets.QLabel(self.btStats)
        self.label_3.setObjectName("label_3")
        self.horizontalLayout_10.addWidget(self.label_3)
        self.btTxt = QtWidgets.QLineEdit(self.btStats)
        self.btTxt.setObjectName("btTxt")
        self.horizontalLayout_10.addWidget(self.btTxt)
        self.verticalLayout_4.addLayout(self.horizontalLayout_10)
        self.horizontalLayout_3 = QtWidgets.QHBoxLayout()
        self.horizontalLayout_3.setContentsMargins(-1, -1, -1, 0)
        self.horizontalLayout_3.setObjectName("horizontalLayout_3")
        self.label_4 = QtWidgets.QLabel(self.btStats)
        self.label_4.setObjectName("label_4")
        self.horizontalLayout_3.addWidget(self.label_4)
        self.btX = QtWidgets.QSpinBox(self.btStats)
        self.btX.setMaximum(2048)
        self.btX.setObjectName("btX")
        self.horizontalLayout_3.addWidget(self.btX)
        self.label_5 = QtWidgets.QLabel(self.btStats)
        self.label_5.setObjectName("label_5")
        self.horizontalLayout_3.addWidget(self.label_5)
        self.btY = QtWidgets.QSpinBox(self.btStats)
        self.btY.setMaximum(2048)
        self.btY.setObjectName("btY")
        self.horizontalLayout_3.addWidget(self.btY)
        self.label_6 = QtWidgets.QLabel(self.btStats)
        self.label_6.setObjectName("label_6")
        self.horizontalLayout_3.addWidget(self.label_6)
        self.btW = QtWidgets.QSpinBox(self.btStats)
        self.btW.setMinimum(2)
        self.btW.setMaximum(2048)
        self.btW.setObjectName("btW")
        self.horizontalLayout_3.addWidget(self.btW)
        self.label_7 = QtWidgets.QLabel(self.btStats)
        self.label_7.setObjectName("label_7")
        self.horizontalLayout_3.addWidget(self.label_7)
        self.btH = QtWidgets.QSpinBox(self.btStats)
        self.btH.setMinimum(2)
        self.btH.setMaximum(2048)
        self.btH.setObjectName("btH")
        self.horizontalLayout_3.addWidget(self.btH)
        self.verticalLayout_4.addLayout(self.horizontalLayout_3)
        self.horizontalLayout_11 = QtWidgets.QHBoxLayout()
        self.horizontalLayout_11.setObjectName("horizontalLayout_11")
        self.colLbl = QtWidgets.QLabel(self.btStats)
        self.colLbl.setMinimumSize(QtCore.QSize(0, 0))
        self.colLbl.setObjectName("colLbl")
        self.horizontalLayout_11.addWidget(self.colLbl)
        self.colBt = QtWidgets.QToolButton(self.btStats)
        self.colBt.setObjectName("colBt")
        self.horizontalLayout_11.addWidget(self.colBt)
        self.verticalLayout_4.addLayout(self.horizontalLayout_11)
        self.iconLayout = QtWidgets.QHBoxLayout()
        self.iconLayout.setContentsMargins(-1, -1, -1, 0)
        self.iconLayout.setObjectName("iconLayout")
        self.iconLb = QtWidgets.QLabel(self.btStats)
        self.iconLb.setObjectName("iconLb")
        self.iconLayout.addWidget(self.iconLb)
        self.iconPath = QtWidgets.QLineEdit(self.btStats)
        self.iconPath.setObjectName("iconPath")
        self.iconLayout.addWidget(self.iconPath)
        self.iconBt = QtWidgets.QToolButton(self.btStats)
        self.iconBt.setObjectName("iconBt")
        self.iconLayout.addWidget(self.iconBt)
        self.delIconBt = QtWidgets.QToolButton(self.btStats)
        self.delIconBt.setObjectName("delIconBt")
        self.iconLayout.addWidget(self.delIconBt)
        self.verticalLayout_4.addLayout(self.iconLayout)
        spacerItem = QtWidgets.QSpacerItem(20, 40, QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Expanding)
        self.verticalLayout_4.addItem(spacerItem)
        self.btEditLayout.addWidget(self.btStats)
        self.selObjGb = QtWidgets.QGroupBox(self.centralwidget)
        self.selObjGb.setMinimumSize(QtCore.QSize(0, 96))
        self.selObjGb.setMaximumSize(QtCore.QSize(16777215, 240))
        self.selObjGb.setObjectName("selObjGb")
        self.verticalLayout_2 = QtWidgets.QVBoxLayout(self.selObjGb)
        self.verticalLayout_2.setObjectName("verticalLayout_2")
        self.selList = QtWidgets.QTextEdit(self.selObjGb)
        self.selList.setObjectName("selList")
        self.verticalLayout_2.addWidget(self.selList)
        self.horizontalLayout_2 = QtWidgets.QHBoxLayout()
        self.horizontalLayout_2.setContentsMargins(-1, -1, -1, 0)
        self.horizontalLayout_2.setObjectName("horizontalLayout_2")
        self.addSelListBt = QtWidgets.QPushButton(self.selObjGb)
        self.addSelListBt.setObjectName("addSelListBt")
        self.horizontalLayout_2.addWidget(self.addSelListBt)
        self.clearSelListBt = QtWidgets.QPushButton(self.selObjGb)
        self.clearSelListBt.setMaximumSize(QtCore.QSize(56, 16777215))
        self.clearSelListBt.setObjectName("clearSelListBt")
        self.horizontalLayout_2.addWidget(self.clearSelListBt)
        self.verticalLayout_2.addLayout(self.horizontalLayout_2)
        self.btEditLayout.addWidget(self.selObjGb)
        self.btEditLayout.setStretch(1, 1)
        self.gridLayout.addLayout(self.btEditLayout, 4, 0, 1, 1)
        self.saveLayout = QtWidgets.QHBoxLayout()
        self.saveLayout.setContentsMargins(-1, -1, -1, 0)
        self.saveLayout.setObjectName("saveLayout")
        self.saveBt = QtWidgets.QPushButton(self.centralwidget)
        self.saveBt.setMinimumSize(QtCore.QSize(0, 38))
        self.saveBt.setObjectName("saveBt")
        self.saveLayout.addWidget(self.saveBt)
        self.closeBt = QtWidgets.QPushButton(self.centralwidget)
        self.closeBt.setMinimumSize(QtCore.QSize(0, 38))
        self.closeBt.setObjectName("closeBt")
        self.saveLayout.addWidget(self.closeBt)
        self.gridLayout.addLayout(self.saveLayout, 6, 0, 1, 1)
        self.createBtGb = QtWidgets.QGroupBox(self.centralwidget)
        self.createBtGb.setObjectName("createBtGb")
        self.horizontalLayout = QtWidgets.QHBoxLayout(self.createBtGb)
        self.horizontalLayout.setObjectName("horizontalLayout")
        self.addBt = QtWidgets.QPushButton(self.createBtGb)
        self.addBt.setMinimumSize(QtCore.QSize(0, 28))
        self.addBt.setObjectName("addBt")
        self.horizontalLayout.addWidget(self.addBt)
        self.importBt = QtWidgets.QPushButton(self.createBtGb)
        self.importBt.setMinimumSize(QtCore.QSize(0, 28))
        self.importBt.setObjectName("importBt")
        self.horizontalLayout.addWidget(self.importBt)
        self.delBt = QtWidgets.QPushButton(self.createBtGb)
        self.delBt.setMinimumSize(QtCore.QSize(0, 28))
        self.delBt.setObjectName("delBt")
        self.horizontalLayout.addWidget(self.delBt)
        self.gridLayout.addWidget(self.createBtGb, 3, 0, 1, 1)
        self.gridLayout.setRowStretch(5, 1)
        MainWindow.setCentralWidget(self.centralwidget)
        self.menubar = QtWidgets.QMenuBar(MainWindow)
        self.menubar.setGeometry(QtCore.QRect(0, 0, 465, 24))
        self.menubar.setObjectName("menubar")
        self.menuMenu = QtWidgets.QMenu(self.menubar)
        self.menuMenu.setObjectName("menuMenu")
        MainWindow.setMenuBar(self.menubar)
        self.statusbar = QtWidgets.QStatusBar(MainWindow)
        self.statusbar.setObjectName("statusbar")
        MainWindow.setStatusBar(self.statusbar)
        self.menubar.addAction(self.menuMenu.menuAction())

        self.retranslateUi(MainWindow)
        QtCore.QMetaObject.connectSlotsByName(MainWindow)

    def retranslateUi(self, MainWindow):
        MainWindow.setWindowTitle(QtWidgets.QApplication.translate("MainWindow", "MainWindow", None, -1))
        self.bgImgGb.setTitle(QtWidgets.QApplication.translate("MainWindow", "BG_Image", None, -1))
        self.bgImgBt.setText(QtWidgets.QApplication.translate("MainWindow", "...", None, -1))
        self.delBgImgBt.setText(QtWidgets.QApplication.translate("MainWindow", "X", None, -1))
        self.scriptEditGb.setTitle(QtWidgets.QApplication.translate("MainWindow", "Script of Button", None, -1))
        self.msRb.setText(QtWidgets.QApplication.translate("MainWindow", "MaxScript", None, -1))
        self.pyRb.setText(QtWidgets.QApplication.translate("MainWindow", "Python", None, -1))
        self.testRunBt.setText(QtWidgets.QApplication.translate("MainWindow", "TestRun", None, -1))
        self.btStats.setTitle(QtWidgets.QApplication.translate("MainWindow", "Button Setting", None, -1))
        self.label_3.setText(QtWidgets.QApplication.translate("MainWindow", "Text", None, -1))
        self.label_4.setText(QtWidgets.QApplication.translate("MainWindow", "X", None, -1))
        self.label_5.setText(QtWidgets.QApplication.translate("MainWindow", "Y", None, -1))
        self.label_6.setText(QtWidgets.QApplication.translate("MainWindow", "W", None, -1))
        self.label_7.setText(QtWidgets.QApplication.translate("MainWindow", "H", None, -1))
        self.colLbl.setText(QtWidgets.QApplication.translate("MainWindow", "ボタンカラー", None, -1))
        self.colBt.setText(QtWidgets.QApplication.translate("MainWindow", "...", None, -1))
        self.iconLb.setText(QtWidgets.QApplication.translate("MainWindow", "アイコン", None, -1))
        self.iconBt.setText(QtWidgets.QApplication.translate("MainWindow", "...", None, -1))
        self.delIconBt.setText(QtWidgets.QApplication.translate("MainWindow", "X", None, -1))
        self.selObjGb.setTitle(QtWidgets.QApplication.translate("MainWindow", "SelectList", None, -1))
        self.addSelListBt.setText(QtWidgets.QApplication.translate("MainWindow", "選択を追加", None, -1))
        self.clearSelListBt.setText(QtWidgets.QApplication.translate("MainWindow", "クリア", None, -1))
        self.saveBt.setText(QtWidgets.QApplication.translate("MainWindow", "Save", None, -1))
        self.closeBt.setText(QtWidgets.QApplication.translate("MainWindow", "Close", None, -1))
        self.createBtGb.setTitle(QtWidgets.QApplication.translate("MainWindow", "Create Button", None, -1))
        self.addBt.setText(QtWidgets.QApplication.translate("MainWindow", "ボタン追加", None, -1))
        self.importBt.setText(QtWidgets.QApplication.translate("MainWindow", "ボタン読み込み", None, -1))
        self.delBt.setText(QtWidgets.QApplication.translate("MainWindow", "ボタン削除", None, -1))
        self.menuMenu.setTitle(QtWidgets.QApplication.translate("MainWindow", "Menu", None, -1))

