using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CueTrack
{
    public partial class WebForm1 : Page
    {
        private readonly string connStr = ConfigurationManager
            .ConnectionStrings["CueTrackDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        // ── REGISTER ──────────────────────────────────────────
        protected void BtnRegister_Click(object sender, EventArgs e)
        {
            string firstName = txtFirstname.Text.Trim();
            string lastName = txtLastname.Text.Trim();
            string phone = txtPhoneno.Text.Trim();
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();

            if (string.IsNullOrEmpty(firstName) || string.IsNullOrEmpty(lastName) ||
                string.IsNullOrEmpty(phone) || string.IsNullOrEmpty(email) ||
                string.IsNullOrEmpty(password))
            {
                ShowAlert("Please fill in all fields.");
                return;
            }

            string hashedPassword = HashPassword(password);

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    string checkQuery = "SELECT COUNT(*) FROM Users WHERE Email = @Email";
                    using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
                    {
                        checkCmd.Parameters.AddWithValue("@Email", email);
                        int count = (int)checkCmd.ExecuteScalar();
                        if (count > 0)
                        {
                            ShowAlert("Email already registered. Please login.");
                            return;
                        }
                    }

                    string insertQuery = @"
                        INSERT INTO Users (FirstName, LastName, PhoneNo, Email, Password)
                        VALUES (@FirstName, @LastName, @PhoneNo, @Email, @Password)";

                    using (SqlCommand insertCmd = new SqlCommand(insertQuery, conn))
                    {
                        insertCmd.Parameters.AddWithValue("@FirstName", firstName);
                        insertCmd.Parameters.AddWithValue("@LastName", lastName);
                        insertCmd.Parameters.AddWithValue("@PhoneNo", phone);
                        insertCmd.Parameters.AddWithValue("@Email", email);
                        insertCmd.Parameters.AddWithValue("@Password", hashedPassword);
                        insertCmd.ExecuteNonQuery();
                    }
                }

                ShowAlert("Registration successful! You can now login.");
                ClearRegisterFields();
            }
            catch (Exception ex)
            {
                ShowAlert("Error: " + ex.Message);
            }
        }

        // ── LOGIN ─────────────────────────────────────────────
        protected void BtnLogin_Click(object sender, EventArgs e)
        {
            string email = txtLoginEmail.Text.Trim();
            string password = txtLoginPassword.Text.Trim();

            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
            {
                ShowAlert("Please enter your email and password.");
                return;
            }

            string hashedPassword = HashPassword(password);

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // ✅ Include Email and PhoneNo so session is fully populated
                    string query = @"
                        SELECT UserID, FirstName, LastName, Email, PhoneNo
                        FROM Users
                        WHERE Email = @Email AND Password = @Password";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        cmd.Parameters.AddWithValue("@Password", hashedPassword);

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                Session["UserID"] = reader["UserID"].ToString();
                                Session["FirstName"] = reader["FirstName"].ToString();
                                Session["LastName"] = reader["LastName"].ToString();
                                Session["Email"] = reader["Email"].ToString();
                                Session["PhoneNo"] = reader["PhoneNo"].ToString();

                                Response.Redirect("Reservation.aspx");
                            }
                            else
                            {
                                ShowAlert("Invalid email or password.");
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error: " + ex.Message);
            }
        }

        // ── HELPERS ───────────────────────────────────────────
        private string HashPassword(string password)
        {
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
                StringBuilder sb = new StringBuilder();
                foreach (byte b in bytes)
                    sb.Append(b.ToString("x2"));
                return sb.ToString();
            }
        }

        private void ShowAlert(string message)
        {
            ScriptManager.RegisterStartupScript(
                this, this.GetType(), "alert",
                $"alert('{message}');", true);
        }

        private void ClearRegisterFields()
        {
            txtFirstname.Text = "";
            txtLastname.Text = "";
            txtPhoneno.Text = "";
            txtEmail.Text = "";
            txtPassword.Text = "";
        }
    }
}