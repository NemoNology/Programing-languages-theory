extends Node
# Flowchart block types templates (see FlowchartBlockType)  is Array:
# 1) Flowchart block shape: FlowchartBlockShape
# 2) Placeholder text: String
# 3) Bonus code (see FlowchartBlock "Bonus code" property): Array
class_name FlowchartBlocksTypes

static var Begin: FlowchartBlockType
static var End: FlowchartBlockType
static var HandInput: FlowchartBlockType
static var Output: FlowchartBlockType
static var ConditionWhile: FlowchartBlockType
static var ConditionIf: FlowchartBlockType
static var Process: FlowchartBlockType

static func _static_init():
	Begin = FlowchartBlockType.new(
		FlowchartBlocksShapes.BeginEnd,
		"",
		[
			FlowchartBlockSlot.new(
				"Начало",
				false, true
			),
		],
		"Блок, характерезующий начало алгоритма",
		"Начало"
	)
	End = FlowchartBlockType.new(
		FlowchartBlocksShapes.BeginEnd,
		"",
		[
			FlowchartBlockSlot.new(
				"Конец",
				true, false
			),
		],
		"Блок, характерезующий конец алгоритма",
		"Конец"
	)
	HandInput = FlowchartBlockType.new(
		FlowchartBlocksShapes.HandInput,
		"Ввод ..",
		[
			FlowchartBlockSlot.new(
				"Предыдущий - Следующий",
			),
		],
		"Блок консольного ввода: значение выражения,\nуказанного внутри блока, будет считано из консольного ввода",
	)
	Output = FlowchartBlockType.new(
		FlowchartBlocksShapes.Output,
		"Вывод ..",
		[
			FlowchartBlockSlot.new(
				"Предыдущий - Следующий",
			),
		],
		"Блок консольного вывода: выражение,\nуказанное внутри блока, будет выведено в консоль",
	)
	ConditionIf = FlowchartBlockType.new(
		FlowchartBlocksShapes.Condition,
		"Если ..",
		[
			FlowchartBlockSlot.new(
				"Предыдущий - Тогда",
			),
			FlowchartBlockSlot.new(
				"Иначе", false
			),
		],
		("Блок условного оператора: содержимое блока - только логическое выражение"
		+ "\nВерхний выход блока - выход для алгоритма,\nсрабатывающего при истинности логического выражения"
		+ "\nНижний выход блока - при ложности логического выражения"
		+ "\nУточнения:\n"
		+ "+) Блок \'иначе\' может отсутствовать"
		+ "+) Блок \'тогда\' кончается в конце первого блока, идущего из\n"
		+ "верхнего выхода (из выхода \'тогда\'); Блок \'иначе\' - соответственно"
		),
	)
	ConditionWhile = FlowchartBlockType.new(
		FlowchartBlocksShapes.Condition,
		"Пока ..",
		[
			FlowchartBlockSlot.new(
				"Предыдущий - Повторять",
			),
			FlowchartBlockSlot.new(
				"Потом", false
			),
		],
		("Блок цикла: содержимое блока - только логическое выражение"
		+ "\nВерхний выход блока - выход для алгоритма,\nсрабатывающего при истинности логического выражения"
		+ "\nНижний выход блока - при ложности логического выражения"
		),
	)
	Process = FlowchartBlockType.new(
		FlowchartBlocksShapes.Process,
		"Код..",
		[
			FlowchartBlockSlot.new(
				"Предыдущий - Следующий",
			),
		],
		"Блок процесса: содержимое блока - \nфункция обработки данных любого вида \nна условном языке программирования",
	)
