extends Control

var flowchart_editor: FlowchartEditor
var errors_output: TextEdit
var warnings_output: TextEdit
var code_output: TextEdit
var variables_output: TextEdit


func _ready():
	flowchart_editor = get_node("TabContainer/Редактор блок-схемы/FlowchartEditor")
	errors_output = get_node("TabContainer/Переводчик/VBox/HBox/Not code/Errors/Text")
	warnings_output = get_node("TabContainer/Переводчик/VBox/HBox/Not code/Warnings/Text")
	variables_output = get_node("TabContainer/Переводчик/VBox/HBox/Not code/Variables/Text")
	code_output = get_node("TabContainer/Переводчик/VBox/HBox/Code/Text")
	flowchart_editor.grab_focus()


func _on_translate_pressed():
	var parsing_result: ParsingResult = flowchart_editor.check_flowchart_blocks()
	errors_output.visible = true
	variables_output.visible = false
	errors_output.text = ""
	warnings_output.text = ""
	code_output.text = ""
	variables_output.text = ""
	if parsing_result.errors.size() > 0:
		for er in parsing_result.errors:
			errors_output.text += er.to_string() + "\n"
		return
		
	#var variables_table: Dictionary = Parser.parse_branch([])
	#for variable in variables_table:
		#variables_output.text += "%s: %s\n" % [variable, variables_table[variable]]
			
	errors_output.text = "Ошибок не найдено..."
	variables_output.visible = true
	errors_output.visible = false

	
	
	var blocks_codes: Array[FLowchartBlockCode] = flowchart_editor.get_block_codes()
	for block in blocks_codes:
		code_output.text += block.to_string() + "\n"
