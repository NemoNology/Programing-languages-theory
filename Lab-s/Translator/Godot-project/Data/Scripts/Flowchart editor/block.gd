extends GraphNode
# Flowchart block is:
# Block ID: int;
# Block type: FlowchartBlockType;
# Block shape: FlowchartBlockShape
# Code block: FlowchartBlockTextEdit;
class_name FlowchartBlock

var id: int
var type: FlowchartBlockType
var input: FlowchartBlockTextEdit
var shape: FlowchartBlockShape

const CODE_INPUT_BLOCK_MARGIN = 15

func _init(
	block_id: int,
	block_type: FlowchartBlockType,
	is_block_input_editable: bool = true
	):
	id = block_id
	type = block_type
	input = FlowchartBlockTextEdit.new(
		block_type.startText,
		block_type.placeholderText,
		is_block_input_editable,
	)
	shape = block_type.shape
	title = str(id)
	tooltip_text = block_type.tooltipText
	input.tooltip_text = tooltip_text
	resizable = true
	add_child(input)
	set_anchors_preset(PRESET_CENTER)
	var titlebarStyleBox = StyleBoxFlat.new()
	var titlebarSelectedStyleBox = StyleBoxFlat.new()
	titlebarStyleBox.bg_color = Color(shape.default_color, 0.5)
	titlebarSelectedStyleBox.bg_color = shape.default_color
	add_theme_stylebox_override("titlebar", titlebarStyleBox)
	add_theme_stylebox_override("titlebar_selected", titlebarSelectedStyleBox)
	for port_index in range(type.slots.size()):
		var slot: FlowchartBlockSlot = type.slots[port_index]
		if (port_index > 0):
			add_child(FlowchartBlockSlot.new_from(slot))
		set_slot(
			port_index,
			slot.isInputPortEnabled,
			FlowchartBlockSlot.DEFAULT_PORT_TYPE,
			FlowchartBlockSlot.DEFAULT_IN_PORT_COLOR,
			slot.isOutputPortEnabled,
			FlowchartBlockSlot.DEFAULT_PORT_TYPE,
			FlowchartBlockSlot.DEFAULT_OUT_PORT_COLOR
		)

# TODO: if there is block shape need see

func get_code(tabulatesCount: int = 0) -> String:
	var codeBuffer: String
	codeBuffer = input.text.replace("\n", "\n" + " tab ".repeat(tabulatesCount))
	if (type == FlowchartBlocksTypes.HandInput):
		return codeBuffer + " будет ввод."
	elif (type == FlowchartBlocksTypes.Output):
		return "вывод " + codeBuffer + "."
	elif (type == FlowchartBlocksTypes.ConditionIf):
		return "если ( " + codeBuffer + " ) : "
	elif (type == FlowchartBlocksTypes.ConditionWhile):
		return "пока ( " + codeBuffer + " ) : "
	return codeBuffer

func _ready():
	input.position = Vector2(
		CODE_INPUT_BLOCK_MARGIN,
		CODE_INPUT_BLOCK_MARGIN)
	
