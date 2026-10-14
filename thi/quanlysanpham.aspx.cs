using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI.WebControls;

public partial class quanlysanpham : System.Web.UI.Page
{

    string cs = ConfigurationManager.ConnectionStrings["QLSanPhamConn"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)         
        {
            NapTheLoai();
            NapSanPham();
        }
    }

    void NapTheLoai()
    {
        SqlDataAdapter da = new SqlDataAdapter("SELECT maloai, maloai + ' - ' + tenloai AS hienthi FROM theloai", cs);
        DataTable dt = new DataTable();
        da.Fill(dt);

        ddlLoc.DataSource = dt;
        ddlLoc.DataValueField = "maloai";
        ddlLoc.DataTextField = "hienthi";
        ddlLoc.DataBind();
        ddlLoc.Items.Insert(0, new ListItem("-- Tất cả thể loại --", ""));  

        ddlMaloai.DataSource = dt;
        ddlMaloai.DataValueField = "maloai";
        ddlMaloai.DataTextField = "hienthi";
        ddlMaloai.DataBind();
    }

    void NapSanPham()
    {
        string sql = @"SELECT s.masp, s.tensp, s.ngaynhap, s.dongia, s.anh, s.maloai, t.tenloai
                       FROM sanpham s JOIN theloai t ON s.maloai = t.maloai
                       WHERE (s.masp LIKE @tukhoa OR s.tensp LIKE @tukhoa)
                         AND (@maloai = '' OR s.maloai = @maloai)
                       ORDER BY s.masp";

        SqlDataAdapter da = new SqlDataAdapter(sql, cs);
        da.SelectCommand.Parameters.AddWithValue("@tukhoa", "%" + txtTim.Text.Trim() + "%");
        da.SelectCommand.Parameters.AddWithValue("@maloai", ddlLoc.SelectedValue);

        DataTable dt = new DataTable();
        da.Fill(dt);

        gvSanPham.DataSource = dt;
        gvSanPham.DataBind();

        lblTong.Text = "Tổng số: <b>" + dt.Rows.Count + "</b> sản phẩm | Trang <b>"
                     + (gvSanPham.PageIndex + 1) + "</b> / " + gvSanPham.PageCount;
    }

    void Bao(string noiDung, bool thanhCong)
    {
        lblThongBao.Text = noiDung;
        lblThongBao.CssClass = thanhCong ? "msg ok" : "msg loi";
        lblThongBao.Visible = true;
    }

    protected void btnLoc_Click(object sender, EventArgs e)
    {
        gvSanPham.PageIndex = 0;    
        NapSanPham();
    }

    protected void gvSanPham_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gvSanPham.PageIndex = e.NewPageIndex;   
        NapSanPham();
    }

    protected void btnThem_Click(object sender, EventArgs e)
    {
        hfCheDo.Value = "them";
        lblTieuDe.Text = "Thêm sản phẩm";
        txtMasp.ReadOnly = false;       
        txtMasp.Text = "";
        txtTensp.Text = "";
        txtNgaynhap.Text = "";
        txtDongia.Text = "";
        hfAnhCu.Value = "";
        pnlForm.Visible = true;
        lblThongBao.Visible = false;
    }

    protected void gvSanPham_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        string masp = e.CommandArgument.ToString();   

        if (e.CommandName == "Sua")
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand("SELECT * FROM sanpham WHERE masp = @masp", con);
                cmd.Parameters.AddWithValue("@masp", masp);
                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    hfCheDo.Value = "sua";
                    lblTieuDe.Text = "Sửa sản phẩm " + masp;
                    txtMasp.Text = dr["masp"].ToString();
                    txtMasp.ReadOnly = true;                 
                    txtTensp.Text = dr["tensp"].ToString();

                    txtNgaynhap.Text = dr["ngaynhap"] == DBNull.Value ? "" : Convert.ToDateTime(dr["ngaynhap"]).ToString("yyyy-MM-dd");
                    txtDongia.Text = dr["dongia"] == DBNull.Value ? "" : Convert.ToDecimal(dr["dongia"]).ToString("0");

                    ddlMaloai.SelectedValue = dr["maloai"].ToString();
                    hfAnhCu.Value = dr["anh"].ToString();    
                    pnlForm.Visible = true;
                    lblThongBao.Visible = false;
                }
            }
        }
        else if (e.CommandName == "Xoa")
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand("DELETE FROM sanpham WHERE masp = @masp", con);
                cmd.Parameters.AddWithValue("@masp", masp);
                con.Open();
                cmd.ExecuteNonQuery();
            }
            Bao("Đã xóa sản phẩm " + masp, true);
            NapSanPham();
        }
    }

    protected void btnLuu_Click(object sender, EventArgs e)
    {
        string masp = txtMasp.Text.Trim();
        string tensp = txtTensp.Text.Trim();

        // --- Kiểm tra dữ liệu nhập ---
        if (masp == "" || tensp == "")
        {
            Bao("Vui lòng nhập Mã sản phẩm và Tên sản phẩm!", false);
            return;
        }

        object ngaynhap = DBNull.Value;
        if (txtNgaynhap.Text != "")
        {
            DateTime ngay;
            if (!DateTime.TryParse(txtNgaynhap.Text, out ngay))
            {
                Bao("Ngày nhập không hợp lệ!", false);
                return;
            }
            ngaynhap = ngay;
        }

        object dongia = DBNull.Value;
        if (txtDongia.Text != "")
        {
            decimal gia;
            if (!decimal.TryParse(txtDongia.Text, out gia) || gia < 0)
            {
                Bao("Đơn giá không hợp lệ (phải là số không âm)!", false);
                return;
            }
            dongia = gia;
        }

        string tenAnh = hfAnhCu.Value;
        if (fuAnh.HasFile)
        {
            string duoi = Path.GetExtension(fuAnh.FileName).ToLower();
            if (duoi != ".jpg" && duoi != ".jpeg" && duoi != ".png" && duoi != ".gif")
            {
                Bao("Chỉ chấp nhận ảnh jpg, png, gif!", false);
                return;
            }
            tenAnh = masp + duoi;                                 
            Directory.CreateDirectory(Server.MapPath("~/Images/")); 
            fuAnh.SaveAs(Server.MapPath("~/Images/" + tenAnh));     
        }

        using (SqlConnection con = new SqlConnection(cs))
        {
            con.Open();
            string sql;

            if (hfCheDo.Value == "them")
            {
                // Kiểm tra trùng mã trước khi thêm
                SqlCommand kt = new SqlCommand("SELECT COUNT(*) FROM sanpham WHERE masp = @masp", con);
                kt.Parameters.AddWithValue("@masp", masp);
                if ((int)kt.ExecuteScalar() > 0)
                {
                    Bao("Mã sản phẩm " + masp + " đã tồn tại!", false);
                    return;
                }
                sql = "INSERT INTO sanpham(masp, tensp, ngaynhap, dongia, anh, maloai) " +
                      "VALUES(@masp, @tensp, @ngaynhap, @dongia, @anh, @maloai)";
            }
            else
            {
                sql = "UPDATE sanpham SET tensp=@tensp, ngaynhap=@ngaynhap, dongia=@dongia, " +
                      "anh=@anh, maloai=@maloai WHERE masp=@masp";
            }

            SqlCommand cmd = new SqlCommand(sql, con);
            cmd.Parameters.AddWithValue("@masp", masp);
            cmd.Parameters.AddWithValue("@tensp", tensp);
            cmd.Parameters.AddWithValue("@ngaynhap", ngaynhap);
            cmd.Parameters.AddWithValue("@dongia", dongia);
            cmd.Parameters.AddWithValue("@anh", tenAnh);
            cmd.Parameters.AddWithValue("@maloai", ddlMaloai.SelectedValue);
            cmd.ExecuteNonQuery();
        }

        Bao(hfCheDo.Value == "them" ? "Đã thêm sản phẩm " + masp : "Đã cập nhật sản phẩm " + masp, true);
        pnlForm.Visible = false;     
        NapSanPham();               
    }

    protected void btnHuy_Click(object sender, EventArgs e)
    {
        pnlForm.Visible = false;
        lblThongBao.Visible = false;
    }
}
