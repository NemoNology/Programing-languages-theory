extends TextEdit

class_name FlowchartBlockTextEdit

const DEFAULT_MIN_WIDTH = 80
const DEFAULT_MIN_HEIGHT = 27


func _init(
	block_placeholder_text: String = "",
	is_flat: bool = false,
):
	context_menu_enabled = false
	var emptyStyleBox: StyleBoxEmpty = StyleBoxEmpty.new()
	add_theme_stylebox_override("normal", emptyStyleBox)
	add_theme_stylebox_override("focus", emptyStyleBox)
	add_theme_stylebox_override("read_only", emptyStyleBox)

	if is_flat:
		custom_minimum_size = Vector2.ZERO
	else:
		custom_minimum_size = Vector2(DEFAULT_MIN_WIDTH, DEFAULT_MIN_HEIGHT)
		placeholder_text = block_placeholder_text
		wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
		scroll_fit_content_height = true
		self_modulate = Color.WHITE
		add_theme_color_override("selection_color", Color.LIGHT_GRAY)
