extends Node2D

# cluster detection : 

var clusters = []  # stores detected clusters
var visited = {}  # track visited boids
var cluster_colors = manager.BRIGHT_COLORS

func _ready() -> void:
	pass # Replace with function body.


func _process(delta):
	if Engine.get_frames_drawn() % 60 == 0 and manager.detect_clusters:  # Run every 60 frames (~1s)
		detect_clusters()
	
	if(!visited.is_empty() and !manager.detect_clusters):
		visited.clear()
		for boid in $".".get_children():
			boid.get_child(0).modulate = Color(1,1,1,1)


func detect_clusters():
	visited.clear()  # Reset visited dictionary
	var cluster_id = 0
	


	# Perform BFS for cluster detection
	for cell in manager.boids_grid.keys():
		for boid in manager.boids_grid[cell]:
			if boid in visited:
				continue  # Skip already visited boids

			var queue = [boid]  # Start BFS from this boid
			var cluster = []  # Store boids in this cluster
			visited[boid] = true

			while queue.size() > 0:
				var current = queue.pop_front()
				cluster.append(current)
				var current_pos = current.global_position

				# Check only relevant neighboring cells in the grid
				var grid_x = int(current_pos.x / manager.GRID_CELL_SIZE)
				var grid_y = int(current_pos.y / manager.GRID_CELL_SIZE)
				var neighbors = []

				# Iterate over the 9 neighboring cells including itself
				for x in range(grid_x - 1, grid_x + 2):
					for y in range(grid_y - 1, grid_y + 2):
						var cell_key = Vector2(x, y)
						if cell_key in manager.boids_grid:
							for nearbyboid in manager.boids_grid[cell_key]:
								if(nearbyboid not in visited and nearbyboid.global_position.distance_to(current_pos) <= 100): 
									visited[nearbyboid] = true
									queue.append(nearbyboid)  


			# Assign a unique color to all boids in this cluster
			var color = cluster_colors[cluster_id % cluster_colors.size()]
			print("neigbours found : ", cluster.size())
			for b in cluster:
				b.set_color(color)  # Assuming boids have a `set_color()` method
			
			cluster_id += 1  # Move to next cluster
