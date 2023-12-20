<?php
require_once('controllers/admin/base_controller.php');
require_once('models/detail.php');

class DetailController extends BaseController
{
	function __construct()
	{
		$this->folder = 'detail';
	}

	public function index()
	{
        $matour = $_GET['matour'];
        $ngaykhoihanh = $_GET['ngaykh'];
        $detail = Detail::getTour($matour);
        $schedule = Detail::getSchedule($matour, $ngaykhoihanh);
        $data = array('detail' => $detail, 'schedule' => $schedule);
        $this->render('index', $data);
	}
}