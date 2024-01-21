class_name Lexer

static func remove_identifier(line: String) -> String:
	var colon = line.find(":")
	return line.substr(colon + 1).strip_edges()


static func split_line(line: String) -> Array:
	var regex = RegEx.new()
	regex.compile("(\\p{Cyrillic}+|\"[^\"]*\"|\\b[а-яА-Я\\w]+\\b|\\.|\\(|\\))")
	var res = []
	var search_res = regex.search_all(line)
	for rmatch in search_res:
		res.append(rmatch.get_string())
	return res
	
	
static func match_lexeme(item: String, block: int, line: int, pos: int) -> Lexeme:
	match item:
		"вывод":
			return(Lexeme.new(LexemeTypes.Cout, item, Vector3i(block, line, pos)))
		"ввод":
			return(Lexeme.new(LexemeTypes.Cin, item, Vector3i(block, line, pos)))
		"будет":
			return(Lexeme.new(LexemeTypes.Assign, item, Vector3i(block, line, pos)))
		"(":
			return(Lexeme.new(LexemeTypes.Obr, item, Vector3i(block, line, pos)))
		")":
			return(Lexeme.new(LexemeTypes.Cbr, item, Vector3i(block, line, pos)))
		".":
			return(Lexeme.new(LexemeTypes.Separatop, item, Vector3i(block, line, pos)))
		"если":
			return(Lexeme.new(LexemeTypes.If, item, Vector3i(block, line, pos)))
		"пока":
			return(Lexeme.new(LexemeTypes.While, item, Vector3i(block, line, pos)))
		"иначе":
			return(Lexeme.new(LexemeTypes.Else, item, Vector3i(block, line, pos)))
		"конец":
			return(Lexeme.new(LexemeTypes.End, item, Vector3i(block, line, pos)))
		"плюс":
			return(Lexeme.new(LexemeTypes.Add, item, Vector3i(block, line, pos)))
		"минус":
			return(Lexeme.new(LexemeTypes.Sub, item, Vector3i(block, line, pos)))
		"умножить":
			return(Lexeme.new(LexemeTypes.Mul, item, Vector3i(block, line, pos)))
		"разделить":
			return(Lexeme.new(LexemeTypes.Div, item, Vector3i(block, line, pos)))
		"ложь":
			return(Lexeme.new(LexemeTypes.False, item, Vector3i(block, line, pos)))
		"правда":
			return(Lexeme.new(LexemeTypes.True, item, Vector3i(block, line, pos)))
		"не":
			return(Lexeme.new(LexemeTypes.Not, item, Vector3i(block, line, pos)))
		"и":
			return(Lexeme.new(LexemeTypes.And, item, Vector3i(block, line, pos)))
		"или":
			return(Lexeme.new(LexemeTypes.Or, item, Vector3i(block, line, pos)))
		"больше":
			return(Lexeme.new(LexemeTypes.More, item, Vector3i(block, line, pos)))
		"меньше":
			return(Lexeme.new(LexemeTypes.Less, item, Vector3i(block, line, pos)))
		"равно":
			return(Lexeme.new(LexemeTypes.Equals, item, Vector3i(block, line, pos)))
		_:
			if(item.to_int() != 0):
				return(Lexeme.new(LexemeTypes.Num, item, Vector3i(block, line, pos)))
			elif(item.begins_with("\"") and item.ends_with("\"")):
				return(Lexeme.new(LexemeTypes.Str, item, Vector3i(block, line, pos)))
			else:
				return Lexeme.new(LexemeTypes.Var, item, Vector3i(block, line, pos))
	
static func get_lexemes(code: String) -> Array[Lexeme]:
	var code_lines = code.split('\n')
	var code_lexemes: Array[Lexeme] = []
	code_lines.resize(code_lines.size()-1)
	
	for i in range(code_lines.size()):
		var block = code_lines[i].split(':')[0]
		var line = i
		var pos
		
		var clean_line = remove_identifier(code_lines[i])
		var clean_line_split = split_line(clean_line)
		for j in range(clean_line_split.size()):
			pos = j
			var lex = match_lexeme(clean_line_split[j], int(block), int(line), int(pos))
			code_lexemes.append(match_lexeme(clean_line_split[j], int(block), int(line), int(pos)))
	return code_lexemes
