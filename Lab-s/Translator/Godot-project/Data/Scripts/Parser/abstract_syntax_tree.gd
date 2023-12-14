class_name AbstractSyntaxTree

var errors_warnings: ErrorsWarnings = ErrorsWarnings.new()

func split_to_branches(all_lexemes: Array[Lexeme]) -> Array[Array]:
	var branches: Array[Array] = []

	var branch_buffer: Array[Lexeme] = []
	for lexeme in all_lexemes:
		if lexeme.type == LexemeTypes.Separatop:
			branches.append(branch_buffer.duplicate())
			branch_buffer = []
		else:
			branch_buffer.append(lexeme)

	return branches


func parse_branch(branch: Array[Lexeme], out_errors_warnings: ErrorsWarnings, out_then_else_stack: Array) -> Array:
	# var statement_lexeme: Sta
	return branch
