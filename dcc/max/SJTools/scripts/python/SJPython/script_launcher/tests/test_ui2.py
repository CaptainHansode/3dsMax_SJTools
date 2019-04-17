# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'D:\Project_TA\GrpTools\dcc\common\max\maxscript\scripts\Python\GrpPython\selecton\test_ui.ui'
#
# Created: Thu Jul  5 17:47:13 2018
#      by: pyside2-uic  running on PySide2 2.0.0~alpha0
#
# WARNING! All changes made in this file will be lost!

from PySide2 import QtCore, QtGui, QtWidgets

class Ui_MainWindow(object):
    def setupUi(self, MainWindow):
        MainWindow.setObjectName("MainWindow")
        MainWindow.resize(766, 784)
        self.centralwidget = QtWidgets.QWidget(MainWindow)
        self.centralwidget.setObjectName("centralwidget")
        self.gridLayout = QtWidgets.QGridLayout(self.centralwidget)
        self.gridLayout.setObjectName("gridLayout")
        self.scrollArea = QtWidgets.QScrollArea(self.centralwidget)
        self.scrollArea.setWidgetResizable(True)
        self.scrollArea.setObjectName("scrollArea")
        self.scrollAreaWidgetContents = QtWidgets.QWidget()
        self.scrollAreaWidgetContents.setGeometry(QtCore.QRect(0, 0, 746, 637))
        self.scrollAreaWidgetContents.setObjectName("scrollAreaWidgetContents")
        self.label = QtWidgets.QLabel(self.scrollAreaWidgetContents)
        self.label.setGeometry(QtCore.QRect(0, 0, 355, 555))
        self.label.setAlignment(QtCore.Qt.AlignLeading|QtCore.Qt.AlignLeft|QtCore.Qt.AlignTop)
        self.label.setObjectName("label")

        self.gridLayout.addWidget(self.scrollArea, 0, 0, 1, 1)
        self.selModeGb = QtWidgets.QGroupBox(self.centralwidget)
        self.selModeGb.setMinimumSize(QtCore.QSize(0, 48))
        self.selModeGb.setMaximumSize(QtCore.QSize(16777215, 48))
        self.selModeGb.setObjectName("selModeGb")
        self.horizontalLayout = QtWidgets.QHBoxLayout(self.selModeGb)
        self.horizontalLayout.setObjectName("horizontalLayout")
        self.nameSelRb = QtWidgets.QRadioButton(self.selModeGb)
        self.nameSelRb.setChecked(True)
        self.nameSelRb.setObjectName("nameSelRb")
        self.horizontalLayout.addWidget(self.nameSelRb)
        self.searchSelRb = QtWidgets.QRadioButton(self.selModeGb)
        self.searchSelRb.setObjectName("searchSelRb")
        self.horizontalLayout.addWidget(self.searchSelRb)
        self.searchTreeSelRb = QtWidgets.QRadioButton(self.selModeGb)
        self.searchTreeSelRb.setChecked(False)
        self.searchTreeSelRb.setObjectName("searchTreeSelRb")
        self.horizontalLayout.addWidget(self.searchTreeSelRb)
        self.gridLayout.addWidget(self.selModeGb, 2, 0, 1, 1)
        self.hint = QtWidgets.QLabel(self.centralwidget)
        self.hint.setMinimumSize(QtCore.QSize(0, 20))
        self.hint.setMaximumSize(QtCore.QSize(16777215, 20))
        self.hint.setObjectName("hint")
        self.gridLayout.addWidget(self.hint, 1, 0, 1, 1)
        MainWindow.setCentralWidget(self.centralwidget)
        self.menubar = QtWidgets.QMenuBar(MainWindow)
        self.menubar.setGeometry(QtCore.QRect(0, 0, 766, 24))
        self.menubar.setObjectName("menubar")
        MainWindow.setMenuBar(self.menubar)
        self.statusbar = QtWidgets.QStatusBar(MainWindow)
        self.statusbar.setObjectName("statusbar")
        MainWindow.setStatusBar(self.statusbar)

        self.retranslateUi(MainWindow)
        QtCore.QMetaObject.connectSlotsByName(MainWindow)

    def retranslateUi(self, MainWindow):
        MainWindow.setWindowTitle(QtWidgets.QApplication.translate("MainWindow", "MainWindow", None, -1))
        self.label.setText(QtWidgets.QApplication.translate("MainWindow", "TextLabel", None, -1))
        self.selModeGb.setTitle(QtWidgets.QApplication.translate("MainWindow", "Select Mode", None, -1))
        self.nameSelRb.setText(QtWidgets.QApplication.translate("MainWindow", "名前で選択", None, -1))
        self.searchSelRb.setText(QtWidgets.QApplication.translate("MainWindow", "シーンから検索", None, -1))
        self.searchTreeSelRb.setText(QtWidgets.QApplication.translate("MainWindow", "ツリーから検索", None, -1))
        self.hint.setText(QtWidgets.QApplication.translate("MainWindow", "Hint", None, -1))

