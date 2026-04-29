using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Configuration;
using System.Security.Cryptography;
using System.Text;
using System.Web.UI;
using System.Net;
using System.Net.Mail;

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
                string firstName = Session["FirstName"]?.ToString() ?? "Guest";
                string lastName = Session["LastName"]?.ToString() ?? "";
                string email = Session["Email"]?.ToString() ?? "";
                string phone = Session["PhoneNo"]?.ToString() ?? "";

                litUserName.Text = firstName;
                litUserName2.Text = firstName + " " + lastName;
                litUserEmail.Text = email;

                txtSettingsFirstName.Text = firstName;
                txtSettingsLastName.Text = lastName;
                txtSettingsPhone.Text = phone;

                string safeEmail = email.Replace("'", "\\'");
                ScriptManager.RegisterStartupScript(this, GetType(), "sessionEmail",
                    $"var SESSION_EMAIL = '{safeEmail}';", true);

                // First load: Table 1 + today
                string today = DateTime.Today.ToString("yyyy-MM-dd");
                var initSlots = GetReservedSlotsForTable(1, today);
                string slotsJson = ToJsonArray(initSlots);
                ScriptManager.RegisterStartupScript(this, GetType(), "initSlots",
                    $"var serverInitSlots = {slotsJson};", true);
            }
            else
            {
                // ✅ REMOVED slot re-emit from here — BtnLoadSlots_Click handles it
                // Only handle step 4 restore
                if (hdnStep.Value == "4")
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "restoreSuccess",
                        "showSuccess();", true);
                }
            }

            // Always re-emit reserved tables
            string todayStr = DateTime.Today.ToString("yyyy-MM-dd");
            var reservedTables = GetReservedTablesForDate(todayStr);
            string tablesJs = $"var serverReservedTables = [{string.Join(",", reservedTables)}];";
            ScriptManager.RegisterStartupScript(this, GetType(), "reservedTables", tablesJs, true);
        }

        // ── LOAD TIME SLOTS (date change) ──────────────────────
        protected void BtnLoadSlots_Click(object sender, EventArgs e)
        {
            string tableID = hdnTableID.Value;
            string date = hdnDate.Value;

            if (string.IsNullOrEmpty(tableID) || string.IsNullOrEmpty(date))
                return;

            var taken = GetReservedSlotsForTable(int.Parse(tableID), date);
            string slotsJson = ToJsonArray(taken);

            // ✅ Set BOTH the variable AND call the function
            // The variable is read by DOMContentLoaded, the function call re-renders after postback
            ScriptManager.RegisterStartupScript(this, GetType(), "initSlots",
                $"var serverInitSlots = {slotsJson}; loadReservedSlots({slotsJson});", true);
        }
        // ── SEND EMAIL ─────────────────────────────────────────
        private void SendEmail(string toAddress, string subject, string htmlBody)
        {
            string smtpHost = ConfigurationManager.AppSettings["SmtpHost"] ?? "smtp.gmail.com";
            int smtpPort = int.Parse(ConfigurationManager.AppSettings["SmtpPort"] ?? "587");
            bool enableSsl = bool.Parse(ConfigurationManager.AppSettings["SmtpEnableSsl"] ?? "true");
            string smtpUser = ConfigurationManager.AppSettings["SmtpUser"] ?? "";
            string smtpPass = ConfigurationManager.AppSettings["SmtpPass"] ?? "";
            string fromAddress = ConfigurationManager.AppSettings["SmtpFromEmail"] ?? smtpUser;
            string fromName = ConfigurationManager.AppSettings["SmtpFromName"] ?? "CueTrack";

            using (var mail = new MailMessage())
            {
                mail.From = new MailAddress(fromAddress, fromName);
                mail.Subject = subject;
                mail.Body = htmlBody;
                mail.IsBodyHtml = true;
                mail.To.Add(toAddress);

                using (var smtp = new SmtpClient(smtpHost, smtpPort))
                {
                    smtp.EnableSsl = enableSsl;
                    smtp.DeliveryMethod = SmtpDeliveryMethod.Network;
                    smtp.UseDefaultCredentials = false;
                    smtp.Credentials = new NetworkCredential(smtpUser, smtpPass);
                    smtp.Send(mail);
                }
            }
        }

        // ── BUILD EMAIL HTML ───────────────────────────────────
        private string BuildConfirmationEmail(
            string firstName, string guestName, string tableID,
            string date, string time, string rentalType,
            string contact, string guests, bool discount, int hours)
        {
            string rateDisplay;
            if (rentalType == "Rental Time")
            {
                int rate = discount ? 300 : 350;
                int total = rate * hours;
                rateDisplay = hours > 1
                    ? $"₱{total} total ({hours} hrs × ₱{rate}{(discount ? ", discounted" : "")})"
                    : $"₱{rate}/hr{(discount ? " (discounted)" : "")}";
            }
            else
            {
                rateDisplay = discount ? "₱300/hr (discounted) – billed at end" : "₱350/hr – billed at end";
            }

            string guestCountLabel = string.IsNullOrEmpty(guests) ? "1" : guests;
            string discountLabel = discount ? "Yes (Student / PWD / Senior)" : "None";
            string formattedDate = date;
            if (DateTime.TryParse(date, out DateTime parsedDate))
                formattedDate = parsedDate.ToString("MMMM dd, yyyy");

            return $@"<!DOCTYPE html>
<html>
<body style='margin:0;padding:0;background:#0f0f0f;font-family:Arial,sans-serif;'>
<table width='100%' cellpadding='0' cellspacing='0' style='background:#0f0f0f;padding:30px 0;'>
  <tr><td align='center'>
    <table width='560' cellpadding='0' cellspacing='0'
           style='background:#1a1a1a;border-radius:16px;overflow:hidden;border:1px solid #2a2a2a;max-width:560px;width:100%;'>
      <tr>
        <td style='background:linear-gradient(135deg,#FF8C00,#FF6A00);padding:28px 32px;text-align:center;'>
          <p style='margin:0;font-size:28px;'>🎱</p>
          <h1 style='margin:8px 0 4px;font-size:26px;font-weight:900;color:#000;text-transform:uppercase;letter-spacing:2px;'>Reservation Confirmed</h1>
          <p style='margin:0;font-size:13px;color:rgba(0,0,0,0.65);font-weight:600;'>CueTrack Billiards Hall</p>
        </td>
      </tr>
      <tr>
        <td style='padding:28px 32px 0;'>
          <p style='margin:0;font-size:15px;color:#f0f0f0;'>Hi <strong style='color:#FF8C00;'>{firstName}</strong>,</p>
          <p style='margin:8px 0 0;font-size:14px;color:#888;line-height:1.6;'>Your reservation is confirmed and pending approval. Here's your booking summary:</p>
        </td>
      </tr>
      <tr>
        <td style='padding:20px 32px;'>
          <table width='100%' cellpadding='0' cellspacing='0' style='background:#111;border-radius:12px;border:1px solid #2a2a2a;'>
            {EmailRow("📅 Date", formattedDate, true)}
            {EmailRow("🕐 Time", time, false)}
            {EmailRow("🎱 Table", "Table " + tableID, true)}
            {EmailRow("📋 Rental Type", rentalType, false)}
            {EmailRow("⏱ Duration", hours == 1 ? "1 hour" : hours + " hours", true)}
            {EmailRow("👤 Guest Name", guestName, false)}
            {EmailRow("📞 Contact", contact, true)}
            {EmailRow("👥 No. of Guests", guestCountLabel, false)}
            {EmailRow("🏷 Discount", discountLabel, true)}
            {EmailRow("💰 Rate", rateDisplay, false)}
          </table>
        </td>
      </tr>
      <tr>
        <td style='padding:0 32px 24px;'>
          <table width='100%' cellpadding='0' cellspacing='0'
                 style='background:rgba(255,140,0,0.08);border:1px solid #FF8C00;border-radius:10px;padding:14px 18px;'>
            <tr><td>
              <p style='margin:0;font-size:13px;color:#FF8C00;font-weight:700;text-transform:uppercase;letter-spacing:1px;'>⏳ Status: Pending Approval</p>
              <p style='margin:6px 0 0;font-size:12px;color:#888;line-height:1.5;'>Our staff will review your booking shortly. Please bring a valid ID if a discount was applied.</p>
            </td></tr>
          </table>
        </td>
      </tr>
      <tr>
        <td style='padding:0 32px 28px;'>
          <table width='100%' cellpadding='0' cellspacing='0'
                 style='background:#161616;border:1px solid #2a2a2a;border-radius:10px;padding:14px 18px;'>
            <tr><td>
              <p style='margin:0;font-size:12px;color:#888;line-height:1.7;'>
                📌 <strong style='color:#f0f0f0;'>Reminders:</strong><br/>
                • Arrive at least 5 minutes before your scheduled time.<br/>
                • Bring a valid ID if you applied for a Student / PWD / Senior discount.<br/>
                • Contact us if you need to cancel or reschedule.
              </p>
            </td></tr>
          </table>
        </td>
      </tr>
      <tr>
        <td style='background:#111;padding:18px 32px;text-align:center;border-top:1px solid #2a2a2a;'>
          <p style='margin:0;font-size:12px;color:#555;'>This is an automated confirmation from <strong style='color:#FF8C00;'>CueTrack</strong>. Please do not reply.</p>
        </td>
      </tr>
    </table>
  </td></tr>
</table>
</body>
</html>";
        }

        // ── EMAIL ROW HELPER ───────────────────────────────────
        private string EmailRow(string label, string value, bool shaded)
        {
            string bg = shaded ? "background:#161616;" : "";
            return $@"<tr>
              <td style='{bg}padding:12px 18px;border-bottom:1px solid #2a2a2a;font-size:12px;color:#888;font-weight:700;text-transform:uppercase;width:38%;vertical-align:top;'>{label}</td>
              <td style='{bg}padding:12px 18px;border-bottom:1px solid #2a2a2a;font-size:13px;color:#f0f0f0;font-weight:600;vertical-align:top;'>{value}</td>
            </tr>";
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
            string userEmail = Session["Email"]?.ToString() ?? "";
            string firstName = Session["FirstName"]?.ToString() ?? "Guest";

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
                    int hours = int.Parse(string.IsNullOrEmpty(hdnHours.Value) ? "1" : hdnHours.Value);
                    if (hours > 1)
                    {
                        var ALL_SLOTS_CS = new List<string> {
        "3:00 PM","4:00 PM","5:00 PM","6:00 PM",
        "7:00 PM","8:00 PM","9:00 PM","10:00 PM",
        "11:00 PM","12:00 AM","1:00 AM","2:00 AM",
        "3:00 AM","4:00 AM","5:00 AM"
    };

                        int startIdx = ALL_SLOTS_CS.IndexOf(time);
                        for (int i = startIdx + 1; i < startIdx + hours && i < ALL_SLOTS_CS.Count; i++)
                        {
                            string blockQ = @"
            INSERT INTO Reservations
                (UserID, TableID, ReservationDate, Schedule,
                 RentalType, GuestName, ContactNo,
                 GuestCount, HasDiscount, Status, CreatedAt)
            VALUES
                (@UserID, @TableID, @Date, @Time,
                 @RentalType, @GuestName, @ContactNo,
                 @GuestCount, @Discount, 'Pending', GETDATE())";

                            using (SqlCommand blk = new SqlCommand(blockQ, conn))
                            {
                                blk.Parameters.AddWithValue("@UserID", int.Parse(userID));
                                blk.Parameters.AddWithValue("@TableID", int.Parse(tableID));
                                blk.Parameters.AddWithValue("@Date", date);
                                blk.Parameters.AddWithValue("@Time", ALL_SLOTS_CS[i]);
                                blk.Parameters.AddWithValue("@RentalType", rentalType);
                                blk.Parameters.AddWithValue("@GuestName", guestName);
                                blk.Parameters.AddWithValue("@ContactNo", contact);
                                blk.Parameters.AddWithValue("@GuestCount", string.IsNullOrEmpty(guests) ? 1 : int.Parse(guests));
                                blk.Parameters.AddWithValue("@Discount", discount);
                                blk.ExecuteNonQuery();
                            }
                        }
                    }
                }

                hdnStep.Value = "4";
                ScriptManager.RegisterStartupScript(this, GetType(), "showOK",
                    "showSuccess();", true);

                // ── Send confirmation email ──────────────────────
                if (!string.IsNullOrEmpty(userEmail))
                {
                    try
                    {
                        int hours = int.Parse(string.IsNullOrEmpty(hdnHours.Value) ? "1" : hdnHours.Value);
                        SendEmail(userEmail, "CueTrack – Reservation Confirmed 🎱",
                            BuildConfirmationEmail(firstName, guestName, tableID, date,
                                time, rentalType, contact, guests, discount, hours));
                    }
                    catch (Exception emailEx)
                    {
                        System.Diagnostics.Debug.WriteLine("Email error: " + emailEx.Message);
                    }
                }
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
                        string updQ = @"UPDATE Users SET FirstName=@FN,LastName=@LN,PhoneNo=@PH,Password=@PW WHERE UserID=@ID";
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
                        string updQ = @"UPDATE Users SET FirstName=@FN,LastName=@LN,PhoneNo=@PH WHERE UserID=@ID";
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

                Session["FirstName"] = firstName;
                Session["LastName"] = lastName;
                Session["PhoneNo"] = phone;

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
                string safeMsg = ex.Message.Replace("'", "\\'").Replace("\r", "").Replace("\n", "");
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

        // ── HELPERS ────────────────────────────────────────────
        private List<string> GetReservedSlotsForTable(int tableID, string date)
        {
            var list = new List<string>();
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // Get all reservations for this table/date
                    string q = @"
                SELECT Schedule, RentalType FROM Reservations
                WHERE  TableID = @TableID
                  AND  CONVERT(DATE, ReservationDate) = CONVERT(DATE, @Date)
                  AND  Status <> 'Cancelled'
                ORDER BY Schedule";

                    var ALL_SLOTS_CS = new List<string> {
                "3:00 PM","4:00 PM","5:00 PM","6:00 PM",
                "7:00 PM","8:00 PM","9:00 PM","10:00 PM",
                "11:00 PM","12:00 AM","1:00 AM","2:00 AM",
                "3:00 AM","4:00 AM","5:00 AM"
            };

                    using (SqlCommand cmd = new SqlCommand(q, conn))
                    {
                        cmd.Parameters.AddWithValue("@TableID", tableID);
                        cmd.Parameters.AddWithValue("@Date", date);

                        using (var r = cmd.ExecuteReader())
                        {
                            while (r.Read())
                            {
                                string schedule = r.GetString(0).Trim();
                                string rentalType = r.GetString(1).Trim();

                                list.Add(schedule);

                                // If Open Time, block all slots after this one
                                if (rentalType == "Open Time")
                                {
                                    int idx = ALL_SLOTS_CS.IndexOf(schedule);
                                    if (idx >= 0)
                                    {
                                        for (int i = idx + 1; i < ALL_SLOTS_CS.Count; i++)
                                        {
                                            if (!list.Contains(ALL_SLOTS_CS[i]))
                                                list.Add(ALL_SLOTS_CS[i]);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("GetSlots error: " + ex.Message);
            }
            return list;
        }
        private List<int> GetReservedTablesForDate(string date)
        {
            var list = new List<int>();
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string q = @"
                        SELECT TableID FROM Reservations
                        WHERE  CONVERT(DATE, ReservationDate) = CONVERT(DATE, @Date)
                          AND  Status <> 'Cancelled'
                        GROUP  BY TableID
                        HAVING COUNT(*) >= 15";
                    using (SqlCommand cmd = new SqlCommand(q, conn))
                    {
                        cmd.Parameters.AddWithValue("@Date", date);
                        using (var r = cmd.ExecuteReader())
                            while (r.Read()) list.Add(r.GetInt32(0));
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("GetReservedTables error: " + ex.Message);
            }
            return list;
        }

        private string ToJsonArray(List<string> items)
        {
            return "[" + string.Join(",", items.ConvertAll(s => "\"" + s.Trim() + "\"")) + "]";
        }

        private string HashPassword(string password)
        {
            using (var sha256 = SHA256.Create())
            {
                byte[] bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
                var sb = new StringBuilder();
                foreach (byte b in bytes) sb.Append(b.ToString("x2"));
                return sb.ToString();
            }
        }

        private void ShowAlert(string msg)
        {
            msg = msg.Replace("'", "\\'").Replace("\r", "").Replace("\n", "");
            ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                $"alert('{msg}');", true);
        }

    }

}