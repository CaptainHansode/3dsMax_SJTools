using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Drawing.Imaging;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.IO;
using System.Diagnostics;
using System.Runtime.InteropServices;


namespace SJPhotoCollect
{
    public partial class MainForm : Form
    {
        Dictionary<String, bool> imgTypes = new Dictionary<String, bool>();

        /// <summary>
        /// ファイル情報を取得
        /// </summary>
        /// <param name="pszPath"></param>
        /// <param name="dwFileAttributes"></param>
        /// <param name="psfi"></param>
        /// <param name="cbFileInfo"></param>
        /// <param name="uFlags"></param>
        /// <returns></returns>
        [DllImport("shell32.dll", CharSet = CharSet.Auto)]
        private static extern IntPtr SHGetFileInfo(string pszPath, uint dwFileAttributes, out SHFILEINFO psfi, uint cbFileInfo, uint uFlags);

        /// <summary>
        /// イメージリストを登録
        /// </summary>
        /// <param name="hWnd"></param>
        /// <param name="Msg"></param>
        /// <param name="wParam"></param>
        /// <param name="lParam"></param>
        /// <returns></returns>
        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        private static extern IntPtr SendMessage(IntPtr hWnd, uint Msg, IntPtr wParam, IntPtr lParam);

        /// <summary>
        /// SHGetFileInfo関数で使用する構造体
        /// </summary>
        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Auto)]
        private struct SHFILEINFO
        {
            public IntPtr hIcon;
            public int iIcon;
            public uint dwAttributes;
            [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 260)]
            public string szDisplayName;
            [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 80)]
            public string szTypeName;
        };

        // ファイル情報用
        private const int SHGFI_LARGEICON = 0x00000000;
        private const int SHGFI_SMALLICON = 0x00000001;
        private const int SHGFI_USEFILEATTRIBUTES = 0x00000010;
        private const int SHGFI_OVERLAYINDEX = 0x00000040;
        private const int SHGFI_ICON = 0x00000100;
        private const int SHGFI_SYSICONINDEX = 0x00004000;
        private const int SHGFI_TYPENAME = 0x000000400;

        // TreeView用
        private const int TVSIL_NORMAL = 0x0000;
        private const int TVSIL_STATE = 0x0002;
        private const int TVM_SETIMAGELIST = 0x1109;

        // ListView用
        private const int LVSIL_NORMAL = 0;
        private const int LVSIL_SMALL = 1;
        private const int LVM_SETIMAGELIST = 0x1003;

        // 選択された項目を保持
        private String selectedItem = "";

        public MainForm()
        {
            InitializeComponent();
            setImgTypes();
            // イメージリストの設定
            SHFILEINFO shFileInfo = new SHFILEINFO();
            IntPtr imageListHandle = SHGetFileInfo(String.Empty, 0, out shFileInfo, (uint)Marshal.SizeOf(shFileInfo), SHGFI_SMALLICON | SHGFI_SYSICONINDEX);
            // ListView
            SendMessage(this.leftListView.Handle, LVM_SETIMAGELIST, new IntPtr(LVSIL_SMALL), imageListHandle);
            SendMessage(this.rightListView.Handle, LVM_SETIMAGELIST, new IntPtr(LVSIL_SMALL), imageListHandle);

            this.leftPBox.Parent = this.pictureBox;
            this.rightPBox.Parent = this.pictureBox;
            this.copyPBox.Parent = this.pictureBox;

            System.Reflection.Assembly asm = System.Reflection.Assembly.GetExecutingAssembly();
            //バージョンの取得
            this.Text = String.Format("{0} Ver.{1}", this.Text, asm.GetName().Version);
        }

        private void setImgTypes()
        {
            imgTypes.Add(".jpg", true);
            imgTypes.Add(".png", true);
            imgTypes.Add(".gif", true);
            imgTypes.Add(".bmp", true);
            imgTypes.Add(".tif", true);
            // imgTypes.Add(".raw", true);
            // imgTypes.Add(".psd", true);
            // imgTypes.Add(".tga", true);
        }

        private void setImage(String imgPaht)
        {
            if (File.Exists(imgPaht) == false)
            {
                return;
            }
            // Image img = 
            Image oldImage = this.pictureBox.Image;
            this.pictureBox.Image = Image.FromFile(imgPaht); // UI用の画像
            oldImage.Dispose();
            // this.imgPanel.BackgroundImage = img;
            // img.Dispose();
        }

        private void setDefPath()
        {
            String deskTopPath = Environment.GetFolderPath(Environment.SpecialFolder.DesktopDirectory);
            String lPath = Properties.Settings.Default.leftPath;
            String rPath = Properties.Settings.Default.rightPath;
            this.leftTextBox.Text = deskTopPath;
            this.rightTextBox.Text = deskTopPath;
            if (Directory.Exists(lPath))
            {
                this.leftTextBox.Text = lPath;
            }
            if (Directory.Exists(rPath))
            {
                this.rightTextBox.Text = rPath;
            }
            setList(this.leftTextBox.Text, this.leftListView);
            setList(this.rightTextBox.Text, this.rightListView);
        }

        /// <summary>
        /// ファイルサイズを単位付きに変換して返します.
        /// </summary>
        /// <param name="fileSize"></param>
        /// <returns></returns>
        private String getFileSize(long fileSize)
        {
            String ret = fileSize + " バイト";
            if (fileSize > (1024f * 1024f * 1024f))
            {
                ret = Math.Round((fileSize / 1024f / 1024f / 1024f), 2).ToString() + " GB";
            }
            else if (fileSize > (1024f * 1024f))
            {
                ret = Math.Round((fileSize / 1024f / 1024f), 2).ToString() + " MB";
            }
            else if (fileSize > 1024f)
            {
                ret = Math.Round((fileSize / 1024f)).ToString() + " KB";
            }

            return ret;
        }


        private bool isImgeFile(String fname)
        {
            bool result = false;
            String ext = Path.GetExtension(fname).ToLower();
            // 拡張子から判断
            if (imgTypes.ContainsKey(ext))
            {
                result = true;
            }
            return result;
        }

        private void setList(String filePath, ListView lv)
        {
            // リストビューのヘッダーを設定
            lv.View = View.Details;
            lv.Clear();
            lv.Columns.Add("名前");
            lv.Columns.Add("更新日時");
            lv.Columns.Add("サイズ");

            try
            {
                // フォルダ一覧
                /*
                DirectoryInfo dirList = new DirectoryInfo(filePath);
                foreach (DirectoryInfo di in dirList.GetDirectories())
                {
                    ListViewItem item = new ListViewItem(di.Name);
                    item.SubItems.Add(String.Format("{0:yyyy/MM/dd HH:mm:ss}", di.LastAccessTime));
                    item.SubItems.Add("");
                    lv.Items.Add(item);
                }
                */

                // ファイル一覧
                List<String> files = Directory.GetFiles(filePath).ToList<String>();
                foreach (String file in files)
                {
                    if (isImgeFile(file) == false)
                    {
                        continue;
                    }

                    FileInfo info = new FileInfo(file);
                    ListViewItem item = new ListViewItem(info.Name);

                    // ファイル種類、アイコンの取得
                    String type = "";
                    int iconIndex = 0;
                    SHFILEINFO shinfo = new SHFILEINFO();
                    IntPtr hSuccess = SHGetFileInfo(info.FullName, 0, out shinfo, (uint)Marshal.SizeOf(shinfo), SHGFI_ICON | SHGFI_LARGEICON | SHGFI_SMALLICON | SHGFI_SYSICONINDEX | SHGFI_TYPENAME);
                    if (hSuccess != IntPtr.Zero)
                    {
                        type = shinfo.szTypeName;
                        iconIndex = shinfo.iIcon;
                    }

                    item.ImageIndex = iconIndex;  // アイコン

                    item.SubItems.Add(String.Format("{0:yyyy/MM/dd HH:mm:ss}", info.LastAccessTime));
                    item.SubItems.Add(getFileSize(info.Length));
                    lv.Items.Add(item);
                }
            }
            catch (IOException ie)
            {
                MessageBox.Show(ie.Message, "選択エラー");
            }

            // 列幅を自動調整
            lv.AutoResizeColumns(ColumnHeaderAutoResizeStyle.HeaderSize);
        }

        private void setRightList(String filePath)
        {

        }

        private String getDirPathDialog(String defpath= @"C:\Windows")
        {
            String result = "";
            FolderBrowserDialog fbd = new FolderBrowserDialog();
            fbd.Description = "フォルダを指定してください。";
            fbd.RootFolder = Environment.SpecialFolder.Desktop;
            fbd.SelectedPath = defpath;
            fbd.ShowNewFolderButton = true;
            if (fbd.ShowDialog(this) == DialogResult.OK)
            {
                result = fbd.SelectedPath;
            }
            return result;
        }

        private String getFilePathDialog()
        {
            OpenFileDialog ofd = new OpenFileDialog();
            ofd.FileName = "default.html";
            ofd.Filter = "HTMLファイル(*.html;*.htm)|*.html;*.htm|すべてのファイル(*.*)|*.*";
            ofd.FilterIndex = 2;
            ofd.Title = "開くファイルを選択してください";
            ofd.RestoreDirectory = true;
            ofd.CheckFileExists = true;
            ofd.CheckPathExists = true;

            if (ofd.ShowDialog() == DialogResult.OK)
            {
                Console.WriteLine(ofd.FileName);
            }
            return "";
        }

        private void addDirListToTreeView()
        {
            // ドライブ一覧を走査してツリーに追加
            foreach (String drive in Environment.GetLogicalDrives())
            {
                TreeNode node = new TreeNode(drive);
                node.Nodes.Add(new TreeNode());
                // leftTreeView.Nodes.Add(node);
            }
            // 初期選択ドライブの内容を表示
            // setListItem(Environment.GetLogicalDrives().First());
        }

        private void leftTreeView_AfterSelect(object sender, TreeViewEventArgs e)
        {

        }

        private void leftTreeView_BeforeExpand(object sender, TreeViewCancelEventArgs e)
        {
            TreeNode node = e.Node;
            String path = node.FullPath;
            node.Nodes.Clear();

            try
            {
                DirectoryInfo dirList = new DirectoryInfo(path);
                foreach (DirectoryInfo di in dirList.GetDirectories())
                {
                    TreeNode child = new TreeNode(di.Name);
                    child.Nodes.Add(new TreeNode());
                    node.Nodes.Add(child);
                }
            }
            catch (IOException ie)
            {
                MessageBox.Show(ie.Message, "選択エラー");
            }
        }

        private void leftButton_Click(object sender, EventArgs e)
        {
            String ret = getDirPathDialog(leftTextBox.Text);
            if (ret == "")
            {
                return;
            }
            leftTextBox.Text = ret;
        }

        private void rightButton_Click(object sender, EventArgs e)
        {
            String ret = getDirPathDialog(rightTextBox.Text);
            if (ret == "")
            {
                return;
            }
            rightTextBox.Text = ret;
        }


        private void runCopy()
        {
            if (this.leftListView.SelectedItems.Count == 0)
            {
                return;
            }
            ListViewItem itemx = new ListViewItem();
            itemx = this.leftListView.SelectedItems[0];

            String fromPath = String.Format("{0}\\{1}", this.leftTextBox.Text, itemx.Text);
            String toPath = String.Format("{0}\\{1}", this.rightTextBox.Text, itemx.Text);

            // コピー先が同じ
            if (fromPath == toPath)
            {
                MessageBox.Show("The path is the same.");
                return;
            }

            File.Copy(fromPath, toPath, true);
           
            setList(this.rightTextBox.Text, this.rightListView);
        }

        private void copyButton_Click(object sender, EventArgs e)
        {
            runCopy();
            
        }

        private void selNextItem()
        {
            if (this.leftListView.Items.Count == 0)
            {
                return;
            }

            if (this.leftListView.SelectedItems.Count == 0)
            {
                this.leftListView.Items[0].Selected = true;
                this.leftListView.Focus();
                return;
            }

            int idx = 0;
            idx = this.leftListView.SelectedItems[0].Index;
            int next_idx = idx + 1;
            if (next_idx < this.leftListView.Items.Count)
            {
                this.leftListView.SelectedItems.Clear();
                this.leftListView.Items[next_idx].Selected = true;
            }

            this.leftListView.Focus();
            this.leftListView.Refresh();
            this.leftListView.Update();
        }

        private void selBackItem()
        {
            if (this.leftListView.Items.Count == 0)
            {
                return;
            }

            if (this.leftListView.SelectedItems.Count == 0)
            {
                this.leftListView.Items[0].Selected = true;
                this.leftListView.Focus();
                return;
            }

            int idx = 0;
            idx = this.leftListView.SelectedItems[0].Index;
            if (idx == 0)
            {
                this.leftListView.Focus();
                return;
            }
            int back_idx = idx - 1;
            this.leftListView.SelectedItems.Clear();
            this.leftListView.Items[back_idx].Selected = true;
            this.leftListView.Focus();
            this.leftListView.Refresh();
            this.leftListView.Update();
        }

        private void nextButton_Click(object sender, EventArgs e)
        {
            selNextItem();
        }

        private void backButton_Click(object sender, EventArgs e)
        {
            selBackItem();
        }

        private void leftTextBox_TextChanged(object sender, EventArgs e)
        {
            setList(this.leftTextBox.Text, this.leftListView);
        }

        private void rightTextBox_TextChanged(object sender, EventArgs e)
        {
            setList(this.rightTextBox.Text, this.rightListView);
        }

        private void leftListView_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (this.leftListView.SelectedItems.Count == 0)
            {
                return;
            }
            ListViewItem itemx = new ListViewItem();
            itemx = this.leftListView.SelectedItems[0];
            String fpath = String.Format("{0}\\{1}", this.leftTextBox.Text, itemx.Text);

            setImage(fpath);

            // ラベル設定
            Image img = Image.FromFile(fpath);
            String InfoMsg = String.Format(
                "Name:{0}  Size:{1} x {2}  Update:{3}  FileSize:{4}",
                itemx.Text,
                img.Width.ToString(),
                img.Height.ToString(),
                itemx.SubItems[1].Text,
                itemx.SubItems[2].Text);
            img.Dispose();
            this.infoLabel.Text = InfoMsg;
        }

        private void rightListView_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (this.rightListView.SelectedItems.Count == 0)
            {
                return;
            }
            ListViewItem itemx = new ListViewItem();
            itemx = this.rightListView.SelectedItems[0];
            String fpath = String.Format("{0}\\{1}", this.rightTextBox.Text, itemx.Text);

            if (File.Exists(fpath) == false)
            {
                MessageBox.Show("Not Found Image File.");
                setList(this.rightTextBox.Text, this.rightListView);
                return;
            }

            setImage(fpath);

            // ラベル設定
            Image img = Image.FromFile(fpath);
            String InfoMsg = String.Format(
                "Name:{0}  Size:{1} x {2}  Update:{3}  FileSize:{4}",
                itemx.Text,
                img.Width.ToString(),
                img.Height.ToString(),
                itemx.SubItems[1].Text,
                itemx.SubItems[2].Text);
            img.Dispose();
            this.infoLabel.Text = InfoMsg;
        }

        private void copyToolStripMenuItem1_Click(object sender, EventArgs e)
        {
            runCopy();
        }

        private void updateToolStripMenuItem_Click(object sender, EventArgs e)
        {
            setList(this.leftTextBox.Text, this.leftListView);
            setList(this.rightTextBox.Text, this.rightListView);
        }

        private void leftTextBox_DoubleClick(object sender, EventArgs e)
        {
            Process.Start(this.leftTextBox.Text);
        }

        private void rightTextBox_DoubleClick(object sender, EventArgs e)
        {
            Process.Start(this.rightTextBox.Text);
        }

        private void MainForm_KeyPress(object sender, KeyPressEventArgs e)
        {
            MessageBox.Show(e.KeyChar.ToString());
            /*
            if (e.KeyChar == Keys.F1)
            {
                MessageBox.Show("F1キーが押されました。");
            }
            */
        }

        private void MainForm_KeyDown(object sender, KeyEventArgs e)
        {
            MessageBox.Show("F1キーが押されました。");
            if (e.KeyCode == Keys.F1)
            {
                MessageBox.Show("F1キーが押されました。");
            }
        }

        private void backToolStripMenuItem_Click(object sender, EventArgs e)
        {
            selBackItem();
        }

        private void nextToolStripMenuItem_Click(object sender, EventArgs e)
        {
            selNextItem();
        }

        private void leftListView_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Left)
            {
                selBackItem();
            }
            if (e.KeyCode == Keys.Right)
            {
                selNextItem();
            }
            if (e.KeyCode == Keys.Delete)
            {
                String fpath = "";
                if (this.leftListView.SelectedItems.Count == 0)
                {
                    return;
                }
                DialogResult ret = MessageBox.Show("Delete selected files?", "Question", MessageBoxButtons.YesNo);
                if (ret == DialogResult.No)
                {
                    return;
                }

                Image oldImage = this.pictureBox.Image;
                this.pictureBox.Image = Properties.Resources.empty;
                oldImage.Dispose();

                foreach (ListViewItem itemx in this.leftListView.SelectedItems)
                {
                    fpath = String.Format("{0}\\{1}", this.leftTextBox.Text, itemx.Text);
                    if (File.Exists(fpath) == false)
                    {
                        continue;
                    }
                    File.Delete(fpath);
                }
                setList(this.leftTextBox.Text, this.leftListView);
            }
        }

        private void pathExchangeToolStripMenuItem_Click(object sender, EventArgs e)
        {
            String leftPath = this.leftTextBox.Text;
            this.leftTextBox.Text = this.rightTextBox.Text;
            this.rightTextBox.Text = leftPath;
            setList(this.leftTextBox.Text, this.leftListView);
            setList(this.rightTextBox.Text, this.rightListView);
        }

        private void MainForm_Load(object sender, EventArgs e)
        {
            setDefPath();
        }

        private void MainForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            Properties.Settings.Default.leftPath = this.leftTextBox.Text;
            Properties.Settings.Default.rightPath = this.rightTextBox.Text;
            Properties.Settings.Default.Save();
        }

        private void richTextBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void infoLabel_Click(object sender, EventArgs e)
        {

        }

        private void leftListView_DoubleClick(object sender, EventArgs e)
        {
            ListViewItem itemx = new ListViewItem();
            itemx = this.leftListView.SelectedItems[0];
            String fpath = String.Format("{0}\\{1}", this.leftTextBox.Text, itemx.Text);
            Process.Start(fpath);
        }

        private void rightListView_DoubleClick(object sender, EventArgs e)
        {
            ListViewItem itemx = new ListViewItem();
            itemx = this.rightListView.SelectedItems[0];
            String fpath = String.Format("{0}\\{1}", this.rightTextBox.Text, itemx.Text);
            Process.Start(fpath);
        }

        private void leftPBox_Click(object sender, EventArgs e)
        {
            selBackItem();
        }

        private void leftPBox_MouseHover(object sender, EventArgs e)
        {
            this.leftPBox.Image = SJPhotoCollect.Properties.Resources.leftBt_hover;
        }

        private void leftPBox_MouseLeave(object sender, EventArgs e)
        {
            this.leftPBox.Image = SJPhotoCollect.Properties.Resources.leftBt_nom;
        }

        private void rightPBox_MouseHover(object sender, EventArgs e)
        {
            this.rightPBox.Image = SJPhotoCollect.Properties.Resources.rightBt_hover;
        }

        private void rightPBox_MouseLeave(object sender, EventArgs e)
        {
            this.rightPBox.Image = SJPhotoCollect.Properties.Resources.rightBt_nom;
        }

        private void copyPBox_MouseHover(object sender, EventArgs e)
        {
            this.copyPBox.Image = SJPhotoCollect.Properties.Resources.copyBt_hover;
        }

        private void copyPBox_MouseLeave(object sender, EventArgs e)
        {
            this.copyPBox.Image = SJPhotoCollect.Properties.Resources.copyBt_nom;
        }

        private void rightListView_KeyPress(object sender, KeyPressEventArgs e)
        {

        }

        private void rightListView_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Delete)
            {
                String fpath = "";
                if (this.rightListView.SelectedItems.Count == 0)
                {
                    return;
                }
                DialogResult ret = MessageBox.Show("Delete selected files?", "Question", MessageBoxButtons.YesNo);
                if (ret == DialogResult.No)
                {
                    return;
                }

                Image oldImage = this.pictureBox.Image;
                this.pictureBox.Image = Properties.Resources.empty;
                oldImage.Dispose();

                foreach (ListViewItem itemx in this.rightListView.SelectedItems)
                {
                    fpath = String.Format("{0}\\{1}", this.rightTextBox.Text, itemx.Text);
                    if (File.Exists(fpath) == false)
                    {
                        continue;
                    }
                    File.Delete(fpath);
                }
                setList(this.rightTextBox.Text, this.rightListView);
            }
        }
    }
}
