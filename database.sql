
CREATE DATABASE asm2;
USE asm2;
CREATE TABLE admin (
  username varchar(255) NOT NULL,
  password varchar(255) DEFAULT NULL,
  init varchar(255) DEFAULT '0',
  createAt datetime DEFAULT NULL,
  updateAt datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng admin
--

INSERT INTO admin (username, password, init, createAt, updateAt) VALUES
('admin', '$2y$10$16nKrw2Lk8TGRgEF0VYwqevMqG3JnEIkw3kmKqd2KDkvkxoskBiZu', '0', '2023-04-22 19:49:49', '2023-04-22 19:49:49');

CREATE TABLE ChiNhanh(
    STT INT NOT NULL default 1,
    MaCN VARCHAR(20),
    TenCN VARCHAR(50) NOT NULL,
    UNIQUE (TenCN),
    KhuVuc VARCHAR(50),
    DiaChi VARCHAR(50) NOT NULL,
    Email VARCHAR(50),
    Fax VARCHAR(50),
    MaNVQL VARCHAR(6),
    PRIMARY KEY (MaCN)
);
DELIMITER //
CREATE TRIGGER increment_chinhanh_stt BEFORE INSERT ON ChiNhanh
FOR EACH ROW
BEGIN
	SET NEW.STT = IF((SELECT (MAX(STT) + 1) FROM ChiNhanh) IS NOT NULL, (SELECT (MAX(STT) + 1) FROM ChiNhanh), 1);
	SET NEW.MaCN = CONCAT('CN', CAST(NEW.STT AS CHAR));
END //
DELIMITER ;
CREATE TABLE SDT_CN(
	MaCN VARCHAR(20) NOT NULL,
    SDT VARCHAR(15) NOT NULL,
    PRIMARY KEY (MaCN, SDT),
    CONSTRAINT FK_SDTCN FOREIGN KEY (MaCN) REFERENCES ChiNhanh(MaCN) ON DELETE CASCADE
);

CREATE TABLE NhanVien(
    MaNV VARCHAR(6) PRIMARY KEY CHECK (MaNV REGEXP '^(VP|HD)[0-9]{4}$'),

    CMND VARCHAR(12) NOT NULL,
    UNIQUE (CMND),

    HoTen VARCHAR(50) NOT NULL,
    DiaChi VARCHAR(50),

    GioiTinh CHAR CHECK (GioiTinh IN ('M', 'F')),

    NgaySinh DATE NOT NULL,
    LoaiNV INT CHECK (LoaiNV IN (1, 2)),

    ViTri VARCHAR(50) NOT NULL,
    MaCN VARCHAR(20) NOT NULL,
    CONSTRAINT FK_MaCN FOREIGN KEY (MaCN) REFERENCES ChiNhanh(MaCN) 
);

ALTER TABLE ChiNhanh 
ADD CONSTRAINT FK_MaNVQL FOREIGN KEY (MaNVQL) REFERENCES NhanVien(MaNV);

CREATE TABLE NgoaiNgu_NV(
	MaNV VARCHAR(6) CHECK (MaNV REGEXP '^(HD)[0-9]{4}$'),
    NgoaiNgu VARCHAR(50) NOT NULL,
    PRIMARY KEY (MaNV, NgoaiNgu),
    CONSTRAINT FK_NgoaiNguNV FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV) ON DELETE CASCADE
);

CREATE TABLE KyNang_NV(
	MaNV VARCHAR(6) CHECK (MaNV REGEXP '^(HD)[0-9]{4}$'),
    KyNang VARCHAR(50) NOT NULL,
    PRIMARY KEY (MaNV, KyNang),
    CONSTRAINT FK_KyNangNV FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV) ON DELETE CASCADE
);

CREATE TABLE DiemDuLich(
    MaDiem INT PRIMARY KEY AUTO_INCREMENT,
    TenDiem VARCHAR(50) NOT NULL,
    DiaChi VARCHAR(50),
    PhuongXa VARCHAR(50),
    QuanHuyen VARCHAR(50) NOT NULL,
    TinhThanh VARCHAR(50) NOT NULL,
    Anh1 VARCHAR(255),
    Anh2 VARCHAR(255),
    Anh3 VARCHAR(255),
    MoTa VARCHAR(255),
    GhiChu VARCHAR(255)
);

CREATE TABLE DonViCungCapDichVu(
    MaDonVi VARCHAR(6) PRIMARY KEY CHECK (MaDonVi REGEXP '^(DV)[0-9]{4}$'),
    TenDonVi VARCHAR(50) NOT NULL,
    Email VARCHAR(50),
    SDT VARCHAR(50),
    Ten_DaiDien VARCHAR(50) NOT NULL,
    SDT_DaiDien VARCHAR(50),
    DiaChi VARCHAR(50),
    PhuongXa VARCHAR(50),
    QuanHuyen VARCHAR(50),
    TinhThanh VARCHAR(50),

    Anh1 VARCHAR(255),
    Anh2 VARCHAR(255),
    Anh3 VARCHAR(255),
    Anh4 VARCHAR(255),
    Anh5 VARCHAR(255),
    LoaiDV INT CHECK (LoaiDV IN (1,2,3)),
    GhiChu VARCHAR(255)
);

CREATE TABLE KhachHang(
    MaKH VARCHAR(6) PRIMARY KEY CHECK (MaKH REGEXP '^(KH)[0-9]{4}$'),
    CMND VARCHAR(12) NOT NULL,
    UNIQUE (CMND),
    HoTen VARCHAR(50) NOT NULL,
    Email VARCHAR(50),  
    SDT VARCHAR(15),
    NgaySinh DATE NOT NULL,
    DiaChi VARCHAR(255)
);

CREATE TABLE KhachDoan(
    MaKD VARCHAR(6) PRIMARY KEY CHECK (MaKD REGEXP '^(KD)[0-9]{4}$'),
    TenCoQuan VARCHAR(50) NOT NULL,
    Email VARCHAR(50),  
    SDT VARCHAR(15),
    DiaChi VARCHAR(255),
    MaDaiDien VARCHAR(6) CHECK (MaDaiDien REGEXP '^(KH)[0-9]{4}$'),
    CONSTRAINT FK_KhachDoan FOREIGN KEY (MaDaiDien) REFERENCES KhachHang(MaKH) 
);

CREATE TABLE KhachDoan_Gom_KhachLe(
    MaKD VARCHAR(6) CHECK (MaKD REGEXP '^(KD)[0-9]{4}$'),
    MaKH VARCHAR(6) CHECK (MaKH REGEXP '^(KH)[0-9]{4}$'),
    PRIMARY KEY (MaKD, MaKH),
    CONSTRAINT FK_KhachDoanKhachLe FOREIGN KEY (MaKD) REFERENCES KhachDoan(MaKD),
    CONSTRAINT FK_KhachLeKhachDoan FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH)
);

CREATE TABLE Tour(
    STT INT NOT NULL DEFAULT 1,
    MaChiNhanh VARCHAR(20) NOT NULL,
    CONSTRAINT FK_Tour_MaCN FOREIGN KEY (MaChiNhanh) REFERENCES ChiNhanh(MaCN),
    MaTour VARCHAR(20) PRIMARY KEY,
    TenTour VARCHAR(50) NOT NULL,
    Anh VARCHAR(255),
    NgayBatDau DATE NOT NULL,
    SoKhachToiThieu INT NOT NULL,
    SoKhachToiDa INT NOT NULL,

    GiaVeLeNguoiLon INT NOT NULL,
    GiaVeLeTreEm INT NOT NULL,
    CHECK (GiaVeLeNguoiLon > GiaVeLeTreEm),

    GiaVeDoanNguoiLon INT NOT NULL,
    GiaVeDoanTreEm INT NOT NULL,
    CHECK (GiaVeDoanNguoiLon > GiaVeDoanTreEm), 

    CHECK (GiaVeLeNguoiLon > GiaVeDoanNguoiLon),
    CHECK (GiaVeLeTreEm > GiaVeDoanTreEm),
    CHECK (SoKhachToiThieu < SoKhachToiDa),
    
    SoKhachDoanToiThieu INT NOT NULL,
    
    SoDem INT NOT NULL CHECK (SoDem > 0),
    SoNgay INT NOT NULL CHECK (soNgay > 0)
);

DELIMITER //
CREATE TRIGGER increment_tour_stt BEFORE INSERT ON Tour
FOR EACH ROW
BEGIN
	SET NEW.STT = IF((SELECT (MAX(STT) + 1) FROM Tour) IS NOT NULL, (SELECT (MAX(STT) + 1) FROM Tour), 1);
	SET NEW.MaTour =  (CONCAT( CAST(NEW.MaChiNhanh AS CHAR),'-', LPAD(CAST(NEW.STT AS CHAR), 6, '0')));
END //
DELIMITER ;

CREATE TABLE NgayKhoiHanh_TourDaiNgay(
    MaTour VARCHAR(20),
    Ngay INT CHECK (Ngay >= 1 AND Ngay <= 31),
    PRIMARY KEY (MaTour, Ngay),
    CONSTRAINT FK_MaTourDaiNgay FOREIGN KEY (MaTour) REFERENCES Tour(MaTour) ON DELETE CASCADE
);

CREATE TABLE LichTrinhTour(
    MaTour VARCHAR(20),
    STT_Ngay INT CHECK (STT_Ngay > 0),
    PRIMARY KEY (MaTour, STT_Ngay),
    CONSTRAINT FK_MaLichTrinhTour FOREIGN KEY (MaTour) REFERENCES Tour(MaTour) ON DELETE CASCADE
);

CREATE TABLE Tour_Co_DiaDiemThamQuan(
    MaTour VARCHAR(20),
    STT_Ngay INT CHECK (STT_Ngay > 0),
    CONSTRAINT FK_MaTour_STT_Ngay FOREIGN KEY (MaTour, STT_Ngay) REFERENCES LichTrinhTour(MaTour, STT_Ngay) ON DELETE CASCADE,
    MaDiemDuLich INT NOT NULL,
    PRIMARY KEY (MaTour, STT_Ngay, MaDiemDuLich),
    CONSTRAINT FK_MaDiemDuLich FOREIGN KEY (MaDiemDuLich) REFERENCES DiemDuLich(MaDiem) ON DELETE CASCADE,
    ThoiGianBatDau TIME NOT NULL,
    ThoiGianKetThuc TIME NOT NULL,
    CHECK (ThoiGianBatDau < ThoiGianKetThuc),
    MoTa VARCHAR(255)
);

CREATE TABLE HanhDong_LichTrinhTour(
    MaTour VARCHAR(20) NOT NULL,
    STT_Ngay INT CHECK (STT_Ngay > 0),
    CONSTRAINT FK_HanhDong_LichTrinhTour FOREIGN KEY (MaTour, STT_Ngay) REFERENCES LichTrinhTour(MaTour, STT_Ngay) ON DELETE CASCADE,
    LoaiHanhDong INT CHECK (LoaiHanhDong IN (1, 2, 3, 4, 5, 6, 7)),
    PRIMARY KEY (MaTour, STT_Ngay, LoaiHanhDong),
    ThoiGianBatDau TIME NOT NULL,
    ThoiGianKetThuc TIME,
    CHECK (ThoiGianBatDau < ThoiGianKetThuc),
    MoTa VARCHAR(255)
);

CREATE TABLE ChuyenDi(
    MaTour VARCHAR(20),
    NgayKhoiHanh DATE,
    NgayKetThuc DATE NOT NULL,
    TongGia INT ,
    PRIMARY KEY (MaTour, NgayKhoiHanh),
    CONSTRAINT FK_MaTour_ChuyenDi FOREIGN KEY (MaTour) REFERENCES Tour(MaTour) ON DELETE CASCADE
);

CREATE TABLE HuongDanVien_ChuyenDi(
    MaTour VARCHAR(20),
    NgayKhoiHanh DATE,
    MaHDV VARCHAR(6) CHECK (MaHDV REGEXP '^(HD)[0-9]{4}$'),
    PRIMARY KEY (MaTour, NgayKhoiHanh, MaHDV),
    CONSTRAINT FK_ChuyenDi FOREIGN KEY (MaTour, NgayKhoiHanh) REFERENCES ChuyenDi(MaTour, NgayKhoiHanh) ON DELETE CASCADE,
    CONSTRAINT FK_MaNV_HDV FOREIGN KEY (MaHDV) REFERENCES NhanVien(MaNV) ON DELETE CASCADE
);

CREATE TABLE LichTrinhChuyen(
    MaTour VARCHAR(20),
    NgayKhoiHanh DATE,
    STT_Ngay INT CHECK (STT_Ngay > 0),
    PRIMARY KEY (MaTour, NgayKhoiHanh, STT_Ngay),
    CONSTRAINT FK_LichTrinhChuyen FOREIGN KEY (MaTour, NgayKhoiHanh) REFERENCES ChuyenDi(MaTour, NgayKhoiHanh) ON DELETE CASCADE
);

CREATE TABLE DonViCungCapChuyen(
    MaTour VARCHAR(20),
    NgayKhoiHanh DATE,
    STT_Ngay INT CHECK (STT_Ngay > 0),
    Loai INT CHECK (Loai IN (1, 2, 3, 4, 5, 6, 7, 8)),
    MaDonVi VARCHAR(6),
    PRIMARY KEY (MaTour, NgayKhoiHanh, STT_Ngay, Loai, MaDonVi),
    CONSTRAINT FK_DonViCungCapChuyen_MaDonVi FOREIGN KEY (MaDonVi) REFERENCES DonViCungCapDichVu(MaDonVi) ON DELETE CASCADE
);

CREATE TABLE PhieuDangKy (
    NgayDangKy DATE NOT NULL,
    GhiChu VARCHAR(225),
    STT INT NOT NULL DEFAULT 1,
    MaPhieu VARCHAR(18) PRIMARY KEY,
    MaNhanVien VARCHAR(6) CHECK (MaNhanVien REGEXP '^(VP)[0-9]{4}$'),
    MaKhachLe VARCHAR(6),
    MaKhachDoan VARCHAR(6),
    CHECK ((MaKhachLe IS NOT NULL AND MaKhachDoan IS NULL) OR (MaKhachDoan IS NOT NULL AND MaKhachLe IS NULL)),
    CONSTRAINT FK_PhieuDangKy_MaNV FOREIGN KEY (MaNhanVien) REFERENCES NhanVien(MaNV) ON DELETE CASCADE,
    CONSTRAINT FK_PhieuDangKy_MaKhachLe FOREIGN KEY (MaKhachLe) REFERENCES KhachHang(MaKH) ON DELETE CASCADE,
    CONSTRAINT FK_PhieuDangKy_MaKhachDoan FOREIGN KEY (MaKhachDoan) REFERENCES KhachDoan(MaKD) ON DELETE CASCADE,
    MaTour VARCHAR(20),
    NgayKhoiHanh DATE,
    CONSTRAINT FK_PhieuDangKy_ChuyenDi FOREIGN KEY (MaTour, NgayKhoiHanh) REFERENCES ChuyenDi(MaTour, NgayKhoiHanh) ON DELETE CASCADE
);

DELIMITER //
CREATE TRIGGER increment_phieudangky_stt BEFORE INSERT ON PhieuDangKy
FOR EACH ROW
BEGIN
	SET NEW.STT = IF((SELECT (MAX(STT) + 1) FROM PhieuDangKy) IS NOT NULL, (SELECT (MAX(STT) + 1) FROM PhieuDangKy), 1);
	SET NEW.MaPhieu = (CONCAT( REPLACE(DATE_FORMAT(NEW.NgayDangKy, '%d/%m/%Y'), '/', ''), LPAD(CAST(NEW.STT AS CHAR), 9, '0')));
END //
DELIMITER ;

CREATE TABLE DonViCungCapDichVu_LienQuan(
    MaTour VARCHAR(20),
    MaDiem INT,
    MaDonVi VARCHAR(6),
    PRIMARY KEY (MaTour, MaDiem, MaDonVi),
    CONSTRAINT FK_MaTour_LienQuan FOREIGN KEY (MaTour) REFERENCES Tour(MaTour) ON DELETE CASCADE,
    CONSTRAINT FK_MaDiem_LienQuan FOREIGN KEY (MaDiem) REFERENCES DiemDuLich(MaDiem) ON DELETE CASCADE,
    CONSTRAINT FK_MaDonVi_LienQuan FOREIGN KEY (MaDonVi) REFERENCES DonViCungCapDichVu(MaDonVi) ON DELETE CASCADE
);

-- 1. Viết một function SoLuongKhach để đếm tổng số khách (cả người lớn và trẻ em) trong một chuyến đi (0.25đ)
--    Input: mã tour, ngày khởi hành
--    Output: tổng số khách
-- DROP FUNCTION IF EXISTS SoLuongKhach;
DELIMITER //
CREATE FUNCTION SoLuongKhach(MaTour VARCHAR(20), NgayKhoiHanh DATE)
RETURNS INT READS SQL DATA
BEGIN
   DECLARE SoKhach INT DEFAULT 0;
   DECLARE Temp INT DEFAULT 0;
   IF NOT EXISTS (SELECT * FROM Tour AS A WHERE A.MaTour = MaTour AND A.NgayBatDau = NgayKhoiHanh) THEN
       SIGNAL SQLSTATE "45000"
	       SET MESSAGE_TEXT = 'Tour không tồn tại !', MYSQL_ERRNO = 1001;
   END IF;
   SELECT COUNT(MaKhachLe) INTO SoKhach
   FROM PhieuDangKy AS A
   WHERE A.MaTour = MaTour AND A.NgayKhoiHanh = NgayKhoiHanh;
   SELECT COUNT(*) INTO Temp
   FROM PhieuDangKy AS A, KhachDoan_Gom_KhachLe AS B
   WHERE A.MaTour = MaTour AND A.NgayKhoiHanh = NgayKhoiHanh AND A.MaKhachDoan = B.MaKD;
   RETURN SoKhach + Temp;
END //
DELIMITER ;

-- 2. Viết một produre LichTrinhChuyen để in ra thông tin chi tiết một chuyến đi (0.5đ)
--    Input: mã tour, ngày khởi hành
--    Output: như ví dụ ở BTL 1, có thông tin đơn vị cung cấp vận chuyển.
--    Out của PROCEDURE bên dưới là một bảng TourInfo(STT_Ngay INT,
--                                                    LoaiHanhDong INT,
--                                    				  ThoiGianBatDau TIME,
--                                    				  ThoiGianKetThuc TIME,
--                                    				  MaDonVi VARCHAR(6),
--                                    				  TenDonVi VARCHAR(50),
--                                    				  MaDiemDuLich INT,
--													  TenDiem VARCHAR(50),
--													  MaDonViVanChuyen VARCHAR(6),
--                                    				  TenDonViVanChuyen VARCHAR(50),
--                                    	  			  MaCN VARCHAR(20),
--                                    				  TenCN VARCHAR(50));
-- DROP PROCEDURE IF EXISTS LichTrinhChuyen;
DELIMITER //
CREATE PROCEDURE LichTrinhChuyen(MaTour VARCHAR(20), NgayKhoiHanh DATE)
BEGIN
	IF NOT EXISTS (SELECT * FROM Tour AS A WHERE A.MaTour = MaTour AND A.NgayBatDau = NgayKhoiHanh) THEN
       SIGNAL SQLSTATE "45000"
	       SET MESSAGE_TEXT = 'Tour không tồn tại !', MYSQL_ERRNO = 1001;
    END IF;
	DROP TABLE IF EXISTS DonViDichVuTour;
	DROP TABLE IF EXISTS DonViVanChuyenTour;
    DROP TABLE IF EXISTS ChiNhanhPhuTrachTour;
    DROP TABLE IF EXISTS TourInfo;
    
    CREATE TEMPORARY TABLE DonViDichVuTour(STT_Ngay INT, Loai INT, MaDonVi VARCHAR(6), TenDonVi VARCHAR(50));
    INSERT INTO DonViDichVuTour SELECT STT_Ngay, Loai, A.MaDonVi, TenDonVi
								FROM DonViCungCapChuyen AS A, DonViCungCapDichVu AS B
								WHERE A.MaTour = MaTour AND A.MaDonVi = B.MaDonVi;
    
	CREATE TEMPORARY TABLE DonViVanChuyenTour(STT_Ngay INT, MaDonViVanChuyen VARCHAR(6), TenDonViVanChuyen VARCHAR(50));
    INSERT INTO DonViVanChuyenTour SELECT STT_Ngay, MaDonVi, TenDonVi
								   FROM DonViDichVuTour
                                   WHERE Loai = 8;
                                   
	CREATE TEMPORARY TABLE ChiNhanhPhuTrachTour(MaCN VARCHAR(20), TenCN VARCHAR(50));
    INSERT INTO ChiNhanhPhuTrachTour SELECT MaCN, TenCN
								     FROM Tour AS A, ChiNhanh AS B
                                     WHERE A.MaTour = MaTour AND A.MaChiNhanh = B.MaCN;
                                   
	CREATE TEMPORARY TABLE TourInfo(STT_Ngay INT,
                                    LoaiHanhDong INT,
                                    ThoiGianBatDau TIME,
                                    ThoiGianKetThuc TIME,
                                    MaDonVi VARCHAR(6),
                                    TenDonVi VARCHAR(50),
                                    MaDiemDuLich INT,
									TenDiem VARCHAR(50),
                                    MaDonViVanChuyen VARCHAR(6),
                                    TenDonViVanChuyen VARCHAR(50),
                                    MaCN VARCHAR(20),
                                    TenCN VARCHAR(50));
                                    
	INSERT INTO TourInfo(STT_Ngay, ThoiGianBatDau, ThoiGianKetThuc, MaDiemDuLich, TenDiem, MaDonViVanChuyen, TenDonViVanChuyen, MaCN, TenCN)
    SELECT A.STT_Ngay, ThoiGianBatDau, ThoiGianKetThuc, MaDiemDuLich, TenDiem, MaDonViVanChuyen, TenDonViVanChuyen, MaCN, TenCN
    FROM Tour_Co_DiaDiemThamQuan AS A, DiemDuLich AS B, DonViVanChuyenTour AS C, ChiNhanhPhuTrachTour AS D
    WHERE A.MaTour = MaTour AND A.MaDiemDuLich = B.MaDiem AND A.STT_Ngay = C.STT_Ngay;
    
    INSERT INTO TourInfo(STT_Ngay, LoaiHanhDong, ThoiGianBatDau, ThoiGianKetThuc, MaDonVi, TenDonVi, MaDonViVanChuyen, TenDonViVanChuyen, MaCN, TenCN)
    SELECT A.STT_Ngay, LoaiHanhDong, ThoiGianBatDau, ThoiGianKetThuc, MaDonVi, TenDonVi, MaDonViVanChuyen, TenDonViVanChuyen, MaCN, TenCN
    FROM HanhDong_LichTrinhTour AS A, DonViDichVuTour AS B, DonViVanChuyenTour AS C, ChiNhanhPhuTrachTour AS D
    WHERE A.MaTour = MaTour AND A.LoaiHanhDong = B.Loai AND A.STT_Ngay = B.STT_Ngay AND A.STT_Ngay = C.STT_Ngay;
    
    SELECT * FROM TourInfo ORDER BY STT_Ngay, ThoiGianBatDau ASC;
END //
DELIMITER ;

-- 3. Viết một procedure/function ThongKeDoanhThu dùng để thống kê tổng doanh thu tour theo tháng
--    trong một năm. (0.5đ)
--    Input: Năm thống kê
--    Output: có dạng <Tháng, Tổng doanh thu>.
-- DROP PROCEDURE IF EXISTS ThongKeDoanhThu;
DELIMITER //
CREATE PROCEDURE ThongKeDoanhThu(YearValue INT)
BEGIN
    SELECT m.MonthNumber AS 'Month', IFNULL(SUM(cd.TongGia), 0) AS 'TotalRevenue'
    FROM (
        SELECT 1 AS MonthNumber UNION ALL
        SELECT 2 UNION ALL
        SELECT 3 UNION ALL
        SELECT 4 UNION ALL
        SELECT 5 UNION ALL
        SELECT 6 UNION ALL
        SELECT 7 UNION ALL
        SELECT 8 UNION ALL
        SELECT 9 UNION ALL
        SELECT 10 UNION ALL
        SELECT 11 UNION ALL
        SELECT 12
    ) M
    LEFT JOIN ChuyenDi CD ON MONTH(CD.NgayKhoiHanh) = M.MonthNumber AND YEAR(CD.NgayKhoiHanh) = YearValue
    GROUP BY M.MonthNumber;
END //
DELIMITER ;

-- 1. Viết trigger cập nhật giá trị cho thuộc tính dẫn xuất tổng giá (tổng doanh thu) của bảng 16 khi insert 
-- hoặc delete một phiếu đăng ký. (1đ) 
-- Lưu ý: khách hàng <=10 tuổi thì tính theo giá vé trẻ em, ngược lại, tính theo giá vé người lớn. Nếu 
-- giá trị mã đoàn trong phiếu đăng ký là null, có nghĩa đây là phiếu đăng ký của khách lẻ, ngược lại là 
-- khách đoàn.

DELIMITER //
CREATE TRIGGER update_total_price_after_booking
AFTER INSERT ON PhieuDangKy
FOR EACH ROW
BEGIN
    DECLARE total_price INT DEFAULT 0;
    DECLARE age INT DEFAULT 0;
    DECLARE SoKhachDoan INT DEFAULT 0;
    
    -- Calculate the total price based on the inserted booking
    IF NEW.MaKhachLe IS NOT NULL THEN
        -- If it's an individual customer
        
        SELECT DATEDIFF(NEW.NgayDangKy, NgaySinh) / 365 INTO age
        FROM KhachHang
        WHERE MaKH = NEW.MaKhachLe;
        
        IF age <= 10 THEN
            SELECT GiaVeLeTreEm INTO total_price
            FROM Tour
            WHERE MaTour = NEW.MaTour;
        ELSE
            SELECT GiaVeLeNguoiLon INTO total_price
            FROM Tour
            WHERE MaTour = NEW.MaTour;
        END IF;
    ELSE
        -- If it's a group booking
        SELECT COUNT(*) INTO SoKhachDoan
        FROM KhachDoan_Gom_KhachLe
        WHERE KhachDoan_Gom_KhachLe.MaKD = NEW.MaKhachDoan;
        
        IF (SoKhachDoan >= (SELECT SoKhachDoanToiThieu FROM Tour WHERE MaTour = NEW.MaTour)) 
        THEN 
			SELECT SUM(CASE WHEN DATEDIFF(NOW(), KhachHang.NgaySinh) / 365 <= 10 THEN Tour.GiaVeDoanTreEm ELSE Tour.GiaVeDoanNguoiLon END)
			INTO total_price
			FROM KhachDoan
			JOIN KhachDoan_Gom_KhachLe ON KhachDoan.MaKD = KhachDoan_Gom_KhachLe.MaKD
			JOIN KhachHang ON KhachHang.MaKH = KhachDoan_Gom_KhachLe.MaKH
			JOIN Tour ON Tour.MaTour = NEW.MaTour AND Tour.NgayBatDau = NEW.NgayKhoiHanh AND KhachDoan.MaKD = NEW.MaKhachDoan;
		ELSE
			SELECT SUM(CASE WHEN DATEDIFF(NOW(), KhachHang.NgaySinh) / 365 <= 10 THEN Tour.GiaVeLeTreEm ELSE Tour.GiaVeLeNguoiLon END)
			INTO total_price
			FROM KhachDoan
			JOIN KhachDoan_Gom_KhachLe ON KhachDoan.MaKD = KhachDoan_Gom_KhachLe.MaKD
			JOIN KhachHang ON KhachHang.MaKH = KhachDoan_Gom_KhachLe.MaKH
			JOIN Tour ON Tour.MaTour = NEW.MaTour AND Tour.NgayBatDau = NEW.NgayKhoiHanh AND KhachDoan.MaKD = NEW.MaKhachDoan;
		END IF;
    END IF;
    
    -- Update the total price in ChuyenDi table
    UPDATE ChuyenDi
    SET TongGia = TongGia + total_price
    WHERE MaTour = NEW.MaTour AND NgayKhoiHanh = NEW.NgayKhoiHanh;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER update_total_price_after_cancellation
AFTER DELETE ON PhieuDangKy
FOR EACH ROW
BEGIN
    DECLARE total_price INT DEFAULT 0;
    DECLARE age INT DEFAULT 0;
    DECLARE SoKhachDoan INT DEFAULT 0;
    
    -- Calculate the total price based on the deleted booking
    IF OLD.MaKhachLe IS NOT NULL THEN
        -- If it's an individual customer
        
        SELECT DATEDIFF(OLD.NgayDangKy, NgaySinh) / 365 INTO age
        FROM KhachHang
        WHERE MaKH = OLD.MaKhachLe;
        
        IF age <= 10 THEN
            SELECT GiaVeLeTreEm INTO total_price
            FROM Tour
            WHERE MaTour = OLD.MaTour;
        ELSE
            SELECT GiaVeLeNguoiLon INTO total_price
            FROM Tour
            WHERE MaTour = OLD.MaTour;
        END IF;
    ELSE
        -- If it's a group booking
        SELECT COUNT(*) INTO SoKhachDoan
        FROM KhachDoan_Gom_KhachLe
        WHERE KhachDoan_Gom_KhachLe.MaKD = OLD.MaKhachDoan
        GROUP BY KhachDoan_Gom_KhachLe.MaKH;
        
        IF (SoKhachDoan >= (SELECT SoKhachDoanToiThieu FROM Tour WHERE MaTour = OLD.MaTour)) 
        THEN 
			SELECT SUM(CASE WHEN DATEDIFF(OLD.NgayDangKy, KhachHang.NgaySinh) / 365 <= 10 THEN Tour.GiaVeDoanTreEm ELSE Tour.GiaVeDoanNguoiLon END)
			INTO total_price
			FROM KhachDoan
			JOIN KhachDoan_Gom_KhachLe ON KhachDoan.MaKD = KhachDoan_Gom_KhachLe.MaKD
			JOIN KhachHang ON KhachHang.MaKH = KhachDoan_Gom_KhachLe.MaKH
			JOIN Tour ON Tour.MaTour = OLD.MaTour AND Tour.NgayBatDau = OLD.NgayKhoiHanh AND KhachDoan.MaKD = OLD.MaKhachDoan;
		ELSE
			SELECT SUM(CASE WHEN DATEDIFF(OLD.NgayDangKy, KhachHang.NgaySinh) / 365 <= 10 THEN Tour.GiaVeLeTreEm ELSE Tour.GiaVeLeNguoiLon END)
			INTO total_price
			FROM KhachDoan
			JOIN KhachDoan_Gom_KhachLe ON KhachDoan.MaKD = KhachDoan_Gom_KhachLe.MaKD
			JOIN KhachHang ON KhachHang.MaKH = KhachDoan_Gom_KhachLe.MaKH
			JOIN Tour ON Tour.MaTour = OLD.MaTour AND Tour.NgayBatDau = OLD.NgayKhoiHanh AND KhachDoan.MaKD = OLD.MaKhachDoan;
		END IF;
    END IF;
    
    -- Update the total price in ChuyenDi table
    UPDATE ChuyenDi
    SET TongGia = TongGia - total_price
    WHERE MaTour = OLD.MaTour AND NgayKhoiHanh = OLD.NgayKhoiHanh;
END;
//
DELIMITER ;
-- use asm2;
-- SELECT * FROM ChuyenDi;
-- Test Insert KhachLe
-- INSERT INTO KhachHang(MaKH, CMND, HoTen, Email, SDT, NgaySinh, DiaChi)
-- VALUES
-- 	('KH1001', '900000001', 'Nguyen Van A', 'nguyenvana@gmail.com', '0123456789', '2003-01-01', '123 Nguyen Van Cu, Quan 5, TP HCM');
-- INSERT INTO 
-- 	PhieuDangKy(NgayDangKy, GhiChu, MaNhanVien, MaKhachLe, MaKhachDoan, MaTour, NgayKhoiHanh)
-- VALUES
-- 	('2023-08-15', NULL, 'VP0001', 'KH1001', NULL, 'CN1-000001', '2023-08-28');
-- SELECT * FROM ChuyenDi;

-- -- Test Insert KhachDoan
-- INSERT INTO KhachHang(MaKH, CMND, HoTen, Email, SDT, NgaySinh, DiaChi)
-- VALUES
-- 	('KH1002', '900000002', 'Tran Thi B', 'tranthib@gmail.com', '0234567890', '1991-02-02', '234 Le Hong Phong, Quan 10, TP HCM'),
-- 	('KH1003', '900000003', 'Le Van C', 'levanc@gmail.com', '0345678901', '2016-03-03', '234 Le Hong Phong, Quan 10, TP HCM');
-- INSERT INTO KhachDoan(MaKD, TenCoQuan, Email, SDT, DiaChi, MaDaiDien)
-- VALUES
-- ('KD9001', 'Công ty E','congtya@gmail.com', '0773322445', '03 Điện Biên Phủ Quận 3 TP Hồ Chí Minh', 'KH1002');
-- INSERT INTO KhachDoan_Gom_KhachLe(MaKD, MaKH)
-- VALUES
-- ('KD9001', 'KH1002'),
-- ('KD9001', 'KH1003');
-- INSERT INTO 
-- 	PhieuDangKy(NgayDangKy, GhiChu, MaNhanVien, MaKhachLe, MaKhachDoan, MaTour, NgayKhoiHanh)
-- VALUES
-- 	('2023-08-15', NULL, 'VP0001', NULL, 'KD9001', 'CN4-000004', '2023-08-27');
-- SELECT * FROM ChuyenDi;

-- Test Delete Khachle
-- DELETE FROM PhieuDangKy
-- WHERE MaKhachLe = 'KH1001';
-- SELECT * FROM chuyendi;


-- Viết trigger kiểm tra ràng buộc sau: 
-- a. Khi thêm một lịch trình chuyến (bảng 18), phải tồn tại lịch trình này trong tour (bảng 13). Ví 
-- dụ: thêm một lịch trình chuyến (CN1-000001, 01/01/2023, 2), thì tour CN1-000001 phải có 
-- lịch trình cho ngày 2. (0.25đ)

DELIMITER //
CREATE TRIGGER check_LichTrinhChuyen BEFORE INSERT ON LichTrinhChuyen
FOR EACH ROW
BEGIN
    DECLARE ExistingSchedule INT;

    -- Check if the schedule exists for the given tour and day
    SELECT COUNT(*) INTO ExistingSchedule
    FROM LichTrinhTour
    WHERE MaTour = NEW.MaTour AND STT_Ngay = NEW.STT_Ngay;

    -- If no schedule exists, raise an error
    IF ExistingSchedule = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lịch trình chuyến không tồn tại trong tour cho ngày đã chọn.';
    END IF;
END;
//
DELIMITER ;
-- Trường hợp k hợp lệ
-- INSERT INTO
-- 	LichTrinhChuyen
-- VALUES
-- 	('CN1-000001', '2023-08-28', 3);
-- Trường hợp hợp lệ
-- INSERT INTO 
-- 	LichTrinhTour
-- VALUES
-- 	('CN1-000001', 3);
--     INSERT INTO
-- 	LichTrinhChuyen
-- VALUES
-- 	('CN1-000001', '2023-08-28', 3);
-- b. Khi thêm một đơn vị cung cấp vận chuyển cho chuyến đi (bảng 19), phải tồn tại loại hoạt 
-- động này trong lịch trình tour (bảng 15), ngoại trừ loại hình vận chuyển (0.25đ)
-- DROP TRIGGER check_donvicungcapchuyen;
DELIMITER //
CREATE TRIGGER check_donvicungcapchuyen BEFORE INSERT ON DonViCungCapChuyen
FOR EACH ROW
BEGIN
    DECLARE ExistingActivityType INT DEFAULT 0;
    DECLARE MaTour_Check INT DEFAULT 0;

    -- Check if the activity type exists for the given tour and activity type
    SELECT COUNT(*) INTO ExistingActivityType
    FROM HanhDong_LichTrinhTour
    WHERE MaTour = NEW.MaTour AND STT_Ngay = NEW.STT_Ngay AND LoaiHanhDong = NEW.Loai;

    -- Check if the tour exists for the given MaTour
    SELECT COUNT(*) INTO MaTour_Check
    FROM HanhDong_LichTrinhTour
    WHERE MaTour = NEW.MaTour AND STT_Ngay = NEW.STT_Ngay;
    
    -- If the activity type doesn't exist, raise an error
    IF ((ExistingActivityType = 0 AND NEW.Loai <> 8) OR (NEW.Loai = 8 AND MaTour_Check = 0)) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Loại hoạt động không tồn tại trong lịch trình tour cho ngày đã chọn.';
    END IF;
END;
//
DELIMITER ;

-- Trường hợp không hợp lệ 1
-- INSERT INTO
-- 	DonViCungCapChuyen
-- VALUES
-- 	('CN7-000001', '2023-08-28', 1, 8, 'DV0003');

-- Trường hợp không hợp lệ 2
-- INSERT INTO
-- 	DonViCungCapChuyen
-- VALUES
-- 	('CN1-000001', '2023-08-28', 1, 3, 'DV0003');

-- Trường hợp hợp lệ 1
-- INSERT INTO
-- 	DonViCungCapChuyen
-- VALUES
-- 	('CN1-000001', '2023-08-28', 2, 8, 'DV0003');

-- Trường hợp hợp lệ 2
-- INSERT INTO 
-- 	HanhDong_LichTrinhTour
-- VALUES 
--     ('CN1-000001', 1, 3, '07:00', '08:00', 'Ăn sáng tại nhà hàng');
-- INSERT INTO
-- 	DonViCungCapChuyen
-- VALUES
-- 	('CN1-000001', '2023-08-28', 1, 3, 'DV0003');

ALTER TABLE ChiNhanh DROP FOREIGN KEY FK_MaNVQL; 

-- Insert to ChiNhanh table
INSERT INTO 
	ChiNhanh(TenCN, KhuVuc, DiaChi, Email, Fax, MaNVQL) 
VALUES 
	("CN_Hà_Nội", "Hà Nội", "1 Hoàng Văn Thụ", "cn_hanoi@gmail.com", "(+84-236) 364 7980", "VP0001"),
    ("CN_Đà_Nẵng", "Đà Nẵng", "42 Lam Sơn", "cn_danang@gmail.com", "(+84-236) 382 2854", "VP0005"),
    ("CN_Hồ_Chí_Minh", "Hồ Chí Minh", "190 Pasteur", "cn_hochiminh@gmail.com", "(+84-28) 3829 9142", "VP0009"),
    ("CN_Quảng_Ninh", "Quảng Ninh", "18 Đường 25/4", "cn_quangninh@gmail.com", " (+84-203) 6262 255", "VP0013"); 

-- Insert to NhanVien table
INSERT INTO 
	NhanVien(MaNV, CMND, HoTen, DiaChi, GioiTinh, NgaySinh, LoaiNV, ViTri, MaCN)
VALUES
	("VP0001", "054203001500", "Trần Văn A", "5 Hoàng Văn Thụ", 'M', '1995-08-07', 1, "Hà Nội", "CN1"),
    ("VP0002", "054203001501", "Nguyễn Thị B", "9 Hoàng Văn Thụ", 'F', '1993-03-07', 1, "Hà Nội", "CN1"),
    ("HD0003", "054203001502", "Trần Hoàng C", "10 Hoàng Văn Thụ", 'M', '1994-05-07', 2, "Hà Nội", "CN1"),
    ("HD0004", "054203001503", "Lê Văn D", "1 Hoàng Diệu", 'M', '1990-12-15', 2, "Hà Nội", "CN1"),
    ("VP0005", "054203001504", "Mộng Thị E", "8 Dương Lâm", 'F', '1980-09-08', 1, "Đà Nẵng", "CN2"),
    ("HD0006", "054203001505", "Hồ Văn F", "19 Dương Lâm", 'M', '1978-12-08', 2, "Đà Nẵng", "CN2"),
    ("VP0007", "054203001506", "Lã Hồng G", "11 Thạch Lam", 'M', '1976-05-18', 1, "Đà Nẵng", "CN2"),
    ("HD0008", "054203001507", "Lê Thị H", "108 Võ Nguyên Giáp", 'F', '1988-10-29', 2, "Đà Nẵng", "CN2"),
    ("VP0009", "054203001508", "Nông Văn I", "10 Điện Biên Phủ", 'M', '1985-11-29', 1, "Hồ Chí Minh", "CN3"),
    ("VP0010", "054203001509", "Nguyễn Trần J", "261 Chu Văn An", 'M', '1986-10-15', 1, "Hồ Chí Minh", "CN3"),
    ("HD0011", "054203001510", "Nguyễn Xuân K", "102 Lý Thường Kiệt", 'F', '1987-08-20', 2, "Hồ Chí Minh", "CN3"),
    ("VP0012", "054203001511", "Hồng Thị L", "18 Võ Văn Ngân", 'F', '1982-06-21', 1, "Hồ Chí Minh", "CN3"),
    ("VP0013", "054203001512", "Mai Hoàng M", "10 Cẩm Phả", 'M', '1991-08-27', 1, "Quảng Ninh", "CN4"),
    ("VP0014", "054203001513", "Lê Thị N", "76 Nguyễn Văn Cừ", 'F', '1983-07-25', 1, "Quảng Ninh", "CN4"),
    ("HD0015", "054203001514", "Trần Nho P", "30 Trần Quốc Nghiễn", 'M', '1995-02-27', 2, "Quảng Ninh", "CN4"),
    ("HD0016", "054203001515", "Mai Thị Y", "50 Hải Thắng", 'F', '1994-03-16', 2, "Quảng Ninh", "CN4");

-- Make foreign key from ChiNhanh(MaNVQL) to NhanVien(MaNV)
ALTER TABLE ChiNhanh 
ADD CONSTRAINT FK_MaNVQL FOREIGN KEY (MaNVQL) REFERENCES NhanVien(MaNV);

-- Insert to SDT_CN table
INSERT INTO
	SDT_CN(MaCN, SDT)
VALUES
	("CN1", "+842363647979"), ("CN1", "+842363647980"), ("CN1", "+842363215960"),
    ("CN2", "+842363821266"), ("CN2", "+842363822185"),
    ("CN3", "+842838668999"),
    ("CN4", "+842036262266");
    
-- Insert to NgoaiNgu_NV
INSERT INTO 
	NgoaiNgu_NV(MaNV, NgoaiNgu)
VALUES 
	("HD0003", "Anh"), ("HD0003", "Pháp"),
    ("HD0004", "Anh"),
    ("HD0006", "Trung"), ("HD0006", "Anh"), ("HD0006", "Hàn"),
    ("HD0008", "Nhật"), ("HD0008", "Anh"),
    ("HD0011", "Thái"), ("HD0011", "Anh"),
    ("HD0015", "Đức"), ("HD0015", "Anh"),
    ("HD0016", "Anh"), ("HD0016", "Tây Ban Nha");
    
-- Insert to KyNang_NV
INSERT INTO
	KyNang_NV(MaNV, KyNang)
VALUES
	("HD0003", "Thuyết Trình"), ("HD0003", "Sắp Xếp"),
    ("HD0004", "Thuyết Trình"), ("HD0004","Xử Lý Tình Huống"),
    ("HD0006", "Thuyết Trình"), ("HD0006", "Kiểm Soát Cảm Xúc"),
    ("HD0008", "Thuyết Trình"), ("HD0008", "Sử Dụng Phương Tiện Truyền Thông"),
    ("HD0011", "Thuyết Trình"), ("HD0011", "Quan Sát"), ("HD0011", "Xử Lý Tình Huống"),
    ("HD0015", "Thuyết Trình"), ("HD0015", "Sắp Xếp"), ("HD0015", "Quan Sát"),
    ("HD0016", "Thuyết Trình"), ("HD0016", "Giao Tiếp"), ("HD0016", "Sắp Xếp");
    
-- Insert to DiemDuLich
INSERT INTO 
	DiemDuLich(TenDiem, DiaChi, PhuongXa, QuanHuyen, TinhThanh, Anh1, Anh2, Anh3, MoTa, GhiChu)
VALUES 
	("Lăng Bác", "Số 2 Hùng Vương", "Điện Biên", "Ba Đình", "Hà Nội", "https://inkythuatso.com/uploads/thumbnails/800/2023/03/1-hinh-anh-lang-bac-ho-inkythuatso-04-11-23-13.jpg", NULL, NULL, 
		NULL,"Chú ý ăn mặc chỉnh tề, không đem theo các thiết bị điện tử ghi hành và giữ trật tự trong lăng"),
	("Văn Miếu - Quốc Tử Giám", "58 P.Quốc Tử Giám", "Văn Miếu", "Đống Đa", "Hà Nội", "https://ik.imagekit.io/tvlk/blog/2022/08/van-mieu-quoc-tu-giam-1.jpg",
    "https://nucuoimekong.com/wp-content/uploads/anh-van-mieu-quoc-tu-giam.jpg", NULL, NULL, NULL),
    ("Nhà Tù Hỏa Lò", "1 P.Hỏa Lò", "Trần Hưng Đạo", "Hoàn Kiếm", "Hà Nội", "https://cdn.vntrip.vn/cam-nang/wp-content/uploads/2017/08/nha-tu-hoa-lo.jpg",
    "https://statics.vinpearl.com/nha-tu-hoa-lo-4_1682224240.jpg", "https://statics.vinpearl.com/nha-tu-hoa-lo-6_1682224296.jpg", 
    "Là nơi giam giữ những chiến sĩ cách mạng chống lại chế độ thực dân", NULL),
    ("Vịnh Hạ Long", NULL, NULL, "TP Hạ Long", "Quảng Ninh", "https://ik.imagekit.io/tvlk/blog/2022/06/kham-pha-du-lich-Ha-Long-3.jpg",
    "https://halongbay.com.vn/Data/images/baiviet/vi-tri-dia-ly-15720.jpeg",
    "https://ik.imagekit.io/tvlk/blog/2022/06/kham-pha-du-lich-Ha-Long-7.jpg?tr=dpr-2,w-675",
    NULL, NULL),
    ("Thác Khe Vằn", NULL, "Húc Động", "Bình Liêu", "Quảng Ninh", "https://ik.imagekit.io/tvlk/blog/2022/10/thac-khe-van-1.jpg?tr=dpr-2,w-675", 
    "https://media.vov.vn/sites/default/files/styles/large_watermark/public/2021-12/suoi_1.jpg", NULL, NULL, NULL),
    ("Bà Nà Hills", "thôn An Sơn", "Hòa Ninh", "Hòa Vang", "Đà Nẵng", "https://hoangkimlandscape.com/image/catalog/5.%20BLOG/18-BA-NA-HILL-CHAU-AU-THU-NHO-NAM-GON-GIUA-NGAN-MAY/2-cay-cau-vang.jpg",
    "https://cdn.tgdd.vn/Files/2021/07/03/1365294/kinh-nghiem-du-lich-ba-na-hill-tron-ven-tu-a-z-202206041049510078.jpg",
    NULL, NULL, NULL),
    ("Phố cổ Hội An", NULL, "Minh An", "Hội An", "Quảng Nam", "https://cdn.vntrip.vn/cam-nang/wp-content/uploads/2017/08/hoi-an-quang-nam-vntrip.jpg",
    "https://cdn.vntrip.vn/cam-nang/wp-content/uploads/2017/08/hoi-an-quang-nam-vntrip-1-768x472.jpg",
    "https://cdn.vntrip.vn/cam-nang/wp-content/uploads/2017/08/pho-co-hoi-an-vntrip-1-768x1110.jpg",
    "Một phố cổ giữ được gần như nguyên vẹn với hơn 1000 di tích kiến trúc từ phố xá, nhà cửa, hội quán, đình, chùa, miếu, nhà thờ tộc, giếng cổ… đến các món ăn truyền thống, tâm hồn của người dân nơi đây.",
    NULL),
    ("Thánh Địa Mỹ Sơn", NULL, "Duy Phú", "Duy Xuyên", "Quảng Nam", "https://res.klook.com/image/upload/fl_lossy.progressive,q_85/c_fill,w_1000/v1647510628/blog/qvy28hgciwgog8rpv3gw.webp", NULL, NULL,
    "Là di sản lịch sử nổi tiếng của tỉnh Quảng Nam với quần thể kiến trúc gồm nhiều đền đài Chăm Pa vô cùng độc đáo",
    "Thời gian tham quan từ 6:00 tới 17:00"),
    ("Nhà Thờ Đức Bà", "Số 1 Công Xã Paris", "Bến Nghé", "Quận 1", "TP Hồ Chí Minh", "https://statics.vinpearl.com/NH%C3%80-TH%E1%BB%9C-%C4%90%E1%BB%A8C-B%C3%80-1_1660297328.jpg",
    "https://ik.imagekit.io/tvlk/blog/2023/01/nha-tho-duc-ba-2-769x1024.jpg?tr=dpr-2,w-675",
    "https://ik.imagekit.io/tvlk/blog/2023/01/nha-tho-duc-ba-5.jpg?tr=dpr-2,w-675", 
    "Kiến trúc của nhà thờ là sự kết hợp giữa phong cách Roman và Gothic nên mang đậm nét cổ điển và sang trọng",
    "Giá vé tham quan miễn phí"),
    ("Dinh Độc Lập - Hội trường Thống Nhất", "Số 135 Đường Nam Kỳ Khởi Nghĩa", "Bến Thành", "Quận 1", "TP Hồ Chí Minh",
    "https://ik.imagekit.io/tvlk/blog/2023/01/dinh-doc-lap-1.jpg?tr=dpr-2,w-675",
    "https://cdn3.dhht.vn/wp-content/uploads/2023/03/dinh-doc-lap-ben-trong-co-gi-o-dau-gia-ve-gio-mo-cua-10.jpg",
    "https://cdn3.dhht.vn/wp-content/uploads/2023/03/dinh-doc-lap-ben-trong-co-gi-o-dau-gia-ve-gio-mo-cua-18.jpg",
    NULL, "Dinh Độc Lập mở cửa cho khách du lịch đến tham quan vào tất cả các ngày trong tuần với 2 khung giờ từ 7h30 đến 11h30 sáng và từ 13h00 đến 17h00 chiều.");
    
INSERT INTO donvicungcapdichvu 
VALUES 
('DV0001', 'VietThanh Travel', 'xekhach1@gmail.com', '0358398999', 'Lý Thị A', '0923456781', '6 Trần Đăng Ninh', 'Quang Trung', 'Hà Đông', 'Hà Nội', 
'https://images.toplist.vn/images/800px/cong-ty-cptm-amp-du-lich-viet-thanh-vietthanh-travel-421594.jpg',
'https://images.toplist.vn/images/800px/cong-ty-cptm-amp-du-lich-viet-thanh-vietthanh-travel-766348.jpg',
'https://vietthanhtravel.com.vn/wp-content/uploads/2023/01/slide1-1.png',
'https://vietthanhtravel.com.vn/wp-content/uploads/2018/08/thue_xe-1.jpg', NULL,
2, NULL ),

('DV0002', 'Anatole Hotel', 'sale@anatolehotelhanoi.com', '02436751888', 'Trương Hoàng Nguyên Vũ', '0923456781', '26-28-30 P.Nhà Chung', 'Hàng Trống', 'Hoàn Kiếm', 'Hà Nội', 
'https://du-lich.chudu24.com/f/m/2002/06/overview-3-0934397.jpg?w=800&h=500',
'https://du-lich.chudu24.com/f/m/2002/06/lobby-5-0934396.jpg?w=800&h=500',
'https://du-lich.chudu24.com/f/m/2002/06/lobby-4-0934397.jpg?w=800&h=500',
'https://du-lich.chudu24.com/f/m/2002/06/lobby-2-khong-gian-0934397.jpg?w=800&h=500', 
'https://du-lich.chudu24.com/f/m/2002/06/lobby-8-0934396.jpg?w=800&h=500',
1, NULL ),

('DV0003', 'ESSENCE Restaurant', 'essencehanoirestaurant@gmail.com', '024 3935 2485', 'Mai Hoàng Nhu', '0932220407', '38 Đường Trần Phú', NULL, 'Ba Đình', 'Hà Nội', 
'https://du-lich.chudu24.com/f/m/2002/06/overview-3-0934397.jpg?w=800&h=500',
'https://du-lich.chudu24.com/f/m/2002/06/lobby-5-0934396.jpg?w=800&h=500',
'https://du-lich.chudu24.com/f/m/2002/06/lobby-4-0934397.jpg?w=800&h=500',
'https://du-lich.chudu24.com/f/m/2002/06/lobby-2-khong-gian-0934397.jpg?w=800&h=500', 
'https://du-lich.chudu24.com/f/m/2002/06/lobby-8-0934396.jpg?w=800&h=500',
3, NULL),

('DV1004', 'Việt Thiên Tâm Travel', 'vietthientam279@gmail.com', '0965036161', 'Hoàng Đức Nguyên', '0918106236', 'Số 3 ngõ 225 Lương Thế Vinh', 'Trung Văn', 'Nam Từ Liêm', 'Hà Nội', 
NULL, NULL, NULL, NULL, NULL, 2, NULL), -- Dịch vụ xe Tour Quảng Ninh

('DV1005', 'Hạ Long Tropical Bay Hotel', NULL, '0339 691 981', 'Nguyễn Tuấn Minh', '0977895246', 'TT03 - THỦY TÙNG', 'Bãi Cháy', 'Hạ Long', 'Quảng Ninh', 
'https://ak-d.tripcdn.com/images/0222r12000avyhfpk95B2_R_640_440_R5_D.jpg_.webp',
'https://ak-d.tripcdn.com/images/0222z12000aun9c4x6F77_R_600_400_R5_D.jpg_.webp',
'https://ak-d.tripcdn.com/images/0223z12000av39k7r2C1F_Z_960_660_R5_D.jpg_.webp',
'https://ak-d.tripcdn.com/images/0223j12000aix5pctEC84_Z_960_660_R5_D.jpg_.webp', 
'https://ak-d.tripcdn.com/images/0224112000aix5qmh3A13_Z_960_660_R5_D.jpg_.webp', 1, 'Không mang vật nuôi vào khách sạn'),

('DV1006', 'Nhà hàng Ngọc Phương Nam', 'phuongnamhalongrestaurant@gmail.com', ' 0335400800', 'Phạm Đức Hào', '0901599598', 'Đỗ Sĩ Họa', 'Bãi Cháy' , 'Hạ Long', 'Quảng Ninh', 
'https://onevivu.vn/wp-content/uploads/2023/02/Anh-9-Nha-hang-ngoc-phuong-nam-ha-long.jpg',
'https://onevivu.vn/wp-content/uploads/2023/02/Nha-hang-Phuong-Nam-Ha-Long.jpg',
'https://onevivu.vn/wp-content/uploads/2023/02/Ngoc-Phuong-Nam-Ha-Long-1.jpg',
'https://onevivu.vn/wp-content/uploads/2023/02/khong-gian-nha-hang.jpg',
 'https://onevivu.vn/wp-content/uploads/2023/02/Ngoc-Phuong-Nam-Ha-Long.jpg', 3, 'Không mang thức ăn đồ uống từ bên ngoài'),

('DV2007', 'Công ty Du lịch Lâm Khai Trí', 'print.khaitri@gmail.com', ' 0982101223', 'Mai Hoàng Danh', '0913420922 ', '68 Tôn Đức Thắng', NULL , 'Tam Kỳ', 'Quảng Nam', 
'http://chothuexeotodulichtaiquangnam.com/HinhCTSP/8002thue-xe-7-cho-tam-ky-053.jpg',
'http://chothuexeotodulichtaiquangnam.com/HinhCTSP/3128thue-xe-35cho-tam-ky-01.jpg',
'https://toplist.vn/images/800px/cong-ty-tnhh-du-lich-lam-khai-tri-777105.jpg',
NULL, NULL, 2, NULL),

('DV2008', 'Hoi An Rose Garden Hotel', 'booking@hoianrosegardenhotel.com', '0981002200', 'Tạ Đình Tiến', '0944435395', '23 Nguyễn Hiền', ' Tân An' , 'Hội An', 'Quảng Nam', 
'https://hoianrosegardenhotel.com/wp-content/uploads/2018/12/Superior-Room-with-Balcony.jpg',
'https://hoianrosegardenhotel.com/wp-content/uploads/2018/12/Family-Room-with-Balcony-1.jpg',
'https://hoianrosegardenhotel.com/wp-content/uploads/2018/12/Deluxe-Twin-Room.jpg',
'https://hoianrosegardenhotel.com/wp-content/uploads/2018/10/gallery5-800x400.jpg',
 'https://hoianrosegardenhotel.com/wp-content/uploads/2018/11/slide2-800x400.png', 1, 'Có spa và các dịch vụ ăn uống'),
 
 ('DV2009', 'Nhà hàng Quảng Nam', 'essencehanoirestaurant@gmail.com', '0905799450', 'Lê Phúc Nguyên', '0986923777', '138 Lê Lợi', 'An Mỹ', 'Tam Kỳ', 'Quảng Nam', 
'https://danhbaquangnam.com/wp-content/uploads/2020/05/5-818x490.jpg?v=1667965382',
'https://danhbaquangnam.com/wp-content/uploads/2020/05/1.jpg?v=1667965387',
'https://danhbaquangnam.com/wp-content/uploads/2020/05/3.jpg?v=1667965386',
'https://danhbaquangnam.com/wp-content/uploads/2020/05/4.jpg?v=1667965384', 
NULL, 3, 'Không phục vụ mang về'),

('DV3010', 'Saigon Tourist Travel', 'info@saigontourist.net', '19001808', 'Phạm Thế Quang', '0988774422', '45 Lê Thánh Tôn', 'Bến Nghé', '1', 'TP Hồ Chí Minh',
'https://www.saigontourist.net/uploads/destination/TrongNuoc/Hochiminh/ben-bach-dang.jpg',
'https://www.saigontourist.net/uploads/destination/TrongNuoc/Hochiminh/dcd9fa66aa62e08f11e1f91fa6e92d3a.jpg',
'https://www.saigontourist.net/uploads/destination/TrongNuoc/Hochiminh/81fb9cc7f5de11a6a757f8c7d0eeb425.jpg',
'https://www.saigontourist.net/uploads/destination/TrongNuoc/Hochiminh/3f38deefed140913bb472fdae1c0902d.jpg',
NULL, 2, 'Du trình kết hợp xe bus 2 tầng'),

('DV3011', 'Home Hotel', 'info@homehotel.com.vn', '0822222201', 'Đỗ Nguyễn Bá Hoàng', '0935987123', '158 Nguyễn Đình Chính', '8', 'Phú Nhuận', 'TP Hồ Chí Minh',
'https://homehotel.com.vn/wp-content/uploads/2020/08/superior-room-homehotel-3.jpg',
'https://homehotel.com.vn/wp-content/uploads/2020/09/goc-noi-bat-homehotel-2.jpg',
'https://homehotel.com.vn/wp-content/uploads/2020/09/coffee-home-hotel-1.jpg',
'https://homehotel.com.vn/wp-content/uploads/2020/09/image-lounge-homehotel-6.jpg',
'https://homehotel.com.vn/wp-content/uploads/2020/08/superior-room-homehotel-5.jpg', 1, 'Có các dịch vụ ăn uống, bar, nơi tổ chức sự kiện'),

('DV3012', 'Nhà Hàng Ngọc Sương Saigon', 'hi@ngocsuong.co', '0888 599 399', 'Phạm Văn Huy', '0327502021', '08 Nguyễn Siêu', 'Bến Nghé', '1', 'TP Hồ Chí Minh',
'https://cdn.tuoitre.vn/thumb_w/730/2019/1/11/photo-1-15471749349422008399290.jpg',
'https://congthuong-cdn.mastercms.vn/stores/news_dataimages/mn_viethung/122018/17/14/in_article/0454_NgYc-SYYng-SYYng-NguyYt-Anh-20.jpg',
'https://media-cdn.tripadvisor.com/media/photo-s/0e/0e/07/9d/nha-hang-ng-c-suong-b.jpg',
NULL, NULL, 3, NULL);

INSERT INTO khachhang 
VALUES
('KH0001', '123456789', 'Nguyen Van A', 'nguyenvana@gmail.com', '0123456789', '2016-01-01', '123 Nguyen Van Cu, Quan 5, TP HCM'),
('KH0002', '234567890', 'Tran Thi B', 'tranthib@gmail.com', '0234567890', '1991-02-02', '234 Le Hong Phong, Quan 10, TP HCM'),
('KH0003', '345678901', 'Le Van C', 'levanc@gmail.com', '0345678901', '1992-03-03', '345 Tran Hung Dao, Quan 1, TP HCM'),
('KH0004', '456789012', 'Pham Thi D', 'phamthid@gmail.com', '0456789012', '1993-04-04', '456 Nguyen Trai, Quan 5, TP HCM'),
('KH0005', '567890123', 'Hoang Van E', 'hoangvane@gmail.com', '0567890123', '1994-05-05', '567 Le Van Sy, Quan 3, TP HCM'),
('KH0006', '678901234', 'Do Thi F', 'dothif@gmail.com', '0678901234', '1995-06-06', '678 Cach Mang Thang Tam, Quan 10, TP HCM'),
('KH0007', '789012345', 'Truong Van G', 'truongvang@gmail.com', '0789012345', '2012-07-07', '789 Pham Ngu Lao, Quan 1, TP HCM'),
('KH0008', '890123456', 'Vo Thi H', 'vothih@gmail.com', '0890123456', '1997-08-08', '1 Nguyen Hue, Quan 1, TP HCM'),
('KH0009', '123456700', 'Nguyen Van X', 'nguyenvanx@gmail.com', '0123456700', '1998-09-09', '123 Nguyen Van Cu, Quan 5, TP HCM'),
('KH0010', '234567800', 'Tran Thi Y', 'tranthiy@gmail.com', '0234567800', '2012-10-10', '234 Le Hong Phong, Quan 10, TP HCM'),
('KH0011', '345678900', 'Le Van Z', 'levanz@gmail.com', '0345678900', '2000-11-11', '345 Tran Hung Dao, Quan 1, TP HCM');

INSERT INTO khachdoan
VALUES
('KD0001', 'Công ty A','congtya@gmail.com', '0773322445', '03 Điện Biên Phủ Quận 3 TP Hồ Chí Minh', 'KH0001'),
('KD1002', 'Công ty B', 'congtyb@gmail.com', '0337722445', '03 Tô Hiến Thành Quận 10 TP Hồ Chí Minh', 'KH0003'),
('KD2003', 'Công ty C', 'congtyc@gmail.com', '0556677889', '132 Chu Văn An Quận Bình Thành TP Hồ Chí Minh', 'KH0005'),
('KD3004', 'Công ty D', 'congtyd@gmail.com', '0388991122', '05 Phạm Văn Đồng Quận 9 TP Hồ Chí Minh', 'KH0007');


INSERT INTO khachdoan_gom_khachle
VALUES
('KD0001', 'KH0001'),
('KD0001', 'KH0002'),
('KD1002', 'KH0003'),
('KD1002', 'KH0004'),
('KD2003', 'KH0005'),
('KD2003', 'KH0006'),
('KD3004', 'KH0007'),
('KD3004', 'KH0008');
    
INSERT INTO 
	tour(MaChiNhanh, TenTour, Anh, NgayBatDau, SoKhachToiThieu, SoKhachToiDa, GiaVeLeNguoiLon, GiaVeLeTreEm, GiaVeDoanNguoiLon, GiaVeDoanTreEm, SoKhachDoanToiThieu,SoDem, SoNgay)
VALUES 
	('CN1', 'Tour Hà Nội', 'https://vietnam.travel/sites/default/files/inline-images/Wallpaper_Ha%20Noi_Vietnam%20Tourism.jpg', '2023-08-28', 2, 10, 800000, 650000, 700000, 550000, 2, 2, 2),
    ('CN2', 'Tour Đà Nẵng', 'https://haycafe.vn/wp-content/uploads/2022/01/Hinh-anh-cau-Rong-dep-huyen-bi-1.jpg', '2023-09-02', 2, 10, 800000, 650000, 700000, 550000, 2, 2, 2),
    ('CN3', 'Tour Hồ Chí Minh', 'https://haycafe.vn/wp-content/uploads/2021/12/hinh-anh-thanh-pho-Ho-Chi-Minh-luc-len-den.jpg', '2023-08-30', 3, 10, 800000, 650000, 700000, 550000, 3, 3, 3),
    ('CN4', 'Tour Quảng Ninh', 'https://haycafe.vn/wp-content/uploads/2022/01/Hinh-anh-Ha-Long-tuyet-dep.jpg', '2023-08-27', 1, 10, 800000, 650000, 700000, 550000, 2, 4, 4);

INSERT INTO 
	ngaykhoihanh_tourdaingay
VALUES
	('CN1-000001', 28), ('CN2-000002', 2), ('CN3-000003', 30), ('CN4-000004', 27);
    
INSERT INTO 
	lichtrinhtour
VALUES
	('CN1-000001', 1), ('CN1-000001', 2),
    ('CN2-000002', 1), ('CN2-000002', 2),
    ('CN3-000003', 1), ('CN3-000003', 2), ('CN3-000003', 3),
    ('CN4-000004', 1), ('CN4-000004', 2), ('CN4-000004', 3), ('CN4-000004', 4);
    
INSERT INTO
	Tour_Co_DiaDiemThamQuan
VALUES
	('CN1-000001', 1, 1, '09:00', '12:00', 'Một công trình có ý nghĩa rất lớn với mọi người dân Việt Nam, nơi đặt thi hài vị cha già kính yêu của dân tộc'), 
    ('CN1-000001', 2, 2, '09:00', '12:00', 'Trường đại học đầu tiên của Việt Nam, nơi ghi dấu các vị Trạng Nguyên tài giỏi đã làm rạng danh trí tuệ con người Đất Việt trong lịch sử'),
    ('CN2-000002', 1, 6, '08:00', '16:00', 'Khu vui chơi giải trí tuyệt đẹp tựa như chuyến đi lên tiên cảnh'), 
    ('CN2-000002', 2, 7, '10:00', '16:00', 'Khu cảng sầm uất một thời của Việt Nam xưa với các công trình cổ kính mang đậm dấu ấn lịch sử'),
    ('CN3-000003', 1, 9, '14:00', '16:00', 'Tiểu vương cung Thánh đường Đức Bà Sài Gòn - một công trình đậm chất tôn giáo đại diện cho nét đẹp cổ kính của Sài Gòn xưa'), 
    ('CN3-000003', 2, 10, '10:00', '12:00', 'Dinh Độc Lập - công trình đại diện cho sự rực rỡ của Sài Gòn xưa, nơi cũng ghi dấu cho chiến thắng rực rỡ 30/04/1975 thống nhất đất nước'), 
    ('CN4-000004', 1, 4, '08:00', '16:00', 'Kỳ quan thiên nhiên thế giới, nơi vẻ đẹp đất trời và sự hùng vĩ hội tụ'), 
    ('CN4-000004', 2, 5, '08:00', '16:00', 'Một điểm đến không thể bỏ qua khi đến với Quảng Ninh - nơi được mẹ thiên nhiên ưu ái ban cho vẻ đẹp rực rỡ của núi rừng');
    
INSERT INTO 
	HanhDong_LichTrinhTour
VALUES
	('CN1-000001', 1, 1, '07:30', '08:30', 'Khởi hành đến với khách sạn'), 
    ('CN1-000001', 1, 6, '08:30', '08:45', 'Check in vào khách sạn'),
    ('CN1-000001', 1, 4, '12:30', '13:30', 'Ăn trưa tại nhà hàng'),
    ('CN1-000001', 1, 5, '18:30', '19:30', 'Ăn tối tại nhà hàng'), 
    ('CN1-000001', 2, 3, '07:00', '08:00', 'Ăn sáng tại nhà hàng'),
    ('CN1-000001', 2, 4, '12:30', '13:30', 'Ăn trưa tại nhà hàng'),
    ('CN1-000001', 2, 7, '16:45', '17:00', 'Check out ra khách sạn'),
    ('CN1-000001', 2, 2, '17:00', '18:00', 'Kết thúc tour và trở về'),
    
    ('CN2-000002', 1, 1, '06:30', '07:15', 'Khởi hành đến với khách sạn'),
    ('CN2-000002', 1, 6, '07:15', '07:30', 'Check in vào khách sạn'),
    ('CN2-000002', 1, 4, '12:30', '13:30', 'Ăn trưa tại nhà hàng'),
    ('CN2-000002', 1, 5, '18:30', '19:30', 'Ăn tối tại nhà hàng'),
    ('CN2-000002', 2, 3, '06:30', '07:30', 'Ăn sáng tại nhà hàng'),
    ('CN2-000002', 2, 7, '07:30', '07:45', 'Check out ra khách sạn'),
	('CN2-000002', 2, 4, '12:30', '13:30', 'Ăn trưa tại nhà hàng'),
    ('CN2-000002', 2, 2, '16:00', '18:00', 'Kết thúc tour và trở về'),
    
    ('CN3-000003', 1, 1, '07:00', '08:00', 'Khởi hành đến với khách sạn'), 
    ('CN3-000003', 1, 6, '08:00', '08:15', 'Check in vào khách sạn'), 
    ('CN3-000003', 1, 4, '12:30', '13:30', 'Ăn trưa tại nhà hàng'),
    ('CN3-000003', 1, 5, '18:30', '19:30', 'Ăn tối tại nhà hàng'), 
    ('CN3-000003', 2, 3, '07:00', '08:00', 'Ăn sáng tại nhà hàng'), 
    ('CN3-000003', 2, 4, '12:30', '13:30', 'Ăn trưa tại nhà hàng'),
    ('CN3-000003', 2, 5, '18:30', '19:30', 'Ăn tối tại nhà hàng'), 
    ('CN3-000003', 3, 3, '07:00', '08:00', 'Ăn sáng tại nhà hàng'),
	('CN3-000003', 3, 7, '08:00', '08:15', 'Check out ra khách sạn'),
	('CN3-000003', 3, 2, '08:15', '09:15', 'Kết thúc tour và trở về'),


    ('CN4-000004', 1, 1, '06:30', '07:15', 'Khởi hành đến với khách sạn'), 
    ('CN4-000004', 1, 6, '07:15', '07:30', 'Check in vào khách sạn'),
    ('CN4-000004', 1, 4, '12:30', '13:30', 'Ăn trưa tại nhà hàng'),
    ('CN4-000004', 1, 5, '18:30', '19:30', 'Ăn tối tại nhà hàng'),
    ('CN4-000004', 2, 3, '06:30', '07:30', 'Ăn sáng tại nhà hàng'),
    ('CN4-000004', 2, 4, '12:30', '13:30', 'Ăn trưa tại nhà hàng'),
    ('CN4-000004', 2, 5, '18:30', '19:30', 'Ăn tối tại nhà hàng'), 
    ('CN4-000004', 3, 3, '07:00', '08:00', 'Ăn sáng tại nhà hàng'),
    ('CN4-000004', 3, 4, '12:30', '13:30', 'Ăn trưa tại nhà hàng'),
    ('CN4-000004', 3, 5, '18:30', '19:30', 'Ăn tối tại nhà hàng'),
    ('CN4-000004', 4, 3, '07:00', '08:00', 'Ăn sáng tại nhà hàng'),
    ('CN4-000004', 4, 7, '08:00', '08:15', 'Check out ra khách sạn'),
    ('CN4-000004', 4, 2, '08:15', '09:00', 'Kết thúc tour và trở về');

INSERT INTO 
	ChuyenDi
VALUES
	('CN1-000001', '2023-08-28', '2023-08-29', 0), 
    ('CN2-000002', '2023-09-02', '2023-09-03', 0), 
    ('CN3-000003', '2023-08-30', '2023-09-01', 0), 
    ('CN4-000004', '2023-08-27', '2023-08-30', 0);
    
INSERT INTO
	HuongDanVien_ChuyenDi
VALUES
	('CN1-000001', '2023-08-28', 'HD0003'), 
    ('CN2-000002', '2023-09-02', 'HD0004'), 
    ('CN3-000003', '2023-08-30', 'HD0006'), 
	('CN3-000003', '2023-08-30', 'HD0008'), 
    ('CN4-000004', '2023-08-27', 'HD0011'),
	('CN4-000004', '2023-08-27', 'HD0015');

INSERT INTO
	LichTrinhChuyen
VALUES
	('CN1-000001', '2023-08-28', 1),
    ('CN1-000001', '2023-08-28', 2),
    ('CN2-000002', '2023-09-02', 1),
    ('CN2-000002', '2023-09-02', 2),
    ('CN3-000003', '2023-08-30', 1),
    ('CN3-000003', '2023-08-30', 2),
    ('CN3-000003', '2023-08-30', 3),
    ('CN4-000004', '2023-08-27', 1),
	('CN4-000004', '2023-08-27', 2),
	('CN4-000004', '2023-08-27', 3),
	('CN4-000004', '2023-08-27', 4);

INSERT INTO
	DonViCungCapChuyen
VALUES
	('CN1-000001', '2023-08-28', 1, 1, 'DV0001'),
    ('CN1-000001', '2023-08-28', 1, 6, 'DV0002'),
    ('CN1-000001', '2023-08-28', 1, 4, 'DV0003'),
    ('CN1-000001', '2023-08-28', 1, 5, 'DV0003'),
    ('CN1-000001', '2023-08-28', 1, 8, 'DV0001'),
    ('CN1-000001', '2023-08-28', 2, 3, 'DV0003'),
    ('CN1-000001', '2023-08-28', 2, 4, 'DV0003'),
    ('CN1-000001', '2023-08-28', 2, 7, 'DV0002'),
    ('CN1-000001', '2023-08-28', 2, 2, 'DV0001'),
    ('CN1-000001', '2023-08-28', 2, 8, 'DV0001'),
    
    ('CN2-000002', '2023-09-02', 1, 1, 'DV2007'),
    ('CN2-000002', '2023-09-02', 1, 6, 'DV2008'),
    ('CN2-000002', '2023-09-02', 1, 4, 'DV2009'),
    ('CN2-000002', '2023-09-02', 1, 5, 'DV2009'),
    ('CN2-000002', '2023-09-02', 1, 8, 'DV2007'),
    ('CN2-000002', '2023-09-02', 2, 3, 'DV2009'),
    ('CN2-000002', '2023-09-02', 2, 7, 'DV2008'),
	('CN2-000002', '2023-09-02', 2, 4, 'DV2009'),
    ('CN2-000002', '2023-09-02', 2, 2, 'DV2007'),
    ('CN2-000002', '2023-09-02', 2, 8, 'DV2007'),
    
    ('CN3-000003', '2023-08-30', 1, 1, 'DV3010'),
    ('CN3-000003', '2023-08-30', 1, 6, 'DV3011'),
    ('CN3-000003', '2023-08-30', 1, 4, 'DV3012'),
    ('CN3-000003', '2023-08-30', 1, 5, 'DV3012'),
    ('CN3-000003', '2023-08-30', 1, 8, 'DV3010'),
    ('CN3-000003', '2023-08-30', 2, 3, 'DV3012'),
    ('CN3-000003', '2023-08-30', 2, 4, 'DV3012'),
    ('CN3-000003', '2023-08-30', 2, 5, 'DV3012'),
    ('CN3-000003', '2023-08-30', 2, 8, 'DV3010'),
    ('CN3-000003', '2023-08-30', 3, 3, 'DV3012'),
	('CN3-000003', '2023-08-30', 3, 7, 'DV3011'),
	('CN3-000003', '2023-08-30', 3, 2, 'DV3010'),
    ('CN3-000003', '2023-08-30', 3, 8, 'DV3010'),


    ('CN4-000004', '2023-08-27', 1, 1, 'DV0001'),
    ('CN4-000004', '2023-08-27', 1, 6, 'DV1005'),
    ('CN4-000004', '2023-08-27', 1, 4, 'DV1006'),
    ('CN4-000004', '2023-08-27', 1, 5, 'DV1006'),
    ('CN4-000004', '2023-08-27', 1, 8, 'DV0001'),
    ('CN4-000004', '2023-08-27', 2, 3, 'DV1006'),
    ('CN4-000004', '2023-08-27', 2, 4, 'DV1006'),
    ('CN4-000004', '2023-08-27', 2, 5, 'DV1006'),
    ('CN4-000004', '2023-08-27', 2, 8, 'DV0001'),
    ('CN4-000004', '2023-08-27', 3, 3, 'DV1006'),
    ('CN4-000004', '2023-08-27', 3, 4, 'DV1006'),
    ('CN4-000004', '2023-08-27', 3, 5, 'DV1006'),
    ('CN4-000004', '2023-08-27', 3, 8, 'DV0001'),
    ('CN4-000004', '2023-08-27', 4, 3, 'DV1006'),
    ('CN4-000004', '2023-08-27', 4, 7, 'DV1005'),
    ('CN4-000004', '2023-08-27', 4, 2, 'DV0001'),
    ('CN4-000004', '2023-08-27', 4, 8, 'DV0001');
    
INSERT INTO 
	PhieuDangKy(NgayDangKy, GhiChu, MaNhanVien, MaKhachLe, MaKhachDoan, MaTour, NgayKhoiHanh)
VALUES
	('2023-08-15', NULL, 'VP0001', NULL, 'KD0001', 'CN1-000001', '2023-08-28'),
    ('2023-08-23', NULL, 'VP0005', NULL, 'KD1002', 'CN2-000002', '2023-09-02'),
    ('2023-08-20', NULL, 'VP0002', NULL, 'KD2003', 'CN3-000003', '2023-08-30'),
    ('2023-08-12', NULL, 'VP0009', NULL, 'KD3004', 'CN4-000004', '2023-08-27'),
    ('2023-08-15', NULL, 'VP0001', 'KH0009', NULL, 'CN1-000001', '2023-08-28'),
    ('2023-08-15', NULL, 'VP0001', 'KH0010', NULL, 'CN1-000001', '2023-08-28'),
    ('2023-08-20', NULL, 'VP0002', 'KH0011', NULL, 'CN3-000003', '2023-08-30');
    
INSERT INTO 
	DonViCungCapDichVu_LienQuan
VALUES
	('CN1-000001', 1, 'DV0001'), 
    ('CN1-000001', 1, 'DV0003'), 
    ('CN1-000001', 2, 'DV0001'), 
    ('CN1-000001', 2, 'DV0003'), 
    ('CN2-000002', 6, 'DV2007'), 
    ('CN2-000002', 6, 'DV2009'), 
    ('CN2-000002', 7, 'DV2007'), 
    ('CN2-000002', 7, 'DV2009'), 
    ('CN3-000003', 9, 'DV3010'), 
    ('CN3-000003', 9, 'DV3012'),
    ('CN3-000003', 10, 'DV3010'), 
    ('CN3-000003', 10, 'DV3012'),
    ('CN4-000004', 4, 'DV0001'),
    ('CN4-000004', 4, 'DV1006'),
    ('CN4-000004', 5, 'DV0001'),
    ('CN4-000004', 5, 'DV1006');
    