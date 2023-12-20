<?php
require_once('connection.php');
class Annual
{
    public $thang;
    public $doanhthu;
    public function __construct($thang, $doanhthu)
    {
        $this->thang = $thang;
        $this->doanhthu = $doanhthu;
    }
    static function getRevenue($year)
    {
        $db = DB::getInstance();
        $req = $db->query(
            "CALL ThongKeDoanhThu($year);"
        );
        $annuals = [];
        foreach($req->fetch_all(MYSQLI_ASSOC) as $annual) {
            $annuals[] = new Annual(
                $annual['Month'],
                $annual['TotalRevenue']
            );
        }
        return $annuals;
    }
}
?>