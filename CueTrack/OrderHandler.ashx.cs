using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.SessionState;

public class OrderHandler : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json";

        // Auth check
        if (context.Session["UserID"] == null)
        {
            context.Response.Write("{\"success\":false,\"message\":\"Not logged in.\"}");
            return;
        }

        if (context.Request.HttpMethod != "POST")
        {
            context.Response.Write("{\"success\":false,\"message\":\"Invalid method.\"}");
            return;
        }

        try
        {
            // Read JSON body
            string body = new StreamReader(context.Request.InputStream).ReadToEnd();
            var js = new JavaScriptSerializer();
            var data = js.Deserialize<OrderPayload>(body);

            if (data == null || data.items == null || data.items.Count == 0)
            {
                context.Response.Write("{\"success\":false,\"message\":\"Empty order.\"}");
                return;
            }

            string connStr = ConfigurationManager.ConnectionStrings["CueTrackDB"].ConnectionString;
            int userID = int.Parse(context.Session["UserID"].ToString());

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // Insert order header
                string insertOrder = @"
                    INSERT INTO Orders (UserID, TableID, Notes, TotalAmount, Status, CreatedAt)
                    OUTPUT INSERTED.OrderID
                    VALUES (@UserID, @TableID, @Notes, @Total, 'Pending', GETDATE())";

                int orderID;
                using (SqlCommand cmd = new SqlCommand(insertOrder, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userID);
                    cmd.Parameters.AddWithValue("@TableID", int.Parse(data.tableID));
                    cmd.Parameters.AddWithValue("@Notes", string.IsNullOrEmpty(data.notes) ? (object)DBNull.Value : data.notes);
                    cmd.Parameters.AddWithValue("@Total", data.total);
                    orderID = (int)cmd.ExecuteScalar();
                }

                // Insert line items
                string insertLine = @"
                    INSERT INTO OrderItems (OrderID, ItemID, ItemName, UnitPrice, Quantity, LineTotal)
                    VALUES (@OrderID, @ItemID, @Name, @Price, @Qty, @LineTotal)";

                foreach (var item in data.items)
                {
                    using (SqlCommand cmd = new SqlCommand(insertLine, conn))
                    {
                        cmd.Parameters.AddWithValue("@OrderID", orderID);
                        cmd.Parameters.AddWithValue("@ItemID", item.id ?? "");
                        cmd.Parameters.AddWithValue("@Name", item.name ?? "");
                        cmd.Parameters.AddWithValue("@Price", item.price);
                        cmd.Parameters.AddWithValue("@Qty", item.qty);
                        cmd.Parameters.AddWithValue("@LineTotal", item.price * item.qty);
                        cmd.ExecuteNonQuery();
                    }
                }
            }

            context.Response.Write("{\"success\":true}");
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine("OrderHandler error: " + ex.Message);
            context.Response.Write("{\"success\":false,\"message\":\"Server error.\"}");
        }
    }

    public bool IsReusable { get { return false; } }

    // ── Payload classes ────────────────────────────
    public class OrderPayload
    {
        public string tableID { get; set; }
        public string notes { get; set; }
        public decimal total { get; set; }
        public List<OrderItem> items { get; set; }
    }

    public class OrderItem
    {
        public string id { get; set; }
        public string name { get; set; }
        public decimal price { get; set; }
        public int qty { get; set; }
    }
}