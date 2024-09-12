extends Node2D


func _ready() -> void:
	trail.width = 2
	trail.default_color = Color(1, 0, 0)

func _process(delta: float) -> void:
	
