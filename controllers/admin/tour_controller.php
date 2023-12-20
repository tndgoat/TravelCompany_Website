<?php
require_once('controllers/admin/base_controller.php');
require_once('models/tour.php');

class TourController extends BaseController
{
	function __construct()
	{
		$this->folder = 'tour';
	}

	public function index()
	{
		$tour = Tour::getAll();
		$data = array('tour' => $tour);
		$this->render('index', $data);
	}

	public function add()
	{
		$macn = $_POST['MaChiNhanh'];
		$tentour = $_POST['TenTour'];
		$anh = $_POST['Anh'];
		$ngaybatdau = $_POST['NgayBatDau'];
		$toithieu = $_POST['SoKhachToiThieu'];
		$toida =$_POST['SoKhachToiDa'];
		$gialelon = $_POST['GiaVeLeNguoiLon'];
		$gialenho = $_POST['GiaVeLeTreEm'];
		$giadoanlon = $_POST['GiaVeDoanNguoiLon'];
		$giadoannho =$_POST['GiaVeDoanTreEm'];
		$sodem = $_POST['SoDem'];
		$songay = $_POST['SoNgay'];
		$doantoithieu = $_POST['SoKhachDoanToiThieu'];
		Tour::insert($macn, $tentour, $anh, $ngaybatdau, $toithieu, $toida, $gialelon, $gialenho, $giadoanlon, $giadoannho, $sodem, $songay, $doantoithieu);
		header('Location: index.php?page=admin&controller=tour&action=index');
	}
	public function insert(){
		$matour = $_POST['MaTour'];
		$ngaykh = $_POST['NgayKH'];
		$songay = $_POST['SoNgay'];
		$STTNgay =$_POST['STTNgay'];
		
		$LoaiHanhDong = $_POST['LoaiHanhDong'];
		$GioBatDau = $_POST['GioBatDau'];
		$GioKetThuc = $_POST['GioKetThuc'];
		$MaDonVi = $_POST['MaDonVi'];
		$MaDiemDuLich = $_POST['MaDiemDuLich'];
		$MaDonViVanChuyen = $_POST['MaDonViVanChuyen'];
		Tour::insertSchedule($matour, $STTNgay, $LoaiHanhDong,$GioBatDau, $GioKetThuc, $MaDonVi, $MaDiemDuLich, $MaDonViVanChuyen, $songay, $ngaykh);
		header('Location: index.php?page=admin&controller=detail&action=index&matour='. $matour .'&ngaykh='. $ngaykh);
	}
}