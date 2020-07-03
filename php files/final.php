<?php
require('connection.php');

$limit =isset($_GET['limit']) ?$_GET['limit']:0;

if($limit == 0){

$sql = 'select * from data order by id desc';
}
else
{
$sql = 'select * from data order by id desc limit '.$limit;
}
$result  = mysqli_query($db, $sql);
 $values=array();


while($row = $result->fetch_array())
{
        array_push($values, array("id"=>$row['id'],"event"=>$row['event'],
        "distance"=>$row['distance'],"temperature"=>$row['temperature'],"humidity"=>$row['humidity'],"rain"=>$row['rain'],"flowlevel"=>$row['flowlevel']));
        
    }
   print(json_encode($values));


$db->close();
?>
