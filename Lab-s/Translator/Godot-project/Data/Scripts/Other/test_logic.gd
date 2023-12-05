extends Control

var output: ItemList
var input: TextEdit
var lexer = Lexer.new()

class Lexer:
	func _init():
		pass
		
	var word = ""
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
		
	func analyze(input, output: ItemList):
		if input[-1] == " ":
			# Проверка на вхождение лексемы в список лексем
			if word in lexems:
				output.add_item(word + ' ' + lexems[word])
			# Проверка лексемы на строку
			elif word[0] == '\"' and word[-1] == '\"':
				output.add_item(word + ' ' + 'string')
			# Проверка лексемы на число
			elif word.is_valid_float() == true:
				output.add_item(word + ' ' + 'num')
			# Проверка лексемы на переменную
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
