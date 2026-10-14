IF DB_ID(N'QLSanPham') IS NULL
BEGIN
    EXEC(N'CREATE DATABASE [QLSanPham]');
END;
GO

USE [QLSanPham];
GO

IF OBJECT_ID(N'dbo.TaiKhoan', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.TaiKhoan
    (
        MaTK    INT IDENTITY(1,1) CONSTRAINT PK_TaiKhoan PRIMARY KEY,
        TenTK   NVARCHAR(50) NOT NULL CONSTRAINT UQ_TaiKhoan_TenTK UNIQUE,
        MatKhau NVARCHAR(100) NOT NULL
    );
END;
GO

IF OBJECT_ID(N'dbo.theloai', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.theloai (
        maloai  VARCHAR(10)   NOT NULL CONSTRAINT PK_theloai PRIMARY KEY,
        tenloai NVARCHAR(100) NOT NULL
    );
END;

IF OBJECT_ID(N'dbo.sanpham', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.sanpham (
        masp     VARCHAR(10)   NOT NULL CONSTRAINT PK_sanpham PRIMARY KEY,
        tensp    NVARCHAR(100) NOT NULL,
        ngaynhap DATE          NULL,
        dongia   DECIMAL(18,0) NULL,
        anh      NVARCHAR(255) NULL,
        maloai   VARCHAR(10)   NOT NULL,
        CONSTRAINT FK_sanpham_theloai
            FOREIGN KEY (maloai) REFERENCES dbo.theloai(maloai)
    );
END;
GO

IF NOT EXISTS (SELECT 1 FROM dbo.theloai WHERE maloai = 'TL01')
    INSERT INTO dbo.theloai (maloai, tenloai) VALUES ('TL01', N'Điện thoại');
IF NOT EXISTS (SELECT 1 FROM dbo.theloai WHERE maloai = 'TL02')
    INSERT INTO dbo.theloai (maloai, tenloai) VALUES ('TL02', N'Laptop');
IF NOT EXISTS (SELECT 1 FROM dbo.theloai WHERE maloai = 'TL03')
    INSERT INTO dbo.theloai (maloai, tenloai) VALUES ('TL03', N'Phụ kiện');
IF NOT EXISTS (SELECT 1 FROM dbo.theloai WHERE maloai = 'TL04')
    INSERT INTO dbo.theloai (maloai, tenloai) VALUES ('TL04', N'Máy tính bảng');

IF NOT EXISTS (SELECT 1 FROM dbo.sanpham WHERE masp = 'SP001')
BEGIN
INSERT INTO dbo.sanpham (masp, tensp, ngaynhap, dongia, maloai) VALUES
 ('SP001', N'Điện thoại Galaxy A55',    '2026-01-10',  9990000, 'TL01'),
 ('SP002', N'Điện thoại Redmi Note 13', '2026-01-15',  5490000, 'TL01'),
 ('SP003', N'Điện thoại iPhone 14',     '2026-02-03', 15990000, 'TL01'),
 ('SP004', N'Điện thoại Oppo Reno 11',  '2026-02-20',  8490000, 'TL01'),
 ('SP005', N'Laptop Dell Inspiron 15',  '2026-01-12', 14500000, 'TL02'),
 ('SP006', N'Laptop Asus Vivobook 14',  '2026-02-08', 12900000, 'TL02'),
 ('SP007', N'Laptop HP Pavilion 15',    '2026-03-01', 16200000, 'TL02'),
 ('SP008', N'Laptop Lenovo IdeaPad 3',  '2026-03-15', 11300000, 'TL02'),
 ('SP009', N'Tai nghe Bluetooth',       '2026-01-25',   590000, 'TL03'),
 ('SP010', N'Chuột không dây',          '2026-02-14',   250000, 'TL03'),
 ('SP011', N'Bàn phím cơ',              '2026-03-05',   890000, 'TL03'),
 ('SP012', N'Sạc dự phòng 10000mAh',    '2026-03-20',   420000, 'TL03');
END;
GO

-- Tài khoản mẫu
IF NOT EXISTS
(
    SELECT 1
    FROM dbo.TaiKhoan
    WHERE TenTK = N'admin'
)
BEGIN
    INSERT INTO dbo.TaiKhoan (TenTK, MatKhau)
    VALUES (N'admin', N'123456');
END;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.sanpham
    WHERE masp = 'SP013'
)
BEGIN
    INSERT INTO dbo.sanpham
        (masp, tensp, ngaynhap, dongia, anh, maloai)
    VALUES
        ('SP013', N'Laptop Dell', CAST(GETDATE() AS DATE),
         15000000, NULL, 'TL02');
END;
GO

-- Kiểm tra
SELECT (SELECT COUNT(*) FROM dbo.theloai) AS SoTheLoai,
       (SELECT COUNT(*) FROM dbo.sanpham) AS SoSanPham;
SELECT t.maloai, t.tenloai, COUNT(s.masp) AS SoSP
FROM dbo.theloai AS t LEFT JOIN dbo.sanpham AS s ON s.maloai = t.maloai
GROUP BY t.maloai, t.tenloai;

SELECT s.masp, s.tensp, s.ngaynhap, s.dongia, t.tenloai
FROM dbo.sanpham AS s JOIN dbo.theloai AS t ON s.maloai = t.maloai;
