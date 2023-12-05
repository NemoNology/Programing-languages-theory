extends TextEdit

class_name FlowchartBlockTextEdit

var _maxWidth: int
var _minWidth: int
var _minHeight: int
var _font: Font

func _init(
	startText: String = "",
	placeHolderText: String = "",
	isEditable: bool = true,
	maxWidth: int = 350,
	minWidth: int = 80,
	minHeight: int = 30
	):
	_minWidth = minWidth
	_minHeight = minHeight
	_maxWidth = maxWidth
	custom_minimum_size = Vector2(_minWidth, _minHeight)
	context_menu_enabled = false
	scroll_fit_content_height = true
	placeholder_text = placeHolderText
	wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
	var emptyStyleBox: StyleBoxEmpty = StyleBoxEmpty.new()
	add_theme_stylebox_override("normal", emptyStyleBox)
	add_theme_stylebox_override("focus", emptyStyleBox)
	add_theme_stylebox_override("read_only", emptyStyleBox)
	text_changed.connect(_on_text_changed)
	self_modulate = Color.BLACK
	add_theme_color_override("selection_color", Color.LIGHT_GRAY)
	_font = get_theme_font("font")
	editable = isEditable
	text = startText
	
func _ready():
	_on_text_changed()
	
func _on_text_changed() -> void:
	var lineCount = get_line_count()
	var sizeBefore = size
	# Change text edit width
	if lineCount > 0:
		# Finding the biggest line
		var maxLengthLineLength: float = 0
		var maxLengthLineIndex: int = 0
		for lineIndex in range(lineCount):
			var lineBufferLength = _font.get_string_size(get_line(lineIndex)).x
			if maxLengthLineLength < lineBufferLength:
				maxLengthLineLength = lineBufferLength
				maxLengthLineIndex = lineIndex
		# Inc/Dec width by the biggest line
		var lineWidth = maxLengthLineLength + 24
		if (get_line_wrap_count(maxLengthLineIndex) > 0):
			while (lineWidth > size.x
			and size.x < _maxWidth):
				size.x += 1
		else:
			while (lineWidth < size.x
			and size.x > _minWidth):
				size.x -= 1
		size.y = lineCount * get_line_height()
		if (sizeBefore != size):
			resized.emit()
