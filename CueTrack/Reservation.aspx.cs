using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Security.Cryptography;
using System.Text;
using System.Web.UI;

namespace CueTrack
{
    public partial class Reservation : Page
    {
        private readonly string connStr = ConfigurationManager
            .ConnectionStrings["CueTrackDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // ── Auth guard ───────────────────────────────────
            if (Session["UserID"] == null)
            {
                Response.Redirect("Default.aspx");
                return;
            }

            if (!IsPostBack)
            {
                string firstName = Session["FirstName"]?.ToString() ?? "Guest";
                string lastName = Session["LastName"]?.ToString() ?? "";
                string email = Session["Email"]?.ToString() ?? "";
                string phone = Session["PhoneNo"]?.ToString() ?? "";

                // Navbar
                litUserName.Text = firstName;
                litUserName2.Text = firstName + " " + lastName;
                litUserEmail.Text = email;

                // Settings modal pre-fill
                txtSettingsFirstName.Text = firstName;
                txtSettingsLastName.Text = lastName;
                txtSettingsPhone.Text = phone;

                // Emit session email to JS for settings modal
                string safeEmail = email.Replace("'", "\\'");
                ScriptManager.RegisterStartupScript(this, GetType(), "sessionEmail",
                    $"var SESSION_EMAIL = '{safeEmail}';", true);

                // Reserved tables for today
                string today = DateTime.Today.ToString("yyyy-MM-dd");
                var reservedTables = GetReservedTablesForDate(today);
                string tablesJs = $"var serverReservedTables = [{string.Join(",", reservedTables)}];";

                // Pre-load slots for Table 1 + today
                var initSlots = GetReservedSlotsForTable(1, today);
                string slotsJson = "[" + string.Join(",",
                    initSlots.ConvertAll(s => "\"" + s.Trim() + "\"")) + "]";
                string slotsJs = $"var serverInitSlots = {slotsJson};";

                ScriptManager.RegisterStartupScript(this, GetType(), "initData",
                    tablesJs + slotsJs, true);
            }
            else
            {
                // Restore step 4 success screen after postback
                if (hdnStep.Value == "4")
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "restoreSuccess",
                        "showSuccess();", true);
                }
            }
        }

        // ── LOAD TIME SLOTS ────────────────────────────────────
        protected void BtnLoadSlots_Click(object sender, EventArgs e)
        {
            string tableID = hdnTableID.Value;
            string date = hdnDate.Value;

            if (string.IsNullOrEmpty(tableID) || string.IsNullOrEmpty(date))
                return;

            var taken = GetReservedSlotsForTable(int.Parse(tableID), date);

            string slotsJson = "[" + string.Join(",",
                taken.ConvertAll(s => "\"" + s.Trim() + "\"")) + "]";

            ScriptManager.RegisterStartupScript(this, GetType(),
                "loadSlots",
                $"loadReservedSlots({slotsJson});",
                true);
        }

        // ── CONFIRM BOOKING ────────────────────────────────────
        protected void BtnConfirm_Click(object sender, EventArgs e)
        {
            string tableID = hdnTableID.Value;
            string time = hdnTime.Value;
            string date = hdnDate.Value;
            string rentalType = hdnRental.Value;
            string guestName = hdnGuestName.Value;
            string contact = hdnContact.Value;
            string guests = hdnGuests.Value;
             bool discount = hdnDiscount.Value == "1";
            string userID = Session["UserID"].ToString();

            if (string.IsNullOrEmpty(tableID) || string.IsNullOrEmpty(time) ||
                string.IsNullOrEmpty(date) || string.IsNullOrEmpty(guestName) ||
                string.IsNullOrEmpty(contact))
            {
                ShowAlert("Missing booking details. Please complete all fields.");
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // Double-booking check
                    string checkQ = @"
                        SELECT COUNT(*) FROM Reservations
                        WHERE  TableID         = @TableID
                          AND  ReservationDate = @Date
                          AND  Schedule        = @Time
                          AND  Status         <> 'Cancelled'";

                    using (SqlCommand chk = new SqlCommand(checkQ, conn))
                    {
                        chk.Parameters.AddWithValue("@TableID", int.Parse(tableID));
                        chk.Parameters.AddWithValue("@Date", date);
                        chk.Parameters.AddWithValue("@Time", time);

                        if ((int)chk.ExecuteScalar() > 0)
                        {
                            ShowAlert("That time slot is already taken. Please choose another.");
                            return;
                        }
                    }

                    // Insert reservation
                    string insertQ = @"
                        INSERT INTO Reservations
                            (UserID, TableID, ReservationDate, Schedule,
                             RentalType, GuestName, ContactNo,
                             GuestCount, HasDiscount, Status, CreatedAt)
                        VALUES
                            (@UserID, @TableID, @Date, @Time,
                             @RentalType, @GuestName, @ContactNo,
                             @GuestCount, @Discount, 'Pending', GETDATE())";

                    using (SqlCommand ins = new SqlCommand(insertQ, conn))
                    {
                        ins.Parameters.AddWithValue("@UserID", int.Parse(userID));
                        ins.Parameters.AddWithValue("@TableID", int.Parse(tableID));
                        ins.Parameters.AddWithValue("@Date", date);
                        ins.Parameters.AddWithValue("@Time", time);
                        ins.Parameters.AddWithValue("@RentalType", string.IsNullOrEmpty(rentalType) ? "Rental Time" : rentalType);
                        ins.Parameters.AddWithValue("@GuestName", guestName);
                        ins.Parameters.AddWithValue("@ContactNo", contact);
                        ins.Parameters.AddWithValue("@GuestCount", string.IsNullOrEmpty(guests) ? 1 : int.Parse(guests));
                        ins.Parameters.AddWithValue("@Discount", discount);
                        ins.ExecuteNonQuery();
                    }
                }

                hdnStep.Value = "4";
                ScriptManager.RegisterStartupScript(this, GetType(), "showOK",
                    "showSuccess();", true);
            }
            catch (Exception ex)
            {
                ShowAlert("Error saving reservation: " + ex.Message);
            }
        }

        // ── SAVE SETTINGS ──────────────────────────────────────
        protected void BtnSaveSettings_Click(object sender, EventArgs e)
        {
            string userID = Session["UserID"].ToString();
            string firstName = hdnNewFirstName.Value.Trim();
            string lastName = hdnNewLastName.Value.Trim();
            string phone = hdnNewPhone.Value.Trim();
            string newPass = hdnNewPassword.Value.Trim();
            string oldPass = hdnOldPassword.Value.Trim();

            if (string.IsNullOrEmpty(firstName) || string.IsNullOrEmpty(lastName) ||
                string.IsNullOrEmpty(phone))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "settingsErr",
                    "showSettingsError('Name and phone cannot be empty.');", true);
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    if (!string.IsNullOrEmpty(newPass))
                    {
                        // Verify old password first
                        if (string.IsNullOrEmpty(oldPass))
                        {
                            ScriptManager.RegisterStartupScript(this, GetType(), "settingsErr",
                                "showSettingsError('Please enter your current password to change it.');", true);
                            return;
                        }

                        string hashedOld = HashPassword(oldPass);
                        string checkQ = "SELECT COUNT(*) FROM Users WHERE UserID=@ID AND Password=@Pass";
                        using (SqlCommand chk = new SqlCommand(checkQ, conn))
                        {
                            chk.Parameters.AddWithValue("@ID", int.Parse(userID));
                            chk.Parameters.AddWithValue("@Pass", hashedOld);
                            if ((int)chk.ExecuteScalar() == 0)
                            {
                                ScriptManager.RegisterStartupScript(this, GetType(), "settingsErr",
                                    "showSettingsError('Current password is incorrect.');", true);
                                return;
                            }
                        }

                        string hashedNew = HashPassword(newPass);
                        string updQ = @"UPDATE Users
                                        SET FirstName=@FN, LastName=@LN,
                                            PhoneNo=@PH, Password=@PW
                                        WHERE UserID=@ID";
                        using (SqlCommand upd = new SqlCommand(updQ, conn))
                        {
                            upd.Parameters.AddWithValue("@FN", firstName);
                            upd.Parameters.AddWithValue("@LN", lastName);
                            upd.Parameters.AddWithValue("@PH", phone);
                            upd.Parameters.AddWithValue("@PW", hashedNew);
                            upd.Parameters.AddWithValue("@ID", int.Parse(userID));
                            upd.ExecuteNonQuery();
                        }
                    }
                    else
                    {
                        string updQ = @"UPDATE Users
                                        SET FirstName=@FN, LastName=@LN, PhoneNo=@PH
                                        WHERE UserID=@ID";
                        using (SqlCommand upd = new SqlCommand(updQ, conn))
                        {
                            upd.Parameters.AddWithValue("@FN", firstName);
                            upd.Parameters.AddWithValue("@LN", lastName);
                            upd.Parameters.AddWithValue("@PH", phone);
                            upd.Parameters.AddWithValue("@ID", int.Parse(userID));
                            upd.ExecuteNonQuery();
                        }
                    }
                }

                // Update session
                Session["FirstName"] = firstName;
                Session["LastName"] = lastName;
                Session["PhoneNo"] = phone;

                // Refresh navbar literals
                litUserName.Text = firstName;
                litUserName2.Text = firstName + " " + lastName;
                txtSettingsFirstName.Text = firstName;
                txtSettingsLastName.Text = lastName;
                txtSettingsPhone.Text = phone;

                ScriptManager.RegisterStartupScript(this, GetType(), "settingsOk",
                    "showSettingsSuccess();", true);
            }
            catch (Exception ex)
            {
                string safeMsg = ex.Message
                    .Replace("'", "\\'")
                    .Replace("\r", "")
                    .Replace("\n", "");
                ScriptManager.RegisterStartupScript(this, GetType(), "settingsErr",
                    $"showSettingsError('Error: {safeMsg}');", true);
            }
        }

        // ── LOGOUT ─────────────────────────────────────────────
        protected void BtnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Default.aspx");
        }

        // ── GET RESERVED SLOTS ─────────────────────────────────
        private List<string> GetReservedSlotsForTable(int tableID, string date)
        {
            var list = new List<string>();
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string q = @"
                        SELECT Schedule FROM Reservations
                        WHERE  TableID = @TableID
                          AND  CONVERT(DATE, ReservationDate) = CONVERT(DATE, @Date)
                          AND  Status <> 'Cancelled'";

                    using (SqlCommand cmd = new SqlCommand(q, conn))
                    {
                        cmd.Parameters.AddWithValue("@TableID", tableID);
                        cmd.Parameters.AddWithValue("@Date", date);
                        using (SqlDataReader r = cmd.ExecuteReader())
                            while (r.Read())
                                list.Add(r.GetString(0).Trim());
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("GetSlots error: " + ex.Message);
            }
            return list;
        }

        // ── GET FULLY-RESERVED TABLES ──────────────────────────
        private List<int> GetReservedTablesForDate(string date)
        {
            var list = new List<int>();
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string q = @"
                        SELECT TableID
                        FROM   Reservations
                        WHERE  CONVERT(DATE, ReservationDate) = CONVERT(DATE, @Date)
                          AND  Status <> 'Cancelled'
                        GROUP  BY TableID
                        HAVING COUNT(*) >= 15";

                    using (SqlCommand cmd = new SqlCommand(q, conn))
                    {
                        cmd.Parameters.AddWithValue("@Date", date);
                        using (SqlDataReader r = cmd.ExecuteReader())
                            while (r.Read())
                                list.Add(r.GetInt32(0));
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("GetReservedTables error: " + ex.Message);
            }
            return list;
        }

        // ── HASH PASSWORD ──────────────────────────────────────
        private string HashPassword(string password)
        {
            using (var sha256 = SHA256.Create())
            {
                byte[] bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
                var sb = new StringBuilder();
                foreach (byte b in bytes)
                    sb.Append(b.ToString("x2"));
                return sb.ToString();
            }
        }

        // ── SHOW ALERT ─────────────────────────────────────────
        private void ShowAlert(string msg)
        {
            msg = msg.Replace("'", "\\'")
                     .Replace("\r", "")
                     .Replace("\n", "");
            ScriptManager.RegisterStartupScript(this, GetType(),
                "alert", $"alert('{msg}');", true);
        }
    }
}