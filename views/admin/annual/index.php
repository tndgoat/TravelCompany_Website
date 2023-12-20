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
					<h1>Doanh thu trong năm</h1>
					<form action="index.php?page=admin&controller=annual&action=get"></form>
				</div>
				<div class="col-sm-6">
					<ol class="breadcrumb float-sm-right">
						<li class="breadcrumb-item"><a href="index.php?page=admin&controller=layouts&action=index">Home</a></li>
						<li class="breadcrumb-item active">Doanh thu trong năm</li>
					</ol>
				</div>
			</div>
		</div>
		<!-- /.container-fluid-->
	</section>
	<!-- Main content-->
	<form class="row gy-2 gx-3 mb-4 ml-2 align-items-center " action="index.php?page=admin&controller=annual&action=get" method="post">	
		<div class="col-auto">
			<label class="form-label m-0 text-dark" for="form11Example1">Nhập năm</label>
		</div>
  		<div class="col-auto">
    		<div class="form-outline">
      		<input type="text" id="form11Example1" name="year" class="form-control" />      
    		</div>
  		</div>
  		<div class="col-auto">
    		<button type="submit" class="btn btn-primary">Hiện</button>
  		</div>
	</form>
	<section class="intro">
  <div class="gradient-custom-1 h-100">
    <div class="mask d-flex align-items-center h-100">
      <div class="container">
        <div class="row justify-content-center">
          <div class="col-12">
            <div class="table-responsive bg-white">
              <table class="table mb-0 w-50 align-middle">
                <thead>
                  <tr>
                    <th scope="col" class="text-center">Tháng</th>
                    <th scope="col" class="text-center">Doanh thu (VND)</th>
                  </tr>
                </thead>
                <tbody>
				  <?php
				  if (isset($annual)) {
					foreach ($annual as $annual) {
						echo '<tr>
						<th scope="row" style="color: #666666;" class="text-center">'.$annual->thang.'</th>
						<td class="text-center">'. $annual->doanhthu .'</td>
						</tr>';
					}
				  }
				  
				  ?>
                </tbody>
              </table>
            </div>
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