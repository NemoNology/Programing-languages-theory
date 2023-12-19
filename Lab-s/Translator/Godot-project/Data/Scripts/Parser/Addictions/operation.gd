class_name Operation

var priority: int
var allowed_first_operand_types: PackedStringArray
var allowed_second_operand_types: PackedStringArray
var position: Vector3i


func _init(init_priority: int, init_allowed_first_operand_types: PackedStringArray, init_allowed_second_operand_types: PackedStringArray, init_position: Vector3i):
	priority = init_priority
	allowed_first_operand_types = init_allowed_first_operand_types
	allowed_second_operand_types = init_allowed_second_operand_types
	position = init_position


func check_input_operands(
	out_operands_stack: Array[Operand], 
	out_parsing_result: ParsingResult
	) -> bool:
	if allowed_second_operand_types == null:
		if not (out_operands_stack[-1].type in allowed_first_operand_types):
			out_parsing_result.errors.append(
				Error.get_wrong_operand_type_error(
					allowed_first_operand_types,
					out_operands_stack[-1].type,
					position
				)
			)
			return false
	else:
		var result: bool = true
		if not (out_operands_stack[-1].type in allowed_second_operand_types):
			out_parsing_result.errors.append(
				Error.get_wrong_operand_type_error(
					allowed_second_operand_types,
					out_operands_stack[-1].type,
					position
				)	
			)
			result = false
		if not (out_operands_stack[-2].type in allowed_first_operand_types):
			out_parsing_result.errors.append(
				Error.get_wrong_operand_type_error(
					allowed_first_operand_types,
					out_operands_stack[-2].type,
					position
				)
			)
			result = false
		if out_operands_stack[-1].type != out_operands_stack[-2].type:
			out_parsing_result.errors.append(
				Error.get_wrong_operand_type_error(
					[out_operands_stack[-2].type],
					out_operands_stack[-1].type,
					position
				)
			)
			result = false
		return result
	return true


static var UnaryOperationsLexemeTypes: PackedStringArray = [
	LexemeTypes.Not,
	LexemeTypes.If,
	LexemeTypes.While,
	LexemeTypes.Cout,
]

static var BinaryOperationsLexemeTypes: PackedStringArray = [
	LexemeTypes.Assign,
	LexemeTypes.Add,
	LexemeTypes.Sub,
	LexemeTypes.Mul,
	LexemeTypes.Div,
	LexemeTypes.And,
	LexemeTypes.Or,
	LexemeTypes.More,
	LexemeTypes.Less,
	LexemeTypes.Equals,
]

static var ExpressionOperatiosLexemeTypes: PackedStringArray = (
	UnaryOperationsLexemeTypes + BinaryOperationsLexemeTypes
)


static func get_priority_by_lexeme_type(lexeme_type: String) -> int:
	if lexeme_type in [LexemeTypes.Obr, LexemeTypes.Cbr]:
		return 1
	elif lexeme_type in [LexemeTypes.Not]:
		return 2
	elif lexeme_type in [LexemeTypes.Mul, LexemeTypes.Div, LexemeTypes.And, LexemeTypes.Or]:
		return 3
	elif (
		lexeme_type
		in [
			LexemeTypes.Add, LexemeTypes.Sub, LexemeTypes.More, LexemeTypes.Less, LexemeTypes.Equals
		]
	):
		return 4

	return -1


static func init_by_lexeme(lexeme: Lexeme, out_parsing_result) -> Operation:
	if lexeme.type not in ExpressionOperatiosLexemeTypes:
		out_parsing_result.errors.append(Error.new(Error.UnknownOperationErrorText, lexeme.position))
		return null
	
	# match lexeme.type:
	return null
