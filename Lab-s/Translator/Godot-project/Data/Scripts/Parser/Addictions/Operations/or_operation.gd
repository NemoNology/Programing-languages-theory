class_name OrOperation extends Operation


func _notification(what):
	if what == NOTIFICATION_POSTINITIALIZE:
		allowed_first_operand_types = [LexemeTypes.False, LexemeTypes.True]
		allowed_second_operand_types = allowed_first_operand_types

 
func try_calculate(out_operands_stack: Array[Operand], out_parsing_result: ParsingResult) -> bool:
	if not check_input_operands(out_operands_stack, out_parsing_result):
		return false
	
	var operand2: Operand = out_operands_stack.pop_back()
	var operand1: Operand = out_operands_stack.pop_back()
	var result_value: bool = operand1.value or operand2.value
	var result_type: String = LexemeTypes.False
	if result_value:
		result_type = LexemeTypes.True
	out_operands_stack.push_back(
		Operand.new(result_value, result_type, operand1.position)
	)
	
	return true
