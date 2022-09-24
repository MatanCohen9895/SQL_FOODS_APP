using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data;
using System.Data.SqlClient;

namespace Ex3
{
    public partial class User_page : Form
    {
        private object publisherid;

        public User_page()
        {
            InitializeComponent();
        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            SqlConnection sqlCon = new SqlConnection(@"Data Source = DESKTOP-OG26RM1\SQLEXPRESS; 
                                                           Initial Catalog = food;
                                                           Integrated Security = True;");
            sqlCon.Open();
            SqlCommand command = new SqlCommand(null, sqlCon);
            SqlCommand command2 = new SqlCommand(null, sqlCon);
            command.CommandText =
            "INSERT INTO Recipes(RecipeID, PublisherID, SubFoodCategoryID, Title, Description, TotalTime, Type, Level, PublicationDate)" +
               "VALUES(@RecipeID,@PublisherID,@SubFoodCategoryID,@Title,@Description,@TotalTime,@Type,@Level,@PublicationDate)";
            SqlParameter RecipeID = new SqlParameter("@RecipeID", SqlDbType.SmallInt);
            SqlParameter PublisherID = new SqlParameter("@PublisherID", SqlDbType.SmallInt);
            SqlParameter SubFoodCategoryID = new SqlParameter("@SubFoodCategoryID", SqlDbType.SmallInt);
            SqlParameter Title = new SqlParameter("@Title", SqlDbType.VarChar, 20);
            SqlParameter Description = new SqlParameter("@pass", SqlDbType.VarChar, 500);
            SqlParameter TotalTime = new SqlParameter("@TotalTime", SqlDbType.Float);
            SqlParameter Type = new SqlParameter("@Type", SqlDbType.VarChar, 10);
            SqlParameter Level = new SqlParameter("@Level", SqlDbType.VarChar, 10);
            SqlParameter PublicationDate = new SqlParameter("@PublicationDate", SqlDbType.DateTime);
            PublisherID.Value = textBox2.Text;
            SubFoodCategoryID.Value = textBox3.Text;
            Title.Value = textBox4.Text;
            Description.Value = textBox5.Text;
            TotalTime.Value = textBox6.Text;
            Type.Value = comboBox1.Text;
            Level.Value = comboBox2.Text;
            PublicationDate.Value = DateTime.Now;

            command2.CommandText =
                    "SELECT top 1 * FROM Recipes ORDER BY RecipeID DESC";
            command2.Prepare();
            SqlDataReader reader = command2.ExecuteReader();
            RecipeID.Value =Int16.Parse(reader.GetValue(0).ToString()) + 1;


            command.Parameters.Add(RecipeID);
            command.Parameters.Add(PublisherID);
            command.Parameters.Add(SubFoodCategoryID);
            command.Parameters.Add(Title);
            command.Parameters.Add(Description);
            command.Parameters.Add(TotalTime);
            command.Parameters.Add(Type);
            command.Parameters.Add(Level);
            command.Parameters.Add(PublicationDate);
            command.Prepare();
            command.ExecuteNonQuery();

        }

        private void button2_Click(object sender, EventArgs e)
        {
            this.Visible = false;
            open_page newForm = new open_page();
            newForm.Show();
        }
    }
}
