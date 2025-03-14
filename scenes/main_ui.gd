extends Control

@onready var alignment_slider: HSlider = $Behaviour_UI_Left/MarginContainer/VBoxContainer/alignment/HSlider
@onready var cohesion_slider: HSlider = $Behaviour_UI_Left/MarginContainer/VBoxContainer/cohesion/HSlider
@onready var separation_slider: HSlider = $Behaviour_UI_Left/MarginContainer/VBoxContainer/seperation/HSlider
@onready var sep_sensitivity_slider: HSlider = $"Behaviour_UI_Left/MarginContainer/VBoxContainer/sep sensitivity/HSlider"
@onready var min_speed_slider: HSlider = $"Behaviour_UI_Left/MarginContainer/VBoxContainer/min speed/HSlider"
@onready var max_speed_slider: HSlider = $"Behaviour_UI_Left/MarginContainer/VBoxContainer/max speed/HSlider"
@onready var max_acc_slider: HSlider = $"Behaviour_UI_Left/MarginContainer/VBoxContainer/max acc/HSlider"
@onready var fov_slider: HSlider = $Behaviour_UI_Left/MarginContainer/VBoxContainer/fov/HSlider
@onready var detection_radius_slider: HSlider = $"Behaviour_UI_Left/MarginContainer/VBoxContainer/detection radius/HSlider"
@onready var trail_length_slider: HSlider = $"Behaviour_UI_Left/MarginContainer/VBoxContainer/trail length/HSlider"

#--
@onready var trails_check: CheckButton = $Behaviour_UI_Left/MarginContainer/VBoxContainer/ButtonTray/checkBoxes/trails_check
@onready var cluster_check: CheckButton = $Behaviour_UI_Left/MarginContainer/VBoxContainer/ButtonTray/checkBoxes/cluster_check

@onready var reset_button: Button = $Behaviour_UI_Left/MarginContainer/VBoxContainer/ButtonTray/radomize_reset/reset_button
@onready var randomize_button: Button = $Behaviour_UI_Left/MarginContainer/VBoxContainer/ButtonTray/radomize_reset/randomize_button


@onready var hide_ui: CheckButton = $hide_ui
@onready var main_root: = $".".get_parent().get_parent()


func _ready() -> void:
	set_defualt_values_in_sliders()
	change_ui_visibility()



func update_fps_boids()->void :
	pass 
	
func change_ui_visibility() -> void:
	hide_ui.button_pressed = !hide_ui.button_pressed
	
	
func set_defualt_values_in_sliders()-> void :
	alignment_slider.value = manager.DEFAULT_ALIGNMENT
	cohesion_slider.value = manager.DEFAULT_COHESION
	separation_slider.value = manager.DEFAULT_SEPERATION_DISTANCE
	sep_sensitivity_slider.value = manager.DEFAULT_SEPERATION_SENSITIVITY
	min_speed_slider.value = manager.DEFAULT_MIN_SPEED
	max_speed_slider.value = manager.DEFAULT_MAX_SPEED
	max_acc_slider.value = manager.DEFAULT_MAX_ACCELERATION
	fov_slider.value = manager.DEFAULT_FOV
	detection_radius_slider.value = manager.DEFAULT_DETECTION_RANGE
	trail_length_slider.value = manager.DEFAULT_TRAIL_LENGTH
	
	max_min_speed_constraint()
	emit_signal_from_all_sliders()

func _on_hide_ui_pressed() -> void:
	change_ui_visibility()


func _on_trails_check_pressed() -> void:
	manager.TRAIL_ENABLED = !manager.TRAIL_ENABLED


func _on_colors_check_pressed() -> void:
	manager.COLOR_MODE_ENABLED = !manager.COLOR_MODE_ENABLED


func _on_reset_button_pressed() -> void:
	set_defualt_values_in_sliders()


func _on_randomize_button_pressed() -> void:
	alignment_slider.value = randf_range(alignment_slider.min_value, alignment_slider.max_value)
	cohesion_slider.value = randf_range(cohesion_slider.min_value, cohesion_slider.max_value)
	separation_slider.value = randf_range(separation_slider.min_value, separation_slider.max_value)
	sep_sensitivity_slider.value = randf_range(sep_sensitivity_slider.min_value, sep_sensitivity_slider.max_value)
	min_speed_slider.value = randf_range(min_speed_slider.min_value, min_speed_slider.max_value)
	max_speed_slider.value = randf_range(max_speed_slider.min_value, max_speed_slider.max_value)
	max_acc_slider.value = randf_range(max_acc_slider.min_value, max_acc_slider.max_value)
	fov_slider.value = randf_range(fov_slider.min_value, fov_slider.max_value)
	#update_latency_slider.value = randf_range(update_latency_slider.min_value, update_latency_slider.max_value)
	#detection_radius_slider.value = randf_range(detection_radius_slider.min_value, detection_radius_slider.max_value)
	trail_length_slider.value = randf_range(trail_length_slider.min_value, trail_length_slider.max_value)
	
	
	max_min_speed_constraint()
	emit_signal_from_all_sliders()

func emit_signal_from_all_sliders()->void :
	alignment_slider.emit_signal("drag_ended" , true)
	cohesion_slider.emit_signal("drag_ended" , true)
	separation_slider.emit_signal("drag_ended" , true)
	sep_sensitivity_slider.emit_signal("drag_ended" , true)
	min_speed_slider.emit_signal("drag_ended" , true)
	max_speed_slider.emit_signal("drag_ended" , true)
	max_acc_slider.emit_signal("drag_ended" , true)
	fov_slider.emit_signal("drag_ended" , true)
	detection_radius_slider.emit_signal("drag_ended" , true)
	trail_length_slider.emit_signal("drag_ended" , true)


func max_min_speed_constraint() -> void : 
	if max_speed_slider.value < min_speed_slider.value:
		max_speed_slider.value = min_speed_slider.value
		manager.MAX_SPEED = max_speed_slider.value

func _on_alignment_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		print("align value changed")
		manager.ALIGNMENT = alignment_slider.value

func _on_cohesion_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		print("coh value changed")
		manager.COHESION = cohesion_slider.value

func _on_separation_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		manager.SEPERATION_DISTANCE = separation_slider.value

func _on_sep_sensitivity_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		manager.SEPERATION_SENSITIVITY = sep_sensitivity_slider.value


func _on_min_speed_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		manager.MIN_SPEED = min_speed_slider.value
		max_min_speed_constraint()

func _on_max_speed_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		manager.MAX_SPEED = max_speed_slider.value
		max_min_speed_constraint()
		

func _on_max_acc_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		manager.MAX_ACCELERATION = max_acc_slider.value

func _on_fov_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		manager.FOV = fov_slider.value
		print(fov_slider.value)


func _on_detection_radius_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		manager.DETECTION_RANGE = detection_radius_slider.value

func _on_trail_length_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		manager.TRAIL_LENGTH = trail_length_slider.value


func _on_spawn_x_boids_button_pressed(x: int) -> void:
	
	if(x > 0):
		main_root.spawn_boid(x)
	else:
		main_root.despawn_boid(-x)
