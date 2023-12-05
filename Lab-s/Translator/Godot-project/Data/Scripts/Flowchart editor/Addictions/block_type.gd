extends Node
# Flowchart block type is:
# 1) Flowchart block shape: FlowchartBlockShape
# 2) Placeholder text: String
# 3) Bonus code (see FlowchartBlock "Bonus code" property): Array
class_name FlowchartBlocksType

var _shape: FlowChartBlockShape
var _placeholderText: String
var _bonusCode: Array

func _init(
    shape: FlowChartBlockShape,
    placeholderText: String,
    bonusCode: Array):
        _shape = shape
        _placeholderText = placeholderText
        _bonusCode = bonusCode
