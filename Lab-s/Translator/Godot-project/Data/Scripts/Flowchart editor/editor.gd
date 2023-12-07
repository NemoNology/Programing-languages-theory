extends GraphEdit

class_name FlowchartEditor

var blocksAmount: int = 1
var toolMenu: FlowchartToolMenu

func _init():
	show_grid = false
	snapping_enabled = false
	minimap_size = Vector2(120, 80)
	var panelStyleBox: StyleBoxFlat = StyleBoxFlat.new()
	panelStyleBox.bg_color = Color.GRAY
	add_theme_stylebox_override("panel", panelStyleBox)
	toolMenu = FlowchartToolMenu.new()
	add_child(toolMenu)
	toolMenu.id_pressed.connect(_on_toolMenu_id_pressed)
	connection_request.connect(_on_connection_requested)
	disconnection_request.connect(_on_disconnection_requested)
	connection_to_empty.connect(_on_connected_to_empty)
	delete_nodes_request.connect(_on_delete_nodes_requested)
	right_disconnects = true

func _on_toolMenu_id_pressed(id: int):
	if (id <  toolMenu.item_count - 1):
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
				FlowchartBlocksTypes.ConditionIf)
			4: buffer = FlowchartBlock.new(
				blocksAmount,
				FlowchartBlocksTypes.ConditionWhile)
			5: buffer = FlowchartBlock.new(
				blocksAmount,
				FlowchartBlocksTypes.EndCondition) 
		buffer.position_offset = toolMenu.position
		blocksAmount += 1
		add_child(buffer)
	elif (id == toolMenu.item_count - 1):
		var childIndex: int = 0
		while childIndex < get_child_count():
			var childBuffer = get_child(childIndex)
			if (childBuffer is FlowchartBlock
				and childBuffer.selected
				and childBuffer.input.editable
				):
				delete_nodes_request.emit([childBuffer.name])
				remove_child(childBuffer)
				blocksAmount -= 1
			else:
				childIndex += 1
	grab_focus()

func check_flowchart_blocks_connections() -> PackedStringArray:
	var errors: PackedStringArray = []
	var cons: Array[Dictionary] = get_connection_list()
	var endBlock: FlowchartBlock = null
	var beginBlock: FlowchartBlock = null
	# Find begin and end
	for child in get_children():
		if (beginBlock != null and endBlock != null):
			break
		elif (child is FlowchartBlock):
			if (child.type == FlowchartBlocksTypes.Begin):
				beginBlock = child
			elif (child.type == FlowchartBlocksTypes.End):
				endBlock = child
	var isThereNextBlock: bool
	var areTherePreviousBlock: bool
	# Find connections not existing
	for child in get_children():
		if (child is FlowchartBlock
			and child != beginBlock
			and child != endBlock):
			isThereNextBlock = false
			areTherePreviousBlock = false
			for con: Dictionary in cons:
				if (isThereNextBlock and areTherePreviousBlock):
					break
				elif (con["from_node"] == child.name):
					isThereNextBlock = true
				elif (con["to_node"] == child.name):
					areTherePreviousBlock = true
			if (not isThereNextBlock):
				errors.append((
					"От блока %s должен быть путь"
					% child.id))
			if (not areTherePreviousBlock):
				errors.append((
					"К блоку %s должен быть путь"
					% child.id))

	return errors

func get_code() -> Dictionary:
	var code: Dictionary = {}
	var tabulatesCount: int = 0
	var childAmount = get_child_count()
	for childIndex in range(childAmount):
		var child: Node = get_child(childIndex)
		if (child is FlowchartBlock
			and child.id > 0
			):
			if (child.type == FlowchartBlocksTypes.ConditionIf
				or child.type == FlowchartBlocksTypes.ConditionWhile
				):
				tabulatesCount += 1
			elif (tabulatesCount > 1
				and childIndex + 1 < childAmount
				):
				var nextBlockType = get_child(childIndex + 1).type
				if (nextBlockType != FlowchartBlocksTypes.ConditionIf
					and nextBlockType != FlowchartBlocksTypes.ConditionWhile
					):
					tabulatesCount -= 1
			code[child.id] = child.get_code(tabulatesCount)
	return code

func _gui_input(event):
	if (event is InputEventMouseButton):
		if (event.pressed):
			if (event.button_index == MOUSE_BUTTON_LEFT):
				toolMenu.hide()
			elif (event.button_index == MOUSE_BUTTON_RIGHT):
				toolMenu.position = event.global_position
				toolMenu.show()
	elif (event is InputEventKey):
		var kc: Key = event.keycode
		if (kc == KEY_A):
			for child in get_children():
				if (child is FlowchartBlock
					and child.input.editable
					):
					child.selected = true
		elif (kc == KEY_X or kc == KEY_DELETE):
			_on_toolMenu_id_pressed(toolMenu.item_count - 1)

func _ready():
	anchors_preset = PRESET_FULL_RECT
	var beginBlock: FlowchartBlock = FlowchartBlock.new(
		0, FlowchartBlocksTypes.Begin, false)
	beginBlock.position_offset = Vector2(
		200,
		120 - beginBlock.size.y)
	var endBlock: FlowchartBlock = FlowchartBlock.new(
		0, FlowchartBlocksTypes.End, false)
	endBlock.position_offset = Vector2(
		400 - endBlock.size.x,
		beginBlock.position_offset.y)
	add_child(beginBlock)
	add_child(endBlock)

func _on_connection_requested(
	from_node: StringName, from_port: int, 
	to_node: StringName, to_port: int
	):
	if (from_node != to_node):
		for con in get_connection_list():
			if (con["from_node"] == from_node
				and con["from_port"] == from_port
				):
				disconnection_request.emit(
					from_node, from_port,
					con["to_node"], con["to_port"]
				)
		connect_node(
			from_node, from_port,
			to_node, to_port,
			)

func _on_disconnection_requested(
	from_node: StringName, from_port: int, 
	to_node: StringName, to_port: int
	):
	disconnect_node(
		from_node, from_port,
		to_node, to_port,
	)

func _on_connected_to_empty(from_node: StringName, from_port: int, release_position: Vector2):
	for con in get_connection_list():
		if (con["from_node"] == from_node
			and con["from_port"] == from_port
			):
			disconnect_node(
				from_node, from_port,
				con["to_node"], con["to_port"],
			)

func _on_delete_nodes_requested(nodes: Array):
	for node in nodes:
		for con in get_connection_list():
			if (con["from_node"] == node
				or con["to_node"] == node
				):
				disconnection_request.emit(
					con["from_node"], con["from_port"],
					con["to_node"], con["to_port"],
				)
