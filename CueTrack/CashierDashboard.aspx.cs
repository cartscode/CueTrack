using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;

namespace CueTrack
{
    public partial class CashierDashboard : Page
    {
        private readonly string connStr = ConfigurationManager
            .ConnectionStrings["CueTrackDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Guard: must be logged in as cashier
            if (Session["CashierID"] == null)
            {
                Response.Redirect("Cashierlogin.aspx");
                return;
            }

            // Show cashier name in top bar
            string firstName = Session["CashierFirstName"]?.ToString() ?? "Cashier";
            litCashierName.Text = firstName;

            // Set staff avatar initial via script
            string initial = firstName.Length > 0 ? firstName[0].ToString().ToUpper() : "C";
            ScriptManager.RegisterStartupScript(this, GetType(), "staffInit",
                $"document.getElementById('staffInitial').textContent = '{initial}';", true);

            if (!IsPostBack)
                LoadPendingReservations();
        }

        // ── LOAD PENDING RESERVATIONS ──────────────────────────
        private void LoadPendingReservations()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string q = @"
                        SELECT TOP 50
                            r.ReservationID,
                            r.TableID,
                            r.ReservationDate,
                            r.Schedule,
                            r.RentalType,
                            r.GuestName,
                            r.ContactNo,
                            r.HasDiscount,
                            r.Status,
                            r.CreatedAt
                        FROM Reservations r
                        WHERE r.Status = 'Pending'
                        ORDER BY r.ReservationDate ASC, r.Schedule ASC";

                    using (SqlCommand cmd = new SqlCommand(q, conn))
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        var dt = new DataTable();
                        da.Fill(dt);
                        gvReservations.DataSource = dt;
                        gvReservations.DataBind();

                        // Update pending badge count
                        int count = dt.Rows.Count;
                        ScriptManager.RegisterStartupScript(this, GetType(), "pendingCount",
                            $"document.getElementById('pendingBadge').textContent = '{count}';", true);
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadReservations error: " + ex.Message);
            }
        }

        // ── APPROVE / REJECT RESERVATION ──────────────────────
        protected void GvReservations_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandName != "Approve" && e.CommandName != "Reject") return;

            int reservID = int.Parse(e.CommandArgument.ToString());
            string newStatus = e.CommandName == "Approve" ? "Approved" : "Cancelled";

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string q = "UPDATE Reservations SET Status = @Status WHERE ReservationID = @ID";
                    using (SqlCommand cmd = new SqlCommand(q, conn))
                    {
                        cmd.Parameters.AddWithValue("@Status", newStatus);
                        cmd.Parameters.AddWithValue("@ID", reservID);
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("UpdateReservation error: " + ex.Message);
            }

            LoadPendingReservations();
        }

        // ── SERVER ACTION (generic hidden button) ──────────────
        protected void BtnServerAction_Click(object sender, EventArgs e)
        {
            string action = hdnAction.Value;
            string tableID = hdnTableID.Value;

            // Extend as needed for server-side billing, etc.
            System.Diagnostics.Debug.WriteLine($"ServerAction: {action}, Table: {tableID}");
        }

        // ── LOGOUT ─────────────────────────────────────────────
        protected void BtnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Cashierlogin.aspx");
        }
    }
}