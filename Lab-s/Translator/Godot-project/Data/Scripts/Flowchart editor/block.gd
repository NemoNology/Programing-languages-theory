# Flowchart block is:
# Block ID: int;
# Block type: FlowchartBlockType;
# Block shape: FlowchartBlockShape
# Code block: FlowchartBlockTextEdit;
class_name FlowchartBlock extends GraphNode

var id: int
var type: FlowchartBlockType
var input: FlowchartBlockTextEdit
var shape: FlowchartBlockShape
var is_else_block: bool = false

const CODE_INPUT_BLOCK_MARGIN = 10


func _init(
	block_id: int,
	block_type: FlowchartBlockType,
	text: String = "",
	block_position_offset: Vector2 = Vector2.ZERO
):
	id = block_id
	type = block_type
	input = FlowchartBlockTextEdit.new(block_type.flat)
	shape = block_type.shape.new_copy()

	title = "%s: %s" % [str(id), block_type.type_name]
	tooltip_text = block_type.tooltipText
	input.tooltip_text = tooltip_text
	input.text = text
	add_child(input)

	var panel_style_box: StyleBox = get_theme_stylebox("panel")
	var panel_selected_style_box: StyleBox = get_theme_stylebox("panel_selected")
	if type.flat:
		panel_style_box = StyleBoxEmpty.new()
		panel_selected_style_box = panel_style_box
	else:
		panel_style_box.bg_color = Color.TRANSPARENT
		panel_selected_style_box.bg_color = Color.TRANSPARENT
		resizable = true
	var titlebar_style_box: StyleBoxFlat = StyleBoxFlat.new()
	titlebar_style_box.bg_color = shape.color.darkened(0.2)
	var titlebar_selected_style_box: StyleBoxFlat = StyleBoxFlat.new()
	titlebar_selected_style_box.bg_color = shape.default_color
	add_theme_stylebox_override("titlebar", titlebar_style_box)
	add_theme_stylebox_override("titlebar_selected", titlebar_selected_style_box)
	add_theme_stylebox_override("panel", panel_style_box)
	add_theme_stylebox_override("panel_selected", panel_selected_style_box)
	position_offset = block_position_offset

	node_selected.connect(_on_node_selected)
	node_deselected.connect(_on_node_deselected)

	for port_index in range(type.slots.size()):
		var slot: FlowchartBlockSlot = type.slots[port_index]
		if port_index > 0:
			var label_buffer: Label = Label.new()
			label_buffer.add_theme_font_size_override("font_size", 8)
			label_buffer.add_theme_color_override("font_color", Color.BLACK)
			label_buffer.size_flags_horizontal = Control.SIZE_FILL
			label_buffer.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
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

	add_child(shape)


func get_code() -> String:
	var code_buffer: String = input.text
	if type == FlowchartBlocksTypes.HandInput:
		if RegEx.create_from_string("^\\s*$").search(input.text):
			code_buffer = " %s%s " % [LexemeTypes.Cin, LexemeTypes.Separatop]
		else:
			code_buffer = (
				" %s %s %s%s "
				% [input.text, LexemeTypes.Assign, LexemeTypes.Cin, LexemeTypes.Separatop]
			)
	elif type == FlowchartBlocksTypes.Output:
		code_buffer = " %s %s%s " % [LexemeTypes.Cout, input.text, LexemeTypes.Separatop]
	elif type == FlowchartBlocksTypes.ConditionIf:
		code_buffer = " %s %s%s " % [LexemeTypes.If, input.text, LexemeTypes.Separatop]
	elif type == FlowchartBlocksTypes.ConditionWhile:
		code_buffer = " %s %s%s " % [LexemeTypes.While, input.text, LexemeTypes.Separatop]
	elif type == FlowchartBlocksTypes.ConditionEnd:
		return " %s%s " % [LexemeTypes.End, LexemeTypes.Separatop]

	if is_else_block:
		return " %s%s %s" % [LexemeTypes.Else, LexemeTypes.Separatop, code_buffer]
	return code_buffer


func _ready():
	input.position = Vector2(CODE_INPUT_BLOCK_MARGIN, CODE_INPUT_BLOCK_MARGIN)
	node_deselected.emit()


func _on_node_selected():
	shape.color = shape.default_color


func _on_node_deselected():
	shape.color = shape.default_color.darkened(0.2)


func _draw():
	shape.queue_redraw()


func _to_string():
	return "%s: %s " % [id, type.to_string(), is_else_block]


func get_state() -> Dictionary:
	var state: Dictionary = {}
	state["id"] = id
	state["type"] = type.type_name
	state["text"] = input.text
	state["position_offset_x"] = position_offset.x
	state["position_offset_y"] = position_offset.y

	return state
