extends TextEdit

class_name FlowchartBlockTextEdit

var _maxWidth: int
var _minWidth: int
var _minHeight: int
var _font: Font

func _init(
	placeHolderText: String = "Код сюда!",
	isEditable: bool = true,
	maxWidth: int = 350,
	minWidth: int = 60,
	minHeight: int = 30):
		_minWidth = minWidth
		_minHeight = minHeight
		_maxWidth = maxWidth
		custom_minimum_size = Vector2(_minWidth, _minHeight)
		scroll_fit_content_height = true
		placeholder_text = placeHolderText
		wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
		var emptyStyleBox: StyleBoxEmpty = StyleBoxEmpty.new()
		add_theme_stylebox_override("normal", emptyStyleBox)
		add_theme_stylebox_override("focus", emptyStyleBox)
		text_changed.connect(_on_text_changed)
		_font = get_theme_font("font")
		editable = isEditable
	
func _on_text_changed() -> void:
	var lineCount = get_line_count()
	# Change text edit width
	if lineCount > 0:
		# Finding the biggest line
		var maxLengthLineLength: int = len(get_line(0))
		var maxLengthLineIndex: int = 0
		for lineIndex in range(1, lineCount):
			var lineBufferLength = len(get_line(lineIndex))
			if maxLengthLineLength < lineBufferLength:
				maxLengthLineLength = lineBufferLength
				maxLengthLineIndex = lineIndex
		# Inc/Dec width by the biggest line
		var lineWidth = _font.get_string_size(get_line(maxLengthLineIndex)).x + 10
		if (get_line_wrap_count(maxLengthLineIndex) > 0):
			while (lineWidth > custom_minimum_size.x
			and custom_minimum_size.x < _maxWidth):
				custom_minimum_size.x += 1
		else:
			while (lineWidth < custom_minimum_size.x
			and custom_minimum_size.x > _minWidth):
				custom_minimum_size.x -= 1
