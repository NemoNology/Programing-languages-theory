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
var _then: FlowchartBlock
var _else: FlowchartBlock
const INPUT_MARGIN = 10

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
		add_child(FlowchartBlockShape.from(_type._shape))
		add_child(idLabel)
		add_child(_input)
		set_anchors_preset(PRESET_CENTER)

func get_code() -> String:
	return _type._bonusCode[0] + get_child(1).get_child(0).text + _type._bonusCode[1]

func _on_resized():
	custom_minimum_size = Vector2(
		_input.size.x + INPUT_MARGIN * 2,
		_input.size.y + INPUT_MARGIN * 2
	)
	_input.position = Vector2(
		INPUT_MARGIN,
		INPUT_MARGIN)

func _draw():
	_type._shape.draw.emit()

func _ready():
	_on_resized()
