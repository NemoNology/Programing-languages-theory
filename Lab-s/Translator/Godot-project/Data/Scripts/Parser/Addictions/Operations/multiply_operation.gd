class_name MultiplyOperation extends Operation


func _notification(what):
	if what == NOTIFICATION_POSTINITIALIZE:
		allowed_first_operand_types = [LexemeTypes.Num]
		allowed_second_operand_types = allowed_first_operand_types


func try_calculate(out_operands_stack: Array[Operand], out_parsing_result: ParsingResult) -> bool:
	if not check_input_operands(out_operands_stack, out_parsing_result):
		return false
	
	var operand2: Operand = out_operands_stack.pop_back()
	var operand1: Operand = out_operands_stack.pop_back()
	out_operands_stack.push_back(
		Operand.new(operand1.value * operand2.value, LexemeTypes.Num, operand1.position)
	)
	
	return true
