class_name Translator

static var python_templates = {
	LexemeTypes.Cout: "print",
	LexemeTypes.Cin: "input()",
	LexemeTypes.Assign: "=",
	LexemeTypes.Obr: "(",
	LexemeTypes.Cbr: ")",
	LexemeTypes.Separatop: "\n",
	LexemeTypes.If: "if",
	LexemeTypes.While: "while",
	LexemeTypes.Else: "else",
	LexemeTypes.End: "end",
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

static func translate(lexemes: Array[Lexeme]) -> String:
	var python_code = " "
	var colon_presence = false
	for lexeme in lexemes:
		if python_templates.has(lexeme.type):
			python_code += python_templates[lexeme.text]
		else:
			python_code += lexeme.text
		python_code += " "
	print(python_code)
	return 's'
