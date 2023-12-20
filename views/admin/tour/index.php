<?php
require_once('views/admin/header.php'); ?>

<!-- Add CSS -->


<?php
require_once('views/admin/content_layouts.php'); ?>


<!-- Code -->
<div class="content-wrapper">
	<!-- Add Content -->
	<!-- Content Header (Page header)-->
	<section class="content-header">
		<div class="container-fluid">
			<div class="row mb-2">
				<div class="col-sm-6">
					<h1>Quản lý Tour</h1>
				</div>
				<div class="col-sm-6">
					<ol class="breadcrumb float-sm-right">
						<li class="breadcrumb-item"><a href="index.php?page=admin&controller=layouts&action=index">Home</a></li>
						<li class="breadcrumb-item active">Quản lý Tour</li>
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
							<!-- Button trigger modal-->
							<button class="btn btn-primary" type="button" data-toggle="modal" data-target="#addAdminModal">Thêm mới</button>
							<!-- Modal-->
							<div class="modal fade" id="addAdminModal" tabindex="-1" role="dialog" aria-labelledby="addAdminModal" aria-hidden="true">
								<div class="modal-dialog" role="document">
									<div class="modal-content">
										<div class="modal-header">
											<h5 class="modal-title">Thêm mới</h5>
											<button class="close" type="button" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
										</div>
										<form action="index.php?page=admin&controller=tour&action=add" method="post">
											<div class="modal-body">
												<div class="form-group mb-0">
												<label for="MaChiNhanh">Mã Chi Nhánh:</label>
												<input class="form-control" type="text" name="MaChiNhanh" required><br>
												</div>
												<div class="form-group mb-0">
												<label for="TenTour">Tên Tour:</label>
												<input class="form-control" type="text" name="TenTour" required><br>
												</div>
												<div class="form-group mb-0">
												<label for="Anh">Ảnh:</label>
												<input class="form-control" type="text" name="Anh" required><br>
												</div>
												<div class="form-group mb-0">
												<label for="NgayBatDau">Ngày Bắt Đầu:</label>
												<input class="form-control" type="date" name="NgayBatDau" required><br>
												</div>
											<div class="row">	
												<div class="form-group mb-0 col-6">
												<label for="SoNgay">Số Ngày:</label>
												<input class="form-control" type="number" name="SoNgay" required><br>
												</div>
												<div class="form-group mb-0 col-6">
												<label for="SoDem">Số Đêm:</label>
												<input class="form-control" type="number" name="SoDem" required><br>
												</div>
												
											</div>	

											<div class="row">
												<div class="form-group mb-0 col-6">
												<label for="GiaVeLeNguoiLon">Giá Vé Lẻ Người Lớn:</label>
												<input class="form-control" type="number" name="GiaVeLeNguoiLon" required><br>
												</div>

												<div class="form-group mb-0 col-6">
												<label for="GiaVeLeTreEm">Giá Vé Lẻ Trẻ Em:</label>
												<input class="form-control" type="number" name="GiaVeLeTreEm" required><br>
												</div>
											</div>												
											
											
											<div class="row">
												<div class="form-group mb-0 col-6">
												<label for="GiaVeDoanNguoiLon">Giá Vé Đoàn Người Lớn:</label>
												<input class="form-control" type="number" name="GiaVeDoanNguoiLon" required><br>
												</div>

												<div class="form-group mb-0 col-6">
												<label for="GiaVeDoanTreEm">Giá Vé Đoàn Trẻ Em:</label>
												<input class="form-control" type="number" name="GiaVeDoanTreEm" required><br>
												</div>
											</div>	
											<div class="row">
												<div class="form-group mb-0 col-6">
												<label for="SoKhachToiThieu">Số Khách Tối Thiểu:</label>
												<input class="form-control" type="number" name="SoKhachToiThieu" required><br>
												</div>

												<div class="form-group mb-0 col-6">
												<label for="SoKhachToiDa">Số Khách Tối Đa:</label>
												<input class="form-control" type="number" name="SoKhachToiDa" required><br>
												</div>
											</div>	
												<div class="form-group mb-0">
												<label for="SoKhachDoanToiThieu">Số Khách Đoàn Tối Thiểu:</label>
												<input class="form-control" type="number" name="SoKhachDoanToiThieu" required><br>
												</div>
												
											</div>
											<div class="modal-footer">
												<button class="btn btn-secondary" type="button" data-dismiss="modal">Đóng lại</button>
												<button class="btn btn-primary" type="submit">Thêm mới</button>
											</div>
    								</form>
											
									</div>
								</div>
							</div>

							<table class="table table-bordered table-striped" id="tab-admin">
								<thead>
									<tr class="text-center">
										<th>Stt</th>
										<th>Mã Tour</th>
										<th>Tên Tour</th>
										<th>Ảnh minh họa</th>
										<th>Ngày bắt đầu</th>
										<th>Số đêm</th>
										<th>Số ngày</th>
										<th>Chi tiết</th>
									</tr>
								</thead>
								<tbody>
									<?php
									$index = 1;
									foreach ($tour as $tour) {
										echo "<tr class='text-center'>";
										echo "<td>" . $index++ . "</td>";
										echo "<td>" . $tour->matour . "</td>";
										echo "<td>" . $tour->tentour . "</td>";
										echo "<td><img style='height:100px; width:100px;' src='$tour->anh'></td>";
										echo "<td>" . $tour->ngaybatdau . "</td>";
										echo "<td>" . $tour->sodem . "</td>";
										echo "<td>" . $tour->songay . "</td>";
										echo "<td>
											<a href='index.php?page=admin&controller=detail&action=index&matour=" . $tour->matour . "&ngaykh=" . $tour->ngaybatdau . "'>
												<btn class='btn-edit btn btn-primary btn-xs' style='margin-right: 5px'><i class='fas fa-edit'></i></btn>
											</a>
										</td>";
										echo "</tr>";
									}
									?>
								</tbody>
							</table>
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