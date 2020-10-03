import bpy


def exclusion_vg(obj, n_list):
    # obj = bpy.context.active_object
    cnt = len(obj.vertex_groups) - 1
    while cnt >= 0:
        vg = obj.vertex_groups[cnt]
        if vg.name not in n_list:
            obj.vertex_groups.active_index = cnt
            bpy.ops.object.vertex_group_remove()
        cnt = cnt - 1


def crean_vg(obj):
    mesh = obj.data
    verts = [v for v in mesh.vertices]
    in_use_vg = {}
    for v in verts:
        for g in v.groups:
            in_use_vg[obj.vertex_groups[g.group].name] = True
    exclusion_vg(obj, in_use_vg.keys())
    return None


crean_vg(bpy.context.active_object)