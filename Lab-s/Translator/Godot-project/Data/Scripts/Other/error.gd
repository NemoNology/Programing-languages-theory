class_name Error

var text: String
var position: Vector3i


func _init(error_text: String, error_position: Vector3i):
	text = error_text
	position = error_position


func _to_string():
	return (
		"%s (%s, %s, %s)"
		% [
			text,
			"блок %s" % position.x,
			"строка %s" % position.y,
			"символ %s" % position.z,
		]
	)
	

static func get_wrong_operand_type_error(expected_types: PackedStringArray, getted_type: String, error_position: Vector3i):
	var error_text: String = "%s: ожидалось " % WrongOperandTypeErrorText
	for type in expected_types:
		error_text += type.to_lower() + ", "
	return Error.new(error_text.substr(0, error_text.length() - 3) + ", но получен %s" % getted_type, error_position)
	

static var UnknownLexemeErrorText: String = "Неизвестная лексема"
static var EmptyBlockErrorText: String = "У блока отсутствует сожержимое"
static var EmptyConditionBlockBodyErrorText: String = "Блок условия не содержит тела"
static var EmptyFlowchartErrorText: String = "Пустая блок-схема"
static var EmptyElseBodyErrorText: String = "Пустое тело 'иначе' блока условного оператора"
static var NoBlockContinuationErrorText: String = "Блок не имеет продолжения"
static var NoBlockBeginningErrorText: String = "Блок не имеет начала"
static var ExcessEndConditionBlockErrorText: String = "Блок конца условия закрывает несуществующий блок условия"
static var ExcessElseBlockErrorText: String = "Ожидалось начало условного оператора перед '%s'" % LexemeTypes.Else
static var ExcessBracketsClosingErrorText: String = "Попытка закрыть несуществующую скобку"
static var ExcessBracketsOpeningErrorText: String = "Незакрытая скобка"
static var NoOperandsErrorText: String = "Отсутсвует(ют) операнд(ы)"
static var UnknownOperationErrorText: String = "Неизвестная операция"
static var UnknownVariableErrorText: String = "Неизвестная переменная"
static var WrongOperandTypeErrorText: String = "Неверный тип операнда(ов)"
static var DivisionByZeroTypeErrorText: String = "Деление на ноль"
