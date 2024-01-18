class_name OrOperator extends Operator


func try_calculate(out_operands_stack: Array[Operand], out_parsing_result: ParsingResult) -> bool:
	if not check_input_operands(out_operands_stack, out_parsing_result):
		return false

	var operand2: Operand = out_operands_stack.pop_back()
	var operand1: Operand = out_operands_stack.pop_back()
	var result_value: bool = (
		operand1.get_value(out_parsing_result) or operand2.get_value(out_parsing_result)
	)
	out_operands_stack.push_back(Operand.new(result_value, LexemeTypes.Bool, operand1.position))

	return true
