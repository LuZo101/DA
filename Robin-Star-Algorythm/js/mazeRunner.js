
// Calculates the Manhattan distance between two points
function manhattanDistance(a, b) {
	const aPos = a.split(',').map(Number);
	const bPos = b.split(',').map(Number);
	return Math.abs(aPos[0] - bPos[0]) + Math.abs(aPos[1] - bPos[1]);
}
  
// Calculates the Euclidean distance between two points
function euclideanDistance(a, b) {
	return Math.sqrt(
	  Math.pow(b[0] - a[0], 2) + Math.pow(b[1] - a[1], 2)
	);
}

function enqueue(queue, val, priority) {
    queue.push({val, priority});
    sort(queue);
}

function dequeue(queue) {
    return queue.shift();
}

function sort(queue) {
    queue.sort((a, b) => a.priority - b.priority);
}

/* 
function breathDeep() {
    node_list = [];
    path_list = [];
    node_list_index = 0;
    path_list_index = 0;
    found = false;
    path = false;
    
    let distances = {};
    let previous = {};
    let pq = [];
    let smallest;
    
    // Set initial distances to Infinity and previous nodes to null
    for (let node in grid) {
        if (node === start_pos) {
            distances[node] = 0;
            enqueue(pq, node, 0);
        } else {
            distances[node] = Infinity;
        }
        previous[node] = null;
    }
    
    // Loop until priority queue is empty
    while (pq.length) {
        smallest = dequeue(pq).val;
        let coords = smallest.split(',').map(Number);
        node_list.push(coords);
        if (smallest === target_pos) {
            // Build path
            while (previous[smallest]) {
                path_list.push(smallest);
                smallest = previous[smallest];
            }
            found = true;
            break;
        }
        
        if (smallest || distances[smallest] !== Infinity) {
            for (let neighbor in grid[smallest]) {
                let nextNode = grid[smallest][neighbor];
                let candidate = distances[smallest] + nextNode.weight;
                if (candidate < distances[nextNode.node]) {
                    distances[nextNode.node] = candidate;
                    previous[nextNode.node] = smallest;
                    enqueue(pq, nextNode.node, candidate);
                }
            }
        }
    }
    
    path_list.reverse();
    
    maze_solvers_interval();
}
*/


function dijkstra() {

    node_list = [];
    path_list = [];
	node_list_index = 0;
    path_list_index = 0;
	
    found = false;
    path = false;

	let frontier = [start_pos];

	grid[start_pos[0]][start_pos[1]] = 1;

	while (frontier.length > 0 && !found) {
		let list = get_neighbours(frontier[0], 1);
		frontier.splice(0, 1);

		for (let i = 0; i < list.length; i++) {
			if (get_node(list[i][0], list[i][1]) == 0) {

				frontier.push(list[i]);
				grid[list[i][0]][list[i][1]] = i + 1;

				if (list[i][0] == target_pos[0] && list[i][1] == target_pos[1]) {
					found = true;
					break;
				}
				node_list.push(list[i]);
			}
		}
	} 

	if (found) {
		let current_node = target_pos;

		while (current_node[0] != start_pos[0] || current_node[1] != start_pos[1]) {

			switch (grid[current_node[0]][current_node[1]]) {
				
				case 1: current_node = [current_node[0], current_node[1] + 1]; break;
				case 2: current_node = [current_node[0] - 1, current_node[1]]; break;
				case 3: current_node = [current_node[0], current_node[1] - 1]; break;
				case 4: current_node = [current_node[0] + 1, current_node[1]]; break;
				default: break;
			}
			path_list.push(current_node);
		}

		path_list.pop();
		path_list.reverse();
	}

	maze_solvers_interval();
}



function bestFirst() {

    node_list = [];
    path_list = [];
	node_list_index = 0;
    path_list_index = 0;
	
    found = false;
    path = false;

	let frontier = [start_pos];
	grid[start_pos[0]][start_pos[1]] = 1;

	while (frontier.length > 0 && !found) {

		frontier.sort(function(a, b) {
			return euclideanDistance(a, target_pos) - euclideanDistance(b, target_pos);
		});

		let list = get_neighbours(frontier[0], 1);
		frontier.splice(0, 1);

		for (let i = 0; i < list.length; i++) {

			if (get_node(list[i][0], list[i][1]) == 0) {

				frontier.push(list[i]);
				grid[list[i][0]][list[i][1]] = i + 1;

				if (list[i][0] == target_pos[0] && list[i][1] == target_pos[1]) {
					found = true;
					break;
				}
				node_list.push(list[i]);
			}
		}
	}
	
	if (found) {
		let current_node = target_pos;

		while (current_node[0] != start_pos[0] || current_node[1] != start_pos[1]) {

			switch (grid[current_node[0]][current_node[1]]) {
				case 1: current_node = [current_node[0], current_node[1] + 1]; break;
				case 2: current_node = [current_node[0] - 1, current_node[1]]; break;
				case 3: current_node = [current_node[0], current_node[1] - 1]; break;
				case 4: current_node = [current_node[0] + 1, current_node[1]]; break;
				default: break;
			}
			path_list.push(current_node);
		}
		path_list.pop();
		path_list.reverse();
	}
	console.log(node_list);
	maze_solvers_interval();
}


// standard tremaux aber auch quasi verbesserter bidirektionaler breath first
function tremaux() {

    node_list = [];
    path_list = [];
	node_list_index = 0;
    path_list_index = 0;
	
    found = false;
    path = false;

	let current_cell;
	let start_end;
	let target_end;

	let frontier = [start_pos, target_pos];

	grid[target_pos[0]][target_pos[1]] = 1;
	grid[start_pos[0]][start_pos[1]] = 11;

	while (frontier.length > 0 && !found) {

		current_cell = frontier[0];
		let list = get_neighbours(current_cell, 1);
		frontier.splice(0, 1);

		for (let i = 0; i < list.length; i++) {

			if (get_node(list[i][0], list[i][1]) == 0) {
				frontier.push(list[i]);

				if (grid[current_cell[0]][current_cell[1]] < 10) {
					grid[list[i][0]][list[i][1]] = i + 1;
				} else
					grid[list[i][0]][list[i][1]] = 11 + i;

				node_list.push(list[i]);
			} 
			else if (get_node(list[i][0], list[i][1]) > 0) {

				if (grid[current_cell[0]][current_cell[1]] < 10 && get_node(list[i][0], list[i][1]) > 10) {
					start_end = current_cell;
					target_end = list[i];
					found = true;
					break;
				} 
				else if (grid[current_cell[0]][current_cell[1]] > 10 && get_node(list[i][0], list[i][1]) < 10) {

					start_end = list[i];
					target_end = current_cell;
					found = true;
					break;
				}
			}
		}
	}

	if (found) {
		let targets = [target_pos, start_pos];
		let starts = [start_end, target_end];

		for (let i = 0; i < starts.length; i++) {

			let current_node = starts[i];

			while (current_node[0] != targets[i][0] || current_node[1] != targets[i][1]) {
				path_list.push(current_node);

				switch (grid[current_node[0]][current_node[1]] - (i * 10)) {
					case 1: current_node = [current_node[0], current_node[1] + 1]; break;
					case 2: current_node = [current_node[0] - 1, current_node[1]]; break;
					case 3: current_node = [current_node[0], current_node[1] - 1]; break;
					case 4: current_node = [current_node[0] + 1, current_node[1]]; break;
					default: break;
				}
			}

			if (i == 0) {
				path_list.reverse();
			}
		}
		path_list.reverse();
	}
	maze_solvers_interval();
}



function aStar() {

	node_list = [];
    path_list = [];
	node_list_index = 0;
    path_list_index = 0;
	
    found = false;
    path = false;

	let frontier = [start_pos];
	let cost_grid = new Array(grid.length).fill(0).map(() => new Array(grid[0].length).fill(0));
	grid[start_pos[0]][start_pos[1]] = 1;

	while (frontier.length > 0 && !found) {

		frontier.sort(function(a, b) {

			let a_value = cost_grid[a[0]][a[1]] + euclideanDistance(a, target_pos) * Math.sqrt(2);
			let b_value = cost_grid[b[0]][b[1]] + euclideanDistance(b, target_pos) * Math.sqrt(2);
			return a_value - b_value;
		});

		let current_cell = frontier[0];
		let list = get_neighbours(current_cell, 1);
		frontier.splice(0, 1);

		for (let i = 0; i < list.length; i++) {
			if (get_node(list[i][0], list[i][1]) == 0) {

				frontier.push(list[i]);
				grid[list[i][0]][list[i][1]] = i + 1;
				cost_grid[list[i][0]][list[i][1]] = cost_grid[current_cell[0]][current_cell[1]] + 1;

				if (list[i][0] == target_pos[0] && list[i][1] == target_pos[1]) {
					found = true;
					break;
				}
				node_list.push(list[i]);
			}
		}
	}
	
	if (found) {
		let current_node = target_pos;

		while (current_node[0] != start_pos[0] || current_node[1] != start_pos[1]) {

			switch (grid[current_node[0]][current_node[1]]) {
				case 1: current_node = [current_node[0], current_node[1] + 1]; break;
				case 2: current_node = [current_node[0] - 1, current_node[1]]; break;
				case 3: current_node = [current_node[0], current_node[1] - 1]; break;
				case 4: current_node = [current_node[0] + 1, current_node[1]]; break;
				default: break;
			}
			path_list.push(current_node);
		}
		path_list.pop();
		path_list.reverse();		
	}
	maze_solvers_interval();
}

function maze_solvers_interval() {
    let my_interval;
    const intervalHandler = () => {
        if (!path) {
            handleNodeList();
        } else {
            handlePathList();
        }
    };

    const handleNodeList = () => {
		console.log(node_list_index);
        place_to_cell(node_list[node_list_index][0], node_list[node_list_index][1]).classList.add("cell_algo");       
        node_list_index++;
		console.log(node_list_index);
        visited_cell_counter = node_list_index;
        document.getElementById("visited_cells_counter").value = visited_cell_counter;

        if (node_list_index == node_list.length) {
            handleNodeListEnd();
        }
    };

    const handleNodeListEnd = () => {
        if (!found) {
            clearInterval(my_interval);
        } else {
            path = true;
            place_to_cell(start_pos[0], start_pos[1]).classList.add("cell_path");
            stoppuhr.stop();
        }
    };

    const handlePathList = () => {
        if (path_list_index == path_list.length) {
            place_to_cell(target_pos[0], target_pos[1]).classList.add("cell_path");
            clearInterval(my_interval);
            console.log("Ziel gefunden! Pfad Länge: " + path_list.length );
            return;
        }

        place_to_cell(path_list[path_list_index][0], path_list[path_list_index][1]).classList.remove("cell_algo");
        place_to_cell(path_list[path_list_index][0], path_list[path_list_index][1]).classList.add("cell_path");
        path_list_index++;
        finalpath_cell_counter = path_list_index;
        document.getElementById("finalpath_cells_counter").value = finalpath_cell_counter;
    };

    my_interval = window.setInterval(intervalHandler, 10);
}


function mazeRunner() {
	
	clear_grid();
	grid_clean = false;

	if (document.querySelector("#selectRunner").value == "1")
		bestFirst();

	else if (document.querySelector("#selectRunner").value == "2")
		dijkstra();
		
	else if (document.querySelector("#selectRunner").value == "3")
		tremaux();

	else if (document.querySelector("#selectRunner").value == "4")
		aStar();

	else ((Math.abs(start_pos[0] - target_pos[0]) == 0 && Math.abs(start_pos[1] - target_pos[1]) == 1) ||
		 (Math.abs(start_pos[0] - target_pos[0]) == 1 && Math.abs(start_pos[1] - target_pos[1]) == 0)) 

		place_to_cell(start_pos[0], start_pos[1]).classList.add("cell_path");
		place_to_cell(target_pos[0], target_pos[1]).classList.add("cell_path");
		
}


