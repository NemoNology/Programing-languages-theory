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
static var EndCondition: FlowchartBlockType
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
			FlowchartBlockSlot.new(),
		],
		"Блок консольного ввода: значение выражения,\nуказанного внутри блока, будет считано из консольного ввода",
	)
	Output = FlowchartBlockType.new(
		FlowchartBlocksShapes.Output,
		"Вывод ..",
		[
			FlowchartBlockSlot.new(),
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
		"Блок условного оператора: содержимое блока - только логическое выражение"
		+ "\nВерхний выход блока - выход для алгоритма,\nсрабатывающего при истинности логического выражения"
		+ "\nНижний выход блока - при ложности логического выражения"
		+ "\nУточнения:\n"
		+ "+) Блок 'иначе' может отсутствовать"
		+ "+) Блоки 'тогда' и 'иначе' должны заканчиваться \nблоком окончания условного оператора"
		,
	)
	ConditionWhile = FlowchartBlockType.new(
		FlowchartBlocksShapes.Condition,
		"Пока ..",
		[
			FlowchartBlockSlot.new(),
		],
		"Блок цикла: содержимое блока - только логическое выражение"
		+ "\nВерхний выход блока - выход для алгоритма,\nсрабатывающего при истинности логического выражения"
		+ "\nНижний выход блока - при ложности логического выражения"
		+ "\nУточнение:\n"
		+ "Должен заканчиваться блоком конца условия",
	)
	EndCondition = FlowchartBlockType.new(
		FlowchartBlocksShapes.Condition,
		"Конец условия..",
		[
			FlowchartBlockSlot.new(),
		],
		"Блок окончания условия: здесь содержаться последний\n"
		+ "функционал, который будет выполнен в теле блока-условия"
		+ "\nУточнения:\n"
		+ "+) Блок-условие - блок условного оператора или блок цикла\n"
		+ "+) Данным блоком должн заканчиваться блок-условие\n"
		+ "+) В случае окончания блока условного оператора, данным блоком должны\n"
		+ "заканчиваться как ветвь 'тогда', так и ветвь 'иначе' (если есть)",
	)
	Process = FlowchartBlockType.new(
		FlowchartBlocksShapes.Process,
		"Код..",
		[
			FlowchartBlockSlot.new(),
		],
		"Блок процесса: содержимое блока - \nфункция обработки данных любого вида \nна условном языке программирования\n"
		+ "Уточнение:\n"
		+ "Этот блок может заменить все остальные;\nИные типы блоков нужны для лучшего визуального восприятия\n"
		+ "всей блок-схемы; Также иные виды блоков позволяют уменьшить количество\n"
		+ "введённого в ручную кода"
		,
	)
