class_name WhileOperator extends Operator


func try_calculate(out_operands_stack: Array[Operand], out_parsing_result: ParsingResult) -> bool:
	if not check_input_operands(out_operands_stack, out_parsing_result):
		return false

	var operand: Operand = out_operands_stack.pop_back()

	return true
