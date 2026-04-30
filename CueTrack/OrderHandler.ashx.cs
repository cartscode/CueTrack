using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.SessionState;

namespace CueTrack
{
    public class OrderHandler : IHttpHandler, IRequiresSessionState
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";

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
                string body = new StreamReader(context.Request.InputStream).ReadToEnd();
                var js = new JavaScriptSerializer();
                var data = js.Deserialize<OrderPayload>(body);

                if (data == null || data.items == null || data.items.Count == 0)
                {
                    context.Response.Write("{\"success\":false,\"message\":\"Empty order.\"}");
                    return;
                }

                if (!int.TryParse(data.tableID, out int tableID) || tableID <= 0)
                {
                    context.Response.Write("{\"success\":false,\"message\":\"Invalid table.\"}");
                    return;
                }

                string connStr = ConfigurationManager.ConnectionStrings["CueTrackDB"].ConnectionString;
                int userID = int.Parse(context.Session["UserID"].ToString());

                decimal total = 0;
                foreach (var item in data.items)
                    total += (decimal)item.price * item.qty;

                int orderID;
                string refNumber;

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // ── Step 1: Insert order header (no ref number yet) ──
                    string insertOrder = @"
                INSERT INTO Orders 
                    (UserID, TableID, Notes, TotalAmount, DiscountType, PaymentMethod, Status, CreatedAt)
                OUTPUT INSERTED.OrderID
                VALUES 
                    (@UserID, @TableID, @Notes, @Total, @DiscountType, @PaymentMethod, 'Pending', GETDATE())";

                    using (SqlCommand cmd = new SqlCommand(insertOrder, conn))
                    {
                        cmd.Parameters.Add("@UserID", System.Data.SqlDbType.Int).Value = userID;
                        cmd.Parameters.Add("@TableID", System.Data.SqlDbType.Int).Value = tableID;
                        cmd.Parameters.Add("@Notes", System.Data.SqlDbType.NVarChar, 500).Value =
                            string.IsNullOrEmpty(data.notes) ? (object)DBNull.Value : data.notes;
                        cmd.Parameters.Add("@Total", System.Data.SqlDbType.Decimal).Value = total;
                        cmd.Parameters.Add("@DiscountType", System.Data.SqlDbType.NVarChar, 20).Value = data.discountType ?? "regular";
                        cmd.Parameters.Add("@PaymentMethod", System.Data.SqlDbType.NVarChar, 20).Value = data.paymentMethod ?? "Cash";
                        ((SqlParameter)cmd.Parameters["@Total"]).Precision = 10;
                        ((SqlParameter)cmd.Parameters["@Total"]).Scale = 2;

                        orderID = (int)cmd.ExecuteScalar();
                    }

                    // ── Step 2: Count today's orders for this table (includes this one) ──
                    string countSql = @"
                SELECT COUNT(*) FROM Orders
                WHERE TableID = @TableID
                AND CAST(CreatedAt AS DATE) = CAST(GETDATE() AS DATE)";

                    int todayCount;
                    using (SqlCommand cmd = new SqlCommand(countSql, conn))
                    {
                        cmd.Parameters.Add("@TableID", System.Data.SqlDbType.Int).Value = tableID;
                        todayCount = (int)cmd.ExecuteScalar();
                    }

                    // ── Step 3: Build ref number and save it ──
                    refNumber = "T" + tableID + "-" + todayCount.ToString("D3");

                    string updateRef = "UPDATE Orders SET ReferenceNo = @RefNo WHERE OrderID = @OrderID";
                    using (SqlCommand cmd = new SqlCommand(updateRef, conn))
                    {
                        cmd.Parameters.Add("@RefNo", System.Data.SqlDbType.NVarChar, 20).Value = refNumber;
                        cmd.Parameters.Add("@OrderID", System.Data.SqlDbType.Int).Value = orderID;
                        cmd.ExecuteNonQuery();
                    }

                    // ── Step 4: Insert line items ──
                    string insertLine = @"
                INSERT INTO OrderItems (OrderID, ItemID, ItemName, UnitPrice, Quantity, LineTotal)
                VALUES (@OrderID, @ItemID, @Name, @Price, @Qty, @LineTotal)";

                    foreach (var item in data.items)
                    {
                        decimal unitPrice = (decimal)item.price;
                        decimal lineTotal = unitPrice * item.qty;

                        using (SqlCommand cmd = new SqlCommand(insertLine, conn))
                        {
                            cmd.Parameters.Add("@OrderID", System.Data.SqlDbType.Int).Value = orderID;
                            cmd.Parameters.Add("@ItemID", System.Data.SqlDbType.NVarChar, 20).Value = item.id ?? "";
                            cmd.Parameters.Add("@Name", System.Data.SqlDbType.NVarChar, 200).Value = item.name ?? "";
                            cmd.Parameters.Add("@Price", System.Data.SqlDbType.Decimal).Value = unitPrice;
                            cmd.Parameters.Add("@Qty", System.Data.SqlDbType.Int).Value = item.qty;
                            cmd.Parameters.Add("@LineTotal", System.Data.SqlDbType.Decimal).Value = lineTotal;
                            cmd.ExecuteNonQuery();
                        }
                    }
                }

                // ── Step 5: Return success ──
                context.Response.Write(
                    "{\"success\":true,\"orderID\":" + orderID +
                    ",\"refNumber\":\"" + refNumber + "\"}");
            }
            catch (Exception ex)
            {
                string safe = ex.Message.Replace("\"", "'").Replace("\r", " ").Replace("\n", " ");
                context.Response.Write("{\"success\":false,\"message\":\"" + safe + "\"}");
            }
        }

        public bool IsReusable { get { return false; } }

        public class OrderPayload
        {
            public string tableID { get; set; }
            public string notes { get; set; }
            public double total { get; set; }
            public string discountType { get; set; }
            public string paymentMethod { get; set; }
            public List<OrderItem> items { get; set; }
        }

        public class OrderItem
        {
            public string id { get; set; }
            public string name { get; set; }
            public double price { get; set; }
            public int qty { get; set; }
        }
    }
}