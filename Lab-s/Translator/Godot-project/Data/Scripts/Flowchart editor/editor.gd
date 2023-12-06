extends GraphEdit

class_name FlowchartEditor

var blocksAmount: int = 1
var toolMenu: FlowchartToolMenu

func _init():
	show_grid = false
	snapping_enabled = false
	toolMenu = FlowchartToolMenu.new()
	add_child(toolMenu)
	toolMenu.id_pressed.connect(_on_toolMenu_id_pressed)
	minimap_size = Vector2(120, 80)

func _on_toolMenu_id_pressed(id: int):
	var buffer: FlowchartBlock
	match id:
		0: buffer = FlowchartBlock.new(
			blocksAmount,
			FlowchartBlocksTypes.Process)
		1: buffer = FlowchartBlock.new(
			blocksAmount,
			FlowchartBlocksTypes.HandInput)
		2: buffer = FlowchartBlock.new(
			blocksAmount,
			FlowchartBlocksTypes.Output)
		3: buffer = FlowchartBlock.new(
			blocksAmount,
			FlowchartBlocksTypes.Condition)
	if (id < 4):
		buffer.position_offset = toolMenu.position
		blocksAmount += 1
		add_child(buffer)
	else:
		var childIndex: int = 0
		while childIndex < get_child_count():
			var childBuffer = get_child(childIndex)
			if (childBuffer is FlowchartBlock
				and childBuffer.selected
				and childBuffer.input.editable
				):
				remove_child(childBuffer)
			else:
				childIndex += 1

func _gui_input(event):
	if (event is InputEventMouseButton):
		if (event.pressed):
			if (event.button_index == MOUSE_BUTTON_LEFT):
				toolMenu.hide()
			elif (event.button_index == MOUSE_BUTTON_RIGHT):
				toolMenu.position = event.global_position
				toolMenu.show()

func _ready():
	var beginBlock: FlowchartBlock = FlowchartBlock.new(
		0, FlowchartBlocksTypes.Begin, false)
	beginBlock.position_offset = Vector2(
		size.x * 0.1,
		size.y * 0.45 - beginBlock.size.y)
	var endBlock: FlowchartBlock = FlowchartBlock.new(
		0, FlowchartBlocksTypes.End, false)
	endBlock.position_offset = Vector2(
		size.x * 0.8,
		beginBlock.position_offset.y)
	add_child(beginBlock)
	add_child(endBlock)
