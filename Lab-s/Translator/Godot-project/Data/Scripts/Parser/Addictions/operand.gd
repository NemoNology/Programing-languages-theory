class_name Operand

static var OperandsLexemeTypes: PackedStringArray = [
	LexemeTypes.Var,
	LexemeTypes.Num,
	LexemeTypes.Str,
	LexemeTypes.True,
	LexemeTypes.False,
	LexemeTypes.Cin,
]

var value
## Use consts from OperandTypes
var value_type: String
var position: Vector3i


func _init(init_value, init_value_type: String, init_position: Vector3i):
	value = init_value
	value_type = init_value_type
	position = init_position


static func init_from_lexeme(lexeme: Lexeme, out_parsing_result: ParsingResult) -> Operand:
	match lexeme.type:
		LexemeTypes.Num:
			return Operand.new(float(lexeme.text), OperandTypes.NumberType, lexeme.position)
		LexemeTypes.Str:
			return Operand.new(lexeme.text, OperandTypes.StringType, lexeme.position)
		LexemeTypes.Cin:
			return Operand.new("'%s'" % lexeme.text, OperandTypes.StringType, lexeme.position)
		LexemeTypes.False:
			return Operand.new(false, OperandTypes.BoolType, lexeme.position)
		LexemeTypes.True:
			return Operand.new(true, OperandTypes.BoolType, lexeme.position)
		LexemeTypes.Var:
			if not lexeme.text in out_parsing_result.variables.keys():
				out_parsing_result.errors.append(Error.new(Error.UnknownVariableError, lexeme.position))

	return null
