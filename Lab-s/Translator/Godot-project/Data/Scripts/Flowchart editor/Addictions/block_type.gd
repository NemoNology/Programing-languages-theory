extends Node
# Flowchart block type is:
# 1) Flowchart block shape: FlowchartBlockShape
# 2) Placeholder text: String
# 3) Start text: String
# 4) Bonus code (see FlowchartBlock "Bonus code" property): Array
class_name FlowchartBlockType

var _shape: FlowchartBlockShape
var _startText: String
var _placeholderText: String
var _bonusCode: Array

func _init(
    shape: FlowchartBlockShape,
    placeholderText: String,
    bonusCode: Array,
    startText: String = ""
    ):
        _shape = shape
        _placeholderText = placeholderText
        _startText = startText
        _bonusCode = bonusCode
