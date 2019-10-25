using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Runtime.InteropServices;


namespace SJSetWindowTopMost
{

    public partial class MainForm : Form
    {
        // public WindowInteropHelper(System.Windows.Window window);

        public MainForm()
        {
            InitializeComponent();
        }

        [DllImport("user32.dll", SetLastError = true)]
        [return: MarshalAs(UnmanagedType.Bool)]
        private static extern bool SetWindowPos(IntPtr hWnd, int hWndInsertAfter, int x, int y, int cx, int cy, int uFlags);

    // ウィンドウをアクティブにする
        public static void SetActiveWindow(IntPtr hWnd)
        {
            const int SWP_NOSIZE = 0x0001;
            const int SWP_NOMOVE = 0x0002;
            const int SWP_SHOWWINDOW = 0x0040;

            // const int HWND_TOPMOST = -1;
            // const int HWND_NOTOPMOST = -2;
            const int HWND_TOPMOST = -1;
            // const int HWND_NOTOPMOST = -2;

            SetWindowPos(hWnd, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE | SWP_NOSIZE);
            // SetWindowPos(hWnd, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_SHOWWINDOW | SWP_NOMOVE | SWP_NOSIZE);
        }

        public delegate bool EnumWindowsDelegate(IntPtr hWnd, IntPtr lparam);

        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        public extern static bool EnumWindows(EnumWindowsDelegate lpEnumFunc,
            IntPtr lparam);

        [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        private static extern int GetWindowText(IntPtr hWnd,
            StringBuilder lpString, int nMaxCount);

        [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        private static extern int GetWindowTextLength(IntPtr hWnd);

        [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        private static extern int GetClassName(IntPtr hWnd,
            StringBuilder lpClassName, int nMaxCount);

        // [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        // private static extern int Set
        // private static extern int GetWindowText(IntPtr hWnd, StringBuilder lpString, int nMaxCount);
        [DllImport("User32.Dll", EntryPoint = "SetWindowText")]
        public static extern void SetWindowText(IntPtr hwnd, StringBuilder text);

        private static bool EnumWindowCallBack(IntPtr hWnd, IntPtr lparam)
        {
            int cnt = 0;
            //ウィンドウのタイトルの長さを取得する

            int textLen = GetWindowTextLength(hWnd);
            if (0 < textLen)
            {
                //ウィンドウのタイトルを取得する
                StringBuilder tsb = new StringBuilder(textLen + 1);
                GetWindowText(hWnd, tsb, tsb.Capacity);

                //ウィンドウのクラス名を取得する
                StringBuilder csb = new StringBuilder(256);
                GetClassName(hWnd, csb, csb.Capacity);

                if (tsb.ToString().IndexOf("Blender") != -1)
                //if (tsb.ToString().IndexOf("32171920") != -1)
                {
                    StringBuilder newName = new StringBuilder("Blender" + cnt.ToString());
                    //結果を表示する
                    // MessageBox.Show("クラス名:" + csb.ToString());
                    //MessageBox.Show("クラス名:" + tsb.ToString());
                    // tsb

                    SetWindowText(hWnd, newName);

                    MessageBox.Show(hWnd.ToString());
                    // SetActiveWindow(hWnd);
                    cnt++;
                    return true;
                }

                // Console.WriteLine("クラス名:" + csb.ToString());
                // Console.WriteLine("タイトル:" + tsb.ToString());
            }

            //すべてのウィンドウを列挙する
            return true;
        }

        private void runButton_Click(object sender, EventArgs e)
        {
            //ウィンドウを列挙する
            EnumWindows(new EnumWindowsDelegate(EnumWindowCallBack), IntPtr.Zero);

            // MessageBox.Show(this.Handle.ToString());
            // IntPtr handle = this.Handle;
            // SetActiveWindow(handle);



            foreach (System.Diagnostics.Process p in System.Diagnostics.Process.GetProcesses())
            {
                //メインウィンドウのタイトルがある時だけ列挙する
                // MessageBox.Show(p.MainWindowTitle.Length.ToString());
                if (p.MainWindowTitle.Length == 0)
                {
                    continue;

                }
                // MessageBox.Show(p.ProcessName + "  " + p.MainWindowTitle);
                // MessageBox.Show(p.MainWindowTitle);
                // MessageBox.Show(p.ProcessName);
                // MessageBox.Show(p.MainWindowTitle);

                //MessageBox.Show(p.ProcessName.IndexOf("blender").ToString());
                //MessageBox.Show(p.ProcessName);

                if (p.ProcessName.IndexOf("blender") != -1)
                {
                    //MessageBox.Show(p.MainWindowTitle);
                    //p.MainWindowTitle = "Blender Main";
                    //MessageBox.Show(p.ProcessName);
                }
            }
            
        }
    }
}
