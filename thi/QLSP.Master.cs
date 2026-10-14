using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QuanLySanPham
{
    public partial class QLSP : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            string trang = Path.GetFileName(Request.Path).ToLower();

            if (trang == "quanlysanpham.aspx")
            {
                lnkSanPham.CssClass = "active";     
                lnkNavSanPham.CssClass = "active";   
            }
            else if (trang == "default.aspx")
            {
                lnkTrangChu.CssClass = "active";
                lnkNavTrangChu.CssClass = "active";
            }
        }
    }
}