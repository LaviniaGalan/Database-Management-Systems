using System;
using System.Data;
using System.Windows.Forms;
using System.Data.SqlClient;
using System.Configuration;

namespace WindowsFormsApp1
{
    public partial class Form1 : Form
    {
        SqlConnection dbConn;
        SqlDataAdapter daParent, daChild;
        DataSet ds;

        SqlCommandBuilder cbChild;

        BindingSource bsParent, bsChild;

        string parentTableName, childTableName, parentFKCol, childFKCol;
        public Form1()
        {
            InitializeComponent();
            parentTableName = ConfigurationManager.AppSettings.Get("Parent");
            childTableName = ConfigurationManager.AppSettings.Get("Child");
            parentFKCol = ConfigurationManager.AppSettings.Get("ParentFKColumn");
            childFKCol = ConfigurationManager.AppSettings.Get("ChildFKColumn");
        }

        private void updateButton_Click(object sender, EventArgs e)
        {
            try
            {
                daChild.Update(ds, childTableName);
            }
            catch (Exception excep)
            {
                MessageBox.Show(excep.Message);
            }
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            dbConn = new SqlConnection("Data Source = DESKTOP-ALKE6K0; Initial Catalog = Hospital; " +
                                    "Integrated Security = SSPI");
            dbConn.Open();

            ds = new DataSet();
            daParent = new SqlDataAdapter("SELECT * FROM " + parentTableName, dbConn);
            daChild = new SqlDataAdapter("SELECT * FROM " + childTableName, dbConn);
           
            cbChild = new SqlCommandBuilder(daChild);

            daParent.Fill(ds, parentTableName);
            daChild.Fill(ds, childTableName);

            DataRelation dr = new DataRelation("FK_Parent_Child", ds.Tables[parentTableName].Columns[parentFKCol],
                ds.Tables[childTableName].Columns[childFKCol]);

            ds.Relations.Add(dr);

            bsParent = new BindingSource();
            bsParent.DataSource = ds;
            bsParent.DataMember = parentTableName;

            bsChild = new BindingSource();
            bsChild.DataSource = bsParent;
            bsChild.DataMember = "FK_Parent_Child";

            dataGridViewParent.DataSource = bsParent;
            dataGridViewChild.DataSource = bsChild;
        }

        private void Form1_Closed(object sender, System.EventArgs e)
        {
            dbConn.Close();
        }

       
    }
}
