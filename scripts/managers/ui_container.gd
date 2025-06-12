extends HBoxContainer

# UI proportions (as percentages)
const LEFT_PANEL_RATIO = 0.20
const CENTER_AREA_RATIO = 0.60
const RIGHT_PANEL_RATIO = 0.20

# Animation settings
const RESIZE_DURATION = 0.1

# Node references - these will now be our custom styled panels!
@onready var left_panel = $LeftPanel  # Should be StyledLeftPanel
@onready var center_panel = $CenterPanel  # Should be StyledCenterPanel
@onready var right_panel = $RightPanel  # Should be StyledRightPanel
@onready var main_canvas = $CenterPanel/MainCanvas
@onready var navigator = $RightPanel/Navigator
@onready var color_picker = $LeftPanel/ColorPicker

# Tween for smooth animations
var resize_tween: Tween

func _ready():
	# Connect to window resize signal
	get_viewport().size_changed.connect(_on_window_resized)
	
	# Setup responsive layout
	call_deferred("setup_responsive_layout")
	
	# Setup canvas background
	call_deferred("setup_canvas_background")
	
	print("UI Container initialized with custom styled panels! 🎉")

func _on_window_resized():
	setup_responsive_layout()

func setup_canvas_background():
	"""Create a beautiful white drawing surface for our main canvas"""
	var canvas_bg = ColorRect.new()
	canvas_bg.name = "CanvasBackground"
	canvas_bg.color = Color(1.0, 1.0, 1.0)  # Pure white
	canvas_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE  # Let drawing events pass through
	
	# Make it fill the entire canvas
	canvas_bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	
	# Add as first child so it's behind everything else
	main_canvas.add_child(canvas_bg)
	main_canvas.move_child(canvas_bg, 0)

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
	
	# Force panels to redraw after resize
	if left_panel:
		left_panel.queue_redraw()
	if center_panel:
		center_panel.queue_redraw()  
	if right_panel:
		right_panel.queue_redraw()

func setup_left_panel(screen_width: float):
	var target_width = screen_width * LEFT_PANEL_RATIO
	var target_height = get_viewport().get_visible_rect().size.y
	
	if left_panel:
		# Set custom minimum size for BOTH dimensions
		resize_tween.tween_property(left_panel, "custom_minimum_size", Vector2(target_width, target_height), RESIZE_DURATION).set_ease(Tween.EASE_OUT)
		
		# Make sure it has proper size flags
		left_panel.size_flags_horizontal = Control.SIZE_FILL
		left_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
		
		# Trigger redraw when tween completes
		resize_tween.tween_callback(left_panel.queue_redraw).set_delay(RESIZE_DURATION)

func setup_color_picker_sizing():
	if color_picker:
		# Force the popup to open immediately
		color_picker.popup_request.emit()
		
		# Or try this alternative:
		# color_picker.get_popup().popup()
		
		# Make the popup non-modal so it stays open
		var popup = color_picker.get_popup()
		if popup:
			popup.popup_window = false
			popup.set_as_minsize()

func setup_center_panel(screen_size: Vector2):
	var center_width = screen_size.x * CENTER_AREA_RATIO
	var center_height = screen_size.y
	
	if center_panel:
		# Set custom minimum size for our 60% width
		resize_tween.tween_property(center_panel, "custom_minimum_size:x", center_width, RESIZE_DURATION).set_ease(Tween.EASE_OUT)
		
		# Set size flags and stretch ratio for 60% of space
		center_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		center_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
		center_panel.size_flags_stretch_ratio = 3.0  # 60% = 3x the 20% panels
		
		# Handle VSplitContainer within center area
		if center_panel is VSplitContainer:
			var canvas_height = center_height * 0.85
			resize_tween.tween_property(center_panel, "split_offset", canvas_height, RESIZE_DURATION).set_ease(Tween.EASE_OUT)
		
		# Trigger redraw when tween completes
		resize_tween.tween_callback(center_panel.queue_redraw).set_delay(RESIZE_DURATION)
	
	# Configure main canvas SubViewport size
	if main_canvas:
		var canvas_size = Vector2i(int(center_width * 0.95), int(center_height * 0.80))
		resize_tween.tween_property(main_canvas, "size", canvas_size, RESIZE_DURATION).set_ease(Tween.EASE_OUT)

func setup_right_panel(screen_width: float):
	var panel_width = screen_width * RIGHT_PANEL_RATIO
	var target_height = get_viewport().get_visible_rect().size.y

	if right_panel:
		# Set custom minimum size for BOTH dimensions
		resize_tween.tween_property(right_panel, "custom_minimum_size", Vector2(panel_width, target_height), RESIZE_DURATION).set_ease(Tween.EASE_OUT)
		
		# Make sure it has proper size flags
		right_panel.size_flags_horizontal = Control.SIZE_FILL
		right_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
		
		# Trigger redraw when tween completes
		resize_tween.tween_callback(right_panel.queue_redraw).set_delay(RESIZE_DURATION)
	
	# Configure navigator SubViewport
	if navigator:
		var nav_size = Vector2i(int(panel_width * 0.9), int(panel_width * 0.6))
		resize_tween.tween_property(navigator, "size", nav_size, RESIZE_DURATION).set_ease(Tween.EASE_OUT)
