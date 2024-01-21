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
		
	if parsing_result.errors.size() > 0:
		for er in parsing_result.errors:
			errors_variables_output.text += er.to_string() + "\n"
		return

	for variable in parsing_result.variables:
		errors_variables_output.text += "%s: %s\n" % [variable, parsing_result.variables[variable]]

	errors_variables_title.text = "Переменные:"
	errors_variables_output.text = "Переменных не объявлено..."

	var blocks_codes: Array[FLowchartBlockCode] = flowchart_editor.get_block_codes()
	
	# Getting array of lexemes
	var result_lexemes: Array[Lexeme]
	for block in blocks_codes:
		result_lexemes.append_array(Lexer.get_lexemes(block))
		code_output.text += block.to_string() + "\n"
		
	#var lexemes_test = Lexer.get_lexemes(code_output.text)
	Parser.parse(result_lexemes, parsing_result)
	Translator.translate(result_lexemes)
	
	for warning in parsing_result.warnings:
		warnings_output.text += warning.to_string() + "\n"

	if parsing_result.variables.size() > 0:
		errors_variables_output.text = ''
		for variable in parsing_result.variables:
			errors_variables_output.text += (
				"%s: %s\n" % [variable, parsing_result.variables[variable].value_type]
			)
