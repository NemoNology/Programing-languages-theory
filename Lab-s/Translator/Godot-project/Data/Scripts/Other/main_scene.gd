extends Control

var flowchart_editor: FlowchartEditor
var errors_variables_output: TextEdit
var warnings_output: TextEdit
var code_output: TextEdit
var errors_variables_title: Label


func _ready():
	flowchart_editor = get_node("TabContainer/Редактор блок-схемы/FlowchartEditor")
	errors_variables_output = get_node(
		"TabContainer/Переводчик/VBox/HBox/Not code/Errors_Variables/Text"
	)
	warnings_output = get_node("TabContainer/Переводчик/VBox/HBox/Not code/Warnings/Text")
	code_output = get_node("TabContainer/Переводчик/VBox/HBox/Code/Text")
	errors_variables_title = get_node(
		"TabContainer/Переводчик/VBox/HBox/Not code/Errors_Variables/Title"
	)
	flowchart_editor.grab_focus()


func _on_translate_pressed():
	var parsing_result: ParsingResult = flowchart_editor.check_flowchart_blocks()
	errors_variables_output.text = ""
	warnings_output.text = ""
	code_output.text = ""
	errors_variables_title.text = "Ошибки:"
	if parsing_result.errors.size() > 0:
		for er in parsing_result.errors:
			errors_variables_output.text += er.to_string() + "\n"
		return

	var test_cutie: Array[Lexeme] = [
		Lexeme.new(LexemeTypes.Var, "a", Vector3i(0, 0, 1)),
		Lexeme.new(LexemeTypes.Assign, "будет", Vector3i(0, 0, 2)),
		Lexeme.new(LexemeTypes.Str, "", Vector3i(0, 0, 3)),
		Lexeme.new(LexemeTypes.Separatop, ".", Vector3i(0, 0, 4)),
		Lexeme.new(LexemeTypes.While, "пока", Vector3i(1, 0, 1)),
		Lexeme.new(LexemeTypes.Not, "ne", Vector3i(1, 0, 2)),
		Lexeme.new(LexemeTypes.Var, "a", Vector3i(1, 0, 3)),
		Lexeme.new(LexemeTypes.Equals, "ravno", Vector3i(1, 0, 4)),
		Lexeme.new(LexemeTypes.Str, "me", Vector3i(1, 0, 5)),
		Lexeme.new(LexemeTypes.Separatop, ".", Vector3i(1, 0, 6)),
		Lexeme.new(LexemeTypes.Cout, "vivod", Vector3i(2, 0, 1)),
		Lexeme.new(LexemeTypes.Str, "Egaday who cutie", Vector3i(2, 0, 2)),
		Lexeme.new(LexemeTypes.Separatop, ".", Vector3i(2, 0, 3)),
		Lexeme.new(LexemeTypes.Var, "a", Vector3i(3, 0, 1)),
		Lexeme.new(LexemeTypes.Assign, "budet", Vector3i(3, 0, 2)),
		Lexeme.new(LexemeTypes.Cin, "vvod", Vector3i(3, 0, 3)),
		Lexeme.new(LexemeTypes.Separatop, ".", Vector3i(3, 0, 4)),
		Lexeme.new(LexemeTypes.End, "konec", Vector3i(4, 0, 1)),
		Lexeme.new(LexemeTypes.Separatop, ".", Vector3i(4, 0, 2)),
		Lexeme.new(LexemeTypes.Cout, "vivod", Vector3i(5, 0, 3)),
		Lexeme.new(LexemeTypes.Str, "Great!", Vector3i(5, 0, 4)),
		Lexeme.new(LexemeTypes.Separatop, ".", Vector3i(5, 0, 5)),
	]

	var test_devide_by_zero: Array[Lexeme] = [
		Lexeme.new(LexemeTypes.Var, "a", Vector3i(0, 0, 1)),
		Lexeme.new(LexemeTypes.Assign, "будет", Vector3i(0, 0, 2)),
		Lexeme.new(LexemeTypes.Num, "1", Vector3i(0, 0, 3)),
		Lexeme.new(LexemeTypes.Div, "/", Vector3i(0, 0, 4)),
		Lexeme.new(LexemeTypes.Num, "0", Vector3i(0, 0, 5)),
		Lexeme.new(LexemeTypes.Separatop, ".", Vector3i(0, 0, 6)),
	]

	var test_school_math: Array[Lexeme] = [
		Lexeme.new(LexemeTypes.Var, "a", Vector3i(0, 0, 1)),
		Lexeme.new(LexemeTypes.Assign, "будет", Vector3i(0, 0, 2)),
		Lexeme.new(LexemeTypes.Num, "2", Vector3i(0, 0, 3)),
		Lexeme.new(LexemeTypes.Add, "+", Vector3i(0, 0, 4)),
		Lexeme.new(LexemeTypes.Num, "2", Vector3i(0, 0, 3)),
		Lexeme.new(LexemeTypes.Mul, "*", Vector3i(0, 0, 4)),
		Lexeme.new(LexemeTypes.Num, "2", Vector3i(0, 0, 3)),
		Lexeme.new(LexemeTypes.Separatop, ".", Vector3i(0, 0, 6)),
	]

	var test_if: Array[Lexeme] = [
		Lexeme.new(LexemeTypes.Var, "а", Vector3i(0, 0, 1)),
		Lexeme.new(LexemeTypes.Assign, "будет", Vector3i(0, 0, 2)),
		Lexeme.new(LexemeTypes.Str, "123", Vector3i(0, 0, 3)),
		Lexeme.new(LexemeTypes.Separatop, ".", Vector3i(0, 0, 4)),
		Lexeme.new(LexemeTypes.If, "если", Vector3i(1, 0, 1)),
		Lexeme.new(LexemeTypes.Var, "а", Vector3i(1, 0, 2)),
		Lexeme.new(LexemeTypes.Equals, "равно", Vector3i(1, 0, 3)),
		Lexeme.new(LexemeTypes.Str, "123", Vector3i(1, 0, 4)),
		Lexeme.new(LexemeTypes.Separatop, ".", Vector3i(1, 0, 5)),
		Lexeme.new(LexemeTypes.Var, "ф", Vector3i(2, 0, 1)),
		Lexeme.new(LexemeTypes.Assign, "будет", Vector3i(2, 0, 2)),
		Lexeme.new(LexemeTypes.True, "истина", Vector3i(2, 0, 3)),
		Lexeme.new(LexemeTypes.Separatop, ".", Vector3i(2, 0, 4)),
		Lexeme.new(LexemeTypes.Else, "иначе", Vector3i(3, 0, 1)),
		Lexeme.new(LexemeTypes.Separatop, ".", Vector3i(3, 0, 2)),
		Lexeme.new(LexemeTypes.Var, "ф", Vector3i(4, 0, 1)),
		Lexeme.new(LexemeTypes.Assign, "будет", Vector3i(4, 0, 2)),
		Lexeme.new(LexemeTypes.False, "ложь", Vector3i(4, 0, 3)),
		Lexeme.new(LexemeTypes.Separatop, ".", Vector3i(4, 0, 4)),
	]


	var lexemes: Array[Lexeme] = test_if

	parsing_result.clear(false)

	Parser.parse(lexemes, parsing_result)
	for l in lexemes:
		code_output.text += l.text + "\n"

	if parsing_result.errors.size() > 0:
		for er in parsing_result.errors:
			errors_variables_output.text += er.to_string() + "\n"
		return

	for variable in parsing_result.variables:
		errors_variables_output.text += "%s: %s\n" % [variable, parsing_result.variables[variable]]

	errors_variables_title.text = "Переменные:"
	errors_variables_output.text = "Переменных не объявлено..."

	var blocks_codes: Array[FLowchartBlockCode] = flowchart_editor.get_block_codes()
	for block in blocks_codes:
		code_output.text += block.to_string() + "\n"

	for warning in parsing_result.warnings:
		warnings_output.text += warning.to_string() + "\n"

	if parsing_result.variables.size() > 0:
		errors_variables_output.text = ''
		for variable in parsing_result.variables:
			errors_variables_output.text += (
				"%s: %s\n" % [variable, parsing_result.variables[variable].value_type]
			)
