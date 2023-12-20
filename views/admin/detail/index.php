<?php
	session_start();
	if (!isset($_SESSION["user"])) {
		header("Location: index.php?page=admin&controller=login&action=index");
	}
	if($_SESSION["user"] != "admin") {
		header("Location: index.php?page=admin&controller=layouts&action=index");
	}
?>
<?php
require_once('views/admin/header.php'); ?>

<!-- Add CSS -->


<?php
require_once('views/admin/content_layouts.php'); 
$max_day = $detail[0]->songay;
$day = 1;
?>
<script>
function add(){
	const node = document.getElementById("addform").lastElementChild;
	const clone = node.cloneNode(true);
	document.getElementById("addform").appendChild(clone);
}
function del(){
	var count = $("#addform").children().length;
	if (count > 1) {
		const node = document.getElementById("addform").lastElementChild;
		document.getElementById("addform").removeChild(node);
	}
}
</script>
<link rel="stylesheet" href="public/detail/css/bootstrap.min.css">
	<link rel="stylesheet" href="public/detail/css/owl.carousel.min.css">
	<link rel="stylesheet" href="public/detail/css/owl.theme.default.min.css">
	<link rel="stylesheet" href="public/detail/css/jquery.fancybox.min.css">
	<link rel="stylesheet" href="public/detail/fonts/icomoon/style.css">
	<link rel="stylesheet" href="public/detail/fonts/flaticon/font/flaticon.css">
	<link rel="stylesheet" href="public/detail/css/daterangepicker.css">
	<link rel="stylesheet" href="public/detail/css/aos.css">
	<link rel="stylesheet" href="public/detail/css/style.css">
<!-- Code -->
<div class="content-wrapper">
	<!-- Add Content -->
	<!-- Content Header (Page header)-->
	<section class="content-header">
		<div class="container-fluid">
			<div class="row mb-2">
				<div class="col-sm-6">
					<h1>Thông tin chi tiết Tour</h1>
				</div>
				<div class="col-sm-6">
					<ol class="breadcrumb float-sm-right">
						<li class="breadcrumb-item"><a href="index.php?page=admin&controller=layouts&action=index">Home</a></li>
						<li class="breadcrumb-item active">Thông tin chi tiết Tour</li>
					</ol>
				</div>
			</div>
		</div>
		<!-- /.container-fluid-->
	</section>
	<!-- Main content-->
	<section class="content">
		<div class="container-fluid ">
			<div class="row">
				<div class="col-12">
					<div class="card">
						<div class="card-body">
							


						<div class="row align-items-stretch">
				<div class="col-lg-4 order-lg-1">
					<div class="h-100"><div class="frame h-100"><div class="feature-img-bg h-100" style="background-image: url('<?php echo $detail[0]->anh?>');"></div></div></div>
				</div>

				<div class="col-6 col-sm-6 col-lg-4 feature-1-wrap d-md-flex flex-md-column order-lg-1" >

					<div class="feature-1 d-md-flex">
						<div class="align-self-center">
							<span class="display-4 text-primary"><i class="bi bi-info-circle"></i></span>
							<h3>Thông tin cơ bản</h3>
							<p class="mb-0"><?php echo $detail[0]->tentour?></p>
							<p class="mb-0"><?php echo $detail[0]->matour?></p>
						</div>
					</div>

					<div class="feature-1 ">
						<div class="align-self-center">
							<span class="display-4 text-primary"><i class="bi bi-people-fill"></i></span>
							<h3>Số lượng</h3>
							<p class="mb-0">Số khách tối thiểu: <?php echo $detail[0]->toithieu ?></p>
							<p class="mb-0">Số khách tối đa: <?php echo $detail[0]->toida ?></p>
							<p class="mb-0">Số khách đoàn tối thiểu: <?php echo $detail[0]->doantoithieu ?></p>
						</div>
					</div>

				</div>

				<div class="col-6 col-sm-6 col-lg-4 feature-1-wrap d-md-flex flex-md-column order-lg-3" >

					<div class="feature-1 d-md-flex">
						<div class="align-self-center">
							<span class="display-4 text-primary"><i class="bi bi-calendar-check"></i></span>
							<h3>Thời gian</h3>
							<p class="mb-0">Ngày bắt đầu: <?php echo $detail[0]->ngaybatdau?></p>
							<p class="mb-0"><?php echo $detail[0]->songay?> ngày <?php echo $detail[0]->sodem?> đêm</p>
						</div>
					</div>

					<div class="feature-1 d-md-flex">
						<div class="align-self-center">
							<span class="display-4 text-primary"><i class="bi bi-wallet"></i></span>
							<h3>Giá</h3>
							<p class="mb-0">Khách lẻ trẻ em: <?php echo $detail[0]->gialenho?></p>
							<p class="mb-0">Khách đoàn trẻ em: <?php echo $detail[0]->giadoannho?></p>
							<p class="mb-0">Khách lẻ người lớn: <?php echo $detail[0]->gialelon?></p>
							<p class="mb-0">
							Khách đoàn người lớn: <?php echo $detail[0]->giadoanlon?></p>
							
						</div>
					</div>

				</div>

			</div>
							<!-- Modal-->
							<div class="modal fade" id="addScheduleModal" tabindex="-1" role="dialog" aria-labelledby="addScheduleModal" aria-hidden="true">
								<div class="modal-dialog modal-lg w-50" role="document">
									<div class="modal-content">
										<div class="modal-header justify-items-center">
											<h5 class="modal-title my-auto">Thêm lịch trình</h5>
											<!-- <div class="m-0 col-1 my-auto justify-items-center">
												<button class="form-control btn btn-primary rounded-circle p-0 my-auto display-2" style="width: 35px; height:35px" type="button" onclick="add()"><i class="fa fa-plus"></i></button>
											</div>
											<div class="m-0 col-1 my-auto justify-items-center">
												<button class="form-control btn btn-primary rounded-circle p-0 my-auto display-2" style="width: 35px; height:35px" type="button" onclick="del()"><i class="fa fa-minus"></i></button>
											</div> -->
											<button class="close" type="button" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
										</div>
										<form action="index.php?page=admin&controller=tour&action=insert" method="post">
											<div class="modal-body">
											<div  id="addform">
											<div class="mb-4 border border-dark border-4 p-3">
											<div class="row">	
												<div class="form-group mb-0 col-0">
													<input class="form-control" type="hidden" name="MaTour" value="<?php echo $detail[0]->matour;?>">
												</div>
												<div class="form-group mb-0 col-0">
													<input class="form-control" type="hidden" name="NgayKH" value="<?php echo $detail[0]->ngaybatdau;?>">
												</div>
												<div class="form-group mb-0 col-0">
													<input class="form-control" type="hidden" name="SoNgay" value="<?php echo $detail[0]->songay;?>">
												</div>
												<div class="form-group mb-0 col-3">
												<label for="STTNgay">STT Ngày</label>
												<select class="form-select " name="STTNgay" id="STTNgay">
													<?php
														for ($i = 1; $i <= $max_day; $i++) {
															echo "<option value=\"$i\">$i</option>";
														}
														?>
												</select>
												</div>
												<div class="form-group mb-0 col-3">
												<label for="LoaiHanhDong">Loại hành động</label>
												<select class="form-select " name="LoaiHanhDong" id="LoaiHanhDong">
													<option value=1> Khởi hành </option>
													<option value=2> Kết thúc</option>
													<option value=3> Ăn sáng</option>
													<option value=4> Ăn trưa</option>
													<option value=5> Ăn tối</option>
													<option value=6> Check in</option>
													<option value=7> Check out</option>
													<option value=8> Tham quan</option>
												</select>
												</div>
												<div class="form-group mb-0 col-3">
												<label for="GioBatDau">Giờ bắt đầu:</label>
												<input class="form-control" type="time" name="GioBatDau" required><br>
												</div>
												<div class="form-group mb-0 col-3">
												<label for="GioKetThuc">Giờ kết thúc:</label>
												<input class="form-control" type="time" name="GioKetThuc" required><br>
												</div>
											</div>
											<div class="row" >	
												<div class="form-group mb-0 col-4">
													<label for="MaDonVi">Mã đơn vị</label>
													<input class="form-control" type="text" name="MaDonVi" id="MaDonVi">
												</div>
												<div class="form-group mb-0 col-4">
													<label for="MaDiemDuLich">Mã điểm du lịch</label>
													<input class="form-control" type="text" name="MaDiemDuLich" id="MaDiemDuLich">
												</div>
												<div class="form-group mb-0 col-4">
													<label for="MaDonViVanChuyen">Mã đơn vị vận chuyển</label>
													<input class="form-control" name="MaDonViVanChuyen" id="MaDonViVanChuyen">
												</div>
											</div>	
											</div>
											</div>
											<div class="modal-footer">
												<button class="btn btn-secondary rounded-0" type="button" data-dismiss="modal">Đóng lại</button>
												<button class="btn btn-primary rounded-0" type="submit">Thêm mới</button>
											</div>
											</div>
    								</form>
											
									</div>
								</div>
							</div>

							<!-- Button trigger modal-->
							<div class="row mt-4">
								<h3 class="mr-3">Lịch trình tour <button class="btn btn-primary rounded-circle p-0 ml-2 display-2" style="width: 35px; height:35px" type="button" data-toggle="modal" data-target="#addScheduleModal"><i class="fa fa-plus"></i></button></h3>
								
							</div>
							
							
							<?php
							$val = -1;
							function f($obj) {
								switch ($obj->loaihanhdong) {
									case 1: 
										echo $obj->tgianbdau ." : ". "Khởi hành từ chi nhánh ". $obj->tencn ."<br>";
										break;
									case 2:  
										echo $obj->tgianbdau ." : ". " Đến chi nhánh ". $obj->tencn  ." kết thúc tour"."<br>";
										break;
									case 3:
										echo $obj->tgianbdau ." - ". $obj->tgiankethuc ." : Ăn sáng tại nhà hàng ". $obj->tendonvi."<br>";
										break;
									case 4:
										echo $obj->tgianbdau ." - ". $obj->tgiankethuc ." : Ăn trưa tại nhà hàng ". $obj->tendonvi."<br>";
										break;
									case 5:
										echo $obj->tgianbdau ." - ". $obj->tgiankethuc ." : Ăn tối tại nhà hàng ". $obj->tendonvi."<br>";
										break;
									case 6:
										echo $obj->tgianbdau ." - ". $obj->tgiankethuc ." : Check in tại khách sạn ". $obj->tendonvi."<br>";
										break;
									case 7:
										echo $obj->tgianbdau ." - ". $obj->tgiankethuc ." : Check out khỏi khách sạn ". $obj->tendonvi .", khởi hành về chi nhánh ". $obj->tencn."<br>";
										break;
									default:
										echo $obj->tgianbdau ." - ". $obj->tgiankethuc ." : Tham quan địa điểm du lịch ". $obj->tendiem."<br>";									 
								}
							} 
							if (isset($schedule)) {
								foreach ($schedule as $value) {
									if ($val != $value->stt_ngay) {
										if ($value->stt_ngay != 1) echo "<br>";
										echo "<p><b>Ngày thứ ".$value->stt_ngay.": Đơn vị vận chuyển ". $value->tendvvc ."</b></p>";
										$val = $value->stt_ngay;
									}
									echo f($value);
								}
							}
							?>
						</div>
					</div>
				</div>
			</div>
		</div>


	</section>
</div>


<?php
require_once('views/admin/footer.php'); ?>

<!-- Add Javascripts -->
<script src="public/js/admin/index.js"></script>
</body>

</html>