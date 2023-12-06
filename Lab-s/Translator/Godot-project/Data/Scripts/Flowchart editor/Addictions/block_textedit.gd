extends TextEdit

class_name FlowchartBlockTextEdit

const DEFAULT_MIN_WIDTH = 80
const DEFAULT_MIN_HEIGHT = 27

var _font: Font

func _init(
	startText: String = "",
	placeHolderText: String = "",
	isEditable: bool = true,
	):
	custom_minimum_size = Vector2(DEFAULT_MIN_WIDTH, DEFAULT_MIN_HEIGHT)
	context_menu_enabled = false
	scroll_fit_content_height = true
	placeholder_text = placeHolderText
	wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
	var emptyStyleBox: StyleBoxEmpty = StyleBoxEmpty.new()
	add_theme_stylebox_override("normal", emptyStyleBox)
	add_theme_stylebox_override("focus", emptyStyleBox)
	add_theme_stylebox_override("read_only", emptyStyleBox)
	self_modulate = Color.WHITE
	add_theme_color_override("selection_color", Color.LIGHT_GRAY)
	_font = get_theme_font("font")
	editable = isEditable
	text = startText