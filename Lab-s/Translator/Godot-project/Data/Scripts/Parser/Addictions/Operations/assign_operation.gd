class_name AssignOperation extends Operation


func _init(init_position: Vector3i):
	position = init_position
	


func try_calculate(out_operands_stack: Array[Operand], out_parsing_result: ParsingResult) -> bool:
	if not check_input_operands(out_operands_stack, out_parsing_result):
		return false
	
	var value: Operand = out_operands_stack.pop_back()
	out_parsing_result.variables[out_operands_stack.pop_back().value] = value
	
	return true
