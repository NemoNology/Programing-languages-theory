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
	# var item_index = LexemeTypes.AllLexemes.index_of();
	# if item_index >= 0:
	if item in LexemeTypes.lexeme_types_as_dictionary:
		return Lexeme.new(item, item, Vector3i(block, line, pos))
	else:
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
