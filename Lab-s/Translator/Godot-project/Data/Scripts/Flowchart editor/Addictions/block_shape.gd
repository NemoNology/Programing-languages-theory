extends Node2D
# Flowchart block shape is:
# 1) Points template: PackedVector2Array
# 2) Color: Color
# 3) Points: PackedVector2Array
class_name FlowchartBlockShape

var points_template: PackedVector2Array
var color: Color
var points: PackedVector2Array


func _init(shape_points_template: PackedVector2Array, shape_color: Color):
	points_template = shape_points_template
	color = shape_color


func new_copy() -> FlowchartBlockShape:
	return FlowchartBlockShape.new(points_template, color)


func _ready():
	_on_resized()
	get_parent().resized.connect(_on_resized)


func _on_resized():
	var parent: Node = get_parent()
	var width = parent.size.x
	var height = parent.size.y
	var points_buffer: PackedVector2Array = []
	for point in points_template:
		points_buffer.append(Vector2(point.x * width, point.y * height))
	points = points_buffer
	if (points.size() > 0):
		points.append(points[0])


func _draw():
	draw_polyline(points, color, 4, true)
