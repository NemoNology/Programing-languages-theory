class_name Translator

static var py_words = {
	LexemeTypes.Cout: "print",
	LexemeTypes.Cin: "input()",
	LexemeTypes.Assign: "=",
	LexemeTypes.Obr: "(",
	LexemeTypes.Cbr: ")",
	LexemeTypes.Separatop: "\n",
	LexemeTypes.If: "if",
	LexemeTypes.While: "while",
	LexemeTypes.Else: "else",
	LexemeTypes.End: "",
	LexemeTypes.Add: "+",
	LexemeTypes.Sub: "-",
	LexemeTypes.Mul: "*",
	LexemeTypes.Div: "\\",
	LexemeTypes.False: "false",
	LexemeTypes.True: "true",
	LexemeTypes.Not: "not",
	LexemeTypes.And: "and",
	LexemeTypes.Or: "or",
	LexemeTypes.More: ">",
	LexemeTypes.Less: "<",
	LexemeTypes.Equals: "==",
}

static var col_tab_word = [
	LexemeTypes.While,
	LexemeTypes.If,
	LexemeTypes.Else,
	]

static func translate(lexemes: Array[Lexeme]) -> Array:
	var code_line: Array = [] # One code line
	var code_lines: Array = [] # All code lines
	var str_code_lines: Array # All code lines in String
	
	# Analyze lexemes list
	for lex in lexemes:
		if lex.type != LexemeTypes.Separatop:
			# Is lexeme type exist in python words
			if py_words.has(lex.type):
				code_line.append(py_words[lex.type])
			else:
				code_line.append(lex.text)
		else:
			code_line.append(py_words[lex.type])
			code_lines.append(code_line)
			code_line = [] # Clear code line to make new
			
	# Work with code lines - tabs & colons
	var tab = false
	for line in code_lines:
		# Add tab if necessary
		if line.has(""):
			tab = false
		if tab == true:
			line.insert(0, "\t")
			
		# Add colon if necessary
		if line.has(py_words[LexemeTypes.While]) or line.has(
			py_words[LexemeTypes.If]) or line.has(py_words[LexemeTypes.Else]):
			line.insert(line.size()-1, ":")
			tab = true
			
		# Convert line from Array[String] to String
		var str_line = ''
		for i in range(line.size()-1):
			str_line += line[i] + ' '
		if str_line.length() > 1:
			str_code_lines.append(str_line)
			
	for l in str_code_lines:
		print(l)
	return str_code_lines
