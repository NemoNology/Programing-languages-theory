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
var _is_else_block: bool

const CODE_INPUT_BLOCK_MARGIN = 10


func _init(block_id: int, block_type: FlowchartBlockType):
	id = block_id
	type = block_type
	input = (FlowchartBlockTextEdit.new(block_type.flat))
	shape = block_type.shape.new_copy()

	title = "%s: %s" % [str(id), block_type.type_name]
	tooltip_text = block_type.tooltipText
	input.tooltip_text = tooltip_text
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
	# TODO: change getting adding code from lexeme types templates
	if type == FlowchartBlocksTypes.HandInput:
		return input.text + " будет ввод. "
	elif type == FlowchartBlocksTypes.Output:
		return " вывод " + input.text + " ."
	elif type == FlowchartBlocksTypes.ConditionIf:
		return " если ( " + input.text + " ) . "
	elif type == FlowchartBlocksTypes.ConditionWhile:
		return " пока ( " + input.text + " ) . "
	elif type == FlowchartBlocksTypes.ConditionEnd:
		return " конец. "
	elif _is_else_block:
		return " иначе. \n" + input.text
	return input.text


func set_is_else_block(new_is_else_block_value: bool) -> void:
	_is_else_block = new_is_else_block_value


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
	return "%s: %s (Is else: %s)" % [id, type.to_string(), _is_else_block]
