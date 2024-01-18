class_name Parser


static func parse(
	lexemes: Array[Lexeme], starting_parsing_result: ParsingResult = null
) -> ParsingResult:
	if starting_parsing_result == null:
		starting_parsing_result = ParsingResult.new()
	var res: ParsingResult = starting_parsing_result
	var then_else_stack: Array[bool] = []

	var branches: Array[Array] = split_to_branches(lexemes)
	for branch in branches:
		parse_branch(branch, res, then_else_stack)

	return res


static func split_to_branches(lexemes: Array[Lexeme]) -> Array[Array]:
	var branches: Array[Array] = []

	var branch_buffer: Array[Lexeme] = []
	for lexeme in lexemes:
		if lexeme.type == LexemeTypes.Separatop:
			branches.append(branch_buffer.duplicate())
			branch_buffer = []
		else:
			branch_buffer.append(lexeme)

	return branches


static func parse_branch(
	branch: Array[Lexeme], out_parsing_result: ParsingResult, out_then_else_stack: Array[bool]
) -> bool:
	var brackets_stack: Array[Vector3i] = []
	var operands: Array[Operand] = []
	var operators: Array[Operator] = []
	for l in branch:
		if l.type == LexemeTypes.If:
			out_then_else_stack.push_back(true)
		elif l.type == LexemeTypes.Else:
			if out_then_else_stack.size() < 1:
				out_parsing_result.errors.append(
					Error.new(Error.ExcessElseBlockErrorText, l.position)
				)
				return false
			out_then_else_stack.pop_back()
		elif l.type == LexemeTypes.Obr:
			brackets_stack.push_back(l.position)
		elif l.type == LexemeTypes.Cbr:
			if brackets_stack.size() < 1:
				out_parsing_result.errors.append(
					Error.new(Error.ExcessBracketsClosingErrorText, l.position)
				)
				return false
			brackets_stack.pop_back()

	if brackets_stack.size() > 0:
		for br_pos: Vector3i in brackets_stack:
			out_parsing_result.errors.append(
				Error.new(Error.ExcessBracketsOpeningErrorText, br_pos)
			)
		return false

	# Calculating
	for l in branch:
		if l.type in Operand.OperandsLexemeTypes:
			operands.push_back(Operand.init_from_lexeme(l))
		elif l.type in Operator.OperatorsLexemeTypes:
			var operator_buffer: Operator = Operator.init_by_lexeme(l, out_parsing_result)
			if (
				operators.size() < 1
				or operator_buffer is ObrOperator
				or operator_buffer.priority <= operators[-1].priority
			):
				operators.append(operator_buffer)
			elif operator_buffer is CbrOperator:
				while not (operator_buffer is ObrOperator):
					if operators.size() < 1:
						var pos: Vector3i = operator_buffer.position
						if operands.size() > 1:
							pos = operands[-1].position
						out_parsing_result.errors.append(Error.new(Error.NoOperatorsErrorText, pos))
						return false
					if not operators.pop_back().try_calculate(operands, out_parsing_result):
						return false
				# Removing found open bracket
				operators.pop_back()
			elif operator_buffer.priority > operators[-1].priority:
				if not operators.pop_back().try_calculate(operands, out_parsing_result):
					return false
				operators.push_back(operator_buffer)
		else:
			out_parsing_result.errors.append(Error.new(Error.UnknownLexemeErrorText, l.position))
			return false

	while operators.size() > 0:
		if not operators.pop_back().try_calculate(operands, out_parsing_result):
			return false

	if operands.size() > 0:
		for o: Operand in operands:
			out_parsing_result.errors.append(Error.new(Error.ExcessOperandsErrorText, o.position))
		return false

	return true
