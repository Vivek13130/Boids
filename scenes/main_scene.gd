extends Node2D

var boid_scene : PackedScene = preload("res://scenes/boid.tscn")
@onready var boid_manager: Node2D = $CanvasLayer/boid_manager




func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	if Input.is_action_pressed("spawn_boid"):
		spawn_boid(1)
	
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()

func spawn_boid(x : int) -> void:
	manager.boid_count += 1
	for i in range(x):
		var new_boid = boid_scene.instantiate()
		new_boid.position = get_global_mouse_position()
		boid_manager.add_child(new_boid)


func despawn_boid(x) -> void:
	manager.boid_count -= x
	var all_boids = $CanvasLayer/boid_manager.get_children()
	var remove_count = min(x, all_boids.size())

	for i in range(remove_count):
		var boid = all_boids[i]  # Get reference before removing
		boid.get_parent().remove_child(boid)  # Remove from scene tree
		boid.queue_free()  # Now safely delete
