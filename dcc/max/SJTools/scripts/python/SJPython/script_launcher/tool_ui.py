# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'D:\sakai\SJTools\dcc\max\SJTools\scripts\python\SJPython\script_launcher\tool_ui.ui'
#
# Created: Wed Jan 23 13:15:15 2019
#      by: pyside2-uic  running on PySide2 2.0.0~alpha0
#
# WARNING! All changes made in this file will be lost!

from PySide2 import QtCore, QtGui, QtWidgets

class Ui_MainWindow(object):
    def setupUi(self, MainWindow):
        MainWindow.setObjectName("MainWindow")
        MainWindow.resize(397, 414)
        self.centralwidget = QtWidgets.QWidget(MainWindow)
        self.centralwidget.setObjectName("centralwidget")
        self.verticalLayout = QtWidgets.QVBoxLayout(self.centralwidget)
        self.verticalLayout.setObjectName("verticalLayout")
        self.path = QtWidgets.QLineEdit(self.centralwidget)
        self.path.setObjectName("path")
        self.verticalLayout.addWidget(self.path)
        self.scList = QtWidgets.QListWidget(self.centralwidget)
        self.scList.setObjectName("scList")
        self.verticalLayout.addWidget(self.scList)
        self.delBt = QtWidgets.QPushButton(self.centralwidget)
        self.delBt.setObjectName("delBt")
        self.verticalLayout.addWidget(self.delBt)
        self.clearBt = QtWidgets.QPushButton(self.centralwidget)
        self.clearBt.setObjectName("clearBt")
        self.verticalLayout.addWidget(self.clearBt)
        self.runBt = QtWidgets.QPushButton(self.centralwidget)
        self.runBt.setObjectName("runBt")
        self.verticalLayout.addWidget(self.runBt)
        self.encryptBt = QtWidgets.QPushButton(self.centralwidget)
        self.encryptBt.setObjectName("encryptBt")
        self.verticalLayout.addWidget(self.encryptBt)
        self.encryptAllBt = QtWidgets.QPushButton(self.centralwidget)
        self.encryptAllBt.setObjectName("encryptAllBt")
        self.verticalLayout.addWidget(self.encryptAllBt)
        MainWindow.setCentralWidget(self.centralwidget)
        self.menubar = QtWidgets.QMenuBar(MainWindow)
        self.menubar.setGeometry(QtCore.QRect(0, 0, 397, 24))
        self.menubar.setObjectName("menubar")
        MainWindow.setMenuBar(self.menubar)
        self.statusbar = QtWidgets.QStatusBar(MainWindow)
        self.statusbar.setObjectName("statusbar")
        MainWindow.setStatusBar(self.statusbar)

        self.retranslateUi(MainWindow)
        QtCore.QMetaObject.connectSlotsByName(MainWindow)

    def retranslateUi(self, MainWindow):
        MainWindow.setWindowTitle(QtWidgets.QApplication.translate("MainWindow", "MainWindow", None, -1))
        self.delBt.setText(QtWidgets.QApplication.translate("MainWindow", "Delete", None, -1))
        self.clearBt.setText(QtWidgets.QApplication.translate("MainWindow", "Clear", None, -1))
        self.runBt.setText(QtWidgets.QApplication.translate("MainWindow", "Run", None, -1))
        self.encryptBt.setText(QtWidgets.QApplication.translate("MainWindow", "Encrypt Maxscript", None, -1))
        self.encryptAllBt.setText(QtWidgets.QApplication.translate("MainWindow", "Encrypt All Maxscript", None, -1))

