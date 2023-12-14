<?php

// hier deine db Daten eintragen
$servername = "192.168.1.144";
$username = "root";
$password = "RbPiAkift23!";
$dbname = "diplomarbeit";

$conn = mysqli_connect($servername, $username, $password, $dbname);

// wurde die connection aufgebaut?
if (!$conn) {
  die("Connection failed: " . mysqli_connect_error());
}

// hier bekommst du die Daten vom POST request
$data = json_decode(file_get_contents('php://input'), true);
$finalPathCounter = $data['finalPathCounter'];
$visitedCellCounter = $data['visitedCellCounter'];
$timeTaken = $data['timeTaken'];

// Tabellen Name eintragen und Daten einfügen...
$sql = "INSERT INTO data (path_length, cells_visited, elapsed_time) VALUES ('$finalPathCounter', '$visitedCellCounter', '$timeTaken')";

if (mysqli_query($conn, $sql)) {
  echo "Data inserted successfully";
} else {
  echo "Error inserting data: " . mysqli_error($conn);
}

// db wieder schließen...
mysqli_close($conn);
?>
