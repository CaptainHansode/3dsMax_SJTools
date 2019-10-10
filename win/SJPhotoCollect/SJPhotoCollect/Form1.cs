using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.IO;

namespace SJPhotoCollect
{
    public partial class MainForm : Form
    {
        public MainForm()
        {
            InitializeComponent();
            setDefPath();
            setList(this.leftTextBox.Text, this.leftListView);
            setList(this.rightTextBox.Text, this.rightListView);
            // addDirListToTreeView();
        }

        private void setImage(String imgPaht)
        {
            if (File.Exists(imgPaht) == false)
            {
                return;
            }
            Image img = Image.FromFile(imgPaht); // UI用の画像
            this.imgPanel.BackgroundImage = img;
        }

        private void setDefPath()
        {
            String ret = Environment.GetFolderPath(Environment.SpecialFolder.DesktopDirectory);
            leftTextBox.Text = ret;
            rightTextBox.Text = ret;
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


        private bool isJpg(String fname)
        {
            bool result = false;
            String ext = Path.GetExtension(fname);
            if (ext == ".jpg")
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
                    if (isJpg(file) == false)
                    {
                        continue;
                    }
                    FileInfo info = new FileInfo(file);
                    ListViewItem item = new ListViewItem(info.Name);
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
            //FolderBrowserDialogクラスのインスタンスを作成
            FolderBrowserDialog fbd = new FolderBrowserDialog();

            //上部に表示する説明テキストを指定する
            fbd.Description = "フォルダを指定してください。";
            //ルートフォルダを指定する
            //デフォルトでDesktop
            fbd.RootFolder = Environment.SpecialFolder.Desktop;
            //最初に選択するフォルダを指定する
            //RootFolder以下にあるフォルダである必要がある
            fbd.SelectedPath = defpath;
            
            //ユーザーが新しいフォルダを作成できるようにする
            //デフォルトでTrue
            fbd.ShowNewFolderButton = true;

            //ダイアログを表示する
            if (fbd.ShowDialog(this) == DialogResult.OK)
            {
                result = fbd.SelectedPath;
                // 選択されたフォルダを表示する
                // Console.WriteLine(fbd.SelectedPath);
            }
            return result;
        }

        private String getFilePathDialog()
        {
            //OpenFileDialogクラスのインスタンスを作成
            OpenFileDialog ofd = new OpenFileDialog();

            //はじめのファイル名を指定する
            //はじめに「ファイル名」で表示される文字列を指定する
            ofd.FileName = "default.html";
            //はじめに表示されるフォルダを指定する
            //指定しない（空の文字列）の時は、現在のディレクトリが表示される
            // ofd.InitialDirectory = @"C:\";

            //[ファイルの種類]に表示される選択肢を指定する
            //指定しないとすべてのファイルが表示される
            ofd.Filter = "HTMLファイル(*.html;*.htm)|*.html;*.htm|すべてのファイル(*.*)|*.*";
            //[ファイルの種類]ではじめに選択されるものを指定する
            //2番目の「すべてのファイル」が選択されているようにする
            ofd.FilterIndex = 2;
            //タイトルを設定する
            ofd.Title = "開くファイルを選択してください";
            //ダイアログボックスを閉じる前に現在のディレクトリを復元するようにする
            ofd.RestoreDirectory = true;
            //存在しないファイルの名前が指定されたとき警告を表示する
            //デフォルトでTrueなので指定する必要はない
            ofd.CheckFileExists = true;
            //存在しないパスが指定されたとき警告を表示する
            //デフォルトでTrueなので指定する必要はない
            ofd.CheckPathExists = true;

            //ダイアログを表示する
            if (ofd.ShowDialog() == DialogResult.OK)
            {
                //OKボタンがクリックされたとき、選択されたファイル名を表示する
                Console.WriteLine(ofd.FileName);
            }
            return "";
        }

        private void addDirListToTreeView()
        {
            // ドライブ一覧を走査してツリーに追加
            foreach (String drive in Environment.GetLogicalDrives())
            {
                // 新規ノード作成
                // プラスボタンを表示するため空のノードを追加しておく
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

        private void MainForm_Load(object sender, EventArgs e)
        {

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
            File.Copy(fromPath, toPath, true);
            setList(this.rightTextBox.Text, this.rightListView);
        }

        private void copyButton_Click(object sender, EventArgs e)
        {
            runCopy();
            
        }

        private void nextButton_Click(object sender, EventArgs e)
        {
            if (this.leftListView.SelectedItems.Count == 0)
            {
                return;
            }
            int idx = 0;
            idx = this.leftListView.SelectedItems[0].Index;

            this.leftListView.Items[0].Selected = true;
            // this.leftListView.Focus();

            //MessageBox.Show(this.leftListView.Items.Count.ToString());

            //listView1.Items[idx + 1].Selected = true;
            // this.leftListView.SelectNextControl
        }

        private void backButton_Click(object sender, EventArgs e)
        {

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

            //選択されているアイテムを取得する
            // string msg
            setImage(String.Format("{0}\\{1}", this.leftTextBox.Text, itemx.Text));
            //MessageBox.Show(msg);
        }

        private void rightListView_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (this.rightListView.SelectedItems.Count == 0)
            {
                return;
            }
            ListViewItem itemx = new ListViewItem();
            itemx = this.rightListView.SelectedItems[0];

            setImage(String.Format("{0}\\{1}", this.rightListView.Text, itemx.Text));
        }

        private void copyToolStripMenuItem1_Click(object sender, EventArgs e)
        {
            runCopy();
        }
    }
}
