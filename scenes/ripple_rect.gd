extends ColorRect

@onready var shader_material: ShaderMaterial = material as ShaderMaterial

func _process(delta):
	if shader_material:
		shader_material.set_shader_parameter("time", Time.get_ticks_msec() / 1000.0)

#func _input(event):
	#if event is InputEventMouseMotion:
		#shader_material.set_shader_parameter("mouse", event.position / get_viewport_rect().size)
