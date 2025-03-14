extends Node2D

@onready var center: Sprite2D = $center
@onready var top_left: Sprite2D = $"top-left"
@onready var top_right: Sprite2D = $"top-right"
@onready var bottom_right: Sprite2D = $"bottom-right"
@onready var bottom_left: Sprite2D = $"bottom-left"

func set_visibility(obstacle_name: String):
	match obstacle_name:
		"center": 
			center.visible = true
		"top-left":
			top_left.visible = true
		"top-right":
			top_right.visible = true
		"bottom-right":
			bottom_right.visible = true
		"bottom-left":
			bottom_left.visible = true
		_:
			print("Invalid obstacle name:", obstacle_name)
