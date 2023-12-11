class_name FLowchartBlockCode

var id: int
var code: String


func _init(block_id: int, block_code: String):
	id = block_id
	code = block_code


func _to_string():
	return "%s: %s" % [id, code]
