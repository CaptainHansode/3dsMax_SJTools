#pyside-uic.exe -o testUI.py testUI.ui
#pyside2-uic -o testUI.py testUI.ui
#python "C:\Program Files\Autodesk\3ds Max 2018\python\Lib\site-packages\pyside2uic" 
#"C:\Program Files\Autodesk\3ds Max 2018\3dsmaxpy.exe" pyside2-uic.exe -o testUI.py testUI.ui

# 3dsMax2018で変換する場合
import os
from pyside2uic import compileUi

def conpile_ui_file():
	current_path = os.getcwd()
	input_file = os.path.join(current_path, "test_tools_ui.ui")
	output_file = os.path.join(current_path, "test_tools_ui.py")

	uifile = open(output_file, 'w')
	compileUi(input_file, uifile, False, 4, False)
	uifile.close()
	
if __name__ == '__main__':
	conpile_ui_file()