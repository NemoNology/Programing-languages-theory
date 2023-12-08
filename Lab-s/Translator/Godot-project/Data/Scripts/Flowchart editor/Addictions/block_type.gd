extends Node
# Flowchart block type is:
# 1) Flowchart block shape: FlowchartBlockShape
# 2) Placeholder text: String
# 3) Tooltip text: String
# 4) (Is) Flat (block): bool
# 5) Slots: Array[FlowchartBlockSlot]
class_name FlowchartBlockType

var shape: FlowchartBlockShape
var placeholderText: String
var tooltipText: String
var flat: bool
var slots: Array[FlowchartBlockSlot]


func _init(
	block_shape: FlowchartBlockShape,
	block_placeholderText: String,
	block_tooltip_text: String,
	block_slots: Array[FlowchartBlockSlot] = [FlowchartBlockSlot.DefautSlot],
	is_flat: bool = false,
):
	shape = block_shape
	placeholderText = block_placeholderText
	slots = block_slots
	tooltipText = block_tooltip_text
	flat = is_flat
