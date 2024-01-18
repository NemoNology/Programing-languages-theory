class_name AssignOperator extends Operator


func try_calculate(out_operands_stack: Array[Operand], out_parsing_result: ParsingResult) -> bool:
	if not check_input_operands(out_operands_stack, out_parsing_result):
		return false

	var operand: Operand = out_operands_stack.pop_back()
	while operand.value in out_parsing_result.variables:
		operand = out_parsing_result.variables[operand.value]
	out_parsing_result.variables[out_operands_stack.pop_back().value] = operand

	return true
