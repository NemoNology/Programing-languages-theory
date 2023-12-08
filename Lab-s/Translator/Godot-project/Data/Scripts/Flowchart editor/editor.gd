extends GraphEdit

class_name FlowchartEditor

var blocks_amount: int = 3
var tool_menu: FlowchartToolMenu


func _init():
	show_grid = false
	snapping_enabled = false
	minimap_size = Vector2(120, 80)
	var panel_style_box: StyleBoxFlat = StyleBoxFlat.new()
	panel_style_box.bg_color = Color.GRAY
	add_theme_stylebox_override("panel", panel_style_box)
	tool_menu = FlowchartToolMenu.new()
	add_child(tool_menu)
	tool_menu.id_pressed.connect(on_tool_menu_id_pressed)
	connection_request.connect(on_connection_requested)
	disconnection_request.connect(on_disconnection_requested)
	connection_to_empty.connect(on_connected_to_empty)
	delete_nodes_request.connect(on_delete_nodes_requested)
	right_disconnects = true


func on_tool_menu_id_pressed(id: int):
	if id < tool_menu.item_count - 1:
		var buffer: FlowchartBlock
		match id:
			0:
				buffer = FlowchartBlock.new(blocks_amount, FlowchartBlocksTypes.Process)
			1:
				buffer = FlowchartBlock.new(blocks_amount, FlowchartBlocksTypes.HandInput)
			2:
				buffer = FlowchartBlock.new(blocks_amount, FlowchartBlocksTypes.Output)
			3:
				buffer = FlowchartBlock.new(blocks_amount, FlowchartBlocksTypes.ConditionIf)
			4:
				buffer = FlowchartBlock.new(blocks_amount, FlowchartBlocksTypes.ConditionWhile)
			5:
				buffer = FlowchartBlock.new(blocks_amount, FlowchartBlocksTypes.ConditionEnd)
		buffer.position_offset = tool_menu.position
		blocks_amount += 1
		add_child(buffer)
	elif id == tool_menu.item_count - 1:
		var child_index: int = 0
		while child_index < get_child_count():
			var child_buffer = get_child(child_index)
			if (
				child_buffer is FlowchartBlock
				and child_buffer.selected
				and child_buffer.input.editable
			):
				delete_nodes_request.emit([child_buffer.name])
				remove_child(child_buffer)
			else:
				child_index += 1
	grab_focus()


# Flowchart blocks checking
# Check blocks connections
# Check condition blocks closing by condition end blocks
# Check empty blocks
func check_flowchart_blocks() -> PackedStringArray:
	var errors: PackedStringArray = []
	var cons: Array[Dictionary] = get_connection_list()
	var conditions_starts: Array[int] = []
	var conditions_ends: Array[int] = []
	var is_whitespace_regex = RegEx.new()
	is_whitespace_regex.compile("^\\s*$")
	for child in get_children():
		if child is FlowchartBlock:
			var is_there_next_block: bool = not child.is_slot_enabled_right(0)
			var is_there_previous_block: bool = not child.is_slot_enabled_left(0)
			var is_condition_block: bool = false
			if (
				child.type == FlowchartBlocksTypes.ConditionIf
				or child.type == FlowchartBlocksTypes.ConditionWhile
			):
				conditions_starts.push_back(child.id)
				is_condition_block = true
			elif child.type == FlowchartBlocksTypes.ConditionEnd:
				conditions_ends.push_back(child.id)
			# Check block emptiness
			if not child.type.flat and is_whitespace_regex.search(child.input.text):
				errors.append("У блока %s отсутствует сожержимое" % child.id)
			for con: Dictionary in cons:
				if is_there_next_block and is_there_previous_block:
					break
				if con["from_node"] == child.name or is_there_next_block:
					var to_node_type = get_node(NodePath(con["to_node"])).type
					if con["from_port"] == 0:
						is_there_next_block = true
						if (
							is_condition_block
							and (to_node_type == FlowchartBlocksTypes.ConditionEnd)
						):
							(
								errors
								. append(
									(
										"Блок условия %s не содержит тела (и сразу же закрывается блоком конца условия)"
										% child.id
									)
								)
							)
						elif (
							child.type == FlowchartBlocksTypes.Begin
							and to_node_type == FlowchartBlocksTypes.End
						):
							errors.append("Тело блок-схемы не сожержит алгоритм")
					else:
						if (
							is_condition_block
							and (to_node_type == FlowchartBlocksTypes.ConditionEnd)
						):
							conditions_starts.push_back(child.id)
							(
								errors
								. append(
									(
										"Тело (ветвь) \'иначе\' блока условия %s является пустым (и сразу же закрывается блоком конца условия)"
										% child.id
									)
								)
							)
				is_there_previous_block = con["to_node"] == child.name or is_there_previous_block
			if not is_there_next_block:
				errors.append("Блок %s не имеет продолжения" % child.id)
			if not is_there_previous_block:
				errors.append("Блок %s не имеет начала" % child.id)
	# Check condition block
	while conditions_starts.size() > 0:
		if conditions_ends.size() > 0:
			conditions_starts.pop_back()
			conditions_ends.pop_back()
		else:
			for block_id in conditions_starts:
				errors.append("Блок условия %s не закрыт блоком конца условия" % block_id)
			break
	# Check condition end block
	for block_id in conditions_ends:
		errors.append("Блок конца условия %s закрывает несуществующий блок условия" % block_id)
	return errors


func get_code() -> Dictionary:
	var code: Dictionary = {}
	var tabulates_count: int = 0
	var branches_queue: Array[FlowchartBlock] = []
	# Find and starts from begin block
	for child in get_children():
		if child is FlowchartBlock and child.type == FlowchartBlocksTypes.Begin:
			branches_queue.push_back(child)
			break
	# Go on every branch
	# TODO: code getting
	var cons: Array[Dictionary] = get_connection_list()
	while branches_queue.size() > 0:
		var block_buffer: FlowchartBlock = branches_queue.pop_front()
		if block_buffer.type == FlowchartBlocksTypes.End:
			return code
		for con in cons:
			if con["from_node"] == block_buffer.name:
				if block_buffer.type == FlowchartBlocksTypes.ConditionWhile:
					tabulates_count += 1
					block_buffer = get_node(NodePath(con["to_node"]))
				elif block_buffer.type == FlowchartBlocksTypes.ConditionIf:
					if con["from_port"] == 0:
						block_buffer = get_node(NodePath(con["to_node"]))
						# Searching 'else' block
						for con1 in cons:
							if con1["from_node"] == con["from_node"] and con1["from_port"] == 1:
								branches_queue.push_back(get_node(NodePath(con1["to_node"])))
								break
					else:
						branches_queue.push_back(get_node(NodePath(con["to_node"])))
						# Searching 'then' block
						for con1 in cons:
							if con1["from_node"] == con["from_node"] and con1["from_port"] == 0:
								block_buffer = get_node(NodePath(con1["to_node"]))
								break
				elif block_buffer.type == FlowchartBlocksTypes.ConditionEnd:
					tabulates_count -= 1
					block_buffer = get_node(NodePath(con["to_node"]))
				else:
					block_buffer = get_node(NodePath(con["to_node"]))
				break
		code[block_buffer.id] = block_buffer.get_code(tabulates_count)

	return code


func _gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				tool_menu.hide()
			elif event.button_index == MOUSE_BUTTON_RIGHT:
				tool_menu.position = event.global_position
				tool_menu.show()
	elif event is InputEventKey:
		var kc: Key = event.keycode
		if kc == KEY_A:
			for child in get_children():
				if child is FlowchartBlock and child.input.editable:
					child.selected = true
		elif kc == KEY_X or kc == KEY_DELETE:
			on_tool_menu_id_pressed(tool_menu.item_count - 1)


func _ready():
	anchors_preset = PRESET_FULL_RECT
	var begin_block: FlowchartBlock = FlowchartBlock.new(1, FlowchartBlocksTypes.Begin)
	begin_block.position_offset = Vector2(200, 120 - begin_block.size.y)
	var end_block: FlowchartBlock = FlowchartBlock.new(2, FlowchartBlocksTypes.End)
	end_block.position_offset = Vector2(400 - end_block.size.x, begin_block.position_offset.y)
	add_child(begin_block)
	add_child(end_block)


func on_connection_requested(
	from_node: StringName, from_port: int, to_node: StringName, to_port: int
):
	if from_node != to_node:
		for con in get_connection_list():
			if con["from_node"] == from_node and con["from_port"] == from_port:
				disconnection_request.emit(from_node, from_port, con["to_node"], con["to_port"])
		connect_node(
			from_node,
			from_port,
			to_node,
			to_port,
		)


func on_disconnection_requested(
	from_node: StringName, from_port: int, to_node: StringName, to_port: int
):
	disconnect_node(
		from_node,
		from_port,
		to_node,
		to_port,
	)


func on_connected_to_empty(from_node: StringName, from_port: int, release_position: Vector2):
	for con in get_connection_list():
		if con["from_node"] == from_node and con["from_port"] == from_port:
			disconnect_node(
				from_node,
				from_port,
				con["to_node"],
				con["to_port"],
			)


func on_delete_nodes_requested(nodes: Array):
	for node in nodes:
		for con in get_connection_list():
			if con["from_node"] == node or con["to_node"] == node:
				(
					disconnection_request
					. emit(
						con["from_node"],
						con["from_port"],
						con["to_node"],
						con["to_port"],
					)
				)
