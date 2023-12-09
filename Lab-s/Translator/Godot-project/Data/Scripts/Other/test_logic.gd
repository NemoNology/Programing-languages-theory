extends Control

var output: ItemList
var input: TextEdit
var lexer = Lexer.new()

class Lexer:
	func _init():
		pass
		
	var word = ""
	var lexemes = {
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
		
	func analyze(input: String, output: ItemList):
		if not input.is_empty() and input[-1] == " ":
			# Checking for presence in the list of lexemes
			if word in lexemes:
				output.add_item(word + ' ' + lexemes[word])
			# Checking for a string
			elif word[0] == '\"' and word[-1] == '\"':
				output.add_item(word + ' ' + 'string')
			# Checking for a num
			elif word.is_valid_float() == true:
				output.add_item(word + ' ' + 'num')
			# Checking for a variable
			else:
				output.add_item(word + ' ' + 'var')
			word = ""
		else:
			word += input[-1]
			
func _ready():
	output = get_node("MarginContainer/HBoxContainer/Output")
	input = get_node("MarginContainer/HBoxContainer/Input")

func _on_input_text_changed():
	lexer.analyze(input.text, output)
