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
    public partial class open_page : Form
    {
        public open_page()
        {

            InitializeComponent();
            if(Form1.flag == "Guest")
            {
                button2.Visible = false;
                button3.Visible = false;
                linkLabel1.Visible =false;
            }else if(Form1.flag == "User")
            {
                //add Buttons 

            }
            else
            {
                // add Buttons

            }
        
      
        }


        private void label5_Click(object sender, EventArgs e)
        {

        }

        private void label2_Click(object sender, EventArgs e)
        {

        }
     
        private void button1_Click_1(object sender, EventArgs e)
        {
            {

                SqlConnection sqlCon = new SqlConnection(@"Data Source = DESKTOP-OG26RM1\SQLEXPRESS; 
                                                           Initial Catalog = food;
                                                           Integrated Security = True;");
                sqlCon.Open();
                SqlCommand command = new SqlCommand("GetStoredProc", sqlCon);
                string kind = comboBox1.Text;
                string type = comboBox2.Text;
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add(new SqlParameter("@TypeOfRecipe", kind));
                command.Parameters.Add(new SqlParameter("@LevelOfRecipe", type));

       
                SqlDataReader reader = command.ExecuteReader();
                while (reader.Read())
                {
                    richTextBox1.Text = richTextBox1.Text
                        + "PublisherID: " + reader[0].ToString().Trim() + "\r\n"
                        + "Description: " + reader[1].ToString().Trim() + "\r\n"
                        + "Type: " + reader[2].ToString().Trim() + "\r\n"
                        + "Level: " + reader[3].ToString().Trim() + "\r\n";
                        
                }

            }
        }

        private void button2_Click(object sender, EventArgs e)
        {

        }

        private void button3_Click(object sender, EventArgs e)
        {

        }

        private void linkLabel1_Click(object sender, EventArgs e)
        {
            this.Visible = false;
            Form2 newForm = new Form2();
            newForm.Show();
        }
    }
}
