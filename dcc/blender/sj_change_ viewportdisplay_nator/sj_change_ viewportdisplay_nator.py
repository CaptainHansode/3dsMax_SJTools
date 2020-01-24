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
# Contributed to by CaptainHansode

bl_info = {
    "name": "SJ Change Viewport Disprlay Nator",
    "author": "CaptainHansode",
    "version": (1, 0, 0),
    "blender": (2, 80, 0),
    "location":  "View3D > Sidebar > Item Tab",
    "description": "Change viewport display on selection all.",
    "warning": "",
    "wiki_url": "",
    "tracker_url": "",
    "category": "Object",
}


import bpy
from bpy.app.handlers import persistent


@persistent
def selection_changes(scene):
    r"""selection change"""
    if len(bpy.context.selected_objects):
        print("selected :", bpy.context.selected_objects[0])


class SJChangeViewportDisprlayProperties(bpy.types.PropertyGroup):
    r"""カスタムプロパティを定義する"""
    # 描き方は:コロンで宣言
    name: bpy.props.BoolProperty(
        name="name", description="Name CheckBox", default=True)
    axis: bpy.props.BoolProperty(
        name="axis", description="axis CheckBox", default=True)
    wireframe: bpy.props.BoolProperty(
        name="wireframe", description="wireframe CheckBox", default=True)
    all_edges: bpy.props.BoolProperty(
        name="all_edges", description="all_edges CheckBox", default=True)
    tex_space: bpy.props.BoolProperty(
        name="tex_space", description="tex_space CheckBox", default=True)
    shadow: bpy.props.BoolProperty(
        name="shadow", description="shadow CheckBox", default=True)
    in_front: bpy.props.BoolProperty(
        name="in_front", description="in_front CheckBox", default=True)
    # disp_as: bpy.props.BoolProperty(
    #     name="disp_as", description="disp_as CheckBox", default=True)
    # color: bpy.props.BoolProperty(
    #     name="color", description="color CheckBox", default=True)
    bounds: bpy.props.BoolProperty(
        name="bounds", description="bounds CheckBox", default=True)


class SJDeleteKeyframeFunction(bpy.types.Operator):
    r"""Operatorで実行されるクラス、事前に登録しておく必要がある"""
    bl_idname = "object.sj_delete_keyframe_by_interval"
    bl_label = "Execute"
    bl_description = "sj_delete_keyframe_by_interval"

    @classmethod
    def poll(cls, context):
        r"""アクティブなオブジェクトがあるか？"""
        return context.active_object is not None

    def execute(self, context):
        r"""実際に実行される内容"""

        # UIで定義していたプロパティはこんな感じで拾う
        sjdk = context.scene.sj_del_keyframe_props

        if sjdk.start_frame > sjdk.end_frame:
            return {'FINISHED'}

        # リストを作成しておく
        flist = []
        for f in list(range(
                sjdk.start_frame, sjdk.end_frame, (sjdk.interval + 1))):
            flist.append(f)

        for f in range(sjdk.start_frame, sjdk.end_frame):
            if f in flist:
                continue

            for obj in bpy.context.selected_objects:
                if sjdk.pos is True:
                    obj.keyframe_delete(data_path="location", frame=f)
                if sjdk.rot is True:
                    obj.keyframe_delete(data_path="rotation_euler", frame=f)
                    obj.keyframe_delete(
                        data_path="rotation_quaternion", frame=f)
                if sjdk.scl is True:
                    obj.keyframe_delete(data_path="scale", frame=f)

            # ポーズモードであったら選択ボーンも処理する
            if bpy.context.object.mode != "POSE":
                continue
            for pbn in bpy.context.selected_pose_bones:
                if sjdk.pos is True:
                    pbn.keyframe_delete(data_path="location", frame=f)
                if sjdk.rot is True:
                    pbn.keyframe_delete(data_path="rotation_euler", frame=f)
                    pbn.keyframe_delete(data_path="rotation_quaternion", frame=f)
                if sjdk.scl is True:
                    pbn.keyframe_delete(data_path="scale", frame=f)
        # 再描画
        bpy.ops.wm.redraw_timer(type='DRAW_WIN_SWAP', iterations=1)
        return {'FINISHED'}


class SJDeleteKeyframeByInterval(bpy.types.Panel):
    r"""UI"""
    # https://docs.blender.org/api/current/bpy.types.Panel.html ui関連のdemo
    bl_label = "SJ Delete Keyframe By Interval"
    bl_space_type = 'VIEW_3D'
    bl_region_type = 'UI'  # UIのタイプは
    # どのモードでも出したい場合はcontextを指定しない
    # bl_context = "posemode"
    bl_category = 'Item'
    bl_options = {'DEFAULT_CLOSED'}  # デフォルトでは閉じている

    def draw(self, context):
        layout = self.layout
        scene = context.scene
        sjdk = context.scene.sj_del_keyframe_props

        # Create a simple row.
        layout.label(text="Frame Range:")
        row = layout.row()
        row.prop(sjdk, "start_frame")
        row.prop(sjdk, "end_frame")

        layout.label(text="Interval:")
        row = layout.row()
        row.prop(sjdk, "interval")

        layout.label(text="Types:")
        row = layout.row()
        row.prop(sjdk, "pos")
        row.prop(sjdk, "rot")
        row.prop(sjdk, "scl")

        # Big render button
        layout.label(text="Execute:")
        row = layout.row()
        row.scale_y = 1.8
        row.operator("object.sj_delete_keyframe_by_interval")


# event handler
# https://docs.blender.org/api/current/bpy.app.handlers.html

classes = (
    SJDelKeyProperties,
    SJDeleteKeyframeByInterval,
    SJDeleteKeyframeFunction
    )


# Register all operators and panels
def register():
    for cls in classes:
        bpy.utils.register_class(cls)

    # プロパティを追加する
    bpy.types.Scene.sj_del_keyframe_props = bpy.props.PointerProperty(type=SJDelKeyProperties)
    # ハンドラ登録
    bpy.app.handlers.depsgraph_update_post.append(selection_changes)


def unregister():
    for cls in classes:
        bpy.utils.unregister_class(cls)

    # プロパティを削除
    del bpy.types.Scene.sj_del_keyframe_props
    # コールバックを削除
    bpy.app.handlers.depsgraph_update_post.remove(selection_changes)


if __name__ == "__main__":
    register()
