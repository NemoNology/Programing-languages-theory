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
static var ConditionEnd: FlowchartBlockType
static var Process: FlowchartBlockType


static func _static_init():
	Begin = (
		FlowchartBlockType
		. new(
			FlowchartBlocksShapes.BeginEnd,
			"Начало",
			[
				FlowchartBlockSlot.new("Начало", false, true),
			],
			"Блок, характерезующий начало алгоритма",
			true,
		)
	)
	End = (
		FlowchartBlockType
		. new(
			FlowchartBlocksShapes.BeginEnd,
			"Конец",
			[
				FlowchartBlockSlot.new("Конец", true, false),
			],
			"Блок, характерезующий конец алгоритма",
			true,
		)
	)
	HandInput = (
		FlowchartBlockType
		. new(
			FlowchartBlocksShapes.HandInput,
			"Ввод ..",
			[
				FlowchartBlockSlot.new(),
			],
			"Блок консольного ввода: значение выражения,\nуказанного внутри блока, будет считано из консольного ввода",
		)
	)
	Output = (
		FlowchartBlockType
		. new(
			FlowchartBlocksShapes.Output,
			"Вывод ..",
			[
				FlowchartBlockSlot.new(),
			],
			"Блок консольного вывода: выражение,\nуказанное внутри блока, будет выведено в консоль",
		)
	)
	ConditionIf = (
		FlowchartBlockType
		. new(
			FlowchartBlocksShapes.ConditionStart,
			"Если ..",
			[
				(
					FlowchartBlockSlot
					. new(
						"Предыдущий - Тогда",
					)
				),
				FlowchartBlockSlot.new("Иначе", false),
			],
			(
				"Блок условного оператора: содержимое блока - только логическое выражение"
				+ "\nВерхний выход блока - выход для алгоритма,\nсрабатывающего при истинности логического выражения"
				+ "\nНижний выход блока - при ложности логического выражения"
				+ "\nУточнения:\n"
				+ "+) Тело (ветвь) 'иначе' может отсутствовать"
				+ "+) Тела 'тогда' и 'иначе' должны заканчиваться \nблоком окончания условного оператора"
			),
		)
	)
	ConditionWhile = (
		FlowchartBlockType
		. new(
			FlowchartBlocksShapes.ConditionStart,
			"Пока ..",
			[
				FlowchartBlockSlot.new(),
			],
			(
				"Блок цикла: содержимое блока - только логическое выражение"
				+ "\nВерхний выход блока - выход для алгоритма,\nсрабатывающего при истинности логического выражения"
				+ "\nНижний выход блока - при ложности логического выражения"
				+ "\nУточнение:\n"
				+ "Тело цикла должно заканчиваться блоком конца условия"
			),
		)
	)
	ConditionEnd = (
		FlowchartBlockType
		. new(
			FlowchartBlocksShapes.ConditionEnd,
			"Конец условия",
			[
				FlowchartBlockSlot.new(),
			],
			(
				"Блок окончания условия: этим блоком должна\n"
				+ "оканчиваться каждая *ветвь (тело) блока условия"
				+ "\nУточнения:\n"
				+ "+) Блок условия - блок условного оператора или блок цикла\n"
				+ "+) В случае окончания блока условного оператора, данным блоком должны\n"
				+ "заканчиваться как *ветвь 'тогда', так и ветвь 'иначе' (если она есть)"
			),
			true,
		)
	)
	Process = (
		FlowchartBlockType
		. new(
			FlowchartBlocksShapes.Process,
			"Код..",
			[
				FlowchartBlockSlot.new(),
			],
			(
				"Блок процесса: содержимое блока -\n"
				+ "функция обработки данных любого вида\n"
				+ "на условном языке программирования\n"
				+ "Уточнение:\n"
				+ "Этот блок может заменить все остальные,\n"
				+ "кроме блока условия; Иные типы блоков нужны\n"
				+ "для лучшего визуального восприятия всей блок-схемы;\n"
				+ "Также иные виды блоков позволяют уменьшить количество\n"
				+ "введённого вручную кода"
			),
		)
	)
