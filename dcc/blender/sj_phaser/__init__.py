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
    "name": "SJ Phaser",
    "author": "CaptainHansode",
    "version": (0, 1, 0),
    "blender": (2, 80, 0),
    "location":  "View3D > Sidebar > Item Tab",
    "description": "Generate a phase animation.",
    "warning": "",
    "wiki_url": "",
    "tracker_url": "",
    "category": "Animation",
}


import bpy
from . import sj_phaser


class SJPhaserProperties(bpy.types.PropertyGroup):
    r"""カスタムプロパティを定義する"""
    # 描き方は:コロンで宣言
    # sf = bpy.context.scene.frame_start
    # ef = bpy.context.scene.frame_end
    sf = 0
    ef = 250

    start_frame: bpy.props.IntProperty(name="Start Frame", default=sf)
    end_frame: bpy.props.IntProperty(name="End Frame", default=ef)

    # ディレイ
    delay: bpy.props.FloatProperty(
        name="Delay", default=5.0, min=0.0, max=10.0)
    # 再帰
    recursion: bpy.props.FloatProperty(
        name="Recursion", default=5.0, min=0.0, max=10.0)
    # 継続性orパワー
    strength: bpy.props.FloatProperty(
        name="Strength", default=1.0, min=1.0, max=10.0)
    # Scalar power strength
    # 閾値
    threshold: bpy.props.FloatProperty(
        name="Threshold", default=1.0, min=0.01, max=10.0)


class SJPhaserFunction(bpy.types.Operator):
    r"""Gen phase animation"""
    bl_idname = "object.sj_phaser"
    bl_label = "Execute"
    bl_description = "Generate a phase animation."
    # sj_phaser_mod = SJPhaserModule()

    @classmethod
    def poll(cls, context):
        r""""""
        return context.active_object is not None

    def execute(self, context):
        r""""""
        sjps = context.scene.sj_phaser_props
        spsmod = sj_phaser.SJPhaserModule()

        sf = sjps.start_frame
        ef = sjps.end_frame
        spsmod.sf = sf
        spsmod.ef = ef

        # delay def=1 to -inf 感覚的に2で割ったほうがいい
        spsmod.delay = 1.0 + (sjps.delay / 2.0)
        # 再帰量 def=0 to max1.0
        spsmod.recursion = sjps.recursion / 10.0
        # persistencez(power) def=0 to max2.0 ベクトルの倍率 2倍以上要らない
        spsmod.power = 1.0
        spsmod.strength = 1.0 + ((sjps.strength - 1.0) / 10.0)

        spsmod.threshold = sjps.threshold / 1000.0

        if sf >= ef:
            return {'FINISHED'}
        # フレームセット
        bpy.context.scene.frame_set(sf)
        bpy.ops.wm.redraw_timer(type='DRAW_WIN_SWAP', iterations=1)
        # 実行するオブジェクトを回収する
        obj_trees = spsmod.get_tree_list()
        # キーフレームを削除する(初期フレームの値をセット)
        spsmod.del_animkey(obj_trees)

        obj_trees = spsmod.set_pre_data(obj_trees)  # 必要な初期matrixなど取得する
        spsmod.pahse(obj_trees)  # 実行

        bpy.ops.wm.redraw_timer(type='DRAW_WIN_SWAP', iterations=1)  # 再描画
        return {'FINISHED'}


class SJPhaser(bpy.types.Panel):
    r"""UI"""
    # https://docs.blender.org/api/current/bpy.types.Panel.html ui関連のdemo
    bl_label = "SJ Phaser"
    bl_space_type = 'VIEW_3D'
    bl_region_type = 'UI'  # UIのタイプは
    bl_context = "posemode"  # ポーズモード以外は使えない
    bl_category = 'Item'
    bl_options = {'DEFAULT_CLOSED'}  # デフォルトでは閉じている

    def draw(self, context):
        layout = self.layout
        scene = context.scene
        sjps = context.scene.sj_phaser_props

        # Create a simple row.
        layout.label(text="Frame")
        row = layout.row()
        row.prop(sjps, "start_frame")
        row.prop(sjps, "end_frame")

        layout.label(text="Properties")
        row = layout.row()
        row.prop(sjps, "delay")
        row.prop(sjps, "recursion")
        row.prop(sjps, "strength")
        row = layout.row()
        row.prop(sjps, "threshold")

        # Big render button
        layout.label(text="Execute")
        row = layout.row()
        row.scale_y = 1.8
        row.operator("object.sj_phaser")


classes = (
    SJPhaserProperties,
    SJPhaserFunction,
    SJPhaser
    )


# Register all operators and panels
def register():
    for cls in classes:
        bpy.utils.register_class(cls)

    # プロパティを追加する
    bpy.types.Scene.sj_phaser_props = bpy.props.PointerProperty(type=SJPhaserProperties)


def unregister():
    for cls in classes:
        bpy.utils.unregister_class(cls)

    # プロパティを削除
    del bpy.types.Scene.sj_phaser_props


if __name__ == "__main__":
    register()
