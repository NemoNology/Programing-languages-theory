# Flowchart block type is:
# 1) Flowchart block shape: FlowchartBlockShape
# 2) Placeholder text: String
# 3) Tooltip text: String
# 4) (Is) Flat (block): bool
# 5) Slots: Array[FlowchartBlockSlot]
class_name FlowchartBlockType

var type_name: String
var shape: FlowchartBlockShape
var tooltipText: String
var flat: bool
var slots: Array[FlowchartBlockSlot]


func _init(
	block_type_name: String,
	block_shape: FlowchartBlockShape,
	block_tooltip_text: String,
	block_slots: Array[FlowchartBlockSlot] = [FlowchartBlockSlot.DefautSlot],
	is_flat: bool = false,
):
	type_name = block_type_name
	shape = block_shape
	slots = block_slots
	tooltipText = block_tooltip_text
	flat = is_flat


func _to_string():
	return type_name
