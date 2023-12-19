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
	var brackets_stack: Array[Lexeme] = []
	var operands: Array[Operand] = []
	var operators: Array[Operation] = []
	for l in branch:
		if l.type == LexemeTypes.If:
			out_then_else_stack.push_back(true)
		elif l.type == LexemeTypes.Else:
			if out_then_else_stack.size() < 1:
				out_parsing_result.errors.append(Error.new(Error.ExcessElseBlockError, l.position))
				# TODO: Maybe 'continue' instead of 'return false'?
				return false
			out_then_else_stack.pop_back()
		elif l.type == LexemeTypes.Obr:
			brackets_stack.push_back(l)
		elif l.type == LexemeTypes.Cbr:
			if brackets_stack.size() < 1:
				out_parsing_result.errors.append(Error.new(Error.ExcessBracketsClosingError, l.position))
				return false
			brackets_stack.pop_back()

		# if l.type != 

	if brackets_stack.size() > 0:
		for br: Lexeme in brackets_stack:
			out_parsing_result.errors.append(Error.new(Error.ExcessBracketsOpeningError, br.position))
		return false

	return true
