extends Line2D

class_name FlowchartBlockShape

var _points: PackedVector2Array


func _init(shapePoints: PackedVector2Array, color: Color):
	_points = shapePoints
	default_color = color
	closed = true
	width = 5


static func new_from(shape: FlowchartBlockShape) -> FlowchartBlockShape:
	return FlowchartBlockShape.new(shape._points, shape.default_color)


func _ready():
	_on_resized()
	get_parent().resized.connect(_on_resized)


func _on_resized():
	var parent: Node = get_parent()
	var newX = parent.size.x
	var newY = parent.size.y
	var pointsBuffer: PackedVector2Array = []
	for point in _points:
		pointsBuffer.append(Vector2(point.x * newX, point.y * newY))
	points = pointsBuffer


func _draw():
	draw_polyline(points, default_color, width, antialiased)
