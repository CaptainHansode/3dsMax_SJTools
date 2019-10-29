namespace SJSetWindowTopMost
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
            this.runButton = new System.Windows.Forms.Button();
            this.imageList1 = new System.Windows.Forms.ImageList(this.components);
            this.titleEditBox = new System.Windows.Forms.TextBox();
            this.renameButton = new System.Windows.Forms.Button();
            this.tableLayoutPanel1 = new System.Windows.Forms.TableLayoutPanel();
            this.winListView = new System.Windows.Forms.ListView();
            this.tableLayoutPanel1.SuspendLayout();
            this.SuspendLayout();
            // 
            // runButton
            // 
            this.runButton.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(89)))), ((int)(((byte)(89)))), ((int)(((byte)(89)))));
            this.runButton.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.runButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.runButton.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(182)))), ((int)(((byte)(182)))), ((int)(((byte)(182)))));
            this.runButton.Location = new System.Drawing.Point(8, 305);
            this.runButton.Name = "runButton";
            this.runButton.Size = new System.Drawing.Size(142, 20);
            this.runButton.TabIndex = 0;
            this.runButton.Text = "Reload";
            this.runButton.UseVisualStyleBackColor = false;
            this.runButton.Click += new System.EventHandler(this.runButton_Click);
            // 
            // imageList1
            // 
            this.imageList1.ImageStream = ((System.Windows.Forms.ImageListStreamer)(resources.GetObject("imageList1.ImageStream")));
            this.imageList1.TransparentColor = System.Drawing.Color.Transparent;
            this.imageList1.Images.SetKeyName(0, "empty.png");
            this.imageList1.Images.SetKeyName(1, "pin.png");
            // 
            // titleEditBox
            // 
            this.titleEditBox.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(30)))), ((int)(((byte)(30)))), ((int)(((byte)(30)))));
            this.titleEditBox.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.titleEditBox.Dock = System.Windows.Forms.DockStyle.Fill;
            this.titleEditBox.Font = new System.Drawing.Font("Yu Gothic UI", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(128)));
            this.titleEditBox.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(229)))), ((int)(((byte)(229)))), ((int)(((byte)(229)))));
            this.titleEditBox.Location = new System.Drawing.Point(3, 3);
            this.titleEditBox.Name = "titleEditBox";
            this.titleEditBox.Size = new System.Drawing.Size(88, 16);
            this.titleEditBox.TabIndex = 2;
            // 
            // renameButton
            // 
            this.renameButton.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(89)))), ((int)(((byte)(89)))), ((int)(((byte)(89)))));
            this.renameButton.Dock = System.Windows.Forms.DockStyle.Fill;
            this.renameButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.renameButton.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(182)))), ((int)(((byte)(182)))), ((int)(((byte)(182)))));
            this.renameButton.Location = new System.Drawing.Point(97, 3);
            this.renameButton.Name = "renameButton";
            this.renameButton.Size = new System.Drawing.Size(42, 20);
            this.renameButton.TabIndex = 3;
            this.renameButton.Text = "Set";
            this.renameButton.UseVisualStyleBackColor = false;
            this.renameButton.Click += new System.EventHandler(this.renameButton_Click);
            // 
            // tableLayoutPanel1
            // 
            this.tableLayoutPanel1.ColumnCount = 2;
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 48F));
            this.tableLayoutPanel1.Controls.Add(this.titleEditBox, 0, 0);
            this.tableLayoutPanel1.Controls.Add(this.renameButton, 1, 0);
            this.tableLayoutPanel1.Dock = System.Windows.Forms.DockStyle.Top;
            this.tableLayoutPanel1.Location = new System.Drawing.Point(8, 8);
            this.tableLayoutPanel1.Name = "tableLayoutPanel1";
            this.tableLayoutPanel1.RowCount = 1;
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel1.Size = new System.Drawing.Size(142, 26);
            this.tableLayoutPanel1.TabIndex = 4;
            // 
            // winListView
            // 
            this.winListView.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(30)))), ((int)(((byte)(30)))), ((int)(((byte)(30)))));
            this.winListView.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.winListView.Dock = System.Windows.Forms.DockStyle.Fill;
            this.winListView.Font = new System.Drawing.Font("Yu Gothic UI", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(128)));
            this.winListView.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(228)))), ((int)(((byte)(228)))), ((int)(((byte)(228)))));
            this.winListView.Location = new System.Drawing.Point(8, 34);
            this.winListView.Name = "winListView";
            this.winListView.Size = new System.Drawing.Size(142, 271);
            this.winListView.SmallImageList = this.imageList1;
            this.winListView.TabIndex = 5;
            this.winListView.UseCompatibleStateImageBehavior = false;
            this.winListView.ColumnClick += new System.Windows.Forms.ColumnClickEventHandler(this.winListView_ColumnClick);
            this.winListView.SelectedIndexChanged += new System.EventHandler(this.winListView_SelectedIndexChanged);
            this.winListView.DoubleClick += new System.EventHandler(this.winListView_DoubleClick);
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(52)))), ((int)(((byte)(52)))), ((int)(((byte)(52)))));
            this.ClientSize = new System.Drawing.Size(158, 333);
            this.Controls.Add(this.winListView);
            this.Controls.Add(this.tableLayoutPanel1);
            this.Controls.Add(this.runButton);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.SizableToolWindow;
            this.Name = "MainForm";
            this.Padding = new System.Windows.Forms.Padding(8);
            this.Text = "SJSetWinTopMost";
            this.TopMost = true;
            this.tableLayoutPanel1.ResumeLayout(false);
            this.tableLayoutPanel1.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button runButton;
        private System.Windows.Forms.ImageList imageList1;
        private System.Windows.Forms.TextBox titleEditBox;
        private System.Windows.Forms.Button renameButton;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel1;
        private System.Windows.Forms.ListView winListView;
    }
}

