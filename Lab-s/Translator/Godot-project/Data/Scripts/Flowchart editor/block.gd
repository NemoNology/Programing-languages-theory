extends GraphNode
# Flowchart block is:
# Block ID: int;
# Block type: FlowchartBlockType;
# Code clock: FlowchartBlockTextEdit
# Next block - then: FlowchartBlock;
# Next block - else: FlowchartBlock;
class_name FlowchartBlock

var id: int
var type: FlowchartBlockType
var input: FlowchartBlockTextEdit
var shape: FlowchartBlockShape
var thenBlock: FlowchartBlock = null
var elseBlock: FlowchartBlock = null
const INPUT_MARGIN = 15
signal replaced(new_global_position: Vector2)

func _init(
	block_id: int,
	block_type: FlowchartBlockType,
	is_block_input_editable: bool = true
	):
	id = block_id
	type = block_type
	input = FlowchartBlockTextEdit.new(
		block_type._startText,
		block_type._placeholderText,
		is_block_input_editable)
	shape = FlowchartBlockShape.from(block_type._shape)
	# var labelID: Label = Label.new()
	# labelID.text = str(id)
	# labelID.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	# labelID.self_modulate = Color.WHITE
	title = str(id)
	add_child(shape)
	add_child(input)
	set_anchors_preset(PRESET_CENTER)
	var titlebarStyleBox = StyleBoxEmpty.new()
	var titlebarSelectedStyleBox = StyleBoxFlat.new()
	titlebarSelectedStyleBox.bg_color = shape.default_color
	add_theme_stylebox_override("titlebar", titlebarStyleBox)
	add_theme_stylebox_override("titlebar_selected", titlebarSelectedStyleBox)

func get_code() -> String:
	if (type == FlowchartBlocksTypes.HandInput):
		return input.text + " равно ввод."
	elif (type == FlowchartBlocksTypes.Output):
		return "вывод " + input.text + "."
	elif (type == FlowchartBlocksTypes.Condition):
		if (thenBlock.thenBlock == self):
			return "пока ( " + input.text + " ) : "
		return "если ( " + input.text + " ) : "
	return input.text

func _draw():
	shape.draw.emit()

func _ready():
	input.position = Vector2(
		INPUT_MARGIN,
		INPUT_MARGIN)
