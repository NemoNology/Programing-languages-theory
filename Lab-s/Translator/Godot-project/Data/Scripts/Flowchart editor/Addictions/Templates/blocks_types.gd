## Flowchart blocks types templates
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
			"Условие",
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
				+ "+) Для завершения тела уловного оператора\n"
				+ "используется блок конца условия."
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
				"Блок цикла: выполняет алгоритм внутри тела,\n"
				+ "пока верно указанное внутри логическое выражение."
				+ "Уточнения:\n"
				+ "+) Для завершения тела цикла\n"
				+ "используется блок конца условия."
			),
		)
	)
	ConditionEnd = (
		FlowchartBlockType
		. new(
			"Блок конца\nусловия",
			FlowchartBlocksShapes.ConditionEnd,
			(
				"Блок окончания условия: этим блоком оканчивается\n"
				+ "каждое тело блока условия.\n"
				+ "Уточнения:\n"
				+ "+) Блок условия - блок условного оператора или цикла.\n"
				+ "+) В случае окончания блока условного оператора и\n"
				+ "наличии тела 'иначе', данным блоком заканчивается\n"
				+ "только тело 'иначе'. Если тело 'иначе' отсутствует,\n"
				+ "то блок конца условия заканчивает тело 'тогда'"
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
				+ "на условном языке программирования.\n"
				+ "Уточнение:\n"
				+ "Этот блок может заменить все остальные.\n"
				+ "Иные типы блоков нужны для лучшего\n"
				+ "визуального восприятия блок-схемы.\n"
				+ "Также иные виды блоков позволяют уменьшить\n"
				+ "количество введённого вручную кода."
			),
		)
	)


static func from_name(type_name: String) -> FlowchartBlockType:
	match type_name:
		Begin.type_name: return Begin
		End.type_name: return End
		HandInput.type_name: return HandInput
		Output.type_name: return Output
		ConditionWhile.type_name: return ConditionWhile
		ConditionIf.type_name: return ConditionIf
		ConditionEnd.type_name: return ConditionEnd
		Process.type_name: return Process
	return null
