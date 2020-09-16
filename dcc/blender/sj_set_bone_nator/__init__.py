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
    "name": "SJ Set Bone Nator",
    "author": "CaptainHansode",
    "version": (1, 0, 0),
    "blender": (2, 80, 0),
    "location":  "View3D > Sidebar > Item Tab",
    "description": "Set bone props.",
    "warning": "",
    "wiki_url": "",
    "tracker_url": "",
    "category": "Rigging",
}


import bpy
import math
from bpy.app.handlers import persistent
# from . import sj_phaser


@persistent
def sj_set_bone_sel_amt_changes(scene):
    r"""selection changeのイベントハンドラ"""
    # ハンドラの範囲が多いので注意
    # if len(bpy.context.selected_objects) is 0:
    #     print("selection zero")
    #     return False
    # ret = bpy.context.active_object.data.bones
    obj = bpy.context.active_object
    if obj.type == "ARMATURE":
        print(ret)
    # sjcvp = bpy.context.scene.sj_change_viewdisp_props
    # obj = bpy.context.active_object
    # sjcvp.show_name = obj.show_name
    return True


def set_bone_group(self, context):
    r"""set bone group"""
    print("set bone group")
    if self.b_grp is "":
        grp = None
    else:
        grp = context.active_object.pose.bone_groups[self.b_grp]
    for pbn in context.selected_pose_bones:
        pbn.bone_group = grp


def set_bone_parent(self, context):
    r"""set bone group"""
    print("set bone group")
    if self.p_grp is "":
        p_bn = None
    else:
        p_bn = context.active_object.data.edit_bones[self.p_grp]
    for bn in context.active_object.data.edit_bones:
        if bn.select is True:
            bn.parent = p_bn


def set_bone_head(self, context):
    r"""bone tm"""
    for bn in context.active_object.data.edit_bones:
        if bn.select is True:
            bn.head = (self.head_x, self.head_y, self.head_z)


def set_bone_tail(self, context):
    r"""bone tm"""
    for bn in context.active_object.data.edit_bones:
        if bn.select is True:
            bn.tail = (self.tail_x, self.tail_y, self.tail_z)


def set_bone_roll(self, context):
    r"""bone tm"""
    for bn in context.active_object.data.edit_bones:
        if bn.select is True:
            bn.roll = math.radians(self.roll)


def set_bone_length(self, context):
    r"""bone tm"""
    for bn in context.active_object.data.edit_bones:
        if bn.select is True:
            bn.length = self.length


# def set_hide(self, context):
#     r"""set bone hide"""
#     print("set bone group")
#     for pbn in context.selected_pose_bones:
#         context.object.data.bones[pbn.name].hide = self.is_hide


def set_cs(self, context):
    r"""set bone custom shape"""
    if self.cs_obj is "":
        obj = None
    else:
        obj = bpy.data.objects[self.cs_obj]
    for pbn in context.selected_pose_bones:
        pbn.custom_shape = obj


def set_cs_scale(self, context):
    r"""set bone cs scale"""
    for pbn in context.selected_pose_bones:
        pbn.custom_shape_scale = self.cs_scale


def set_bone_size(self, context):
    r"""set bone cs b length"""
    for pbn in context.selected_pose_bones:
        pbn.use_custom_shape_bone_size = self.scl_b_size


def set_show_wire(self, context):
    r"""set bone show wire"""
    for pbn in context.selected_pose_bones:
        context.object.data.bones[pbn.name].show_wire = self.is_w_frame


class SJSetBoneName(bpy.types.Operator):
    r"""Ser Bone Name"""
    bl_idname = "object.sj_set_bone_nator"
    bl_label = "Set"
    bl_description = "Change selected bone name."

    @classmethod
    def poll(cls, context):
        r""""""
        return context.active_object is not None

    def execute(self, context):
        r""""""
        print("Set bone name.")
        sjsb = context.scene.sj_set_bone_nator_props
        cnt = sjsb.s_num

        for pbn in bpy.context.selected_pose_bones:
            new_name = sjsb.b_name
            cnt_str = str(cnt)
            if sjsb.numbering is True:
                while len(cnt_str) < sjsb.n_digit:  # 0 fill
                    cnt_str = "0{}".format(cnt_str)
                pbn.name = "{}{}".format(new_name, cnt_str)
            else:
                pbn.name = new_name
            cnt += 1

        bpy.ops.wm.redraw_timer(type='DRAW_WIN_SWAP', iterations=1)  # 再描画
        return {'FINISHED'}


class SJSelBoneTree(bpy.types.Operator):
    r""""""
    bl_idname = "object.sj_sel_bone_tree"
    bl_label = "Select Bone Tree"
    bl_description = "Select Bone Tree."

    @classmethod
    def poll(cls, context):
        r""""""
        return context.active_object is not None

    def _get_children(self, c_objs):
        r"""ツリーを再帰回収"""
        ret = []
        for obj in c_objs:
            ret.append(obj.name)
            if len(obj.children) is not 0:
                # 再帰
                ret.extend(self._get_children(obj.children))
        return ret

    def execute(self, context):
        r""""""
        # ポーズモードと編集モード2種類用意する
        if len(bpy.context.selected_pose_bones) is 0:
            return {'FINISHED'}
        
        sel_list = []
        
        for root_b in context.selected_pose_bones:
            sel_list.append(root_b.name)

            if len(root_b.children) is not 0:
                sel_list.extend(self._get_children(root_b.children))

        bpy.ops.pose.select_all(action='DESELECT')  # 選択解除

        for b_name in sel_list:  # 選択
            context.active_object.pose.bones[b_name].bone.select = True

        bpy.ops.wm.redraw_timer(type='DRAW_WIN_SWAP', iterations=1)  # 再描画
        return {'FINISHED'}


class SJSelBoneRotationMode(bpy.types.Operator):
    r""""""
    bl_idname = "object.sj_sel_bone_rot_mode"
    bl_label = "Set Bone Rotation Mode"
    bl_description = "Set Rotation Mode."

    @classmethod
    def poll(cls, context):
        r""""""
        return context.active_object is not None

    def execute(self, context):
        r""""""
        for pbn in context.selected_pose_bones:  # 選択
            context.active_object.pose.bones[pbn.name].rotation_mode = 'XYZ'

        bpy.ops.wm.redraw_timer(type='DRAW_WIN_SWAP', iterations=1)  # 再描画
        return {'FINISHED'}


class SJSetBoneNatorProperties(bpy.types.PropertyGroup):
    r"""カスタムプロパティを定義する"""
    # name
    b_name: bpy.props.StringProperty(name="Name", default="")
    numbering: bpy.props.BoolProperty(
        name="Numbering", description="Numbering CheckBox", default=False)
    s_num: bpy.props.IntProperty(name="Start Number", default=0)
    n_digit: bpy.props.IntProperty(
        name="Digit", min=1, max=8, default=3)

    b_grp: bpy.props.StringProperty(name="Bone Group", update=set_bone_group)

    # is_hide: bpy.props.BoolProperty(name="Hide", default=False, update=set_hide)
    cs_obj: bpy.props.StringProperty(name="Custom Shape", update=set_cs)
    cs_scale: bpy.props.FloatProperty(
        name="Scale", default=1.0, min=0.0, max=1000.0, update=set_cs_scale)
    scl_b_size: bpy.props.BoolProperty(
        name="Scale to Bone Length", default=False, update=set_bone_size)
    is_w_frame: bpy.props.BoolProperty(
        name="Wireframe", default=False, update=set_show_wire)

    # edit mode
    p_grp: bpy.props.StringProperty(name="Parent", update=set_bone_parent)

    head_x: bpy.props.FloatProperty(
        name="X", default=0.0, min=-10000.0, max=10000.0, update=set_bone_head)
    head_y: bpy.props.FloatProperty(        
        name="Y", default=0.0, min=-10000.0, max=10000.0, update=set_bone_head)
    head_z: bpy.props.FloatProperty(
        name="Z", default=0.0, min=-10000.0, max=10000.0, update=set_bone_head)

    tail_x: bpy.props.FloatProperty(
        name="X", default=0.0, min=-10000.0, max=10000.0, update=set_bone_tail)
    tail_y: bpy.props.FloatProperty(        
        name="Y", default=0.0, min=-10000.0, max=10000.0, update=set_bone_tail)
    tail_z: bpy.props.FloatProperty(
        name="Z", default=0.0, min=-10000.0, max=10000.0, update=set_bone_tail)

    roll: bpy.props.FloatProperty(name="Roll", update=set_bone_roll)
    length: bpy.props.FloatProperty(name="Length", update=set_bone_length)


class SJSetBoneNatorEditBnPanel(bpy.types.Panel):
    r"""UI"""
    bl_label = "SJ Set Bone Nator"
    bl_space_type = 'VIEW_3D'
    bl_region_type = 'UI'  # UIのタイプ
    bl_context = "armature_edit"  # ポーズモード以外は使えない

    # カスタムタブは名前を指定するだけで問題ない 他のツールのタブにも追加できる
    bl_category = 'Tool'
    # bl_category = 'SJTools'
    bl_options = {'DEFAULT_CLOSED'}  # デフォルトでは閉じている

    def draw(self, context):
        layout = self.layout
        sjsb = context.scene.sj_set_bone_nator_props

        layout.label(text="Transform")
        col = layout.column(align=True)
        col.prop(sjsb, "head_x")
        col.prop(sjsb, "head_y")
        col.prop(sjsb, "head_z")

        col = layout.column(align=True)
        col.prop(sjsb, "tail_x")
        col.prop(sjsb, "tail_y")
        col.prop(sjsb, "tail_z")

        col = layout.column(align=True)
        col.prop(sjsb, "roll")

        col = layout.column(align=True)
        col.prop(sjsb, "length")

        # layout = self.layout
        layout.label(text="Set Bone Parent")
        row = layout.row()
        row.prop_search(sjsb, "p_grp", context.active_object.data, "edit_bones")


        # layout.prop(sjsb, "is_hide")
    # amt = bpy.context.selected_objects[0]
    # # print(amt.data.edit_bones["c_jacketSusoAll"])
    # p = amt.data.edit_bones["c_jacketSusoAll"]
    # for b in amt.data.edit_bones:
    #     # b.layers[30] = False
    #     if b.select is True:
    #         # bpy.context.object.data.parent = bpy.data.armatures["rig"].(null)
    #         # print(b.parent)
    #         b.parent = p


class SJSetBoneNatorPanel(bpy.types.Panel):
    r"""UI"""
    bl_label = "SJ Set Bone Nator"
    bl_space_type = 'VIEW_3D'
    bl_region_type = 'UI'  # UIのタイプ
    bl_context = "posemode"  # ポーズモード以外は使えない

    # カスタムタブは名前を指定するだけで問題ない 他のツールのタブにも追加できる
    bl_category = 'Tool'
    # bl_category = 'SJTools'
    bl_options = {'DEFAULT_CLOSED'}  # デフォルトでは閉じている

    def draw(self, context):
        layout = self.layout
        scene = context.scene
        sjsb = context.scene.sj_set_bone_nator_props

        layout.label(text="Select Tree")
        row = layout.row()
        row.scale_y = 1.5
        row.operator("object.sj_sel_bone_tree")
        layout.separator(factor=2)

        layout.label(text="Set Bone Name")
        row = layout.row()
        row.prop(sjsb, "b_name")
        row = layout.row()
        row.prop(sjsb, "numbering")
        row.prop(sjsb, "s_num")
        row.prop(sjsb, "n_digit")
        row = layout.row()
        row.scale_y = 1.0
        row.operator("object.sj_set_bone_nator")
        layout.separator(factor=2)

        layout.label(text="Set Bone Layer")
        row = layout.row(align=True)
        row.operator("object.sj_set_bone_ly0")
        row.operator("object.sj_set_bone_ly1")
        row.operator("object.sj_set_bone_ly2")
        row.operator("object.sj_set_bone_ly3")
        row.operator("object.sj_set_bone_ly4")
        row.operator("object.sj_set_bone_ly5")
        row.operator("object.sj_set_bone_ly6")
        row.operator("object.sj_set_bone_ly7")
        row.separator(factor=3)
        row.operator("object.sj_set_bone_ly8")
        row.operator("object.sj_set_bone_ly9")
        row.operator("object.sj_set_bone_ly10")
        row.operator("object.sj_set_bone_ly11")
        row.operator("object.sj_set_bone_ly12")
        row.operator("object.sj_set_bone_ly13")
        row.operator("object.sj_set_bone_ly14")
        row.operator("object.sj_set_bone_ly15")
        row = layout.row(align=True)
        row.operator("object.sj_set_bone_ly16")
        row.operator("object.sj_set_bone_ly17")
        row.operator("object.sj_set_bone_ly18")
        row.operator("object.sj_set_bone_ly19")
        row.operator("object.sj_set_bone_ly20")
        row.operator("object.sj_set_bone_ly21")
        row.operator("object.sj_set_bone_ly22")
        row.operator("object.sj_set_bone_ly23")
        row.separator(factor=3)
        row.operator("object.sj_set_bone_ly24")
        row.operator("object.sj_set_bone_ly25")
        row.operator("object.sj_set_bone_ly26")
        row.operator("object.sj_set_bone_ly27")
        row.operator("object.sj_set_bone_ly28")
        row.operator("object.sj_set_bone_ly29")
        row.operator("object.sj_set_bone_ly30")
        row.operator("object.sj_set_bone_ly31")

        # トグル用 描き方が長くなるので却下
        # wm = context.window_manager
        # label = "Operator ON" if wm.sj_set_bone_ly0 else "Operator OFF"
        # row.prop(wm, 'sj_set_bone_ly0', text="0", toggle=True)
        row = layout.row()
        # row.operator("object.sj_set_bone_layer")
        row.operator("object.sj_set_bone_clear_layer")

        layout.separator(factor=2)

        layout.label(text="Set Bone Group")
        row = layout.row()
        row.prop_search(sjsb, "b_grp", context.active_object.pose, "bone_groups")
        # layout.prop(sjsb, "is_hide")

        layout.label(text="Set Bone Custom Shape")
        row = layout.row()
        row.prop_search(sjsb, "cs_obj", context.scene, "objects")
        layout.prop(sjsb, "cs_scale")
        layout.prop(sjsb, "scl_b_size")
        layout.prop(sjsb, "is_w_frame")

        layout.separator(factor=2)
        layout.label(text="Set Bone Rotation Mode")
        layout.operator("object.sj_sel_bone_rot_mode")


class SJSetBoneLy(object):
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


class SJSetBoneLy0(bpy.types.Operator):
    r"""Ser Bone Layer"""
    ly = 0
    bl_idname = "object.sj_set_bone_ly{}".format(ly)
    bl_label = str(ly)

    def execute(self, context):
        sbl = SJSetBoneLy(self.ly)
        del sbl
        return {'FINISHED'}


class SJSetBoneLy1(bpy.types.Operator):
    r"""Ser Bone Layer"""
    ly = 1
    bl_idname = "object.sj_set_bone_ly{}".format(ly)
    bl_label = str(ly)

    def execute(self, context):
        sbl = SJSetBoneLy(self.ly)
        del sbl
        return {'FINISHED'}


class SJSetBoneLy2(bpy.types.Operator):
    r"""Ser Bone Layer"""
    ly = 2
    bl_idname = "object.sj_set_bone_ly{}".format(ly)
    bl_label = str(ly)

    def execute(self, context):
        sbl = SJSetBoneLy(self.ly)
        del sbl
        return {'FINISHED'}


class SJSetBoneLy3(bpy.types.Operator):
    r"""Ser Bone Layer"""
    ly = 3
    bl_idname = "object.sj_set_bone_ly{}".format(ly)
    bl_label = str(ly)

    def execute(self, context):
        sbl = SJSetBoneLy(self.ly)
        del sbl
        return {'FINISHED'}


class SJSetBoneLy4(bpy.types.Operator):
    r"""Ser Bone Layer"""
    ly = 4
    bl_idname = "object.sj_set_bone_ly{}".format(ly)
    bl_label = str(ly)

    def execute(self, context):
        sbl = SJSetBoneLy(self.ly)
        del sbl
        return {'FINISHED'}


class SJSetBoneLy5(bpy.types.Operator):
    r"""Ser Bone Layer"""
    ly = 5
    bl_idname = "object.sj_set_bone_ly{}".format(ly)
    bl_label = str(ly)

    def execute(self, context):
        sbl = SJSetBoneLy(self.ly)
        del sbl
        return {'FINISHED'}


class SJSetBoneLy6(bpy.types.Operator):
    r"""Ser Bone Layer"""
    ly = 6
    bl_idname = "object.sj_set_bone_ly{}".format(ly)
    bl_label = str(ly)

    def execute(self, context):
        sbl = SJSetBoneLy(self.ly)
        del sbl
        return {'FINISHED'}


class SJSetBoneLy7(bpy.types.Operator):
    r"""Ser Bone Layer"""
    ly = 7
    bl_idname = "object.sj_set_bone_ly{}".format(ly)
    bl_label = str(ly)

    def execute(self, context):
        sbl = SJSetBoneLy(self.ly)
        del sbl
        return {'FINISHED'}


class SJSetBoneLy8(bpy.types.Operator):
    r"""Ser Bone Layer"""
    ly = 8
    bl_idname = "object.sj_set_bone_ly{}".format(ly)
    bl_label = str(ly)

    def execute(self, context):
        sbl = SJSetBoneLy(self.ly)
        del sbl
        return {'FINISHED'}


class SJSetBoneLy9(bpy.types.Operator):
    r"""Ser Bone Layer"""
    ly = 9
    bl_idname = "object.sj_set_bone_ly{}".format(ly)
    bl_label = str(ly)

    def execute(self, context):
        sbl = SJSetBoneLy(self.ly)
        del sbl
        return {'FINISHED'}


class SJSetBoneLy10(bpy.types.Operator):
    r"""Ser Bone Layer"""
    ly = 10
    bl_idname = "object.sj_set_bone_ly{}".format(ly)
    bl_label = str(ly)

    def execute(self, context):
        sbl = SJSetBoneLy(self.ly)
        del sbl
        return {'FINISHED'}


class SJSetBoneLy11(bpy.types.Operator):
    r"""Ser Bone Layer"""
    ly = 11
    bl_idname = "object.sj_set_bone_ly{}".format(ly)
    bl_label = str(ly)

    def execute(self, context):
        sbl = SJSetBoneLy(self.ly)
        del sbl
        return {'FINISHED'}


class SJSetBoneLy12(bpy.types.Operator):
    r"""Ser Bone Layer"""
    ly = 12
    bl_idname = "object.sj_set_bone_ly{}".format(ly)
    bl_label = str(ly)

    def execute(self, context):
        sbl = SJSetBoneLy(self.ly)
        del sbl
        return {'FINISHED'}


class SJSetBoneLy13(bpy.types.Operator):
    r"""Ser Bone Layer"""
    ly = 13
    bl_idname = "object.sj_set_bone_ly{}".format(ly)
    bl_label = str(ly)

    def execute(self, context):
        sbl = SJSetBoneLy(self.ly)
        del sbl
        return {'FINISHED'}


class SJSetBoneLy14(bpy.types.Operator):
    r"""Ser Bone Layer"""
    ly = 14
    bl_idname = "object.sj_set_bone_ly{}".format(ly)
    bl_label = str(ly)

    def execute(self, context):
        sbl = SJSetBoneLy(self.ly)
        del sbl
        return {'FINISHED'}


class SJSetBoneLy15(bpy.types.Operator):
    r"""Ser Bone Layer"""
    ly = 15
    bl_idname = "object.sj_set_bone_ly{}".format(ly)
    bl_label = str(ly)

    def execute(self, context):
        sbl = SJSetBoneLy(self.ly)
        del sbl
        return {'FINISHED'}


class SJSetBoneLy16(bpy.types.Operator):
    r"""Ser Bone Layer"""
    ly = 16
    bl_idname = "object.sj_set_bone_ly{}".format(ly)
    bl_label = str(ly)

    def execute(self, context):
        sbl = SJSetBoneLy(self.ly)
        del sbl
        return {'FINISHED'}


class SJSetBoneLy17(bpy.types.Operator):
    r"""Ser Bone Layer"""
    ly = 17
    bl_idname = "object.sj_set_bone_ly{}".format(ly)
    bl_label = str(ly)

    def execute(self, context):
        sbl = SJSetBoneLy(self.ly)
        del sbl
        return {'FINISHED'}


class SJSetBoneLy18(bpy.types.Operator):
    r"""Ser Bone Layer"""
    ly = 18
    bl_idname = "object.sj_set_bone_ly{}".format(ly)
    bl_label = str(ly)

    def execute(self, context):
        sbl = SJSetBoneLy(self.ly)
        del sbl
        return {'FINISHED'}


class SJSetBoneLy19(bpy.types.Operator):
    r"""Ser Bone Layer"""
    ly = 19
    bl_idname = "object.sj_set_bone_ly{}".format(ly)
    bl_label = str(ly)

    def execute(self, context):
        sbl = SJSetBoneLy(self.ly)
        del sbl
        return {'FINISHED'}


class SJSetBoneLy20(bpy.types.Operator):
    r"""Ser Bone Layer"""
    ly = 20
    bl_idname = "object.sj_set_bone_ly{}".format(ly)
    bl_label = str(ly)

    def execute(self, context):
        sbl = SJSetBoneLy(self.ly)
        del sbl
        return {'FINISHED'}


class SJSetBoneLy21(bpy.types.Operator):
    r"""Ser Bone Layer"""
    ly = 21
    bl_idname = "object.sj_set_bone_ly{}".format(ly)
    bl_label = str(ly)

    def execute(self, context):
        sbl = SJSetBoneLy(self.ly)
        del sbl
        return {'FINISHED'}


class SJSetBoneLy22(bpy.types.Operator):
    r"""Ser Bone Layer"""
    ly = 22
    bl_idname = "object.sj_set_bone_ly{}".format(ly)
    bl_label = str(ly)

    def execute(self, context):
        sbl = SJSetBoneLy(self.ly)
        del sbl
        return {'FINISHED'}


class SJSetBoneLy23(bpy.types.Operator):
    r"""Ser Bone Layer"""
    ly = 23
    bl_idname = "object.sj_set_bone_ly{}".format(ly)
    bl_label = str(ly)

    def execute(self, context):
        sbl = SJSetBoneLy(self.ly)
        del sbl
        return {'FINISHED'}


class SJSetBoneLy24(bpy.types.Operator):
    r"""Ser Bone Layer"""
    ly = 24
    bl_idname = "object.sj_set_bone_ly{}".format(ly)
    bl_label = str(ly)

    def execute(self, context):
        sbl = SJSetBoneLy(self.ly)
        del sbl
        return {'FINISHED'}


class SJSetBoneLy25(bpy.types.Operator):
    r"""Ser Bone Layer"""
    ly = 25
    bl_idname = "object.sj_set_bone_ly{}".format(ly)
    bl_label = str(ly)

    def execute(self, context):
        sbl = SJSetBoneLy(self.ly)
        del sbl
        return {'FINISHED'}


class SJSetBoneLy26(bpy.types.Operator):
    r"""Ser Bone Layer"""
    ly = 26
    bl_idname = "object.sj_set_bone_ly{}".format(ly)
    bl_label = str(ly)

    def execute(self, context):
        sbl = SJSetBoneLy(self.ly)
        del sbl
        return {'FINISHED'}


class SJSetBoneLy27(bpy.types.Operator):
    r"""Ser Bone Layer"""
    ly = 27
    bl_idname = "object.sj_set_bone_ly{}".format(ly)
    bl_label = str(ly)

    def execute(self, context):
        sbl = SJSetBoneLy(self.ly)
        del sbl
        return {'FINISHED'}


class SJSetBoneLy28(bpy.types.Operator):
    r"""Ser Bone Layer"""
    ly = 28
    bl_idname = "object.sj_set_bone_ly{}".format(ly)
    bl_label = str(ly)

    def execute(self, context):
        sbl = SJSetBoneLy(self.ly)
        del sbl
        return {'FINISHED'}


class SJSetBoneLy29(bpy.types.Operator):
    r"""Ser Bone Layer"""
    ly = 29
    bl_idname = "object.sj_set_bone_ly{}".format(ly)
    bl_label = str(ly)

    def execute(self, context):
        sbl = SJSetBoneLy(self.ly)
        del sbl
        return {'FINISHED'}


class SJSetBoneLy30(bpy.types.Operator):
    r"""Ser Bone Layer"""
    ly = 30
    bl_idname = "object.sj_set_bone_ly{}".format(ly)
    bl_label = str(ly)

    def execute(self, context):
        sbl = SJSetBoneLy(self.ly)
        del sbl
        return {'FINISHED'}


class SJSetBoneLy31(bpy.types.Operator):
    r"""Ser Bone Layer"""
    ly = 31
    bl_idname = "object.sj_set_bone_ly{}".format(ly)
    bl_label = str(ly)

    def execute(self, context):
        sbl = SJSetBoneLy(self.ly)
        del sbl
        return {'FINISHED'}


class SJSetBoneClearLayer(bpy.types.Operator):
    r"""Ser Bone Clear Layer"""
    bl_idname = "object.sj_set_bone_clear_layer"
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



# pose.bones["hair.066"].use_custom_shape_bone_size

# class ToggledModalOperator(bpy.types.Operator):
#     r"""トグルボタン用"""
#     bl_idname = "object.sj_set_bone_ly"
#     bl_label = "0"

#     def modal(self, context, event):
#         print("running")
#         if not context.window_manager.sj_set_bone_ly:
#             context.window_manager.event_timer_remove(self._timer)
#             return {'FINISHED'}
#         return {'PASS_THROUGH'}

#     def invoke(self, context, event):
#         self._timer = context.window_manager.event_timer_add(0.01, context.window)
#         context.window_manager.modal_handler_add(self)
#         return {'RUNNING_MODAL'}


# def update_function(self, context):
#     r"""トグルのアップデート用"""
#     if self.sj_set_bone_ly:
#         bpy.ops.object.sj_set_bone_ly('INVOKE_DEFAULT')
#     return


classes = (
    SJSetBoneNatorProperties, SJSelBoneTree,
    SJSetBoneNatorPanel,
    SJSetBoneNatorEditBnPanel,
    SJSetBoneName, SJSelBoneRotationMode,
    SJSetBoneLy0, SJSetBoneLy1, SJSetBoneLy2, SJSetBoneLy3, SJSetBoneLy4,
    SJSetBoneLy5, SJSetBoneLy6, SJSetBoneLy7, SJSetBoneLy8, SJSetBoneLy9,
    SJSetBoneLy10, SJSetBoneLy11, SJSetBoneLy12, SJSetBoneLy13, SJSetBoneLy14,
    SJSetBoneLy15, SJSetBoneLy16, SJSetBoneLy17, SJSetBoneLy18, SJSetBoneLy19,
    SJSetBoneLy20, SJSetBoneLy21, SJSetBoneLy22, SJSetBoneLy23, SJSetBoneLy24,
    SJSetBoneLy25, SJSetBoneLy26, SJSetBoneLy27, SJSetBoneLy28, SJSetBoneLy29,
    SJSetBoneLy30, SJSetBoneLy31, SJSetBoneClearLayer
    # ToggledModalOperator
    )


# Register all operators and panels
def register():
    for cls in classes:
        bpy.utils.register_class(cls)

    # プロパティを追加する
    bpy.types.Scene.sj_set_bone_nator_props = bpy.props.PointerProperty(type=SJSetBoneNatorProperties)
    # ハンドラ登録 depsgraphはイベントの範囲が広いので注意
    # bpy.app.handlers.depsgraph_update_post.append(sj_set_bone_sel_amt_changes)
    # トグル用
    # bpy.types.WindowManager.sj_set_bone_ly0 = bpy.props.BoolProperty(
    #     default=False, update=update_function)


def unregister():
    for cls in classes:
        bpy.utils.unregister_class(cls)

    # プロパティを削除
    del bpy.types.Scene.sj_set_bone_nator_props
    # コールバックを削除
    # bpy.app.handlers.depsgraph_update_post.remove(sj_set_bone_sel_amt_changes)
    # トグル用
    # del bpy.types.WindowManager.sj_set_bone_ly0


if __name__ == "__main__":
    register()
