<%@ Page Title="Quản lý sản phẩm" Language="C#" MasterPageFile="~/QLSP.Master" AutoEventWireup="true" CodeFile="quanlysanpham.aspx.cs" Inherits="quanlysanpham" Culture="vi-VN" UICulture="vi-VN" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2 class="page-title"><i class="fas fa-box"></i> QUẢN LÝ SẢN PHẨM</h2>

    <div class="toolbar">
        <div class="tim">
            <asp:TextBox ID="txtTim" runat="server" placeholder="Tìm theo mã, tên SP..."></asp:TextBox>
        </div>
        <asp:DropDownList ID="ddlLoc" runat="server"></asp:DropDownList>
        <asp:LinkButton ID="btnLoc" runat="server" CssClass="btn btn-loc" OnClick="btnLoc_Click"><i class="fas fa-filter"></i> Lọc</asp:LinkButton>
        <asp:LinkButton ID="btnThem" runat="server" CssClass="btn btn-them" OnClick="btnThem_Click">+ Thêm sản phẩm</asp:LinkButton>
    </div>

    <asp:Label ID="lblThongBao" runat="server" Visible="false"></asp:Label>

    <asp:Panel ID="pnlForm" runat="server" Visible="false" CssClass="form-box">
        <h3><asp:Label ID="lblTieuDe" runat="server" Text="Thêm sản phẩm"></asp:Label></h3>
        <div class="form-row">
            <div class="form-item">
                <label>Mã sản phẩm</label>
                <asp:TextBox ID="txtMasp" runat="server" MaxLength="10"></asp:TextBox>
            </div>
            <div class="form-item">
                <label>Tên sản phẩm</label>
                <asp:TextBox ID="txtTensp" runat="server" MaxLength="100"></asp:TextBox>
            </div>
            <div class="form-item">
                <label>Ngày nhập</label>
                <asp:TextBox ID="txtNgaynhap" runat="server" TextMode="Date"></asp:TextBox>
            </div>
            <div class="form-item">
                <label>Đơn giá (đồng)</label>
                <asp:TextBox ID="txtDongia" runat="server" TextMode="Number"></asp:TextBox>
            </div>
            <div class="form-item">
                <label>Thể loại</label>
                <asp:DropDownList ID="ddlMaloai" runat="server"></asp:DropDownList>
            </div>
            <div class="form-item">
                <label>Ảnh (jpg, png, gif)</label>
                <asp:FileUpload ID="fuAnh" runat="server" />
            </div>
        </div>
        <div class="form-actions">
            <asp:LinkButton ID="btnLuu" runat="server" CssClass="btn btn-luu" OnClick="btnLuu_Click"><i class="fas fa-save"></i> Lưu</asp:LinkButton>
            <asp:LinkButton ID="btnHuy" runat="server" CssClass="btn btn-huy" OnClick="btnHuy_Click" CausesValidation="false">Hủy</asp:LinkButton>
        </div>
        <asp:HiddenField ID="hfCheDo" runat="server" Value="them" />
        <asp:HiddenField ID="hfAnhCu" runat="server" />
    </asp:Panel>

    <asp:GridView ID="gvSanPham" runat="server" CssClass="grid" GridLines="None"
        AutoGenerateColumns="False" AllowPaging="True" PageSize="6"
        OnPageIndexChanging="gvSanPham_PageIndexChanging"
        OnRowCommand="gvSanPham_RowCommand">

        <PagerSettings Mode="NumericFirstLast" FirstPageText="Đầu" LastPageText="Cuối" />
        <PagerStyle CssClass="pager" />

        <Columns>
            <asp:BoundField DataField="masp" HeaderText="MÃ SP" ItemStyle-CssClass="ma" />

            <asp:TemplateField HeaderText="ẢNH">
                <ItemTemplate>
                    <asp:Image ID="imgAnh" runat="server" CssClass="avatar"
                        ImageUrl='<%# string.IsNullOrEmpty(Eval("anh").ToString()) ? "~/Images/default.png" : "~/Images/" + Eval("anh") %>' />
                </ItemTemplate>
            </asp:TemplateField>

            <asp:BoundField DataField="tensp" HeaderText="TÊN SẢN PHẨM" />
            <asp:BoundField DataField="ngaynhap" HeaderText="NGÀY NHẬP" DataFormatString="{0:dd/MM/yyyy}" HtmlEncode="false" />
            <asp:BoundField DataField="dongia" HeaderText="ĐƠN GIÁ" DataFormatString="{0:N0} đ" HtmlEncode="false" />

            <asp:TemplateField HeaderText="THỂ LOẠI">
                <ItemTemplate>
                    <span class="badge"><%# Eval("maloai") %> - <%# Eval("tenloai") %></span>
                </ItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField HeaderText="THAO TÁC">
                <ItemTemplate>
                    <asp:LinkButton ID="btnSua" runat="server" CssClass="btn-sua"
                        CommandName="Sua" CommandArgument='<%# Eval("masp") %>'><i class="fas fa-edit"></i> Sửa</asp:LinkButton>
                    <asp:LinkButton ID="btnXoa" runat="server" CssClass="btn-xoa"
                        CommandName="Xoa" CommandArgument='<%# Eval("masp") %>'
                        OnClientClick="return confirm('Bạn có chắc muốn xóa sản phẩm này?');"><i class="fas fa-trash"></i> Xóa</asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>

    <div class="tong"><asp:Label ID="lblTong" runat="server"></asp:Label></div>

</asp:Content>
