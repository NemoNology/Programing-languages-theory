class_name ErrorsWarnings

var errors: PackedStringArray
var warnings: PackedStringArray


func _init(errors_array: PackedStringArray = [], warnings_array: PackedStringArray = []):
	errors = errors_array
	warnings = warnings_array
