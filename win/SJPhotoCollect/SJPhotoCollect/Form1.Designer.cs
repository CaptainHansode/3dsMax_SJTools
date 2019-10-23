namespace SJPhotoCollect
{
    partial class MainForm
    {
        /// <summary>
        /// 必要なデザイナー変数です。
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// 使用中のリソースをすべてクリーンアップします。
        /// </summary>
        /// <param name="disposing">マネージド リソースを破棄する場合は true を指定し、その他の場合は false を指定します。</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows フォーム デザイナーで生成されたコード

        /// <summary>
        /// デザイナー サポートに必要なメソッドです。このメソッドの内容を
        /// コード エディターで変更しないでください。
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(MainForm));
            this.leftListView = new System.Windows.Forms.ListView();
            this.leftButton = new System.Windows.Forms.Button();
            this.leftTextBox = new System.Windows.Forms.TextBox();
            this.imgPanel = new System.Windows.Forms.Panel();
            this.copyPBox = new System.Windows.Forms.PictureBox();
            this.rightPBox = new System.Windows.Forms.PictureBox();
            this.leftPBox = new System.Windows.Forms.PictureBox();
            this.pictureBox = new System.Windows.Forms.PictureBox();
            this.infoLabel = new System.Windows.Forms.Label();
            this.rightTextBox = new System.Windows.Forms.TextBox();
            this.rightButton = new System.Windows.Forms.Button();
            this.rightListView = new System.Windows.Forms.ListView();
            this.tableLayoutPanel2 = new System.Windows.Forms.TableLayoutPanel();
            this.tableLayoutPanel3 = new System.Windows.Forms.TableLayoutPanel();
            this.tableLayoutPanel4 = new System.Windows.Forms.TableLayoutPanel();
            this.tableLayoutPanel5 = new System.Windows.Forms.TableLayoutPanel();
            this.splitContainer1 = new System.Windows.Forms.SplitContainer();
            this.splitContainer2 = new System.Windows.Forms.SplitContainer();
            this.menuStrip1 = new System.Windows.Forms.MenuStrip();
            this.menuToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.updateToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.copyToolStripMenuItem1 = new System.Windows.Forms.ToolStripMenuItem();
            this.backToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.nextToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.pathExchangeToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.copyToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.contextMenuStrip1 = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.tableLayoutPanel1 = new System.Windows.Forms.TableLayoutPanel();
            this.imgPanel.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.copyPBox)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.rightPBox)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.leftPBox)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox)).BeginInit();
            this.tableLayoutPanel2.SuspendLayout();
            this.tableLayoutPanel3.SuspendLayout();
            this.tableLayoutPanel4.SuspendLayout();
            this.tableLayoutPanel5.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer1)).BeginInit();
            this.splitContainer1.Panel1.SuspendLayout();
            this.splitContainer1.Panel2.SuspendLayout();
            this.splitContainer1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer2)).BeginInit();
            this.splitContainer2.Panel1.SuspendLayout();
            this.splitContainer2.Panel2.SuspendLayout();
            this.splitContainer2.SuspendLayout();
            this.menuStrip1.SuspendLayout();
            this.contextMenuStrip1.SuspendLayout();
            this.tableLayoutPanel1.SuspendLayout();
            this.SuspendLayout();
            // 
            // leftListView
            // 
            this.leftListView.BackColor = System.Drawing.Color.Black;
            this.leftListView.Dock = System.Windows.Forms.DockStyle.Fill;
            this.leftListView.Font = new System.Drawing.Font("Yu Gothic UI", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(128)));
            this.leftListView.ForeColor = System.Drawing.SystemColors.Control;
            this.leftListView.Location = new System.Drawing.Point(3, 39);
            this.leftListView.Name = "leftListView";
            this.leftListView.Size = new System.Drawing.Size(122, 619);
            this.leftListView.TabIndex = 3;
            this.leftListView.UseCompatibleStateImageBehavior = false;
            this.leftListView.SelectedIndexChanged += new System.EventHandler(this.leftListView_SelectedIndexChanged);
            this.leftListView.DoubleClick += new System.EventHandler(this.leftListView_DoubleClick);
            this.leftListView.KeyDown += new System.Windows.Forms.KeyEventHandler(this.leftListView_KeyDown);
            // 
            // leftButton
            // 
            this.leftButton.Dock = System.Windows.Forms.DockStyle.Fill;
            this.leftButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.leftButton.ForeColor = System.Drawing.SystemColors.Control;
            this.leftButton.Location = new System.Drawing.Point(106, 3);
            this.leftButton.Name = "leftButton";
            this.leftButton.Size = new System.Drawing.Size(13, 24);
            this.leftButton.TabIndex = 2;
            this.leftButton.Text = "...";
            this.leftButton.UseVisualStyleBackColor = true;
            this.leftButton.Click += new System.EventHandler(this.leftButton_Click);
            // 
            // leftTextBox
            // 
            this.leftTextBox.BackColor = System.Drawing.Color.Black;
            this.leftTextBox.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.leftTextBox.Dock = System.Windows.Forms.DockStyle.Fill;
            this.leftTextBox.Font = new System.Drawing.Font("Yu Gothic UI", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(128)));
            this.leftTextBox.ForeColor = System.Drawing.Color.LightGray;
            this.leftTextBox.Location = new System.Drawing.Point(5, 5);
            this.leftTextBox.Margin = new System.Windows.Forms.Padding(5);
            this.leftTextBox.Name = "leftTextBox";
            this.leftTextBox.Size = new System.Drawing.Size(93, 16);
            this.leftTextBox.TabIndex = 1;
            this.leftTextBox.TextChanged += new System.EventHandler(this.leftTextBox_TextChanged);
            this.leftTextBox.DoubleClick += new System.EventHandler(this.leftTextBox_DoubleClick);
            // 
            // imgPanel
            // 
            this.imgPanel.BackColor = System.Drawing.Color.Black;
            this.imgPanel.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Zoom;
            this.imgPanel.Controls.Add(this.copyPBox);
            this.imgPanel.Controls.Add(this.rightPBox);
            this.imgPanel.Controls.Add(this.leftPBox);
            this.imgPanel.Controls.Add(this.pictureBox);
            this.imgPanel.Dock = System.Windows.Forms.DockStyle.Fill;
            this.imgPanel.ForeColor = System.Drawing.SystemColors.Control;
            this.imgPanel.Location = new System.Drawing.Point(0, 0);
            this.imgPanel.Name = "imgPanel";
            this.imgPanel.Size = new System.Drawing.Size(989, 646);
            this.imgPanel.TabIndex = 0;
            // 
            // copyPBox
            // 
            this.copyPBox.BackColor = System.Drawing.Color.Transparent;
            this.copyPBox.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.copyPBox.Image = global::SJPhotoCollect.Properties.Resources.copyBt_nom;
            this.copyPBox.Location = new System.Drawing.Point(80, 582);
            this.copyPBox.Name = "copyPBox";
            this.copyPBox.Size = new System.Drawing.Size(829, 64);
            this.copyPBox.SizeMode = System.Windows.Forms.PictureBoxSizeMode.CenterImage;
            this.copyPBox.TabIndex = 13;
            this.copyPBox.TabStop = false;
            this.copyPBox.Click += new System.EventHandler(this.copyButton_Click);
            this.copyPBox.MouseLeave += new System.EventHandler(this.copyPBox_MouseLeave);
            this.copyPBox.MouseHover += new System.EventHandler(this.copyPBox_MouseHover);
            // 
            // rightPBox
            // 
            this.rightPBox.BackColor = System.Drawing.Color.Transparent;
            this.rightPBox.Dock = System.Windows.Forms.DockStyle.Right;
            this.rightPBox.Image = global::SJPhotoCollect.Properties.Resources.rightBt_nom;
            this.rightPBox.Location = new System.Drawing.Point(909, 0);
            this.rightPBox.Name = "rightPBox";
            this.rightPBox.Size = new System.Drawing.Size(80, 646);
            this.rightPBox.SizeMode = System.Windows.Forms.PictureBoxSizeMode.CenterImage;
            this.rightPBox.TabIndex = 12;
            this.rightPBox.TabStop = false;
            this.rightPBox.Click += new System.EventHandler(this.nextButton_Click);
            this.rightPBox.MouseLeave += new System.EventHandler(this.rightPBox_MouseLeave);
            this.rightPBox.MouseHover += new System.EventHandler(this.rightPBox_MouseHover);
            // 
            // leftPBox
            // 
            this.leftPBox.BackColor = System.Drawing.Color.Transparent;
            this.leftPBox.Dock = System.Windows.Forms.DockStyle.Left;
            this.leftPBox.Image = global::SJPhotoCollect.Properties.Resources.leftBt_nom;
            this.leftPBox.Location = new System.Drawing.Point(0, 0);
            this.leftPBox.Name = "leftPBox";
            this.leftPBox.Size = new System.Drawing.Size(80, 646);
            this.leftPBox.SizeMode = System.Windows.Forms.PictureBoxSizeMode.CenterImage;
            this.leftPBox.TabIndex = 10;
            this.leftPBox.TabStop = false;
            this.leftPBox.Click += new System.EventHandler(this.backButton_Click);
            this.leftPBox.MouseLeave += new System.EventHandler(this.leftPBox_MouseLeave);
            this.leftPBox.MouseHover += new System.EventHandler(this.leftPBox_MouseHover);
            // 
            // pictureBox
            // 
            this.pictureBox.BackColor = System.Drawing.Color.Transparent;
            this.pictureBox.Dock = System.Windows.Forms.DockStyle.Fill;
            this.pictureBox.Image = global::SJPhotoCollect.Properties.Resources.empty;
            this.pictureBox.Location = new System.Drawing.Point(0, 0);
            this.pictureBox.Name = "pictureBox";
            this.pictureBox.Size = new System.Drawing.Size(989, 646);
            this.pictureBox.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.pictureBox.TabIndex = 9;
            this.pictureBox.TabStop = false;
            // 
            // infoLabel
            // 
            this.infoLabel.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.infoLabel.Font = new System.Drawing.Font("Yu Gothic UI", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(128)));
            this.infoLabel.ForeColor = System.Drawing.SystemColors.Control;
            this.infoLabel.Location = new System.Drawing.Point(0, 646);
            this.infoLabel.Name = "infoLabel";
            this.infoLabel.Size = new System.Drawing.Size(989, 15);
            this.infoLabel.TabIndex = 11;
            this.infoLabel.Text = "Info";
            // 
            // rightTextBox
            // 
            this.rightTextBox.BackColor = System.Drawing.Color.Black;
            this.rightTextBox.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.rightTextBox.Dock = System.Windows.Forms.DockStyle.Fill;
            this.rightTextBox.Font = new System.Drawing.Font("Yu Gothic UI", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(128)));
            this.rightTextBox.ForeColor = System.Drawing.Color.Transparent;
            this.rightTextBox.Location = new System.Drawing.Point(3, 3);
            this.rightTextBox.Name = "rightTextBox";
            this.rightTextBox.Size = new System.Drawing.Size(98, 16);
            this.rightTextBox.TabIndex = 0;
            this.rightTextBox.TextChanged += new System.EventHandler(this.rightTextBox_TextChanged);
            this.rightTextBox.DoubleClick += new System.EventHandler(this.rightTextBox_DoubleClick);
            // 
            // rightButton
            // 
            this.rightButton.Dock = System.Windows.Forms.DockStyle.Fill;
            this.rightButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.rightButton.ForeColor = System.Drawing.SystemColors.Control;
            this.rightButton.Location = new System.Drawing.Point(107, 3);
            this.rightButton.Name = "rightButton";
            this.rightButton.Size = new System.Drawing.Size(13, 24);
            this.rightButton.TabIndex = 4;
            this.rightButton.Text = "...";
            this.rightButton.UseVisualStyleBackColor = true;
            this.rightButton.Click += new System.EventHandler(this.rightButton_Click);
            // 
            // rightListView
            // 
            this.rightListView.BackColor = System.Drawing.Color.Black;
            this.rightListView.Dock = System.Windows.Forms.DockStyle.Fill;
            this.rightListView.Font = new System.Drawing.Font("Yu Gothic UI", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(128)));
            this.rightListView.ForeColor = System.Drawing.SystemColors.Control;
            this.rightListView.Location = new System.Drawing.Point(3, 39);
            this.rightListView.Name = "rightListView";
            this.rightListView.Size = new System.Drawing.Size(123, 619);
            this.rightListView.TabIndex = 5;
            this.rightListView.UseCompatibleStateImageBehavior = false;
            this.rightListView.SelectedIndexChanged += new System.EventHandler(this.rightListView_SelectedIndexChanged);
            this.rightListView.DoubleClick += new System.EventHandler(this.rightListView_DoubleClick);
            this.rightListView.KeyDown += new System.Windows.Forms.KeyEventHandler(this.rightListView_KeyDown);
            this.rightListView.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.rightListView_KeyPress);
            // 
            // tableLayoutPanel2
            // 
            this.tableLayoutPanel2.ColumnCount = 2;
            this.tableLayoutPanel2.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 85F));
            this.tableLayoutPanel2.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 15F));
            this.tableLayoutPanel2.Controls.Add(this.leftButton, 1, 0);
            this.tableLayoutPanel2.Controls.Add(this.leftTextBox, 0, 0);
            this.tableLayoutPanel2.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel2.Location = new System.Drawing.Point(3, 3);
            this.tableLayoutPanel2.Name = "tableLayoutPanel2";
            this.tableLayoutPanel2.RowCount = 1;
            this.tableLayoutPanel2.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel2.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 30F));
            this.tableLayoutPanel2.Size = new System.Drawing.Size(122, 30);
            this.tableLayoutPanel2.TabIndex = 4;
            // 
            // tableLayoutPanel3
            // 
            this.tableLayoutPanel3.ColumnCount = 2;
            this.tableLayoutPanel3.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 85F));
            this.tableLayoutPanel3.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 15F));
            this.tableLayoutPanel3.Controls.Add(this.rightButton, 1, 0);
            this.tableLayoutPanel3.Controls.Add(this.rightTextBox, 0, 0);
            this.tableLayoutPanel3.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel3.Location = new System.Drawing.Point(3, 3);
            this.tableLayoutPanel3.Name = "tableLayoutPanel3";
            this.tableLayoutPanel3.RowCount = 1;
            this.tableLayoutPanel3.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel3.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 30F));
            this.tableLayoutPanel3.Size = new System.Drawing.Size(123, 30);
            this.tableLayoutPanel3.TabIndex = 5;
            // 
            // tableLayoutPanel4
            // 
            this.tableLayoutPanel4.ColumnCount = 1;
            this.tableLayoutPanel4.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel4.Controls.Add(this.rightListView, 0, 1);
            this.tableLayoutPanel4.Controls.Add(this.tableLayoutPanel3, 0, 0);
            this.tableLayoutPanel4.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel4.Location = new System.Drawing.Point(0, 0);
            this.tableLayoutPanel4.Name = "tableLayoutPanel4";
            this.tableLayoutPanel4.RowCount = 2;
            this.tableLayoutPanel4.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 36F));
            this.tableLayoutPanel4.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel4.Size = new System.Drawing.Size(129, 661);
            this.tableLayoutPanel4.TabIndex = 4;
            // 
            // tableLayoutPanel5
            // 
            this.tableLayoutPanel5.ColumnCount = 1;
            this.tableLayoutPanel5.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel5.Controls.Add(this.leftListView, 0, 1);
            this.tableLayoutPanel5.Controls.Add(this.tableLayoutPanel2, 0, 0);
            this.tableLayoutPanel5.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel5.Location = new System.Drawing.Point(0, 0);
            this.tableLayoutPanel5.Name = "tableLayoutPanel5";
            this.tableLayoutPanel5.RowCount = 2;
            this.tableLayoutPanel5.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 36F));
            this.tableLayoutPanel5.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel5.Size = new System.Drawing.Size(128, 661);
            this.tableLayoutPanel5.TabIndex = 5;
            // 
            // splitContainer1
            // 
            this.splitContainer1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.splitContainer1.Location = new System.Drawing.Point(3, 23);
            this.splitContainer1.Name = "splitContainer1";
            // 
            // splitContainer1.Panel1
            // 
            this.splitContainer1.Panel1.Controls.Add(this.tableLayoutPanel5);
            // 
            // splitContainer1.Panel2
            // 
            this.splitContainer1.Panel2.Controls.Add(this.splitContainer2);
            this.splitContainer1.Size = new System.Drawing.Size(1254, 661);
            this.splitContainer1.SplitterDistance = 128;
            this.splitContainer1.TabIndex = 7;
            // 
            // splitContainer2
            // 
            this.splitContainer2.Dock = System.Windows.Forms.DockStyle.Fill;
            this.splitContainer2.Location = new System.Drawing.Point(0, 0);
            this.splitContainer2.Name = "splitContainer2";
            // 
            // splitContainer2.Panel1
            // 
            this.splitContainer2.Panel1.Controls.Add(this.imgPanel);
            this.splitContainer2.Panel1.Controls.Add(this.infoLabel);
            // 
            // splitContainer2.Panel2
            // 
            this.splitContainer2.Panel2.Controls.Add(this.tableLayoutPanel4);
            this.splitContainer2.Size = new System.Drawing.Size(1122, 661);
            this.splitContainer2.SplitterDistance = 989;
            this.splitContainer2.TabIndex = 0;
            // 
            // menuStrip1
            // 
            this.menuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.menuToolStripMenuItem});
            this.menuStrip1.Location = new System.Drawing.Point(0, 0);
            this.menuStrip1.Name = "menuStrip1";
            this.menuStrip1.Size = new System.Drawing.Size(1260, 20);
            this.menuStrip1.TabIndex = 9;
            this.menuStrip1.Text = "menuStrip1";
            // 
            // menuToolStripMenuItem
            // 
            this.menuToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.updateToolStripMenuItem,
            this.copyToolStripMenuItem1,
            this.backToolStripMenuItem,
            this.nextToolStripMenuItem,
            this.pathExchangeToolStripMenuItem});
            this.menuToolStripMenuItem.Name = "menuToolStripMenuItem";
            this.menuToolStripMenuItem.Size = new System.Drawing.Size(50, 16);
            this.menuToolStripMenuItem.Text = "Menu";
            // 
            // updateToolStripMenuItem
            // 
            this.updateToolStripMenuItem.Name = "updateToolStripMenuItem";
            this.updateToolStripMenuItem.ShortcutKeys = System.Windows.Forms.Keys.F5;
            this.updateToolStripMenuItem.Size = new System.Drawing.Size(152, 22);
            this.updateToolStripMenuItem.Text = "Update";
            this.updateToolStripMenuItem.Click += new System.EventHandler(this.updateToolStripMenuItem_Click);
            // 
            // copyToolStripMenuItem1
            // 
            this.copyToolStripMenuItem1.Name = "copyToolStripMenuItem1";
            this.copyToolStripMenuItem1.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.C)));
            this.copyToolStripMenuItem1.Size = new System.Drawing.Size(152, 22);
            this.copyToolStripMenuItem1.Text = "Copy";
            this.copyToolStripMenuItem1.Click += new System.EventHandler(this.copyToolStripMenuItem1_Click);
            // 
            // backToolStripMenuItem
            // 
            this.backToolStripMenuItem.Name = "backToolStripMenuItem";
            this.backToolStripMenuItem.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.B)));
            this.backToolStripMenuItem.Size = new System.Drawing.Size(152, 22);
            this.backToolStripMenuItem.Text = "Back";
            this.backToolStripMenuItem.Click += new System.EventHandler(this.backToolStripMenuItem_Click);
            // 
            // nextToolStripMenuItem
            // 
            this.nextToolStripMenuItem.Name = "nextToolStripMenuItem";
            this.nextToolStripMenuItem.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.N)));
            this.nextToolStripMenuItem.Size = new System.Drawing.Size(152, 22);
            this.nextToolStripMenuItem.Text = "Next";
            this.nextToolStripMenuItem.Click += new System.EventHandler(this.nextToolStripMenuItem_Click);
            // 
            // pathExchangeToolStripMenuItem
            // 
            this.pathExchangeToolStripMenuItem.Name = "pathExchangeToolStripMenuItem";
            this.pathExchangeToolStripMenuItem.Size = new System.Drawing.Size(152, 22);
            this.pathExchangeToolStripMenuItem.Text = "Path Exchange";
            this.pathExchangeToolStripMenuItem.Click += new System.EventHandler(this.pathExchangeToolStripMenuItem_Click);
            // 
            // copyToolStripMenuItem
            // 
            this.copyToolStripMenuItem.Name = "copyToolStripMenuItem";
            this.copyToolStripMenuItem.Size = new System.Drawing.Size(101, 22);
            this.copyToolStripMenuItem.Text = "Copy";
            // 
            // contextMenuStrip1
            // 
            this.contextMenuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.copyToolStripMenuItem});
            this.contextMenuStrip1.Name = "contextMenuStrip1";
            this.contextMenuStrip1.Size = new System.Drawing.Size(102, 26);
            // 
            // tableLayoutPanel1
            // 
            this.tableLayoutPanel1.ColumnCount = 1;
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel1.Controls.Add(this.menuStrip1, 0, 0);
            this.tableLayoutPanel1.Controls.Add(this.splitContainer1, 0, 1);
            this.tableLayoutPanel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel1.Location = new System.Drawing.Point(0, 0);
            this.tableLayoutPanel1.Name = "tableLayoutPanel1";
            this.tableLayoutPanel1.RowCount = 2;
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 20F));
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel1.Size = new System.Drawing.Size(1260, 687);
            this.tableLayoutPanel1.TabIndex = 11;
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Black;
            this.ClientSize = new System.Drawing.Size(1260, 687);
            this.Controls.Add(this.tableLayoutPanel1);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MainMenuStrip = this.menuStrip1;
            this.Name = "MainForm";
            this.Text = "SJ Photo Collect";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.MainForm_FormClosing);
            this.Load += new System.EventHandler(this.MainForm_Load);
            this.KeyDown += new System.Windows.Forms.KeyEventHandler(this.MainForm_KeyDown);
            this.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.MainForm_KeyPress);
            this.imgPanel.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.copyPBox)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.rightPBox)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.leftPBox)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox)).EndInit();
            this.tableLayoutPanel2.ResumeLayout(false);
            this.tableLayoutPanel2.PerformLayout();
            this.tableLayoutPanel3.ResumeLayout(false);
            this.tableLayoutPanel3.PerformLayout();
            this.tableLayoutPanel4.ResumeLayout(false);
            this.tableLayoutPanel5.ResumeLayout(false);
            this.splitContainer1.Panel1.ResumeLayout(false);
            this.splitContainer1.Panel2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer1)).EndInit();
            this.splitContainer1.ResumeLayout(false);
            this.splitContainer2.Panel1.ResumeLayout(false);
            this.splitContainer2.Panel2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer2)).EndInit();
            this.splitContainer2.ResumeLayout(false);
            this.menuStrip1.ResumeLayout(false);
            this.menuStrip1.PerformLayout();
            this.contextMenuStrip1.ResumeLayout(false);
            this.tableLayoutPanel1.ResumeLayout(false);
            this.tableLayoutPanel1.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion
        private System.Windows.Forms.TextBox leftTextBox;
        private System.Windows.Forms.Button leftButton;
        private System.Windows.Forms.ListView leftListView;
        private System.Windows.Forms.Panel imgPanel;
        private System.Windows.Forms.Button rightButton;
        private System.Windows.Forms.TextBox rightTextBox;
        private System.Windows.Forms.ListView rightListView;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel2;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel3;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel4;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel5;
        private System.Windows.Forms.SplitContainer splitContainer1;
        private System.Windows.Forms.SplitContainer splitContainer2;
        private System.Windows.Forms.MenuStrip menuStrip1;
        private System.Windows.Forms.ToolStripMenuItem menuToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem copyToolStripMenuItem1;
        private System.Windows.Forms.ToolStripMenuItem copyToolStripMenuItem;
        private System.Windows.Forms.ContextMenuStrip contextMenuStrip1;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel1;
        private System.Windows.Forms.ToolStripMenuItem updateToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem backToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem nextToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem pathExchangeToolStripMenuItem;
        private System.Windows.Forms.PictureBox pictureBox;
        private System.Windows.Forms.PictureBox leftPBox;
        private System.Windows.Forms.Label infoLabel;
        private System.Windows.Forms.PictureBox copyPBox;
        private System.Windows.Forms.PictureBox rightPBox;
    }
}

