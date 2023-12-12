class_name AbstractSyntaxTree


static func split_to_branches(all_lexemes: Array[Lexeme]) -> Array[Array]:
	var branches: Array[Array] = []

	var branch_buffer: Array[Lexeme] = []
	for lexeme in all_lexemes:
		if lexeme.type == LexemeTypes.Separatop and branch_buffer.size() > 0:
			branches.append(branch_buffer)
			branch_buffer = []
		else:
			branch_buffer.append(lexeme)

	return branches
