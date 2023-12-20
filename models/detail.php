<?php
require_once('connection.php');
class Detail
{
    public $matour;
    public $tentour;
    public $anh;
    public $ngaybatdau;
    public $sodem;
    public $songay;
    public $gialelon;
    public $gialenho;
    public $giadoanlon;
    public $giadoannho;
    public $doantoithieu;
    public $toithieu;
    public $toida;

    public $stt_ngay;
    public $loaihanhdong;
    public $tgianbdau;
    public $tgiankethuc;
    public $madonvi;
    public $tendonvi;
    public $madiemdulich;
    public $tendiem;
    public $madvvc;
    public $tendvvc;
    public $macn;
    public $tencn;

    public function __construct(
        $matour, $tentour, $anh, $ngaybatdau, $sodem, $songay,
        $gialelon, $gialenho, $giadoanlon, $giadoannho, $doantoithieu, $toithieu, $toida,
        $stt_ngay, $loaihanhdong, $tgianbdau, $tgiankethuc, $madonvi, $tendonvi,
        $madiemdulich, $tendiem, $madvvc, $tendvvc, $macn, $tencn) 
    {
        $this->matour = $matour;
        $this->tentour = $tentour;
        $this->anh = $anh;
        $this->ngaybatdau = $ngaybatdau;
        $this->sodem = $sodem;
        $this->songay = $songay;
        $this->gialelon = $gialelon;
        $this->gialenho = $gialenho;
        $this->giadoanlon = $giadoanlon;
        $this->giadoannho = $giadoannho;
        $this->doantoithieu = $doantoithieu;
        $this->toithieu = $toithieu;
        $this->toida = $toida;
        $this->stt_ngay = $stt_ngay;
        $this->loaihanhdong = $loaihanhdong;
        $this->tgianbdau = $tgianbdau;
        $this->tgiankethuc = $tgiankethuc;
        $this->madonvi = $madonvi;
        $this->tendonvi = $tendonvi;
        $this->madiemdulich = $madiemdulich;
        $this->tendiem = $tendiem;
        $this->madvvc = $madvvc;
        $this->tendvvc = $tendvvc;
        $this->macn = $macn;
        $this->tencn = $tencn;
    }

    static function getTour($matour)
    {
        $db = DB::getInstance();
        $req = $db->query(
            "SELECT * FROM tour WHERE MaTour = '$matour';"
        );
        $details = [];
        foreach($req->fetch_all(MYSQLI_ASSOC) as $detail) {
            $details[] = new Detail(
                $detail['MaTour'],
                $detail['TenTour'],
                $detail['Anh'],
                $detail['NgayBatDau'],
                $detail['SoDem'],
                $detail['SoNgay'],
                $detail['GiaVeLeNguoiLon'],
                $detail['GiaVeLeTreEm'],
                $detail['GiaVeDoanNguoiLon'],
                $detail['GiaVeDoanTreEm'],
                $detail['SoKhachDoanToiThieu'],
                $detail['SoKhachToiThieu'],
                $detail['SoKhachToiDa'], NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
            );
        }
        return $details;
    }
    static function getSchedule($matour, $ngaykhoihanh)
    {
        $db = DB::getInstance();
        $req = $db->query(
            "CALL LichTrinhChuyen('$matour', '$ngaykhoihanh');"
        );
        $details = [];
        foreach($req->fetch_all(MYSQLI_ASSOC) as $detail) {
            $details[] = new Detail(
                NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
                $detail['STT_Ngay'],
                $detail['LoaiHanhDong'],
                $detail['ThoiGianBatDau'],
                $detail['ThoiGianKetThuc'],
                $detail['MaDonVi'],
                $detail['TenDonVi'],
                $detail['MaDiemDuLich'],
                $detail['TenDiem'],
                $detail['MaDonViVanChuyen'],
                $detail['TenDonViVanChuyen'],
                $detail['MaCN'],
                $detail['TenCN']
            );
        }
        return $details;
    }
}
?>