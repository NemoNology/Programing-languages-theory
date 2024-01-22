class_name Operator

var priority: int
var allowed_first_operand_types: PackedStringArray
var allowed_second_operand_types: PackedStringArray
var is_operands_types_need_to_be_equals: bool
var position: Vector3i


func _init(
	init_position: Vector3i = Vector3i.ZERO,
	init_priority: int = -1,
	init_allowed_first_operand_types: PackedStringArray = [],
	are_allowed_second_operand_types_copies_from_allowed_first_operand_types: bool = false,
	init_allowed_second_operand_types: PackedStringArray = [],
	init_is_operands_types_need_to_be_equals: bool = true
):
	position = init_position
	priority = init_priority
	allowed_first_operand_types = init_allowed_first_operand_types
	if are_allowed_second_operand_types_copies_from_allowed_first_operand_types:
		allowed_second_operand_types = allowed_first_operand_types
	else:
		allowed_second_operand_types = init_allowed_second_operand_types
	is_operands_types_need_to_be_equals = init_is_operands_types_need_to_be_equals


func check_input_operands(
	in_operands_stack: Array[Operand], out_parsing_result: ParsingResult
) -> bool:
	# Need less than two operands
	if allowed_second_operand_types.is_empty():
		# Need zero operands
		if allowed_first_operand_types.size() < 1:
			if in_operands_stack.size() > 0:
				out_parsing_result.errors.append(Error.new(Error.ExcessOperandsErrorText, position))
				return false
		# Need one operand
		else:
			if in_operands_stack.size() < 1:
				out_parsing_result.errors.append(Error.new(Error.NoOperandsErrorText, position))
				return false
			elif in_operands_stack[-1].value_type in allowed_first_operand_types:
				return true
			else:
				if in_operands_stack[-1] in out_parsing_result.variables:
					if (
						out_parsing_result.variables[in_operands_stack[-1].value].value_type
						in allowed_first_operand_types
					):
						return true
					else:
						out_parsing_result.errors.append(
							Error.new(
								Error.WrongOperandTypeErrorText, in_operands_stack[-1].position
							)
						)
						return false
				else:
					out_parsing_result.errors.append(
						Error.new(
							Error.UnknownVariableErrorText, in_operands_stack[-1].value_type, position
						)
					)
					return false

	# Need two operands
	else:
		var o1_var: Operand
		var o2_var: Operand
		if in_operands_stack.size() < 2:
			out_parsing_result.errors.append(Error.new(Error.NoOperandsErrorText, position))
			return false

		o1_var = in_operands_stack[-2]
		while (
			o1_var.value_type == LexemeTypes.Var
			and not (o1_var.value_type in allowed_first_operand_types)
		):
			if not (o1_var.value in out_parsing_result.variables):
				out_parsing_result.errors.append(
					Error.new(Error.UnknownVariableErrorText, o1_var.position)
				)
				return false
			o1_var = out_parsing_result.variables[o1_var.value]

		o2_var = in_operands_stack[-1]
		while (
			o2_var.value_type == LexemeTypes.Var
			and not (o2_var.value_type in allowed_second_operand_types)
		):
			if not (o2_var.value in out_parsing_result.variables):
				out_parsing_result.errors.append(
					Error.new(Error.UnknownVariableErrorText, o2_var.position)
				)
				return false
			o2_var = out_parsing_result.variables[o2_var.value]

		var result: bool = true

		if not (o1_var.value_type in allowed_first_operand_types):
			out_parsing_result.errors.append(
				Error.get_wrong_operand_type_error(
					allowed_first_operand_types, o1_var.value_type, position
				)
			)
			result = false
		if not (o2_var.value_type in allowed_second_operand_types):
			out_parsing_result.errors.append(
				Error.get_wrong_operand_type_error(
					allowed_second_operand_types, o2_var.value_type, position
				)
			)
			result = false
		if is_operands_types_need_to_be_equals and o1_var.value_type != o2_var.value_type:
			out_parsing_result.errors.append(
				Error.get_wrong_operand_type_error([o1_var.value_type], o2_var.value_type, position)
			)
			result = false

		return result

	return true


static var NullaryOperatorsLexemeTypes: PackedStringArray = [
	LexemeTypes.Else, LexemeTypes.Obr, LexemeTypes.Cbr, LexemeTypes.End
]

static var UnaryOperatorsLexemeTypes: PackedStringArray = [
	LexemeTypes.Not,
	LexemeTypes.If,
	LexemeTypes.While,
	LexemeTypes.Cout,
]

static var BinaryOperatorsLexemeTypes: PackedStringArray = [
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

static var OperatorsLexemeTypes: PackedStringArray = (
	NullaryOperatorsLexemeTypes + UnaryOperatorsLexemeTypes + BinaryOperatorsLexemeTypes
)


static func get_priority_by_lexeme_type(lexeme_type: String) -> int:
	if lexeme_type in [LexemeTypes.Obr, LexemeTypes.Cbr, LexemeTypes.Else, LexemeTypes.End]:
		return 1
	elif (
		lexeme_type
		in [
			LexemeTypes.Not,
			LexemeTypes.Mul,
			LexemeTypes.Div,
			LexemeTypes.And,
			LexemeTypes.Or,
			LexemeTypes.Equals,
			LexemeTypes.More,
			LexemeTypes.Less,
		]
	):
		return 2
	elif lexeme_type in [LexemeTypes.Add, LexemeTypes.Sub]:
		return 3
	elif (
		lexeme_type
		in [
			LexemeTypes.Assign,
			LexemeTypes.If,
			LexemeTypes.While,
		]
	):
		return 4

	return -1


static func init_by_lexeme(lexeme: Lexeme, out_parsing_result):
	if lexeme.type not in OperatorsLexemeTypes:
		out_parsing_result.errors.append(Error.new(Error.UnknownOperatorErrorText, lexeme.position))
		return null

	var init_priority: int = get_priority_by_lexeme_type(lexeme.type)
	match lexeme.type:
		LexemeTypes.Obr:
			return ObrOperator.new(lexeme.position, init_priority)
		LexemeTypes.Cbr:
			return CbrOperator.new(lexeme.position, init_priority)
		LexemeTypes.Else:
			return ElseOperator.new(lexeme.position, init_priority)
		LexemeTypes.End:
			return EndOperator.new(lexeme.position, init_priority)
		LexemeTypes.Not:
			return NotOperator.new(lexeme.position, init_priority, [LexemeTypes.Bool])
		LexemeTypes.If:
			return IfOperator.new(lexeme.position, init_priority, [LexemeTypes.Bool])
		LexemeTypes.While:
			return WhileOperator.new(lexeme.position, init_priority, [LexemeTypes.Bool])
		LexemeTypes.Cout:
			return CoutOperator.new(lexeme.position, init_priority, [LexemeTypes.Str])
		LexemeTypes.Assign:
			return AssignOperator.new(
				lexeme.position,
				init_priority,
				[LexemeTypes.Var],
				false,
				Operand.ConstantOperandsLexemeTypes,
				false
			)
		LexemeTypes.Add:
			return AddOperator.new(
				lexeme.position, init_priority, [LexemeTypes.Str, LexemeTypes.Num], true
			)
		LexemeTypes.Sub:
			return SubstractOperator.new(lexeme.position, init_priority, [LexemeTypes.Num], true)
		LexemeTypes.Mul:
			return MultiplyOperator.new(lexeme.position, init_priority, [LexemeTypes.Num], true)
		LexemeTypes.Div:
			return DivideOperator.new(lexeme.position, init_priority, [LexemeTypes.Num], true)
		LexemeTypes.And:
			return AndOperator.new(lexeme.position, init_priority, [LexemeTypes.Bool], true)
		LexemeTypes.Or:
			return OrOperator.new(lexeme.position, init_priority, [LexemeTypes.Bool], true)
		LexemeTypes.More:
			return MoreOperator.new(lexeme.position, init_priority, [LexemeTypes.Bool], true)
		LexemeTypes.Less:
			return LessOperator.new(lexeme.position, init_priority, [LexemeTypes.Bool], true)
		LexemeTypes.Equals:
			return EqualsOperator.new(
				lexeme.position, init_priority, Operand.ConstantOperandsLexemeTypes, true
			)

	return null
