using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;

namespace CueTrack
{
    public partial class Order : Page
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

                litUserName.Text = firstName;
                litUserName2.Text = firstName + " " + lastName;
                litUserEmail.Text = email;
                litSession.Text = firstName;
            }
        }


        // ── LOGOUT ─────────────────────────────────────────────
        protected void BtnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Default.aspx");
        }

        // ── JSON PARSER ────────────────────────────────────────
        // Simple manual parser — no Newtonsoft dependency required
        private List<OrderLine> ParseOrderJson(string json)
        {
            var result = new List<OrderLine>();
            try
            {
                // json is: [{"id":"c1","name":"Shark's Bite","price":250,"qty":2},...]
                json = json.Trim().TrimStart('[').TrimEnd(']');
                if (string.IsNullOrEmpty(json)) return result;

                // Split objects by },{ boundary
                var objects = SplitJsonObjects(json);
                foreach (var obj in objects)
                {
                    string id = ExtractJsonString(obj, "id");
                    string name = ExtractJsonString(obj, "name");
                    decimal price = ExtractJsonDecimal(obj, "price");
                    int qty = ExtractJsonInt(obj, "qty");
                    if (!string.IsNullOrEmpty(name) && qty > 0)
                        result.Add(new OrderLine { ItemID = id, Name = name, Price = price, Qty = qty });
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("ParseJson error: " + ex.Message);
            }
            return result;
        }

        private List<string> SplitJsonObjects(string json)
        {
            var list = new List<string>();
            int depth = 0; int start = 0;
            for (int i = 0; i < json.Length; i++)
            {
                if (json[i] == '{') { if (depth == 0) start = i; depth++; }
                else if (json[i] == '}') { depth--; if (depth == 0) list.Add(json.Substring(start, i - start + 1)); }
            }
            return list;
        }

        private string ExtractJsonString(string obj, string key)
        {
            string search = "\"" + key + "\":\"";
            int idx = obj.IndexOf(search);
            if (idx < 0) return "";
            idx += search.Length;
            int end = obj.IndexOf("\"", idx);
            return end < 0 ? "" : obj.Substring(idx, end - idx).Replace("\\'", "'");
        }

        private decimal ExtractJsonDecimal(string obj, string key)
        {
            string search = "\"" + key + "\":";
            int idx = obj.IndexOf(search);
            if (idx < 0) return 0;
            idx += search.Length;
            int end = idx;
            while (end < obj.Length && (char.IsDigit(obj[end]) || obj[end] == '.')) end++;
            decimal.TryParse(obj.Substring(idx, end - idx), out decimal val);
            return val;
        }

        private int ExtractJsonInt(string obj, string key)
        {
            return (int)ExtractJsonDecimal(obj, key);
        }

        // ── HELPERS ────────────────────────────────────────────
        private class OrderLine
        {
            public string ItemID { get; set; }
            public string Name { get; set; }
            public decimal Price { get; set; }
            public int Qty { get; set; }
        }
    }
}