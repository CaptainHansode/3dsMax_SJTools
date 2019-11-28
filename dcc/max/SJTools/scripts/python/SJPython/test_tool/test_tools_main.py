# -*- coding: utf-8 -*-
r"""noisy
uiの基本的処理
TODO:長い、もっと短くかく
"""
from __future__ import absolute_import
from __future__ import division
from __future__ import print_function
from __future__ import unicode_literals

import collections
import datetime
import glob
import json
import os
import os.path
from collections import OrderedDict

import test_tools_ui

import pymxs
import MaxPlus
from PySide2 import QtCore, QtGui, QtWidgets

reload(test_tools_ui)


class TestClassRun(object):
    r"""汎用で使いそうなエラーメッセージ
    自前のpython関数の転用です
    """
    def __init__(self):
        print("TestClassRun")

class TestTool(QtWidgets.QMainWindow, test_tools_ui.Ui_MainWindow):
    r"""UI Class
    """
    def __init__(self, *args, **kwargs):
        super(TestTool, self).__init__(*args, **kwargs)
        self.setWindowFlags(QtCore.Qt.Tool)

        self.tool_name = "TestTool"
        self.version = "0.0.0.1"
        self.auther = ""

        """set up ui"""
        self.setupUi(self)
        self.setWindowTitle("{} {}".format(self.tool_name, self.version))
        self.setObjectName(self.tool_name)

