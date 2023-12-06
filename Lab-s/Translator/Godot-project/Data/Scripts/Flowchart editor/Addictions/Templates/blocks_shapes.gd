extends Node
# Flowchat block shape template is Array
# 1) Shape points: PackedVector2Array
# 2) Shape color: Color
class_name FlowchartBlocksShapes

static var BeginEnd: FlowchartBlockShape
static var HandInput: FlowchartBlockShape
static var Output: FlowchartBlockShape
static var Condition: FlowchartBlockShape
static var Process: FlowchartBlockShape

static func _static_init():
	BeginEnd = FlowchartBlockShape.new(
		[
			# left -> top
			Vector2(0, 0.5),
			Vector2(0.0425, 0.33),
			Vector2(0.125, 0.16),
			Vector2(0.25, 0.075),
			Vector2(0.375, 0.034),
			Vector2(0.5, 0),
			# top -> right
			Vector2(0.625, 0.034),
			Vector2(0.75, 0.075),
			Vector2(0.875, 0.16),
			Vector2(0.9575, 0.33),
			Vector2(1, 0.5),
			# right -> bottom
			Vector2(0.9575, 0.67),
			Vector2(0.875, 0.84),
			Vector2(0.75, 0.925),
			Vector2(0.625, 0.966),
			Vector2(0.5, 1),
			# bottom -> left
			Vector2(0.375, 0.966),
			Vector2(0.25, 0.925),
			Vector2(0.125, 0.84),
			Vector2(0.0425, 0.67),
		],
		Color.WEB_GREEN
	)
	HandInput = FlowchartBlockShape.new(
		[
			Vector2.ZERO,
			Vector2(1, -0.34),
			Vector2.ONE,
			Vector2.DOWN,
		],
		Color.DEEP_SKY_BLUE
	)
	Output = FlowchartBlockShape.new(
		[
			Vector2.ZERO,
			Vector2.RIGHT,
			# Rounded right side
			Vector2(1.0625, 0.085),
			Vector2(1.09375, 0.17),
			Vector2(1.1125, 0.34),
			Vector2(1.125, 0.5),
			Vector2(1.1125, 0.66),
			Vector2(1.09375, 0.83),
			Vector2(1.0625, 0.915),
			Vector2.ONE,
			Vector2.DOWN,
			# Triangled left side
			Vector2(-0.25, 0.5),
		],
		Color.MEDIUM_PURPLE
	)
	Condition = FlowchartBlockShape.new(
		[
			Vector2(-0.25, 0.5),
			Vector2(0.5, -0.34),
			Vector2(1.25, 0.5),
			Vector2(0.5, 1.34),
		],
		Color.PINK
	)
	Process = FlowchartBlockShape.new(
		[
			Vector2.ZERO,
			Vector2.RIGHT,
			Vector2.ONE,
			Vector2.DOWN,
		],
		Color.WHEAT
	)
