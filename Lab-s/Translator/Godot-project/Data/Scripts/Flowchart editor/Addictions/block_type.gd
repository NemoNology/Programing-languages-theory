extends Node
# Flowchart block type is:
# 1) Flowchart block shape: FlowchartBlockShape
# 2) Placeholder text: String
# 3) Start text: String
# 4) Bonus code (see FlowchartBlock "Bonus code" property): Array
class_name FlowchartBlockType

var shape: FlowchartBlockShape
var startText: String
var placeholderText: String
var tooltipText: String
var flat: bool
var slots: Array

func _init(
    block_shape: FlowchartBlockShape,
    block_placeholderText: String,
    block_slots: Array,
    block_tooltip_text: String,
    is_flat: bool = false
    ):
        shape = block_shape
        placeholderText = block_placeholderText
        slots = block_slots
        tooltipText = block_tooltip_text
        flat = is_flat
