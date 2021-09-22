<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Credentials: true");
header("Content-type:application/json;charset=utf-8"); 
header("Access-Control-Allow-Methods: POST");
$servername="localhost";
$username="root";
$password="";
$dbname="EXEMPTION_KODAGU";
$table="District";

$action=$_POST["action"];
$conn=new mysqli($servername,$username,$password,$dbname);

if($conn->connect_error)
{
    die("Connection Error".$conn->connect_error);
    return;
}
if("CREATE_TABLE"==$action){
    $sql="CREATE TABLE IF NOT EXISTS $table(dist_id int(10)Primary key,dist_name varchar(30))";

    if($conn->query($sql)===TRUE)
    {
        echo "Create successfully";
    }
    else
    {
        echo "Error creating table";
    }
    $conn->close();
    return;
}

if("GET_ALL" == $action){
    $db_data = array();
    $sql = "SELECT dist_id, dist_name from $table";
    $result = $conn->query($sql);
    if($result->num_rows > 0){
        while($row = $result->fetch_assoc()){
            $db_data[] = $row;
        }
        // Send back the complete records as a json
        echo json_encode($db_data);
    }else{
        echo "error";
    }
    $conn->close();
    return;
}
if("ADD_DISTRICT"==$action)
{
    $dist_id=$_POST["dist_id"];
    $dist_name=$_POST["dist_name"];
    $sql="INSERT INTO $table VALUES('$dist_id','$dist_name')";
    $result=$conn->query($sql);
    echo "Success";
    $conn->close();
    return;
}
?>