class_name FlowchartEditor extends GraphEdit

var blocks_amount: int = 3
var tool_menu: FlowchartToolMenu
var _save_load_handler: FlowchartSaveLoadHandler


func _init():
	show_grid = false
	snapping_enabled = false
	right_disconnects = true
	minimap_size = Vector2(120, 80)

	var panel_style_box: StyleBoxFlat = StyleBoxFlat.new()
	panel_style_box.bg_color = Color.from_string("#dfe8e9", Color.WHITE)
	add_theme_stylebox_override("panel", panel_style_box)
	add_theme_color_override("grid_minor", Color.GRAY)
	add_theme_color_override("grid_major", Color.BLACK)

	_save_load_handler = FlowchartSaveLoadHandler.new(self)
	tool_menu = FlowchartToolMenu.new()
	add_child(_save_load_handler)
	add_child(tool_menu)

	_save_load_handler.state_load.connect(_on_state_loaded)
	tool_menu.id_pressed.connect(_on_tool_menu_id_pressed)
	connection_request.connect(_on_connection_requested)
	disconnection_request.connect(_on_disconnection_requested)
	connection_to_empty.connect(_on_connected_to_empty)
	delete_nodes_request.connect(_on_delete_nodes_requested)


func _on_tool_menu_id_pressed(id: int) -> void:
	if id in tool_menu.AddingBlockTypeByOptionID:
		var buffer: FlowchartBlock = FlowchartBlock.new(
			blocks_amount,
			tool_menu.AddingBlockTypeByOptionID[id],
			"",
			Vector2(tool_menu.position) + scroll_offset / zoom
		)
		blocks_amount += 1
		add_child(buffer)
	elif id == tool_menu.DeleteSelectedBlocksOptionID:
		var child_index: int = 0
		while child_index < get_child_count():
			var child_buffer = get_child(child_index)
			if (
				child_buffer is FlowchartBlock
				and child_buffer.selected
				and not child_buffer.type in [FlowchartBlocksTypes.Begin, FlowchartBlocksTypes.End]
			):
				delete_nodes_request.emit([child_buffer.name])
			else:
				child_index += 1
	elif id == tool_menu.SelectAllBlocksOptionID:
		for child in get_children():
			if child is FlowchartBlock:
				child.selected = true
	elif id == tool_menu.SaveFlowchartOptionID:
		_save_load_handler.save()
	elif id == tool_menu.SaveFlowchartAsOptionID:
		_save_load_handler.save_as()
	elif id == tool_menu.LoadFlowchartOptionID:
		_save_load_handler.load()
	grab_focus()


## Flowchart blocks checking:
## -) Check blocks connections;
## -) Check condition blocks closing by condition end blocks;
## -) Check empty blocks;
## Returns: errors array
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
				elif con["from_node"] == child.name or is_there_next_block:
					var to_node_type = get_node(NodePath(con["to_node"])).type
					if con["from_port"] == 0:
						is_there_next_block = true
						if is_condition_block:
							if to_node_type == FlowchartBlocksTypes.ConditionEnd:
								errors.append("Блок условия %s не содержит тела" % child.id)
							else:
								is_condition_block = false
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
							errors.append(
								"Тело \'иначе\' блока условия %s является пустым" % child.id
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


## Return flowchart full code -> list of FLowchartBlockCode
func get_block_codes() -> Array[FLowchartBlockCode]:
	var blocks_codes: Array[FLowchartBlockCode] = []
	var branches_queue: Array[FlowchartBlock] = []
	var conditions_types_stack: Array[bool] = []
	var cons: Array[Dictionary] = get_connection_list()
	# Find and starts from begin block
	for child in get_children():
		if child is FlowchartBlock:
			child.is_else_block = false
			if child.type == FlowchartBlocksTypes.Begin:
				for con in cons:
					if con["from_node"] == child.name:
						branches_queue.push_back(get_node(NodePath(con["to_node"])))

	# Go on every branch
	while branches_queue.size() > 0:
		var block_buffer: FlowchartBlock = branches_queue.pop_front()
		var con_index: int = 0

		while con_index < cons.size():
			var con: Dictionary = cons[con_index]

			if con["from_node"] == block_buffer.name:
				if block_buffer.type == FlowchartBlocksTypes.End:
					return blocks_codes

				if block_buffer.type == FlowchartBlocksTypes.ConditionWhile:
					conditions_types_stack.push_back(false)
				elif block_buffer.type == FlowchartBlocksTypes.ConditionIf:
					conditions_types_stack.push_back(true)
					blocks_codes.append(
						FLowchartBlockCode.new(block_buffer.id, block_buffer.get_code())
					)
					# Searching what's block go next: 'else' or 'then'
					# If it's 'then' (next block from_port == 0) -> search 'save', push 'save' to branches
					# If it's 'else' -> push it to branches and switch to 'then' block
					for con1 in cons:
						if con1["from_node"] == block_buffer.name:
							if con1["from_port"] == 0:
								# Switching to next 'then' block
								block_buffer = get_node(NodePath(con1["to_node"]))
							else:
								# Pushing next 'else' block
								var block_else: FlowchartBlock = get_node(NodePath(con1["to_node"]))
								block_else.is_else_block = true
								branches_queue.push_back(block_else)
							# Searching another body: 'then' for 'else' or 'else' for 'then'
							for con2 in cons:
								if (
									con2["from_node"] == con1["from_node"]
									and con2["from_port"] != con1["from_port"]
								):
									if con1["from_port"] == 0:
										# Pushing 'else'
										var block_else: FlowchartBlock = get_node(
											NodePath(con2["to_node"])
										)
										block_else.is_else_block = true
										branches_queue.push_back(block_else)
									else:
										# Switching to 'then'
										block_buffer = get_node(NodePath(con2["to_node"]))
										con_index = 0
									# We do all we need
									break
							break
					continue
				elif block_buffer.type == FlowchartBlocksTypes.ConditionEnd:
					var is_previous_condition_if_block: bool = conditions_types_stack.pop_back()
					if not branches_queue.is_empty() and is_previous_condition_if_block:
						conditions_types_stack.push_back(false)
						break

				blocks_codes.append(
					FLowchartBlockCode.new(block_buffer.id, block_buffer.get_code())
				)
				block_buffer = get_node(NodePath(con["to_node"]))
				con_index = 0
			else:
				con_index += 1

	return blocks_codes


func _gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				tool_menu.hide()
			elif event.button_index == MOUSE_BUTTON_RIGHT:
				tool_menu.position = event.global_position
				tool_menu.show()
	elif event is InputEventKey:
		if event.keycode in [KEY_X, KEY_DELETE]:
			_on_tool_menu_id_pressed(tool_menu.DeleteSelectedBlocksOptionID)
		elif event.keycode == KEY_A:
			_on_tool_menu_id_pressed(tool_menu.SelectAllBlocksOptionID)
		elif event.keycode == KEY_S and event.ctrl_pressed:
			if event.shift_pressed:
				_on_tool_menu_id_pressed(tool_menu.SaveFlowchartAsOptionID)
			else:
				_on_tool_menu_id_pressed(tool_menu.SaveFlowchartOptionID)
		elif event.keycode == KEY_O and event.ctrl_pressed:
			_on_tool_menu_id_pressed(tool_menu.LoadFlowchartOptionID)


func _ready():
	anchors_preset = PRESET_FULL_RECT
	var begin_block: FlowchartBlock = FlowchartBlock.new(1, FlowchartBlocksTypes.Begin)
	begin_block.position_offset = Vector2(200, 120 - begin_block.size.y)
	var end_block: FlowchartBlock = FlowchartBlock.new(2, FlowchartBlocksTypes.End)
	end_block.position_offset = Vector2(400 - end_block.size.x, begin_block.position_offset.y)
	add_child(begin_block)
	add_child(end_block)


func _on_connection_requested(
	from_node: StringName, from_port: int, to_node: StringName, to_port: int
) -> void:
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


func _on_disconnection_requested(
	from_node: StringName, from_port: int, to_node: StringName, to_port: int
) -> void:
	disconnect_node(
		from_node,
		from_port,
		to_node,
		to_port,
	)


func _on_connected_to_empty(
	from_node: StringName, from_port: int, _release_position: Vector2
) -> void:
	for con in get_connection_list():
		if con["from_node"] == from_node and con["from_port"] == from_port:
			disconnect_node(
				from_node,
				from_port,
				con["to_node"],
				con["to_port"],
			)


func _on_delete_nodes_requested(nodes: Array) -> void:
	# Clear nodes connections
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
	# Remove nodes
	for node in nodes:
		remove_child(get_node(NodePath(node)))


## Return a flowchart state as a dictionary; State needed for saving/loading
func get_state() -> Dictionary:
	var state: Dictionary = {}

	var blocks_buffer: Array[Dictionary] = []
	for child in get_children():
		if child is FlowchartBlock:
			blocks_buffer.append(child.get_state())

	state["blocks"] = blocks_buffer
	state["connections"] = []
	var cons: Array[Dictionary] = get_connection_list()
	for con in cons:
		(
			state["connections"]
			. append(
				{
					"from_node": get_node(NodePath(con["from_node"])).id,
					"from_port": con["from_port"],
					"to_node": get_node(NodePath(con["to_node"])).id,
					"to_port": con["to_port"],
				}
			)
		)

	return state


## Set inputted flowchart state as current flowchart state; State needed for saving/loading
func set_state(state: Dictionary) -> void:
	var blocks_amount_buffer: int = 0
	var child_index: int = 0
	while child_index < get_child_count():
		var child_buffer = get_child(child_index)
		if child_buffer is FlowchartBlock:
			delete_nodes_request.emit([child_buffer.name])
		else:
			child_index += 1

	var blocks_names_by_id: Dictionary = {}

	for block in state["blocks"]:
		var block_buffer: FlowchartBlock = FlowchartBlock.new(
			block["id"],
			FlowchartBlocksTypes.from_name(block["type"]),
			block["text"],
			Vector2(block["position_offset_x"], block["position_offset_y"])
		)
		if blocks_amount_buffer < block_buffer.id:
			blocks_amount_buffer = block_buffer.id
		add_child(block_buffer)
		blocks_names_by_id[block_buffer.id] = block_buffer.name
	blocks_amount = blocks_amount_buffer

	var children = get_children()
	for con in state["connections"]:
		var from_block: FlowchartBlock = null
		var to_block: FlowchartBlock = null
		for child in children:
			if child is FlowchartBlock:
				if child.id == con["from_node"]:
					from_block = child
				elif child.id == con["to_node"]:
					to_block = child
			if from_block != null and to_block != null:
				connection_request.emit(
					blocks_names_by_id[from_block.id],
					con["from_port"],
					blocks_names_by_id[to_block.id],
					con["to_port"]
				)
				break


func _on_state_loaded(state: Dictionary) -> void:
	set_state(state)
