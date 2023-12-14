<?php

ini_set('display_errors', 1);
error_reporting(E_ALL);


$servername = "192.168.1.144:3306,";
$username = "root";
$password = "RbPiAkift23!";
$dbname = "diplomarbeit";

try {
    $conn = new mysqli($servername, $username, $password, $dbname);
    
    // Überprüfen, ob die Verbindung hergestellt wurde
    if ($conn->connect_error) {
        throw new Exception("Connection failed: " . $conn->connect_error);
    }

    $data = json_decode(file_get_contents('php://input'), true);

    // Validieren der Eingabedaten
    if (!isset($data['finalPathCounter'], $data['visitedCellCounter'], $data['timeTaken'])) {
        throw new Exception("Invalid input data");
    }

    $finalPathCounter = $conn->real_escape_string($data['finalPathCounter']);
    $visitedCellCounter = $conn->real_escape_string($data['visitedCellCounter']);
    $timeTaken = $conn->real_escape_string($data['timeTaken']);

    // Prepared Statement verwenden
    $stmt = $conn->prepare("INSERT INTO data (path_length, cells_visited, elapsed_time) VALUES (?, ?, ?)");
    $stmt->bind_param("iii", $finalPathCounter, $visitedCellCounter, $timeTaken);

    if (!$stmt->execute()) {
        throw new Exception("Error inserting data: " . $stmt->error);
    }

    echo "Data inserted successfully";
} catch (Exception $e) {
    // Fehlerprotokollierung
    error_log($e->getMessage());
    // Anzeige einer allgemeinen Fehlermeldung
    echo "An error occurred. Please try again later.";
} finally {
    if (isset($conn)) {
        $conn->close();
    }
}
?>
