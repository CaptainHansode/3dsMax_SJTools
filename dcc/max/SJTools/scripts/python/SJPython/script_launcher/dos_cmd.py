# -*- coding:utf-8 -*-
# Copyright (C)
# Author:
# Contact:
r"""common dos cmmand
 個人的に作成していたものの転用です
"""
from __future__ import absolute_import
from __future__ import division
from __future__ import print_function
from __future__ import unicode_literals

import os
import subprocess


class NormalizePath(object):
    r"""パスを整える"""
    def __init__(self):
        pass

    def normalize_path(self, path=''):
        r"""normalize path

        ケツに\があると除去パスが存在しないと空
        absでじゅうぶんじゃね？

        Arguments:
        path -- string

        Return value:
        path -- string
        """
        path = path or ''
        if path is '':
            path = ''

        laststr = path[-1]
        if laststr == '\\':
            path = path[0:len(path) - 1]

        path = path.replace("/", "\\")

        if os.path.exists(path) is False:
            path = ''
        return path


class CommonCmd(object):
    r"""CommonCmd
    """
    def __init__(self):
        self.nom_path = NormalizePath()

    def common_cmd(self, cmd):
        r"""common"""
        cmd_ret = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)
        return cmd_ret

    def __get_sp_folder_path(self):
        result = []
        cmd = 'reg query \"HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders\"'
        cmd_ret = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)
        for i in cmd_ret.stdout.readlines():
            print(i.decode('shift-jis').encode('utf-8'))
        return

    def get_files_in_dir_at_cmd(
            self,
            dir_path='',
            file_filter='*',
            dir_only=False,
            sub=False):
        r"""get file list"""
        dir_path = self.nom_path.normalize_path(dir_path)
        if dir_path is '':
            return []

        dir_option = ''
        if dir_only:
            dir_option = '/A:D'

        sub_option = ''
        if sub:
            sub_option = '/S'

        cmd = 'dir /B {} {} \"{}\\{}\"'.format(
            sub_option,
            dir_option,
            dir_path,
            file_filter
            )

        cmd_ret = subprocess.Popen(
            cmd.encode('shift-jis'),
            stdout=subprocess.PIPE,
            shell=True
            )

        result = []
        for i in cmd_ret.stdout.readlines():
            dir_str = self.try_decode(i).replace('\r\n', '')
            if sub:
                result.append(dir_str)
            else:
                result.append("{}\\{}".format(dir_path, dir_str))
        return result

    def try_decode(self, decstr=""):
        codes = [
            'shift-jis', 'cp932', 'utf-8', 'utf-16', 'utf-16-be', 'utf-16-le']
        result = ""
        for c in codes:
            try:
                result = decstr.decode(c)
                return result
            except UnicodeDecodeError:
                result = "Doesn't decode"
        return result

    def try_encode(self, encstr=""):
        codes = [
            'shift-jis', 'cp932', 'utf-8', 'utf-16', 'utf-16-be', 'utf-16-le']
            # 'shift-jis', 'shift-jisx0213', 'shift-jis-2004', 'cp932', 'utf-8', 'utf-16', 'utf-16-be', 'utf-16-le']
        result = ""
        for c in codes:
            try:
                result = encstr.encode(c)
                return result
            except:
                return ""
        return result

    def explorer_at_cmd(self, dir_path='', select=False):
        r"""open explorer"""
        dir_path = self.nom_path.normalize_path(dir_path)
        # dir_path = self.try_encode(dir_path)unichr(dir_path)
        if dir_path is '':
            return
        if select:
            cmd = 'explorer /select,\"{}\"'.format(dir_path)
        else:
            if os.path.isfile(dir_path):
                dir_path = os.path.dirname(dir_path)
            cmd = 'explorer \"{}\"'.format(dir_path)
        cmd = self.try_encode(cmd)
        if cmd == "":
            return False
        subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)
        return True
