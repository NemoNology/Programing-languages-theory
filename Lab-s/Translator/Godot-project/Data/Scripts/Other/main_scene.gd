extends Control

var editor: FlowchartEditor
var errors_output: TextEdit
var code_output: TextEdit
var ast_output: TextEdit


func _ready():
	editor = get_node("TabContainer/Редактор блок-схемы/FlowchartEditor")
	errors_output = get_node("TabContainer/Переводчик/VBox/HBox/Not code/Errors/Text")
	ast_output = get_node("TabContainer/Переводчик/VBox/HBox/Not code/AST/Text")
	code_output = get_node("TabContainer/Переводчик/VBox/HBox/Code/Text")


func _on_translate_pressed():
	var errors: PackedStringArray = editor.check_flowchart_blocks()
	errors_output.text = ""
	code_output.text = ""
	if errors.size() > 0:
		for er in errors:
			errors_output.text += er + "\n"
		return
	errors_output.text = "Ошибок не найдено..."
	var code: Dictionary = editor.get_code()
	for block_id in code:
		if not code[block_id].match("^\\s*$"):
			code_output.text += code[block_id] + "\n"
