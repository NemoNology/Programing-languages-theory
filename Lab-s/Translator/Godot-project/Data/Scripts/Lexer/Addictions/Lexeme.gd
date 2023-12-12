class_name Lexeme

var type: String
var text: String
var position: Vector3i


func _init(lexeme_type: String, lexeme_text: String, lexeme_position: Vector3i):
	type = lexeme_type
	text = lexeme_text
	position = lexeme_position
