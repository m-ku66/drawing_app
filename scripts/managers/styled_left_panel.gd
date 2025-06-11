extends VBoxContainer
class_name StyledLeftPanel

var bg_color = Color(0.25, 0.25, 1.0)  # Subtle blue/gray
var border_color = Color(0.1, 0.1, 0.1, 0.5)
var border_width = 2

func _draw():
	# Draw background
	draw_rect(Rect2(Vector2.ZERO, size), bg_color)
	
	# Draw right border
	var border_rect = Rect2(size.x - border_width, 0, border_width, size.y)
	draw_rect(border_rect, border_color)
