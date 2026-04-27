using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Security.Cryptography;
using System.Text;
using System.Web.UI;

namespace CueTrack
{
    public partial class CashierLogin : Page
    {
        // ── Change this to match the secret code management distributes ──
        private const string STAFF_ACCESS_CODE = "SHARKS2026";

        private readonly string connStr = ConfigurationManager
            .ConnectionStrings["CueTrackDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Already logged-in cashier → redirect to dashboard
            if (Session["CashierID"] != null)
                Response.Redirect("CashierDashboard.aspx");
        }

        // ── LOGIN ──────────────────────────────────────────────
        protected void BtnLogin_Click(object sender, EventArgs e)
        {
            string email = txtLoginEmail.Text.Trim();
            string password = txtLoginPassword.Text.Trim();

            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
            {
                ShowAlert("Please enter your email and password.", "error");
                return;
            }

            string hashed = HashPassword(password);

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string q = @"
                        SELECT CashierID, FirstName, LastName, Email
                        FROM   Cashiers
                        WHERE  Email    = @Email
                          AND  Password = @Password
                          AND  IsActive = 1";

                    using (SqlCommand cmd = new SqlCommand(q, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        cmd.Parameters.AddWithValue("@Password", hashed);

                        using (var r = cmd.ExecuteReader())
                        {
                            if (r.Read())
                            {
                                Session["CashierID"] = r["CashierID"].ToString();
                                Session["CashierFirstName"] = r["FirstName"].ToString();
                                Session["CashierLastName"] = r["LastName"].ToString();
                                Session["CashierEmail"] = r["Email"].ToString();

                                Response.Redirect("CashierDashboard.aspx");
                            }
                            else
                            {
                                ShowAlert("Invalid email or password.", "error");
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error: " + ex.Message, "error");
            }
        }

        // ── REGISTER ───────────────────────────────────────────
        protected void BtnRegister_Click(object sender, EventArgs e)
        {
            string firstName = txtFirstName.Text.Trim();
            string lastName = txtLastName.Text.Trim();
            string phone = txtPhone.Text.Trim();
            string email = txtEmail.Text.Trim();
            string accessCode = txtAccessCode.Text.Trim().ToUpper();
            string password = txtPassword.Text.Trim();

            // Validate access code
            if (accessCode != STAFF_ACCESS_CODE)
            {
                ShowAlert("Invalid staff access code. Contact management.", "error");
                SetTab("register");
                return;
            }

            if (string.IsNullOrEmpty(firstName) || string.IsNullOrEmpty(lastName) ||
                string.IsNullOrEmpty(phone) || string.IsNullOrEmpty(email) ||
                string.IsNullOrEmpty(password))
            {
                ShowAlert("Please fill in all fields.", "error");
                SetTab("register");
                return;
            }

            if (password.Length < 6)
            {
                ShowAlert("Password must be at least 6 characters.", "error");
                SetTab("register");
                return;
            }

            string hashed = HashPassword(password);

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // Duplicate email check
                    string checkQ = "SELECT COUNT(*) FROM Cashiers WHERE Email = @Email";
                    using (SqlCommand chk = new SqlCommand(checkQ, conn))
                    {
                        chk.Parameters.AddWithValue("@Email", email);
                        if ((int)chk.ExecuteScalar() > 0)
                        {
                            ShowAlert("That email is already registered.", "error");
                            SetTab("register");
                            return;
                        }
                    }

                    string insertQ = @"
                        INSERT INTO Cashiers
                            (FirstName, LastName, PhoneNo, Email, Password, IsActive, CreatedAt)
                        VALUES
                            (@FirstName, @LastName, @Phone, @Email, @Password, 1, GETDATE())";

                    using (SqlCommand ins = new SqlCommand(insertQ, conn))
                    {
                        ins.Parameters.AddWithValue("@FirstName", firstName);
                        ins.Parameters.AddWithValue("@LastName", lastName);
                        ins.Parameters.AddWithValue("@Phone", phone);
                        ins.Parameters.AddWithValue("@Email", email);
                        ins.Parameters.AddWithValue("@Password", hashed);
                        ins.ExecuteNonQuery();
                    }
                }

                ShowAlert("Account created! You can now log in.", "success");
                SetTab("login");
            }
            catch (Exception ex)
            {
                ShowAlert("Error: " + ex.Message, "error");
                SetTab("register");
            }
        }

        // ── HELPERS ────────────────────────────────────────────
        private string HashPassword(string password)
        {
            using (SHA256 sha = SHA256.Create())
            {
                byte[] bytes = sha.ComputeHash(Encoding.UTF8.GetBytes(password));
                var sb = new StringBuilder();
                foreach (byte b in bytes)
                    sb.Append(b.ToString("x2"));
                return sb.ToString();
            }
        }

        private void ShowAlert(string msg, string type)
        {
            string safe = msg.Replace("'", "\\'")
                             .Replace("\r", "")
                             .Replace("\n", "");
            ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                $"showAlert('{safe}', '{type}');", true);
        }

        private void SetTab(string tab)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "setTab",
                $"switchTab('{tab}');", true);
        }
    }
}
