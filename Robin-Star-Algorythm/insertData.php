<?php

ini_set('display_errors', 1);
error_reporting(E_ALL);

$servername = "192.168.1.144";
$username = "root";
$password = "RbPiAkift23!";
$dbname = "diplomarbeit";

try {
    $conn = new mysqli($servername, $username, $password, $dbname);

    if ($conn->connect_error) {
        throw new Exception("Connection failed: " . $conn->connect_error);
    }

    $data = json_decode(file_get_contents('php://input'), true);

    if (!isset($data['finalPathCounter'], $data['visitedCellCounter'], $data['timeTaken'], $data['algorithmId'])) {
        throw new Exception("Invalid input data");
    }

    $finalPathCounter = $conn->real_escape_string($data['finalPathCounter']);
    $visitedCellCounter = $conn->real_escape_string($data['visitedCellCounter']);
    $timeTaken = $conn->real_escape_string($data['timeTaken']);
    $algorithmId = $conn->real_escape_string($data['algorithmId']);

    $stmt = $conn->prepare("INSERT INTO data (algorithm_id, path_length, cells_visited, elapsed_time) VALUES (?, ?, ?, ?)");
    $stmt->bind_param("iiis", $algorithmId, $finalPathCounter, $visitedCellCounter, $timeTaken);

    if (!$stmt->execute()) {
        throw new Exception("Error inserting data: " . $stmt->error);
    }

    echo json_encode(["message" => "Data inserted successfully"]);
} catch (Exception $e) {
    error_log($e->getMessage());
    echo json_encode(["error" => "An error occurred. Please try again later."]);
} finally {
    if (isset($conn)) {
        $conn->close();
    }
}
?>
