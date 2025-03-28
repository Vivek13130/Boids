extends Control

# sliders : 
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

@onready var trail_addon_option_button: OptionButton = $"Behaviour_UI_Left/MarginContainer/VBoxContainer/trail noise/OptionButton"

@onready var trails_check: CheckButton = $Behaviour_UI_Left/MarginContainer/VBoxContainer/ButtonTray/checkBoxes/trails_check
@onready var cluster_check: CheckButton = $Behaviour_UI_Left/MarginContainer/VBoxContainer/ButtonTray/checkBoxes/cluster_check

@onready var reset_button: Button = $Behaviour_UI_Left/MarginContainer/VBoxContainer/ButtonTray/radomize_reset/reset_button
@onready var randomize_button: Button = $Behaviour_UI_Left/MarginContainer/VBoxContainer/ButtonTray/radomize_reset/randomize_button


@onready var hide_ui: CheckButton = $hide_ui
@onready var main_root: = $".".get_parent().get_parent()
@onready var main_ui: Control = $"."

@onready var elemental_ui_right: ScrollContainer = $Elemental_UI_Right
@onready var behaviour_ui_left: ScrollContainer = $Behaviour_UI_Left

@onready var ripple_rect: ColorRect = $"../RippleRect"


func _ready() -> void:
	set_default_values_in_sliders()
	if(! hide_ui.button_pressed):
		change_ui_visibility()

# behaviour UI : sliders and all : upto line 160

func _on_hide_ui_pressed() -> void:
	change_ui_visibility()

func change_ui_visibility() -> void:
	elemental_ui_right.visible = !elemental_ui_right.visible
	behaviour_ui_left.visible = !behaviour_ui_left.visible
	
	
func set_default_values_in_sliders()-> void :
	alignment_slider.value = manager.DEFAULT_ALIGNMENT
	cohesion_slider.value = manager.DEFAULT_COHESION
	separation_slider.value = manager.DEFAULT_SEPERATION_DISTANCE
	sep_sensitivity_slider.value = manager.DEFAULT_SEPERATION_SENSITIVITY
	min_speed_slider.value = manager.DEFAULT_MIN_SPEED
	max_speed_slider.value = manager.DEFAULT_MAX_SPEED
	max_acc_slider.value = manager.DEFAULT_MAX_ACCELERATION
	fov_slider.value = manager.DEFAULT_FOV
	detection_radius_slider.value = manager.DEFAULT_DETECTION_RANGE
	detection_radius_slider.step = manager.GRID_CELL_SIZE
	trail_length_slider.value = manager.DEFAULT_TRAIL_LENGTH
	
	max_min_speed_constraint()
	emit_signal_from_all_sliders()


func _on_trails_check_pressed() -> void:
	manager.TRAIL_ENABLED = !manager.TRAIL_ENABLED


func _on_colors_check_pressed() -> void:
	manager.COLOR_MODE_ENABLED = !manager.COLOR_MODE_ENABLED


func _on_reset_button_pressed() -> void:
	set_default_values_in_sliders()


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
		manager.ALIGNMENT = alignment_slider.value

func _on_cohesion_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
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




# elemental UI : right 

# spawn-despawn : full grid control 
func _on_spawn_x_boids_button_pressed(x: int) -> void:
	
	if(x > 0):
		main_root.spawn_boid(x)
	else:
		main_root.despawn_boid(-x)




# obstacles selection and deselection : 
var selected_obstacle := "NONE"
@onready var ghost_texture: TextureRect = $ghost_texture

@onready var ui_buttons := {
	"center": $Elemental_UI_Right/MarginContainer/HBoxContainer/VBoxContainer2/obstaclePlacement/VBoxContainer/GridContainer/center,
	"top-left": $"Elemental_UI_Right/MarginContainer/HBoxContainer/VBoxContainer2/obstaclePlacement/VBoxContainer/GridContainer/top-left",
	"top-right": $"Elemental_UI_Right/MarginContainer/HBoxContainer/VBoxContainer2/obstaclePlacement/VBoxContainer/GridContainer/top-right",
	"bottom-right": $"Elemental_UI_Right/MarginContainer/HBoxContainer/VBoxContainer2/obstaclePlacement/VBoxContainer/GridContainer/bottom-right",
	"bottom-left": $"Elemental_UI_Right/MarginContainer/HBoxContainer/VBoxContainer2/obstaclePlacement/VBoxContainer/GridContainer/bottom-left"
}

var obstacle_texture_paths := {
	"center": "res://assets/center.png",
	"top-left": "res://assets/top-left.png",
	"top-right": "res://assets/top-right.png",
	"bottom-right": "res://assets/bottom-right.png",
	"bottom-left": "res://assets/bottom-left.png"
}


func _on_obstacle_grid_gui_input(event: InputEvent, obstacle_name: String) -> void:
	if event is InputEventMouseButton and event.pressed:
		print(obstacle_name)
		# another obstacle is selected and we recieved a click : 
		if selected_obstacle != "NONE":
			# place it in main scene
			reset_obstacle_selection()
		else : 
			select_obstacle(obstacle_name)
		
		print("selected obs : " , selected_obstacle)


func reset_obstacle_selection():
	for button in ui_buttons.values():
		button.modulate = Color(1, 1, 1, 1)  # Fully visible
	print("reset obstacle")
	
	# Reset selection
	selected_obstacle = "NONE"
	ghost_texture.visible = false 
	ghost_texture.texture = null

func select_obstacle(obstacle_name : String):
	selected_obstacle = obstacle_name
	ghost_texture.visible = true
	ghost_texture.texture = load(obstacle_texture_paths[selected_obstacle])
	ghost_texture.modulate = Color(1,0,0,1)
	
	print("select obstacle")
	# Darken the UI button to indicate selection
	if ui_buttons.has(obstacle_name):
		ui_buttons[obstacle_name].modulate = Color(0.5, 0.5, 0.5, 1)  # Darken effect
	else:
		print("ui button not found")


var counter := 0 
var counter_limit_placing_obstacles = 10

func _process(delta: float) -> void:
	counter += 1
	
	if ghost_texture.texture:
		var mouse_pos = get_global_mouse_position()
		var grid_x = floor(mouse_pos.x / manager.GRID_CELL_SIZE) * manager.GRID_CELL_SIZE
		var grid_y = floor(mouse_pos.y / manager.GRID_CELL_SIZE) * manager.GRID_CELL_SIZE
		ghost_texture.position = Vector2(grid_x, grid_y) 

	if is_placing_obstacles and selected_obstacle != "NONE" and counter > counter_limit_placing_obstacles:
		counter = 0
		main_root.place_obstacle(selected_obstacle, ghost_texture.global_position)



var is_placing_obstacles := false  # Track if the button is held

func _on_main_ui_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and selected_obstacle != "NONE":
			is_placing_obstacles = true  # Start placing
		elif not event.pressed:
			is_placing_obstacles = false  # Stop placing
