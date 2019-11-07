# -*- coding: utf-8 -*-
r"""tool config
"""
from __future__ import absolute_import
from __future__ import division
from __future__ import print_function
from __future__ import unicode_literals

import collections
import json
import os
import os.path


class ToolConfig(object):
    r"""汎用のコンフィグクラス
    自前のpython関数の転用です
    Json
    """
    def __init__(self, file_path="", file_name="config.json", default={}):
        file_path = file_path or os.environ.get("USERPROFILE")
        self.path = "{}\\{}".format(file_path, file_name)
        self.dec = json.JSONDecoder(object_pairs_hook=collections.OrderedDict)
        self.data = default
        self.load()

    def save(self):
        r"""save"""
        save_file = open(self.path, 'w')
        json.dump(self.data, fp=save_file, indent=4)
        save_file.close()

    def load(self):
        r"""load"""
        if os.path.exists(self.path) is False:
            self.create_config_file()
        load_file = open(self.path, 'r')
        json_dict = json.load(
            load_file, object_pairs_hook=collections.OrderedDict)
        load_file.close()
        self.data = json_dict

    def create_config_file(self):
        r"""create"""
        if os.path.exists(os.path.dirname(self.path)) is False:
            os.makedirs(os.path.dirname(self.path))
        save_file = open(self.path, 'w')
        json.dump(self.data, fp=save_file, indent=4)
        save_file.close()

    def clear(self):
        r"""clear"""
        self.data = {}
        self.save()
