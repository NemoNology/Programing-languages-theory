class_name CbrOperator extends Operator


func try_calculate(out_operands_stack: Array[Operand], out_parsing_result: ParsingResult) -> bool:
	if check_input_operands(out_operands_stack, out_parsing_result):
		return false

	return true
