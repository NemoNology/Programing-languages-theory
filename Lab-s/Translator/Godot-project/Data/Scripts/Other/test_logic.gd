extends Control

var output: ItemList
var input: TextEdit
var lexer = Lexer.new()


class Lexer_test:
	static var word = ""
	static var lexemes = {
		"вывод": "cout",
		"ввод": "cin",
		"будет": "assign",
		"(": "obr",
		")": "cbr",
		"tab": "tab",
		":": "colon",
		".": "sep",
		"если": "if",
		"пока": "while",
		"тогда": "then",
		"иначе": "else",
		"плюс": "add",
		"минус": "sub",
		"умножить": "mul",
		"разделить": "div",
		"ложь": "false",
		"истина": "true",
		"не": "not",
		"и": "and",
		"или": "or",
		"больше": "more",
		"меньше": "less",
		"равно": "equals",
	}

# lexemes.append(Lexeme.new(...))

	static func analyze(input: String, output: ItemList):
		if input.is_empty():
			return
		elif input[-1] == " ":
			# Checking for presence in the list of lexemes
			if word in lexemes:
				output.add_item(word + " " + lexemes[word])
			# Checking for a string
			elif word[0] == '\"' and word[-1] == '\"':
				output.add_item(word + " " + "string")
			# Checking for a num
			elif word.is_valid_float() == true:
				output.add_item(word + " " + "num")
			# Checking for a variable
			else:
				output.add_item(word + " " + "var")
			word = ""
		else:
			word += input[-1]


func _ready():
	output = get_node("MarginContainer/HBoxContainer/Output")
	input = get_node("MarginContainer/HBoxContainer/Input")


func _on_input_text_changed():
	Lexer_test.analyze(input.text, output)
