extends Control
#extends Node2D

var boid_scene : PackedScene = preload("res://scenes/boid.tscn")
@onready var boid_manager: Node2D = $boid_manager

@onready var fps: Label = $ui_manager/text_info/fps
@onready var total_boids: Label = $ui_manager/text_info/total_boids




func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	if Input.is_action_pressed("spawn_boid"):
		spawn_boid()
	
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()

func spawn_boid() -> void:
	manager.boid_count += 1
	
	var new_boid = boid_scene.instantiate()
	new_boid.position = get_global_mouse_position()
	boid_manager.add_child(new_boid)
