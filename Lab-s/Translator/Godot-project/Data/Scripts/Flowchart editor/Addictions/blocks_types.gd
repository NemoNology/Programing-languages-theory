extends Node
# Flowchart block types templates (see FlowchartBlockType)  is Array:
# 1) Flowchart block shape: FlowchartBlockShape
# 2) Placeholder text: String
# 3) Bonus code (see FlowchartBlock "Bonus code" property): Array
class_name FlowchartBlocksTypes

static var BeginEnd: FlowchartBlocksType
static var HandInput: FlowchartBlocksType
static var Output: FlowchartBlocksType
static var Condition: FlowchartBlocksType
static var Process: FlowchartBlocksType

static func _static_init():
	BeginEnd = FlowchartBlocksType.new(
		FlowchartBlocksShapes.BeginEnd,
		"",
		["", ""]
	)
	HandInput = FlowchartBlocksType.new(
		FlowchartBlocksShapes.HandInput,
		"",
		["", ""]
	)
	Output = FlowchartBlocksType.new(
		FlowchartBlocksShapes.Output,
		"",
		["", ""]
	)
	Condition = FlowchartBlocksType.new(
		FlowchartBlocksShapes.Condition,
		"",
		["", ""]
	)
	Process = FlowchartBlocksType.new(
		FlowchartBlocksShapes.Process,
		"",
		["", ""]
	)
