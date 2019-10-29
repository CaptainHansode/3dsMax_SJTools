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
using System.Collections;

namespace SJWindowPin
{

    public partial class MainForm : Form
    {
        public MainForm()
        {
            InitializeComponent();
            SetWinList();  // 初回設定  
        }

        [DllImport("user32.dll", SetLastError = true)]
        [return: MarshalAs(UnmanagedType.Bool)]
        private static extern bool SetWindowPos(IntPtr hWnd, int hWndInsertAfter, int x, int y, int cx, int cy, int uFlags);

        /// <summary>
        /// アクティブ化
        /// </summary>
        /// <param name="hWnd"></param>
        public static void SetActiveWindow(IntPtr hWnd)
        {
            const int SWP_NOSIZE = 0x0001;
            const int SWP_NOMOVE = 0x0002;
            const int SWP_SHOWWINDOW = 0x0040;

            const int HWND_TOPMOST = -1;
            // const int HWND_NOTOPMOST = -2;
            SetWindowPos(hWnd, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE | SWP_NOSIZE);
            // SetWindowPos(hWnd, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_SHOWWINDOW | SWP_NOMOVE | SWP_NOSIZE);
        }

        /// <summary>
        /// TopMostを設定
        /// </summary>
        /// <param name="hWnd"></param>
        /// <param name="hwnd_topmost"></param>
        public static void SetTopMostWindow(IntPtr hWnd, int hwnd_topmost=1)
        {
            const int SWP_NOSIZE = 0x0001;
            const int SWP_NOMOVE = 0x0002;
            const int SWP_SHOWWINDOW = 0x0040;
            int HWND_TOPMOST = hwnd_topmost;
            SetWindowPos(hWnd, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE | SWP_NOSIZE);
        }

        /// <summary>
        /// ウィンドウテキスト書き換え
        /// </summary>
        /// <param name="hwnd"></param>
        /// <param name="text"></param>
        [DllImport("User32.Dll", EntryPoint = "SetWindowText")]
        public static extern void SetWindowText(IntPtr hwnd, StringBuilder text);


        /// <summary>
        /// 取得関連
        /// </summary>

        public delegate bool EnumWindowsDelegate(IntPtr hWnd, IntPtr lparam);

        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        public extern static bool EnumWindows(EnumWindowsDelegate lpEnumFunc, IntPtr lparam);

        [DllImport("user32")]
        private static extern bool IsWindowVisible(IntPtr hWnd);

        [DllImport("user32")]
        private static extern int GetWindowThreadProcessId(IntPtr hWnd, out int lpdwProcessId);

        [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        private static extern int GetWindowText(IntPtr hWnd, StringBuilder lpString, int nMaxCount);

        [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        private static extern int GetWindowTextLength(IntPtr hWnd);

        [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        private static extern int GetClassName(IntPtr hWnd, StringBuilder lpClassName, int nMaxCount);

        [DllImport("user32.dll")]
        public static extern IntPtr GetForegroundWindow();

        /// <summary>
        /// ウィンドウサイズ取得
        /// </summary>

        [DllImport("user32.dll")]
        private static extern bool GetWindowRect(IntPtr hwnd, out RECT lpRect);

        [StructLayout(LayoutKind.Sequential)]
        private struct RECT
        {
            public int left;
            public int top;
            public int right;
            public int bottom;
        }

        public bool EnumWindowCallBack(IntPtr hWnd, IntPtr lparam)
        {
            //ウィンドウのタイトルの長さを取得する
            int textLen = GetWindowTextLength(hWnd);
            if (0 >= textLen)
            {
                return true;
            }

            if (IsWindowVisible(hWnd) == false)
            {
                return true;
            }

            //ウィンドウのタイトルを取得する
            StringBuilder tsb = new StringBuilder(textLen + 1);
            GetWindowText(hWnd, tsb, tsb.Capacity);

            if (tsb.ToString().IndexOf("SJWindowPin") != -1)
            {
                return true;
            }

            //ウィンドウのクラス名を取得する
            //StringBuilder csb = new StringBuilder(256);
            //GetClassName(hWnd, csb, csb.Capacity);

            ListViewItem item = new ListViewItem(tsb.ToString());
            item.SubItems.Add(hWnd.ToString());
            item.ImageIndex = 0;  // アイコン
            this.winListView.Items.Add(item);
            this.winListView.AutoResizeColumns(ColumnHeaderAutoResizeStyle.HeaderSize);

            //すべてのウィンドウを列挙するにはtrueを変える
            return true;
        }

        public void SetWinList()
        {
            this.titleEditBox.Text = "";
            this.winListView.View = View.Details;
            this.winListView.Clear();
            this.winListView.Columns.Add("WindowName");
            this.winListView.Columns.Add("Handle");

            //ウィンドウを列挙する https://smdn.jp/programming/tips/enumwindows/
            EnumWindows(new EnumWindowsDelegate(EnumWindowCallBack), IntPtr.Zero);
        }

        private void runButton_Click(object sender, EventArgs e)
        {
            ResetTopMostWindow();
            SetWinList();
        }

        private void winListView_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (this.winListView.SelectedItems.Count == 0)
            {
                return;
            }
            ListViewItem itm = new ListViewItem();
            itm = this.winListView.SelectedItems[0];
            this.titleEditBox.Text = itm.Text;
        }

        private void winListView_DoubleClick(object sender, EventArgs e)
        {
            ListViewItem itm = new ListViewItem();
            itm = this.winListView.SelectedItems[0];

            if (itm.ImageIndex == 0)
            {
                itm.ImageIndex = 1;
                IntPtr hWnd = new IntPtr(int.Parse(itm.SubItems[1].Text));
                SetTopMostWindow(hWnd, -1);
            }
            else
            {
                itm.ImageIndex = 0;
                IntPtr hWnd = new IntPtr(int.Parse(itm.SubItems[1].Text));
                SetTopMostWindow(hWnd, -2);
            }

        }

        /// <summary>
        /// ListViewの項目の並び替えに使用するクラス
        /// </summary>
        public class ListViewItemComparer : IComparer
        {
            private int _column;

            /// <summary>
            /// ListViewItemComparerクラスのコンストラクタ
            /// </summary>
            /// <param name="col">並び替える列番号</param>
            public ListViewItemComparer(int col)
            {
                _column = col;
            }

            //xがyより小さいときはマイナスの数、大きいときはプラスの数、
            //同じときは0を返す
            public int Compare(object x, object y)
            {
                //ListViewItemの取得
                ListViewItem itemx = (ListViewItem)x;
                ListViewItem itemy = (ListViewItem)y;

                //xとyを文字列として比較する
                return string.Compare(itemx.SubItems[_column].Text,
                    itemy.SubItems[_column].Text);
            }
        }

        private void winListView_ColumnClick(object sender, ColumnClickEventArgs e)
        {
            //ListViewItemSorterを指定する
            this.winListView.ListViewItemSorter = new ListViewItemComparer(e.Column);
        }

        public void ResetTopMostWindow()
        {
            foreach (ListViewItem itm in this.winListView.Items)
            {
                if (itm.ImageIndex == 0)
                {
                    continue;
                }
                itm.ImageIndex = 0;
                IntPtr hWnd = new IntPtr(int.Parse(itm.SubItems[1].Text));
                SetTopMostWindow(hWnd, -2);
            }
        }

        private void renameButton_Click(object sender, EventArgs e)
        {
            if (this.winListView.SelectedItems.Count == 0)
            {
                return;
            }
            ListViewItem itm = new ListViewItem();
            itm = this.winListView.SelectedItems[0];
            itm.Text = this.titleEditBox.Text;
            StringBuilder newName = new StringBuilder(this.titleEditBox.Text);
            IntPtr hWnd = new IntPtr(int.Parse(itm.SubItems[1].Text));
            SetWindowText(hWnd, newName);
        }

        private void MainForm_FormClosed(object sender, FormClosedEventArgs e)
        {

        }

        private void MainForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            ResetTopMostWindow();
            if (this.Left >= 0)
            {
                Properties.Settings.Default.PosX = this.Left;
            }
            if (this.Top >= 0)
            {
                Properties.Settings.Default.PosY = this.Top;
            }
            if (this.Height >= 0)
            {
                Properties.Settings.Default.Height = this.Height;
            }
            if (this.Width >= 0)
            {
                Properties.Settings.Default.Width = this.Width;
            }
            Properties.Settings.Default.Save();
        }

        private void MainForm_Load(object sender, EventArgs e)
        {
            this.Left = Properties.Settings.Default.PosX;
            this.Top = Properties.Settings.Default.PosY;
            this.Height = Properties.Settings.Default.Height;
            this.Width = Properties.Settings.Default.Width;
        }

        private void winListView_DrawColumnHeader(object sender, DrawListViewColumnHeaderEventArgs e)
        {
        }
    }
}
