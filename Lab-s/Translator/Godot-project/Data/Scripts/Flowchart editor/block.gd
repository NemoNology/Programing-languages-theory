extends Container
# Flowchart block is:
# Block ID: int;
# Block type: FlowchartBlockType;
# Next block - then: FlowchartBlock;
# Next block - else: FlowchartBlock;
class_name FlowchartBlock

var _id: int
var _type: FlowchartBlockType
var _input: FlowchartBlockTextEdit
var _shape: FlowchartBlockShape
var _then: FlowchartBlock
var _else: FlowchartBlock
var _is_dragging: bool
const INPUT_MARGIN = 15

func _init(
	id: int,
	type: FlowchartBlockType,
	thenBlock: FlowchartBlock,
	elseBlock: FlowchartBlock = null,
	isEditable: bool = true
	):
	_id = id
	_type = type
	_then = thenBlock
	_else = elseBlock
	_input = FlowchartBlockTextEdit.new(_type._startText, _type._placeholderText, isEditable)
	_input.resized.connect(_on_resized)
	var idLabel = Label.new()
	idLabel.self_modulate = Color.BLACK
	idLabel.text = str(_id)
	_shape = FlowchartBlockShape.from(_type._shape)
	add_child(_shape)
	add_child(idLabel)
	add_child(_input)
	set_anchors_preset(PRESET_CENTER)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	focus_mode = Control.FOCUS_CLICK

func _on_resized():
	custom_minimum_size = Vector2(
		_input.size.x + INPUT_MARGIN * 2,
		_input.size.y + INPUT_MARGIN * 2
	)

func _draw():
	_type._shape.draw.emit()

func _ready():
	_input.position = Vector2(
		INPUT_MARGIN,
		INPUT_MARGIN)
	_on_resized()


func _gui_input(event):
	if (event is InputEventMouseButton):
		_on_mouse_button(event)
	elif (event is InputEventMouseMotion):
		if (_is_dragging):
			global_position = event.global_position

func _on_mouse_button(event: InputEventMouseButton):
	if (event.button_index == MOUSE_BUTTON_LEFT):
		if (event.pressed):
			_is_dragging = true
		else:
			_is_dragging = false
	elif (event.button_index == MOUSE_BUTTON_RIGHT):
		pass

func _on_mouse_entered():
	modulate = Color.LIGHT_GRAY

func _on_mouse_exited():
	modulate = Color.WHITE
