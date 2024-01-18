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


static func get_wrong_operand_type_error(
	expected_types: PackedStringArray, getted_type: String, error_position: Vector3i
):
	var error_text: String = "%s: ожидалось " % WrongOperandTypeErrorText
	for type in expected_types:
		error_text += type.to_lower() + ", "
	return Error.new(
		error_text.substr(0, error_text.length() - 3) + ", но получен %s" % getted_type,
		error_position
	)


const UnknownLexemeErrorText: String = "Неизвестная лексема"
const EmptyBlockErrorText: String = "У блока отсутствует сожержимое"
const EmptyConditionBlockBodyErrorText: String = "Блок условия не содержит тела"
const EmptyFlowchartErrorText: String = "Пустая блок-схема"
const EmptyElseBodyErrorText: String = "Пустое тело 'иначе' блока условного оператора"
const NoBlockContinuationErrorText: String = "Блок не имеет продолжения"
const NoBlockBeginningErrorText: String = "Блок не имеет начала"
const ExcessEndConditionBlockErrorText: String = "Блок конца условия закрывает несуществующий блок условия"
static var ExcessElseBlockErrorText: String = (
	"Ожидалось начало условного оператора перед '%s'" % LexemeTypes.Else
)
const ExcessBracketsClosingErrorText: String = "Попытка закрыть несуществующую скобку"
const ExcessBracketsOpeningErrorText: String = "Незакрытая скобка"
const NoOperandsErrorText: String = "Отсутсвует(ют) операнд(ы)"
const NoOperatorsErrorText: String = "Отсутсвует(ют) операторы(ы)"
const UnknownOperatorErrorText: String = "Неизвестная операция"
const UnknownVariableErrorText: String = "Неизвестная переменная"
const WrongOperandTypeErrorText: String = "Неверный тип операнда(ов)"
const DivisionByZeroTypeErrorText: String = "Деление на ноль"
const ExcessOperandsErrorText: String = "Избыток операндов"
