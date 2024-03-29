class_name Operand

static var ConstantOperandsLexemeTypes: PackedStringArray = [
	LexemeTypes.Num,
	LexemeTypes.Str,
	LexemeTypes.Bool,
	LexemeTypes.False,
	LexemeTypes.True,
	LexemeTypes.Cin,
]

static var OperandsLexemeTypes: PackedStringArray = ConstantOperandsLexemeTypes.duplicate()

var value
## Use var-s from LexemeTypes
var value_type: String
var position: Vector3i


static func _static_init():
	OperandsLexemeTypes.append(LexemeTypes.Var)


func _init(init_value, init_value_type: String, init_position: Vector3i):
	value = init_value
	value_type = init_value_type
	position = init_position


func get_value(parsing_result: ParsingResult):
	if value_type == LexemeTypes.Var:
		return parsing_result.variables[value].value
	else:
		return value


static func init_from_lexeme(lexeme: Lexeme) -> Operand:
	match lexeme.type:
		LexemeTypes.Num:
			return Operand.new(float(lexeme.text), LexemeTypes.Num, lexeme.position)
		LexemeTypes.Str:
			return Operand.new(lexeme.text, LexemeTypes.Str, lexeme.position)
		LexemeTypes.Cin:
			return Operand.new("'%s'" % lexeme.text, LexemeTypes.Str, lexeme.position)
		LexemeTypes.Bool:
			return Operand.new(false, LexemeTypes.Bool, lexeme.position)
		LexemeTypes.False:
			return Operand.new(false, LexemeTypes.Bool, lexeme.position)
		LexemeTypes.True:
			return Operand.new(true, LexemeTypes.Bool, lexeme.position)
		LexemeTypes.Var:
			return Operand.new(lexeme.text, LexemeTypes.Var, lexeme.position)
	return null
