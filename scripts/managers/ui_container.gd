extends HSplitContainer

# UI proportions (as percentages)
const LEFT_PANEL_RATIO = 0.20
const CENTER_AREA_RATIO = 0.60
const RIGHT_PANEL_RATIO = 0.20

# Animation settings
const RESIZE_DURATION = 0.3

# Node references - using proper node names from your scene!
@onready var left_panel = $LeftPanel
@onready var center_panel = $CenterPanel  # Fixed name!
@onready var right_panel = $RightPanel
@onready var main_canvas = $CenterPanel/MainCanvas  # Fixed path!
@onready var navigator = $RightPanel/Navigator

# Tween for smooth animations
var resize_tween: Tween

func _ready():
	# Connect to window resize signal
	get_viewport().size_changed.connect(_on_window_resized)
	
	# Delay initial setup to ensure all nodes are ready
	call_deferred("setup_responsive_layout")
	
	print("UI Container initialized! 🎉")

func _on_window_resized():
	setup_responsive_layout()

func setup_responsive_layout():
	var screen_size = get_viewport().get_visible_rect().size
	
	# Kill existing tween and create new one
	if resize_tween:
		resize_tween.kill()
	resize_tween = create_tween()
	resize_tween.set_parallel(true)
	
	setup_left_panel(screen_size.x)
	setup_center_panel(screen_size)
	setup_right_panel(screen_size.x)

func setup_left_panel(screen_width: float):
	var target_width = screen_width * LEFT_PANEL_RATIO
	var target_split_offset = target_width
	
	resize_tween.tween_property(self, "split_offset", target_split_offset, RESIZE_DURATION).set_ease(Tween.EASE_OUT)
	
	if left_panel:
		left_panel.custom_minimum_size.x = target_width

func setup_center_panel(screen_size: Vector2):
	var center_width = screen_size.x * CENTER_AREA_RATIO
	var center_height = screen_size.y
	
	if center_panel and center_panel is VSplitContainer:
		var canvas_height = center_height * 0.85
		resize_tween.tween_property(center_panel, "split_offset", canvas_height, RESIZE_DURATION).set_ease(Tween.EASE_OUT)
	
	if main_canvas:
		var canvas_size = Vector2i(int(center_width * 0.95), int(center_height * 0.80))  # Fixed Vector2i type!
		resize_tween.tween_property(main_canvas, "size", canvas_size, RESIZE_DURATION).set_ease(Tween.EASE_OUT)

func setup_right_panel(screen_width: float):
	var panel_width = screen_width * RIGHT_PANEL_RATIO
	
	if right_panel:
		right_panel.custom_minimum_size.x = panel_width
	
	if navigator:
		var nav_size = Vector2i(int(panel_width * 0.9), int(panel_width * 0.6))  # Fixed Vector2i type!
		resize_tween.tween_property(navigator, "size", nav_size, RESIZE_DURATION).set_ease(Tween.EASE_OUT)
