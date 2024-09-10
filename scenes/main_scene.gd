extends Node2D

var boid_scene : PackedScene = preload("res://scenes/boid.tscn")
@onready var boid_manager: Node2D = $boid_manager
@onready var fps: Label = $debug_nodes/fps
@onready var total_boids: Label = $debug_nodes/total_boids

var boid_count = 1;

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
#	updating debug nodes : 
	fps.text = "FPS: " + str(Engine.get_frames_per_second())
	total_boids.text = "Total B: " + str(boid_count)
	
	if Input.is_action_pressed("spawn_boid"):
		spawn_boid()

func spawn_boid() -> void:
	boid_count += 1
	
	var new_boid = boid_scene.instantiate()
	new_boid.position = get_global_mouse_position()
	boid_manager.add_child(new_boid)
