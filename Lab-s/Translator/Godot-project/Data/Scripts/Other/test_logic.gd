extends Control

var output: ItemList
var input: TextEdit
var lexer = Lexer.new()

class Lexer:
	func _init():
		pass
		
	var word = ''
	var final_word
	var last_symbol
	var lexems = {
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
		
	func analyze(input, output):
		last_symbol = input[input.length()-1]
		if last_symbol != ' ':
			word += last_symbol
		else:
			final_word = word
			# final_word - конечное слово, проверяем чем оно является
			word = ''
			output.add_item(final_word + str(final_word.length()))
		
func _ready():
	output = get_node("MarginContainer/HBoxContainer/Output")
	input = get_node("MarginContainer/HBoxContainer/Input")

func _on_input_text_changed():
	lexer.analyze(input.text, output)
