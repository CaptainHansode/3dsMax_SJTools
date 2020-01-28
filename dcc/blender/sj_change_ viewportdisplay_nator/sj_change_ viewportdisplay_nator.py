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
    r"""selection changeのイベントハンドラ"""
    # ハンドラの範囲が多いので注意
    if len(bpy.context.selected_objects) is 0:
        print("selection zero")
        return False
    sjcvp = bpy.context.scene.sj_change_viewdisp_props
    obj = bpy.context.active_object
    sjcvp.show_name = obj.show_name
    sjcvp.show_axis = obj.show_axis
    sjcvp.show_wire = obj.show_wire
    sjcvp.show_all_edges = obj.show_all_edges
    sjcvp.show_texture_space = obj.show_texture_space
    sjcvp.show_shadows = obj.display.show_shadows
    sjcvp.show_in_front = obj.show_in_front
    sjcvp.display_type = obj.display_type
    sjcvp.disp_color = (obj.color[0], obj.color[1], obj.color[2])

    sjcvp.show_bounds = obj.show_bounds
    sjcvp.display_bounds_type = obj.display_bounds_type
    return True


def update_func(self, context):
    r"""test func"""
    print("my test function", self)
    print(self.show_name)
    for obj in bpy.context.selected_objects:
        obj.show_name = self.show_name


def set_show_name(self, context):
    r"""set show_name"""
    for obj in bpy.context.selected_objects:
        obj.show_name = self.show_name


def set_show_axis(self, context):
    r"""set show_axis"""
    for obj in bpy.context.selected_objects:
        obj.show_axis = self.show_axis


def set_show_wire(self, context):
    r"""set show_wire"""
    for obj in bpy.context.selected_objects:
        obj.show_wire = self.show_wire


def set_show_all_edges(self, context):
    r"""set show_all_edges"""
    for obj in bpy.context.selected_objects:
        obj.show_all_edges = self.show_all_edges


def set_show_texture_space(self, context):
    r"""set show_name"""
    for obj in bpy.context.selected_objects:
        obj.show_texture_space = self.show_texture_space


def set_show_shadows(self, context):
    r"""set show_shadows"""
    for obj in bpy.context.selected_objects:
        obj.display.show_shadows = self.show_shadows


def set_show_in_front(self, context):
    r"""set show_in_front"""
    for obj in bpy.context.selected_objects:
        obj.show_in_front = self.show_in_front


def set_disp_color(self, context):
    r"""set disp_color"""
    # RGBAではないので、アルファ値を加える
    col = (self.disp_color.r, self.disp_color.g, self.disp_color.b, 1.0)
    for obj in bpy.context.selected_objects:
        obj.color = col


def set_display_type(self, context):
    r"""set display_type"""
    for obj in bpy.context.selected_objects:
        obj.display_type = self.display_type


def set_show_bounds(self, context):
    r"""set show_bounds"""
    for obj in bpy.context.selected_objects:
        obj.show_bounds = self.show_bounds


def show_display_bounds_type(self, context):
    r"""set show_name"""
    for obj in bpy.context.selected_objects:
        obj.display_bounds_type = self.display_bounds_type


class SJChangeViewportDspProperties(bpy.types.PropertyGroup):
    r"""カスタムプロパティを定義する"""
    show_name: bpy.props.BoolProperty(
        name="Name", description="Name CheckBox", default=False, update=set_show_name)
    show_axis: bpy.props.BoolProperty(
        name="Axis", description="axis CheckBox", default=False, update=set_show_axis)
    show_wire: bpy.props.BoolProperty(
        name="Wireframe", description="wireframe CheckBox", default=False, update=set_show_wire)
    show_all_edges: bpy.props.BoolProperty(
        name="All Edges", description="all_edges CheckBox", default=False, update=set_show_all_edges)
    show_texture_space: bpy.props.BoolProperty(
        name="Texture Space", description="tex_space CheckBox", default=False, update=set_show_texture_space)
    show_shadows: bpy.props.BoolProperty(
        name="Shadow", description="shadow CheckBox", default=False, update=set_show_shadows)
    show_in_front: bpy.props.BoolProperty(
        name="In Front", description="in_front CheckBox", default=False, update=set_show_in_front)

    disp_color: bpy.props.FloatVectorProperty(
        name="Color",
        subtype='COLOR',
        default=(1.0, 1.0, 1.0),
        min=0.0, max=1.0,
        description="color picker",
        update=set_disp_color
        )

    display_type: bpy.props.EnumProperty(
        items=[
            ("BOUNDS", "Bounds", ""),
            ("WIRE", "Wire", ""),
            ("SOLID", "Solid", ""),
            ("TEXTURED", "Textured", ""),
        ],
        name="Display As",
        default="BOUNDS",
        update=set_display_type
    )

    show_bounds: bpy.props.BoolProperty(
        name="Bounds", description="bounds CheckBox", default=False, update=set_show_bounds)

    display_bounds_type: bpy.props.EnumProperty(
        items=[
            ("CAPSULE", "Capsule", ""),
            ("CONE", "Cone", ""),
            ("CYLINDER", "Cylinder", ""),
            ("SPHERE", "Sphere", ""),
            ("BOX", "Box", ""),
        ],
        name="Display Bounds Type",
        default="CAPSULE",
        update=show_display_bounds_type
    )


class SJChangeViewportDspFunction(bpy.types.Operator):
    r"""Operatorで実行されるクラス、事前に登録しておく必要がある"""
    bl_idname = "object.sj_change_viewportdisplay_function"
    bl_label = "Execute"
    bl_description = "sj_change_viewportdisplay_function"

    @classmethod
    def poll(cls, context):
        return context.active_object is not None

    def execute(self, context):
        r"""実際に実行される内容"""
        # 再描画
        bpy.ops.wm.redraw_timer(type='DRAW_WIN_SWAP', iterations=1)
        return {'FINISHED'}


class SJChangeViewportDspNator(bpy.types.Panel):
    r"""UI"""
    bl_label = "SJ Change Viewport Display Nator"
    bl_space_type = 'VIEW_3D'
    bl_region_type = 'UI'
    # bl_context = "posemode"  # どのモードでも出したい場合はcontextを指定しない
    bl_category = 'Item'
    bl_options = {'DEFAULT_CLOSED'}

    def draw(self, context):
        r"""ここではオブジェクトへの書き込みができない？"""
        layout = self.layout
        sjcvp = context.scene.sj_change_viewdisp_props

        row = layout.row()
        row.prop(sjcvp, "show_name")
        row.prop(sjcvp, "show_axis")
        row.prop(sjcvp, "show_wire")
        row = layout.row()
        row.prop(sjcvp, "show_all_edges")
        row.prop(sjcvp, "show_texture_space")
        row.prop(sjcvp, "show_shadows")
        row = layout.row()
        row.prop(sjcvp, "show_in_front")
        row = layout.row()
        row.prop(sjcvp, "display_type")
        row = layout.row()
        row.prop(sjcvp, "disp_color")
        row = layout.row()
        row.prop(sjcvp, "show_bounds")
        row.prop(sjcvp, "display_bounds_type")

        # row.operator("object.sj_change_viewportdisplay_function")


classes = (
    SJChangeViewportDspProperties,
    SJChangeViewportDspFunction,
    SJChangeViewportDspNator
    )


# Register all operators and panels
def register():
    for cls in classes:
        bpy.utils.register_class(cls)
    # プロパティを追加する
    bpy.types.Scene.sj_change_viewdisp_props = bpy.props.PointerProperty(type=SJChangeViewportDspProperties)
    # ハンドラ登録 depsgraphはイベントの範囲が広いので注意
    # bpy.app.handlers.depsgraph_update_post.append(selection_changes)


def unregister():
    for cls in classes:
        bpy.utils.unregister_class(cls)
    # プロパティを削除
    del bpy.types.Scene.sj_change_viewdisp_props
    # コールバックを削除
    # bpy.app.handlers.depsgraph_update_post.remove(selection_changes)


if __name__ == "__main__":
    register()
