<?php
require_once('controllers/admin/base_controller.php');
require_once('models/annual.php');

class AnnualController extends BaseController
{
	function __construct()
	{
		$this->folder = 'annual';
	}

	public function index()
	{
		$this->render('index');
	}

	public function get()
	{
        $year = $_POST['year'];
        if (!is_numeric($year)) {
            header('Location: index.php?page=admin&controller=annual&action=index');
        }
        $annual = Annual::getRevenue($year);
		$data = array('annual' => $annual);
		$this->render('index', $data);
	}
}