# -*- coding:utf-8 -*-
# Copyright (C)
# Author:
# Contact:
r"""Common Utility
汎用の色々あれするやつ
"""
from __future__ import absolute_import
from __future__ import division
from __future__ import print_function
from __future__ import unicode_literals

import os
import os.path
import platform

from datetime import datetime
try:
    from PySide2.QtWidgets import *
    from PySide2.QtGui import *
    from PySide2.QtCore import *

except ImportError:
    from PySide.QtGui import *
    from PySide.QtCore import *

import _winreg


class CommonErrorMsg(object):
    r"""汎用で使いそうなエラーメッセージ
    自前のpython関数の転用です
    """
    def __init__(self):
        pass

    def show_error_msg(self, error_str=""):
        """基本的なエラー"""
        QMessageBox.information(None, "Error Msg", error_str)


class MessageBox(object):
    r"""汎用で使いそうなエラーメッセージ
    自前のpython関数の転用です
    """
    def __init__(self):
        pass

    def show_msg(self, parent=None, msg_str=""):
        """基本的なメッセージ"""
        QMessageBox.information(parent, "Message", msg_str)

    def query_box(self, parent=None, title="Query", msg_str=""):
        """クエリー"""
        ret = QMessageBox.information(
            parent,
            title,
            msg_str,
            QMessageBox.Yes,
            QMessageBox.No
            )

        result = True
        if ret == QMessageBox.Yes:
            result = True
        elif ret == QMessageBox.No:
            result = False
        return result


class CommonUtil(object):
    """汎用ユーティリティ"""
    def __init__(self):
        pass

    def get_install_software(self, software=''):
        """install soft"""
        regi_key = "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall"
        key = _winreg.OpenKey(_winreg.HKEY_LOCAL_MACHINE, regi_key)
        reg_info = _winreg.QueryInfoKey(key)

        item = []
        for i in range(reg_info[0]):
            install_name = _winreg.EnumKey(key, i)
            try:
                sub_key = _winreg.OpenKey(key, install_name)
                item.append(_winreg.QueryValueEx(sub_key, "DisplayVersion")[0])
            except Exception:
                pass

        return item

    def get_os_ver(self):
        """Get OS ver"""
        return platform.platform()

    def get_win_ver(self):
        """Get Win ver """
        os_ver = platform.platform()
        os_name = "windows"

        if os_ver.find("windows-7"):
            os_name = "win7"
        elif os_ver.find("windows-8"):
            os_name = "win8"
        elif os_ver.find("windows-10"):
            os_name = "win10"
        return os_name

    def get_sp_folder_path(self, folder_name=''):
        """スペシャルフォルダのパスを取得
        Win7とWin10で参照するキーが違う
        """
        item = []
        if folder_name is '':
            return item

        regi_key = "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer"
        os_name = self.get_win_ver()
        # 文字列は完全比較
        if os_name == "win7":
            regi_key = "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer"
        elif os_name == "win10":
            regi_key = "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer"

        # 取得したキーのから指定の名前(folder_name)の値を取得する
        key = _winreg.OpenKey(_winreg.HKEY_CURRENT_USER, regi_key)
        reg_info = _winreg.QueryInfoKey(key)

        for i in range(reg_info[0]):
            value_name = _winreg.EnumKey(key, i)
            try:
                sub_key = _winreg.OpenKey(key, value_name)
                item.append(_winreg.QueryValueEx(sub_key, folder_name)[0])
            except Exception:
                pass

        return item

    def get_user_documents_path(self):
        return os.environ.get("USERPROFILE")

    def get_files_in_dir(self, dir_path=''):
        """get files
        遅い、Dosのほうが圧倒的に早い
        """
        dir_path = dir_path or ''
        file_list = []
        if dir_path is '':
            return file_list

        for root, dirs, files in os.walk(dir_path):
            for file in files:
                file_list.append(os.path.join(root, file))

        return file_list

    def get_time_stamp(self):
        return datetime.now().strftime('%Y_%m%d_%H%M%S')
