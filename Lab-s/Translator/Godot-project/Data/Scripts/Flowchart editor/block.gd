extends PanelContainer
class_name Block

var _sprite: Sprite2D
var text: String
var _id: int
var _then: Block
var _else: Block

func _init(id: int, block_theme: Theme):
	theme = block_theme
	clip_contents = true
	var textEdit = TextEdit.new()
	# TODO: this...
	
