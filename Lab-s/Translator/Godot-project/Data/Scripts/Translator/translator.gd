class_name Translator

static var python_templates = {
	LexemeTypes.Cout: "print",
	# TODO: Not using magic constants
	"ввод": "input()",
	"будет": "=",
	"(": "(",
	")": ")",
	".": "\n",
	"если": "if",
	"пока": "while",
	"иначе": "else",
	"конец": "",
	"плюс": "+",
	"минус": "-",
	"умножить": "*",
	"разделить": "\\",
	"ложь": "false",
	"правда": "true",
	"не": "not",
	"и": "and",
	"или": "or",
	"больше": ">",
	"меньше": "<",
	"равно": "==",
}

static func translate(lexemes: Array[Lexeme]) -> String:
	var python_code = ""
	var colon_presence = false
	for lexeme in lexemes:
		if python_templates.has(lexeme.type):
			python_code += python_templates[lexeme.text]
		else:
			python_code += lexeme.text
		python_code += " "
	print(python_code)
	return 's'
