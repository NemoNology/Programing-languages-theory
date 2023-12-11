## Flowchart block shape is:
## 1) Points template: PackedVector2Array
## 2) Color: Color
## 3) Points: PackedVector2Array
class_name FlowchartBlockShape extends Node2D

var points_template: PackedVector2Array
var default_color: Color
var color: Color
var points: PackedVector2Array


func _init(shape_points_template: PackedVector2Array, shape_color: Color):
	points_template = shape_points_template
	default_color = shape_color
	color = shape_color
	show_behind_parent = true
	set_process_input(false)


func new_copy() -> FlowchartBlockShape:
	return FlowchartBlockShape.new(points_template, color)


func _ready():
	_on_parent_resized()


func _on_parent_resized():
	var parent: Node = get_parent()
	if parent == null:
		return
	var width = parent.size.x
	var height = parent.size.y
	var points_buffer: PackedVector2Array = []
	for point in points_template:
		points_buffer.append(Vector2(point.x * width, point.y * height))
	points = points_buffer
	if points.size() > 0:
		points.append(points[0])
	draw.emit()


func _draw():
	_on_parent_resized()
	draw_polyline(points, color, 4, true)
