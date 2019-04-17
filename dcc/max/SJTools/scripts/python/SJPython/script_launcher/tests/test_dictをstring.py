import collections
import json


def get_ui_dict_value(obj):
	r"""get dict data
	"""
	ret = obj.Object.ParameterBlock.UiDict.Value
	return json.loads(ret)


def set_ui_dict_value(obj, dict_data):
	r"""set dict data
	"""
	ret = obj.Object.ParameterBlock.UiDict.Value
	obj.Object.ParameterBlock.UiDict.Value = json.dumps(dict_data, indent=4)


def get_bt_dict():
	return {
		"obj_name": "",
		"name": "",
		"bt_text": "",
		"pos": [0, 0],
		"size": [0, 0],
		"icon": "",
		"bg_dolor": 0,
		"transparency": "",
		"style_sheet": "",
		"depth": 0,
		"tab_stop": 0,
		"select_obj": [],
		"scripts": "",
		"script_type": "ms"
	}


def get_def_dict():
	return {
		"posx": 100,
		"posx": 100,
		"width": 0,
		"height": 0,
		"maxsize": 150,
		"minsize": 150,
		"last_select": "",
		"bg_image": "",
		"sel_from_tree": True,
		"buttons": {}
	}

test_val = """
{
\"myDic\": True,
\"param\": False
}
"""
eval_val = eval(test_val)

obj = MaxPlus.SelectionManager.GetNodes()[0]
set_ui_dict_value(obj, eval_val)
ret = get_ui_dict_value(obj)
print(ret["myDic"])
print(ret["param"])

ret = get_bt_dict()
print(ret["pos"])

ret = get_def_dict()
print(ret["posx"])


"""

print(eval_val["myDic"])
print(eval_val["param"])

dum = json.dumps(eval_val, indent=4)
print(dum)
print(type(dum))
"""