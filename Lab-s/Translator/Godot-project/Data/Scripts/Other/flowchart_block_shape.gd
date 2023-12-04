extends Line2D

class_name FlowChartBlockShape

var _points: PackedVector2Array

func _init(shapePoints: PackedVector2Array, color: Color):
	_points = shapePoints
	default_color = color
	_on_rect_changed()
	item_rect_changed.connect(_on_rect_changed)

func _on_rect_changed():
	var parent: Node = get_parent()
	var newX = parent.size.x
	var newY = parent.size.y
	points.clear()
	for point in _points:
		points.append(Vector2(
			point.x * newX,
			point.y * newY))
	draw.emit()
