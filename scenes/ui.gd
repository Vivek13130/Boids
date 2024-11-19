extends Control

@onready var alignment_slider: HSlider = $sliders/alignment/HSlider
@onready var cohesion_slider: HSlider = $sliders/cohesion/HSlider
@onready var separation_slider: HSlider = $sliders/seperation/HSlider
@onready var sep_sensitivity_slider: HSlider = $"sliders/sep sensitivity/HSlider"
@onready var noise_slider: HSlider = $sliders/noise/HSlider
@onready var min_speed_slider: HSlider = $"sliders/min speed/HSlider"
@onready var max_speed_slider: HSlider = $"sliders/max speed/HSlider"
@onready var max_acc_slider: HSlider = $"sliders/max acc/HSlider"
@onready var fov_slider: HSlider = $sliders/fov/HSlider
@onready var update_latency_slider: HSlider = $"sliders/update latency/HSlider"
@onready var detection_radius_slider: HSlider = $"sliders/detection radius/HSlider"
@onready var trail_length_slider: HSlider = $"sliders/trail length/HSlider"


@onready var fps_label: Label = $"checks and text_info/fps"
@onready var boid_count_label: Label = $"checks and text_info/boid_count"
@onready var trails_check: CheckButton = $"checks and text_info/trails_check"
@onready var colors_check: CheckButton = $"checks and text_info/colors_check"


@onready var reset_button: Button = $"checks and text_info/reset_button"
@onready var randomize_button: Button = $"checks and text_info/randomize_button"


@onready var hide_ui: CheckButton = $hide_ui
@onready var white_bg_for_ui: ColorRect = $white_bg_for_ui
@onready var sliders: Panel = $sliders
@onready var checks_and_text_info: Panel = $"checks and text_info"

var counter = 0 ;

func _ready() -> void:
	set_defualt_values_in_sliders()
	change_ui_visibility()


func _process(delta: float) -> void:
	counter += 1
	if(counter > 30):
		counter = 0
		update_fps_boids()
	

func update_fps_boids()->void :
	fps_label.text = "FPS: " + str(Engine.get_frames_per_second())
	boid_count_label.text = "Boids: " + str(manager.boid_count)
	
func change_ui_visibility() -> void:
	#hide_ui.button_pressed = !hide_ui.button_pressed
	white_bg_for_ui.visible = !white_bg_for_ui.visible
	sliders.visible = !sliders.visible
	checks_and_text_info.visible = !checks_and_text_info.visible

func set_defualt_values_in_sliders()-> void :
	alignment_slider.value = manager.DEFAULT_ALIGNMENT
	cohesion_slider.value = manager.DEFAULT_COHESION
	separation_slider.value = manager.DEFAULT_SEPERATION_DISTANCE
	sep_sensitivity_slider.value = manager.DEFAULT_SEPERATION_SENSITIVITY
	noise_slider.value = manager.DEFAULT_NOISE
	min_speed_slider.value = manager.DEFAULT_MIN_SPEED
	max_speed_slider.value = manager.DEFAULT_MAX_SPEED
	max_acc_slider.value = manager.DEFAULT_MAX_ACCELERATION
	fov_slider.value = manager.DEFAULT_FOV
	update_latency_slider.value = manager.DEFAULT_FLOCKING_UPDATE_LATENCY
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
	noise_slider.value = randf_range(noise_slider.min_value, noise_slider.max_value)
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
	noise_slider.emit_signal("drag_ended" , true)
	min_speed_slider.emit_signal("drag_ended" , true)
	max_speed_slider.emit_signal("drag_ended" , true)
	max_acc_slider.emit_signal("drag_ended" , true)
	fov_slider.emit_signal("drag_ended" , true)
	update_latency_slider.emit_signal("drag_ended" , true)
	detection_radius_slider.emit_signal("drag_ended" , true)
	trail_length_slider.emit_signal("drag_ended" , true)


func max_min_speed_constraint() -> void : 
	if max_speed_slider.value < min_speed_slider.value:
		max_speed_slider.value = min_speed_slider.value
		manager.MAX_SPEED = max_speed_slider.value
		print("hello")
	#print(max_speed_slider.value," <- max  min-> ",  min_speed_slider.value)
	


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

func _on_noise_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		manager.NOISE = noise_slider.value

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

func _on_update_latency_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		manager.FLOCKING_UPDATE_LATENCY = update_latency_slider.value

func _on_detection_radius_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		manager.DETECTION_RANGE = detection_radius_slider.value

func _on_trail_length_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		manager.TRAIL_LENGTH = trail_length_slider.value
