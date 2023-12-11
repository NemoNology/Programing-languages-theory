class_name FlowchartBlockTextEdit extends TextEdit

const DEFAULT_MIN_WIDTH = 80
const DEFAULT_MIN_HEIGHT = 27


func _init(
	is_flat: bool = false,
):
	if is_flat:
		custom_minimum_size = Vector2.ZERO
	else:
		custom_minimum_size = Vector2(DEFAULT_MIN_WIDTH, DEFAULT_MIN_HEIGHT)
		placeholder_text = "..."
		wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
		scroll_fit_content_height = true

	var style_box_empty: StyleBoxEmpty = StyleBoxEmpty.new()
	add_theme_stylebox_override("normal", style_box_empty)
	add_theme_stylebox_override("focus", style_box_empty)
	add_theme_stylebox_override("read_only", style_box_empty)

	add_theme_color_override("font_color", Color.BLACK)
	add_theme_color_override("font_placeholder_color", Color.DIM_GRAY)
	add_theme_color_override("selection_color", Color.LIGHT_GRAY)
	add_theme_color_override("caret_color", Color.BLACK)
	add_theme_color_override("current_line_color", Color(Color.BLACK, 0.5))
