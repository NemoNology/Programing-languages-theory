extends Node
class_name CustomUIElementsTemplatesStack

func get_flowchart_block_textedit(placeholder_text: String) -> TextEdit:
	var custom_textedit = TextEdit.new()
	custom_textedit.custom_minimum_size = Vector2(200, 30)
	custom_textedit.scroll_fit_content_height = true
	custom_textedit.placeholder_text = placeholder_text
	custom_textedit.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
	var styleBoxEmpty = StyleBoxEmpty.new()
	custom_textedit.add_theme_stylebox_override("normal", styleBoxEmpty)
	custom_textedit.add_theme_stylebox_override("focus", styleBoxEmpty)
	return custom_textedit

