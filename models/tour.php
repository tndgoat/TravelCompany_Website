<?php
require_once('connection.php');
class Tour
{
    public $matour;
    public $tentour;
    public $ngaybatdau;
    public $anh;
    public $sodem;
    public $songay;
    public function __construct($matour, $tentour, $anh, $ngaybatdau, $sodem, $songay)
    {
        $this->matour = $matour;
        $this->tentour = $tentour;
        $this->anh = $anh;
        $this->ngaybatdau = $ngaybatdau;
        $this->sodem = $sodem;
        $this->songay = $songay;
    }
    static function getAll()
    {
        $db = DB::getInstance();
        $req = $db->query(
            "SELECT MaTour, TenTour, Anh, NgayBatDau, SoDem, SoNgay FROM tour;"
        );
        $tours = [];
        foreach($req->fetch_all(MYSQLI_ASSOC) as $tour) {
            $tours[] = new Tour(
                $tour['MaTour'],
                $tour['TenTour'],
                $tour['Anh'],
                $tour['NgayBatDau'],
                $tour['SoDem'],
                $tour['SoNgay'],
            );
        }
        return $tours;
    }
    static function insert($macn, $tentour, $anh, $ngaybatdau, $toithieu, $toida, $gialelon, $gialenho, $giadoanlon, $giadoannho, $sodem, $songay, $doantoithieu)
    {
        $db = DB::getInstance();
        $req = $db->query(
            "INSERT INTO tour(MaChiNhanh, TenTour, Anh, NgayBatDau, SoKhachToiThieu, SoKhachToiDa, GiaVeLeNguoiLon, GiaVeLeTreEm, GiaVeDoanNguoiLon, GiaVeDoanTreEm, SoKhachDoanToiThieu,SoDem, SoNgay)
             VALUES ('$macn', '$tentour', '$anh', '$ngaybatdau', $toithieu, $toida, $gialelon, $gialenho, $giadoanlon, $giadoannho, $doantoithieu, $sodem, $songay);"
        );
        return $req;
    }
    static function insertSchedule($matour, $STTNgay, $LoaiHanhDong, $GioBatDau, $GioKetThuc, $MaDonVi, $MaDiemDuLich, $MaDonViVanChuyen, $songay, $ngaykh)
    {
        $db = DB::getInstance();
        $ngaykh_temp = intval(substr($ngaykh, -2));
        if ($songay > 1) {
            $req = $db->query(
                "INSERT INTO ngaykhoihanh_tourdaingay 
                    SELECT '$matour', $ngaykh_temp FROM DUAL
                WHERE NOT EXISTS 
                (SELECT * FROM ngaykhoihanh_tourdaingay WHERE MATOUR = '$matour' AND NGAY = $ngaykh_temp);"
            );
        }
        $req = $db->query(
            "INSERT INTO lichtrinhtour SELECT '$matour', $STTNgay FROM DUAL
            WHERE NOT EXISTS
            (SELECT * FROM lichtrinhtour WHERE MaTour='$matour' AND STT_Ngay= $STTNgay);"
        );
        $giobatdau = $GioBatDau;
        $gioketthuc = $GioKetThuc;
        if ($LoaiHanhDong == 8) {
            $req = $db->query(
                "INSERT INTO Tour_Co_DiaDiemThamQuan VALUES ('$matour', $STTNgay, $MaDiemDuLich, '$giobatdau', '$gioketthuc', NULL);"
            );
        }
        else {
            $req = $db->query(
                "INSERT INTO HanhDong_LichTrinhTour VALUES ('$matour', $STTNgay, $LoaiHanhDong, '$giobatdau', '$gioketthuc', NULL);"
            );
        }
        

        $ngaykh_temp = new DateTime($ngaykh);

        $ngayketthuc = clone $ngaykh_temp;     
        $ngayketthuc->modify("+" . $songay . " days");

        $ngayketthuc = $ngayketthuc->format("Y-m-d");

        
        $req = $db->query(
            "INSERT INTO ChuyenDi 
            SELECT '$matour', '$ngaykh', '$ngayketthuc', 0 FROM DUAL
            WHERE NOT EXISTS
            (SELECT * FROM ChuyenDi WHERE Matour = '$matour' AND ngaykhoihanh = '$ngaykh');"
        );
        $req = $db->query(
            "INSERT INTO LichTrinhChuyen SELECT '$matour', '$ngaykh', $STTNgay FROM DUAL
            WHERE NOT EXISTS
            (SELECT * FROM LichTrinhChuyen WHERE MaTour='$matour' AND STT_Ngay= $STTNgay AND NgayKhoiHanh = '$ngaykh');"
        );
        if ($LoaiHanhDong != 8) {
            $req = $db->query(
                "INSERT INTO DonViCungCapChuyen VALUES ('$matour', '$ngaykh', $STTNgay, $LoaiHanhDong, '$MaDonVi');"
            );
            $req = $db->query(
                "INSERT INTO DonViCungCapChuyen
                SELECT '$matour', '$ngaykh', $STTNgay, 8, '$MaDonViVanChuyen' FROM DUAL
                WHERE NOT EXISTS 
                (SELECT * FROM DonViCungCapChuyen WHERE MaTour='$matour' AND NgayKhoiHanh='$ngaykh' AND STT_Ngay= $STTNgay AND Loai=8 AND MaDonVi='$MaDonViVanChuyen');"
            );
        }
        else {
            $req = $db->query(
                "INSERT INTO DonViCungCapDichVu_LienQuan VALUES ('$matour', $MaDiemDuLich, '$MaDonVi');"
            );
        }
        
        return $req;
    }
}
?>