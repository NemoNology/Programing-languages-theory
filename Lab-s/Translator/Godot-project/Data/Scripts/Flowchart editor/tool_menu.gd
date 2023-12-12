class_name FlowchartToolMenu extends PopupMenu

## Dictionary: key - menu option/item ID; Value -
static var AddingBlockTypeByOptionID: Dictionary = {
	0: FlowchartBlocksTypes.Process,
	1: FlowchartBlocksTypes.HandInput,
	2: FlowchartBlocksTypes.Output,
	3: FlowchartBlocksTypes.ConditionIf,
	4: FlowchartBlocksTypes.ConditionWhile,
	5: FlowchartBlocksTypes.ConditionEnd,
}
static var DeleteSelectedBlocksOptionID: int = 8
static var SelectAllBlocksOptionID: int = 7
static var SaveFlowchartOptionID: int = 10
static var SaveFlowchartAsOptionID: int = 11
static var LoadFlowchartOptionID: int = 12


func _init():
	add_item('Добавить блок "Процесс"')
	add_item('Добавить блок "Ввод с консоли"')
	add_item('Добавить блок "Вывод в консоль"')
	add_item('Добавить блок "Условный оператор"')
	add_item('Добавить блок "Цикл"')
	add_item('Добавить блок "Конец условия"')
	add_separator()
	add_item("Выделить все блоки")
	add_item("Удалить выделенные блоки")
	add_separator()
	add_item("Сохранить блок-схему")
	add_item("Сохранить блок-схему как..")
	add_item("Загрузить блок-схему")
