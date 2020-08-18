# -*- coding: utf-8 -*-
# ##### BEGIN GPL LICENSE BLOCK #####
#
#  This program is free software; you can redistribute it and/or
#  modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation; either version 2
#  of the License, or (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software Foundation,
#  Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
#
# ##### END GPL LICENSE BLOCK #####


bl_info = {
    "name": "SJ SPARK Nator",
    "author": "CaptainHansode",
    "version": (0, 1, 0),
    "blender": (2, 80, 0),
    "location":  "View3D > Sidebar > Tool Tab",
    "description": "My Tools.",
    "warning": "",
    "wiki_url": "",
    "tracker_url": "",
    "category": "Animation",
}


import bpy
from bpy.app.handlers import persistent


class SJSparkSelTree(bpy.types.Operator):
    r"""Ser Bone Name"""
    bl_idname = "object.sj_spark_nator_sel_tree"
    bl_label = "Tree Select"

    @classmethod
    def poll(cls, context):
        r""""""
        return context.active_object is not None

    def execute(self, context):
        r""""""
        sjsb = context.scene.sj_spark_nator_props
        obj = context.active_object
        print(obj)
        print(obj.children)

        # for pbn in bpy.context.selected_pose_bones:
        #     new_name = sjsb.b_name
        #     cnt_str = str(cnt)
        #     if sjsb.numbering is True:
        #         while len(cnt_str) < sjsb.n_digit:  # 桁が足りなかったら足す
        #             cnt_str = "0{}".format(cnt_str)
        #         pbn.name = "{}{}".format(new_name, cnt_str)
        #     else:
        #         pbn.name = new_name
        #     print(pbn.name)
        #     cnt += 1

        bpy.ops.wm.redraw_timer(type='DRAW_WIN_SWAP', iterations=1)  # 再描画
        return {'FINISHED'}


class SJSparkNatorProperties(bpy.types.PropertyGroup):
    r"""カスタムプロパティを定義する"""
    b_name: bpy.props.StringProperty(name="Name", default="")


class SJSparkNator(bpy.types.Panel):
    r"""UI"""
    bl_label = "SJ SPARK Nator"
    bl_space_type = 'VIEW_3D'
    bl_region_type = 'UI'  # UIのタイプ
    # bl_context = "posemode"
    # カスタムタブは名前を指定するだけで問題ない 他のツールのタブにも追加できる
    bl_category = 'Tool'
    # bl_category = 'SJTools'
    bl_options = {'DEFAULT_CLOSED'}  # デフォルトでは閉じている

    def draw(self, context):
        layout = self.layout
        scene = context.scene
        sjsp = context.scene.sj_spark_nator_props
        layout.label(text="Select")
        row = layout.row()
        row.scale_y = 1.0
        row.operator("object.sj_spark_nator_sel_tree")


class SJSparkLy(object):
    r"""set lay"""
    def __init__(self, *args, **kwargs):
        if len(bpy.context.selected_pose_bones) is 0:
            return None
        b = bpy.context.selected_pose_bones[-0]
        sw = bpy.context.object.data.bones[b.name].layers[args[0]]

        self.set_bone_layer(
            bpy.context.selected_pose_bones, [args[0]], not(sw))
        return None

    def set_bone_layer(self, pbn_list=[], ly_list=[0], sw=True):
        r"""set bone layers"""
        # 一旦レイヤー状態を保存
        saved_layers = [
            layer_bool for layer_bool in bpy.context.active_object.data.layers]
        # 表示
        for ly in range(0, 32):
            bpy.context.active_object.data.layers[ly] = True
        
        for pbn in pbn_list:
            for ly in ly_list:
                bpy.context.object.data.bones[pbn.name].layers[ly] = sw
        
        # 表示状態を復元して終わり
        for i, layer_bool in enumerate(saved_layers):
            bpy.context.active_object.data.layers[i] = layer_bool

        return True


class SJSparkClearLayer(bpy.types.Operator):
    r"""Ser Bone Clear Layer"""
    bl_idname = "object.sj_spark_nator_clear_layer"
    bl_label = "Clear"
    bl_description = "Change the settings of the selected bone layer."

    @classmethod
    def poll(cls, context):
        r""""""
        return context.active_object is not None

    def clear_bone_layer(self, pbn_list=[], ly_list=[0], sw=True):
        r"""set bone layers"""
        # 一旦レイヤー状態を保存
        saved_layers = [
            layer_bool for layer_bool in bpy.context.active_object.data.layers]
        # 表示
        for ly in range(0, 32):
            bpy.context.active_object.data.layers[ly] = True
        
        for pbn in pbn_list:
            for ly in ly_list:
                bpy.context.object.data.bones[pbn.name].layers[ly] = sw
        
        # 表示状態を復元して終わり
        for i, layer_bool in enumerate(saved_layers):
            bpy.context.active_object.data.layers[i] = layer_bool

    def execute(self, context):
        r""""""
        b_layers = [
            1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
            16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
        print("clear bone layer")
        # bones_data = bpy.context.active_object.data.bones
        # 0を設定
        self.clear_bone_layer(bpy.context.selected_pose_bones, [0], True)
        # クリア
        self.clear_bone_layer(bpy.context.selected_pose_bones, b_layers, False)
        bpy.ops.wm.redraw_timer(type='DRAW_WIN_SWAP', iterations=1)  # 再描画
        return {'FINISHED'}


classes = (
    SJSparkNatorProperties, SJSparkNator,
    SJSparkSelTree, SJSparkClearLayer)


# Register all operators and panels
def register():
    for cls in classes:
        bpy.utils.register_class(cls)

    bpy.types.Scene.sj_spark_nator_props = bpy.props.PointerProperty(
        type=SJSparkNatorProperties)


def unregister():
    for cls in classes:
        bpy.utils.unregister_class(cls)

    del bpy.types.Scene.sj_spark_nator_props


if __name__ == "__main__":
    register()
