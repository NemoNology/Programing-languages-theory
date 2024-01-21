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
	var in_all_lexemes = LexemeTypes.AllLexemes.has(item);
	if in_all_lexemes == true:
		return Lexeme.new(item, item, Vector3i(block, line, pos))
	else:
		if(item.to_int() != 0):
			return(Lexeme.new(LexemeTypes.Num, item, Vector3i(block, line, pos)))
		elif(item.begins_with("\"") and item.ends_with("\"")):
			return(Lexeme.new(LexemeTypes.Str, item, Vector3i(block, line, pos)))
		else:
			return Lexeme.new(LexemeTypes.Var, item, Vector3i(block, line, pos))
	
static func get_lexemes(block: FLowchartBlockCode):
	var code_lexemes: Array[Lexeme] = []
	var clean_line = split_line(block.code)
	for j in range(clean_line.size()):
		code_lexemes.append(match_lexeme(clean_line[j], block.id, 1, j))
	return code_lexemes
