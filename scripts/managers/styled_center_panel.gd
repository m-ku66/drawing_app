extends VSplitContainer
class_name StyledCenterPanel

var bg_color = Color(1.0, 1.0, 1.0)  # Pure white
var border_color = Color(0.1, 0.1, 0.1, 0.3)
var border_width = 2

func _draw():
	# Draw background
	draw_rect(Rect2(Vector2.ZERO, size), bg_color)
	
	# Draw left border
	var left_border = Rect2(0, 0, border_width, size.y)
	draw_rect(left_border, border_color)
	
	# Draw right border
	var right_border = Rect2(size.x - border_width, 0, border_width, size.y)
	draw_rect(right_border, border_color)
