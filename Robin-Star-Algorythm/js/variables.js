//////////////////////////////////////////////////////////////
// Globale Variablen Liste

//Webversion
const startUpMaxGrid = 60;
const startUpMaxGridMobile = 40;
const panelSize = 300;





let table;

let cellSize;
let grid_size_x;
let grid_size_y;
let grid_oneCell;
let grid;
let visited_cell_counter;
let finalpath_cell_counter;

let clicked_onto_block = false; //check falls event
let clicking = false;
let moving_start = false;
let moving_target = false;
let when_moved_not_set = true;
let start_pos;
let lab_position_a; //euclid distance p1
let lab_position_b; //p2
let end_pos;
let target_pos;
let target_pos2;
let grid_clean = true;
let my_interval;
let interval_timeout;
let interval_selected_test;
let max_distance;
let distance;

let node_list = [];
let path_list = [];
let node_list_index = 0;
let path_list_index = 0;

/* let node_list;
let node_list2;
let path_list;
let path_list2;
let graph_list;
let node_list_index;
let node_list2_index;   
let path_list_index;
let graph_list_index;
*/

let found = false;
let started = false;
let path = false;
let generating = false;
let finished_generating;
let timeouts = [];
let time_over;
let test_time;
let timeCounter = { timer: null, start: null, end: null };
let stopWatchRunning = false;
let startTime;