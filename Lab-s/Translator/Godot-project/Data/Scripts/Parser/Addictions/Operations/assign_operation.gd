class_name AssignOperation extends Operation


func _notification(what):
	if what == NOTIFICATION_POSTINITIALIZE:
		allowed_first_operand_types = [LexemeTypes.Var]
		allowed_second_operand_types = Operand.ConstantOperandsLexemeTypes


func try_calculate(out_operands_stack: Array[Operand], out_parsing_result: ParsingResult) -> bool:
	if not check_input_operands(out_operands_stack, out_parsing_result):
		return false
	
	var operand: Operand = out_operands_stack.pop_back()
	out_parsing_result.variables[out_operands_stack.pop_back().value] = operand.value
	
	return true
