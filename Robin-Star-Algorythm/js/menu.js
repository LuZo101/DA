////////////////////////////////////////////////
// Menu und Event Handler

window.onload = function () {
  initMenu();
  generateGrid();
  initCss();

  window.addEventListener('resize', () => {
    clear();
    initMenu();
    initCss();
  });

  visualEvents();
  menu_event_listeners();
};

function initMenu() {
  const isPortrait = window.innerHeight > window.innerWidth;
  var menu = document.querySelector("#menu");
  var visualizer = document.querySelector("#visualizer");

  if (isPortrait) {
    // In portrait mode, the menu should be full-width at the bottom of the viewport.
    menu.style.width = '100%';
    menu.style.height = '25vh'; // or whatever height you want it to be
    menu.style.position = 'fixed';
    menu.style.bottom = '0';
    menu.style.left = '0';

    // The visualizer should take the remaining space.
    visualizer.style.position = 'absolute';
    visualizer.style.top = '0';
    visualizer.style.bottom = '25vh'; // same height as the menu
    visualizer.style.width = '100%';
    visualizer.style.height = 'auto';
  } else {
    // In landscape mode, you can define a fixed width for the menu if needed.
    // If the menu should not be visible, you can set it to display: none;
    menu.style.width = '300px'; // or whatever width the menu should be
    menu.style.height = '100%';
    menu.style.position = 'absolute';
    menu.style.left = '0';

    // The visualizer should take the remaining space.
    visualizer.style.position = 'absolute';
    visualizer.style.top = '0';
    visualizer.style.bottom = '0';
    visualizer.style.left = '300px'; // same width as the menu
    visualizer.style.width = 'calc(100% - 300px)'; // subtract the width of the menu
    visualizer.style.height = 'auto';
  }
}


function initCss() {
  var grid = document.querySelector("#grid");
  grid.style.width = (cellSize * grid_size_x).toString(10) + "px";
  grid.style.height = (cellSize * grid_size_y).toString(10) + "px";
}
function idset(id, string) {
  document.getElementById(id).innerHTML = string;
}

var stoppuhr = (function () {
  var stop = 1;
  var mins = 0;
  var secs = 0;
  var msecs = 0;

  return {
    start: function () {
      stop = 0;
    },
    stop: function () {
      stop = 1;
    },
    clear: function () {
      stoppuhr.stop();
      mins = 0;
      secs = 0;
      msecs = 0;
      stoppuhr.html();
    },
    restart: function () {
      stoppuhr.clear();
      stoppuhr.start();
    },
    timer: function () {
      if (stop === 0) {
        msecs++;
        if (msecs === 100) {
          secs++;
          msecs = 0;
        }
        if (secs === 60) {
          mins++;
          secs = 0;
        }
        stoppuhr.html();
        timeTaken = `${String(mins).padStart(2, '0')}:${String(secs).padStart(2, '0')}:${String(msecs).padStart(2, '0')}`;
      }
    },
    set: function (minuten, sekunden, msekunden) {
      stoppuhr.stop();
      mins = minuten;
      secs = sekunden;
      msecs = msekunden;
      stoppuhr.html();
    },
    html: function () {
      idset("minuten", mins);
      idset("sekunden", secs);
      idset("msekunden", msecs);
    },
  };
})();
setInterval(stoppuhr.timer, 10);

function clear() {
  document.getElementById("visited_cells_counter").value = null;
  document.getElementById("finalpath_cells_counter").value = null;

  for (let i = 0; i < timeouts.length; i++) clearTimeout(timeouts[i]);
  timeouts = [];

  stoppuhr.restart();
  stoppuhr.stop();
  clearInterval(my_interval);
  delete_grid();

  if (window.innerWidth > panelSize + 50) {
    initMenu();
    generateGrid();
    initCss();
    visualEvents();
  }
}

function menu_event_listeners() {
  // Generate Maze
  document.querySelector("#generateMaze").addEventListener("click", (event) => {
    clear();
    maze_generators();
  });

  // Start Button
  document.querySelector("#play").addEventListener("click", (event) => {
    if (generating == true) {
      document.querySelector("#generator").value = "0";
    }

    generating = false;
    stoppuhr.restart();
    clear_grid();
    mazeRunner();
  });
//Save Button
document.querySelector("#saveTable").addEventListener("click", (event) => {
  const finalpath_cell_counter = document.getElementById("finalpath_cells_counter").value;
  const visited_cell_counter = document.getElementById("visited_cells_counter").value;
  const time = `${stoppuhr.mins}:${stoppuhr.secs}:${stoppuhr.msecs}`;
  
  // Abrufen der ausgewählten Algorithmus-ID
  const selectRunner = document.getElementById("selectRunner");
  const algorithmId = selectRunner.value;

  console.log("Länge gesammt = " + finalpath_cell_counter + ", Zellen besucht = " + visited_cell_counter + " benötigte Zeit = " + time);

  const finalPathCounter = finalpath_cell_counter;
  const visitedCellCounter = visited_cell_counter;
  const timeTaken = `${String(stoppuhr.mins).padStart(2, '0')}:${String(stoppuhr.secs).padStart(2, '0')}:${String(stoppuhr.msecs).padStart(2, '0')}`;

  const data = {
    finalPathCounter,
    visitedCellCounter,
    timeTaken,
    algorithmId, // Die ausgewählte Algorithmus-ID hinzufügen
  };

  fetch("http://192.168.1.144/DA/Robin-Star-Algorythm/insertData.php", {
    method: "POST",
    body: JSON.stringify(data),
  })
    .then((response) => response.json())
    .then((data) => console.log(data))
    .catch((error) => console.error(error));
});


  // Delete Button
  document.querySelector("#clear").addEventListener("click", (event) => {
    let start_temp = start_pos;
    let target_temp = target_pos;

    clear();

    // wenn startpunkt und endpunkt verschoben wurden
    place_to_cell(start_pos[0], start_pos[1]).classList.remove("startpunkt");
    place_to_cell(start_temp[0], start_temp[1]).classList.add("startpunkt");
    place_to_cell(target_pos[0], target_pos[1]).classList.remove("zielpunkt");
    place_to_cell(target_temp[0], target_temp[1]).classList.add("zielpunkt");

    start_pos = start_temp;
    target_pos = target_temp;
  });
}