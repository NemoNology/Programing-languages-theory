extends Node
# Flowchart blocks types templates
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
			"Начало",
			FlowchartBlocksShapes.BeginEnd,
			"Блок, характерезующий начало алгоритма.",
			[FlowchartBlockSlot.new(false, true)],
			true,
		)
	)
	End = (
		FlowchartBlockType
		. new(
			"Конец",
			FlowchartBlocksShapes.BeginEnd,
			"Блок, характерезующий конец алгоритма.",
			[FlowchartBlockSlot.new(true, false)],
			true,
		)
	)
	HandInput = (
		FlowchartBlockType
		. new(
			"Ввод",
			FlowchartBlocksShapes.HandInput,
			(
				"Блок консольного ввода: значение выражения\n"
				+ "указанного внутри блока, будет считано из консольного ввода."
			),
		)
	)
	Output = (
		FlowchartBlockType
		. new(
			"Вывод",
			FlowchartBlocksShapes.Output,
			(
				"Блок консольного вывода: выражение,"
				+ "указанное внутри блока, будет выведено в консоль."
			),
		)
	)
	ConditionIf = (
		FlowchartBlockType
		. new(
			"Условный оператор",
			FlowchartBlocksShapes.ConditionStart,
			(
				"Блок условного оператора:\n"
				+ "Верхний выход блока - тело \'тогда\' - многоблочное\n"
				+ "(минимум один блок) тело алгоритма, срабатывающее при\n"
				+ "истинности логического выражения.\n"
				+ "Нижний выход блока - тело \'иначе\' - при ложности\n"
				+ "логического выражения.\n"
				+ "Уточнения:\n"
				+ "+) Содержимое блока должно быть логическим выражением.\n"
				+ "+) Тело 'иначе' может отсутствовать.\n"
				+ "+) Тела 'тогда' (верхний выход блока) и 'иначе' должны\n"
				+ "заканчиваться блоком окончания условного оператора."
			),
			[FlowchartBlockSlot.DefautSlot, FlowchartBlockSlot.new(false, true, "Иначе")],
		)
	)
	ConditionWhile = (
		FlowchartBlockType
		. new(
			"Цикл",
			FlowchartBlocksShapes.ConditionStart,
			(
				"Блок цикла.\n"
				+ "Уточнения:\n"
				+ "+) Содержимое блока должно быть логическим выражением.\n"
				+ "+) Тело цикла должно заканчиваться блоком конца условия."
			),
		)
	)
	ConditionEnd = (
		FlowchartBlockType
		. new(
			"Конец блока\nусловия",
			FlowchartBlocksShapes.ConditionEnd,
			(
				"Блок окончания условия: этим блоком должно\n"
				+ "оканчиваться каждое тела блока условия.\n"
				+ "Уточнения:\n"
				+ "+) Блок условия - блок условного оператора или блок цикла.\n"
				+ "+) В случае окончания блока условного оператора, данным блоком должны\n"
				+ "заканчиваться как тело 'тогда', так и тело 'иначе' (если он есть)."
			),
			[FlowchartBlockSlot.DefautSlot],
			true,
		)
	)
	Process = (
		FlowchartBlockType
		. new(
			"Процесс",
			FlowchartBlocksShapes.Process,
			(
				"Блок процесса: содержимое блока -\n"
				+ "функция обработки данных любого вида\n"
				+ "на условном языке программирования\n."
				+ "Уточнение:\n"
				+ "Этот блок может заменить все остальные,\n"
				+ "кроме блока условия. Иные типы блоков нужны\n"
				+ "для лучшего визуального восприятия блок-схемы.\n"
				+ "Также иные виды блоков позволяют уменьшить количество\n"
				+ "введённого вручную кода."
			),
		)
	)
