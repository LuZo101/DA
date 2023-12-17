<?php

$servername = "192.168.1.144";
$username = "root";
$password = "RbPiAkift23!";
$dbname = "diplomarbeit";

try {
    $conn = new mysqli($servername, $username, $password, $dbname);

    if ($conn->connect_error) {
        throw new Exception("Connection failed: " . $conn->connect_error);
    }

    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $data = json_decode(file_get_contents('php://input'), true);
        error_log("Received POST data: " . print_r($data, true));

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
    } elseif ($_SERVER['REQUEST_METHOD'] === 'GET') {
        $result = $conn->query("SELECT * FROM data");
        $data = [];

        while ($row = $result->fetch_assoc()) {
            $data[] = $row;
        }

        echo json_encode($data);
    }
} catch (Exception $e) {
    error_log("Exception: " . $e->getMessage());
    echo json_encode(["error" => "An error occurred: " . $e->getMessage()]);
} finally {
    if (isset($conn)) {
        $conn->close();
    }
}
?>
