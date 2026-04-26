using System;
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
            }
        }

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
                string.IsNullOrEmpty(date) || string.IsNullOrEmpty(guestName))
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
                        WHERE TableID = @TableID
                          AND ReservationDate = @Date
                          AND Schedule = @Time
                          AND Status <> 'Cancelled'";

                    using (SqlCommand chk = new SqlCommand(checkQ, conn))
                    {
                        chk.Parameters.AddWithValue("@TableID", tableID);
                        chk.Parameters.AddWithValue("@Date", date);
                        chk.Parameters.AddWithValue("@Time", time);

                        if ((int)chk.ExecuteScalar() > 0)
                        {
                            ShowAlert("That table is already reserved at this time. Please choose another slot.");
                            return;
                        }
                    }

                    // Insert
                    string insertQ = @"
                        INSERT INTO Reservations
                            (UserID, TableID, ReservationDate, Schedule, RentalType,
                             GuestName, ContactNo, GuestCount, HasDiscount, Status, CreatedAt)
                        VALUES
                            (@UserID, @TableID, @Date, @Time, @RentalType,
                             @GuestName, @ContactNo, @GuestCount, @Discount, 'Pending', GETDATE())";

                    using (SqlCommand ins = new SqlCommand(insertQ, conn))
                    {
                        ins.Parameters.AddWithValue("@UserID", userID);
                        ins.Parameters.AddWithValue("@TableID", tableID);
                        ins.Parameters.AddWithValue("@Date", date);
                        ins.Parameters.AddWithValue("@Time", time);
                        ins.Parameters.AddWithValue("@RentalType", rentalType);
                        ins.Parameters.AddWithValue("@GuestName", guestName);
                        ins.Parameters.AddWithValue("@ContactNo", contact);
                        ins.Parameters.AddWithValue("@GuestCount", guests);
                        ins.Parameters.AddWithValue("@Discount", discount);
                        ins.ExecuteNonQuery();
                    }
                }

                // Signal JS to show Step 4
                hdnStep.Value = "4";
                ScriptManager.RegisterStartupScript(
                    this, GetType(), "success", "showSuccess();", true);
            }
            catch (Exception ex)
            {
                ShowAlert("Error: " + ex.Message);
            }
        }

        private void ShowAlert(string msg)
        {
            msg = msg.Replace("'", "\\'");
            ScriptManager.RegisterStartupScript(
                this, GetType(), "alert", $"alert('{msg}');", true);
        }
    }
}