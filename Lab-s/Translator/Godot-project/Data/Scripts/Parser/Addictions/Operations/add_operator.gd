class_name AddOperator extends Operator


func try_calculate(out_operands_stack: Array[Operand], out_parsing_result: ParsingResult) -> bool:
	if not check_input_operands(out_operands_stack, out_parsing_result):
		return false

	var operand2: Operand = out_operands_stack.pop_back()
	var operand1: Operand = out_operands_stack.pop_back()
	out_operands_stack.push_back(
		Operand.new(
			operand1.get_value(out_parsing_result) + operand2.get_value(out_parsing_result),
			LexemeTypes.Num,
			operand1.position
		)
	)

	return true
