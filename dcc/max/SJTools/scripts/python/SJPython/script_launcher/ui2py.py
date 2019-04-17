#pyside-uic.exe -o testUI.py testUI.ui
#pyside2-uic -o testUI.py testUI.ui


#python "C:\Program Files\Autodesk\3ds Max 2018\python\Lib\site-packages\pyside2uic" 
#"C:\Program Files\Autodesk\3ds Max 2018\3dsmaxpy.exe" pyside2-uic.exe -o testUI.py testUI.ui
# 3dsMax2018で変換する場合\checkers
from pyside2uic import compileUi

input_file = "D:\\sakai\\SJTools\\dcc\\max\\SJTools\\scripts\\python\\SJPython\\script_launcher\\tool_ui.ui"
output_file = "D:\\sakai\\SJTools\\dcc\\max\\SJTools\\scripts\\python\\SJPython\\script_launcher\\tool_ui.py"
uifile = open(output_file, 'w')
compileUi(input_file, uifile, False, 4, False)
uifile.close()
