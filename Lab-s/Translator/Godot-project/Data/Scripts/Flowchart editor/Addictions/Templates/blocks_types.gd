extends Node
# Flowchart block types templates (see FlowchartBlockType)  is Array:
# 1) Flowchart block shape: FlowchartBlockShape
# 2) Placeholder text: String
# 3) Bonus code (see FlowchartBlock "Bonus code" property): Array
class_name FlowchartBlocksTypes

static var Begin: FlowchartBlockType
static var End: FlowchartBlockType
static var HandInput: FlowchartBlockType
static var Output: FlowchartBlockType
static var Condition: FlowchartBlockType
static var Process: FlowchartBlockType

static func _static_init():
	Begin = FlowchartBlockType.new(
		FlowchartBlocksShapes.BeginEnd,
		"",
		["", ""],
		"Начало"
	)
	End = FlowchartBlockType.new(
		FlowchartBlocksShapes.BeginEnd,
		"",
		["", ""],
		"Конец"
	)
	HandInput = FlowchartBlockType.new(
		FlowchartBlocksShapes.HandInput,
		"Ввод ..",
		["", " ( ) "]
	)
	Output = FlowchartBlockType.new(
		FlowchartBlocksShapes.Output,
		"Вывод ..",
		[" ( ", " ) : "]
	)
	Condition = FlowchartBlockType.new(
		FlowchartBlocksShapes.Condition,
		"Условие ..",
		[" ( ", " ) : "]
	)
	Process = FlowchartBlockType.new(
		FlowchartBlocksShapes.Process,
		"Код..",
		["", ""]
	)
