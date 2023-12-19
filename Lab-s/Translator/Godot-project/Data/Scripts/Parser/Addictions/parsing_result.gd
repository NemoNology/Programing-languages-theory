class_name ParsingResult

var errors: Array[Error]
var warnings: Array[Error]
var variables: Dictionary


func _init(
	start_errors: Array[Error] = [],
	start_warnings: Array[Error] = [],
	start_variables: Dictionary = {}
):
	errors = start_errors
	warnings = start_warnings
	variables = start_variables
