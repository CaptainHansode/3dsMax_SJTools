# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'D:\Project_TA\GrpTools\dcc\common\max\maxscript\scripts\Python\GrpPython\selecton\selecton_main.ui'
#
# Created: Fri Jul  6 19:22:17 2018
#      by: pyside2-uic  running on PySide2 2.0.0~alpha0
#
# WARNING! All changes made in this file will be lost!

from PySide2 import QtCore, QtGui, QtWidgets

class Ui_MainWindow(object):
    def setupUi(self, MainWindow):
        MainWindow.setObjectName("MainWindow")
        MainWindow.resize(170, 374)
        self.centralwidget = QtWidgets.QWidget(MainWindow)
        self.centralwidget.setObjectName("centralwidget")
        self.verticalLayout_3 = QtWidgets.QVBoxLayout(self.centralwidget)
        self.verticalLayout_3.setObjectName("verticalLayout_3")
        self.horizontalLayout = QtWidgets.QHBoxLayout()
        self.horizontalLayout.setContentsMargins(6, -1, -1, 6)
        self.horizontalLayout.setObjectName("horizontalLayout")
        self.groupBox = QtWidgets.QGroupBox(self.centralwidget)
        self.groupBox.setObjectName("groupBox")
        self.verticalLayout = QtWidgets.QVBoxLayout(self.groupBox)
        self.verticalLayout.setObjectName("verticalLayout")
        self.reloadBt = QtWidgets.QPushButton(self.groupBox)
        self.reloadBt.setObjectName("reloadBt")
        self.verticalLayout.addWidget(self.reloadBt)
        self.selectorList = QtWidgets.QListWidget(self.groupBox)
        self.selectorList.setObjectName("selectorList")
        self.verticalLayout.addWidget(self.selectorList)
        self.openBt = QtWidgets.QPushButton(self.groupBox)
        self.openBt.setMinimumSize(QtCore.QSize(0, 32))
        self.openBt.setObjectName("openBt")
        self.verticalLayout.addWidget(self.openBt)
        self.addBt = QtWidgets.QPushButton(self.groupBox)
        self.addBt.setObjectName("addBt")
        self.verticalLayout.addWidget(self.addBt)
        self.editBt = QtWidgets.QPushButton(self.groupBox)
        self.editBt.setObjectName("editBt")
        self.verticalLayout.addWidget(self.editBt)
        self.horizontalLayout.addWidget(self.groupBox)
        self.verticalLayout_3.addLayout(self.horizontalLayout)
        MainWindow.setCentralWidget(self.centralwidget)
        self.menubar = QtWidgets.QMenuBar(MainWindow)
        self.menubar.setGeometry(QtCore.QRect(0, 0, 170, 24))
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
        self.groupBox.setTitle(QtWidgets.QApplication.translate("MainWindow", "Selector List", None, -1))
        self.reloadBt.setText(QtWidgets.QApplication.translate("MainWindow", "Reload", None, -1))
        self.openBt.setText(QtWidgets.QApplication.translate("MainWindow", "Open", None, -1))
        self.addBt.setText(QtWidgets.QApplication.translate("MainWindow", "Add", None, -1))
        self.editBt.setText(QtWidgets.QApplication.translate("MainWindow", "Edit", None, -1))
        self.menuMenu.setTitle(QtWidgets.QApplication.translate("MainWindow", "Menu", None, -1))

