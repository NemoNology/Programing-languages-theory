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


func _init(block_id: int, block_type: FlowchartBlockType):
	id = block_id
	type = block_type
	input = (
		FlowchartBlockTextEdit
		. new(
			block_type.placeholderText,
			block_type.flat,
		)
	)
	title = str(id)
	if block_type.flat:
		title += ": " + block_type.placeholderText
	else:
		resizable = true
	shape = block_type.shape
	tooltip_text = block_type.tooltipText
	input.tooltip_text = tooltip_text
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
		if port_index > 0:
			var label_buffer: Label = Label.new()
			label_buffer.add_theme_font_size_override("font_size", 8)
			label_buffer.text = slot.text
			label_buffer.uppercase = true
			add_child(label_buffer)
		set_slot(
			port_index,
			slot.input_port_enabled,
			FlowchartBlockSlot.DEFAULT_PORT_TYPE,
			FlowchartBlockSlot.DEFAULT_IN_PORT_COLOR,
			slot.output_port_enabled,
			FlowchartBlockSlot.DEFAULT_PORT_TYPE,
			FlowchartBlockSlot.DEFAULT_OUT_PORT_COLOR
		)


func get_code(tabulatesCount: int = 0) -> String:
	var codeBuffer: String
	codeBuffer = input.text.replace("\n", "\n" + " tab ".repeat(tabulatesCount))
	if type == FlowchartBlocksTypes.HandInput:
		return codeBuffer + " будет ввод."
	elif type == FlowchartBlocksTypes.Output:
		return "вывод " + codeBuffer + "."
	elif type == FlowchartBlocksTypes.ConditionIf:
		return "если ( " + codeBuffer + " ) : "
	elif type == FlowchartBlocksTypes.ConditionWhile:
		return "пока ( " + codeBuffer + " ) : "
	return codeBuffer


func _ready():
	input.position = Vector2(CODE_INPUT_BLOCK_MARGIN, CODE_INPUT_BLOCK_MARGIN)
