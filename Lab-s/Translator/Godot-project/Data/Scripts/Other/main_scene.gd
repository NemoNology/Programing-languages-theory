extends Control

var flowchart_editor: FlowchartEditor
var errors_output: TextEdit
var code_output: TextEdit
var variables_output: TextEdit


func _ready():
	flowchart_editor = get_node("TabContainer/Редактор блок-схемы/FlowchartEditor")
	errors_output = get_node("TabContainer/Переводчик/VBox/HBox/Not code/Errors/Text")
	variables_output = get_node("TabContainer/Переводчик/VBox/HBox/Not code/Variables/Text")
	code_output = get_node("TabContainer/Переводчик/VBox/HBox/Code/Text")


func _on_translate_pressed():
	var errors: PackedStringArray = flowchart_editor.check_flowchart_blocks()
	errors_output.text = ""
	code_output.text = ""
	variables_output.text = ""
	if errors.size() > 0:
		for er in errors:
			errors_output.text += er + "\n"
		return
	errors_output.text = "Ошибок не найдено..."
	
	var variables_table: Dictionary = Parser.parse([]) 
	for variable in variables_table:
		variables_output.text += "%s: %s\n" % [variable, variables_table[variable]]

	var blocks_codes: Array[FLowchartBlockCode] = flowchart_editor.get_block_codes()
	for block in blocks_codes:
		code_output.text += block.to_string() + "\n"
