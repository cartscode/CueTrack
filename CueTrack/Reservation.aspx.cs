using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;

namespace CueTrack
{
    public partial class Reservation : Page
    {
        private readonly string connStr = ConfigurationManager
            .ConnectionStrings["CueTrackDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Default.aspx");
                return;
            }

            if (!IsPostBack)
            {
                litUserName.Text = Session["FirstName"]?.ToString() ?? "Guest";

                // Mark fully-reserved tables for today using stored procedure
                string today = DateTime.Today.ToString("yyyy-MM-dd");
                var reservedTables = GetReservedTablesForDate(today);
                string js = $"var serverReservedTables = [{string.Join(",", reservedTables)}];";
                ScriptManager.RegisterStartupScript(this, GetType(), "initTables", js, true);
            }
        }

        // ── LOAD TIME SLOTS ────────────────────────────────────
        protected void BtnLoadSlots_Click(object sender, EventArgs e)
        {
            string tableID = hdnTableID.Value;
            string date = hdnDate.Value;

            if (string.IsNullOrEmpty(tableID) || string.IsNullOrEmpty(date))
                return;

            var takenSlots = GetReservedSlotsForTable(int.Parse(tableID), date);

            // Build JS array — double quotes must match ALL_SLOTS strings exactly
            string slotsJson = "[" + string.Join(",",
                takenSlots.ConvertAll(s => "\"" + s.Trim() + "\"")) + "]";

            // Use Page.ClientScript instead of ScriptManager for hidden button postbacks
            Page.ClientScript.RegisterStartupScript(
                this.GetType(),
                "loadSlots_" + DateTime.Now.Ticks,
                "setTimeout(function(){ loadReservedSlots(" + slotsJson + "); }, 50);",
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

            // Validate
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

                    // ── Double-booking check ──────────────────
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

                    // ── Insert reservation ────────────────────
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

                // Move to success step
                hdnStep.Value = "4";
            }
            catch (Exception ex)
            {
                ShowAlert("Error saving reservation: " + ex.Message);
            }
        }

        // ── STORED PROCEDURE: Get reserved slots ───────────────
        private List<string> GetReservedSlotsForTable(int tableID, string date)
        {
            var list = new List<string>();
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // Use inline SQL to avoid any SP issues
                    string q = @"SELECT Schedule FROM Reservations
                         WHERE TableID = @TableID
                           AND CONVERT(DATE, ReservationDate) = CONVERT(DATE, @Date)
                           AND Status <> 'Cancelled'";

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
                System.Diagnostics.Debug.WriteLine("Slot error: " + ex.Message);
            }
            return list;
        }

        // ── STORED PROCEDURE: Get reserved tables ──────────────
        private List<int> GetReservedTablesForDate(string date)
        {
            var list = new List<int>();
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    using (SqlCommand cmd = new SqlCommand("sp_GetReservedTablesForDate", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@Date",
                            DateTime.Parse(date).ToString("yyyy-MM-dd"));

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

        private void ShowAlert(string msg)
        {
            msg = msg.Replace("'", "\\'").Replace("\r", "").Replace("\n", "");
            ScriptManager.RegisterStartupScript(this, GetType(),
                "alert", $"alert('{msg}');", true);
        }
    }
}