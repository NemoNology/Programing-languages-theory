extends Label

class_name FlowchartBlockSlot

const DEFAULT_IN_PORT_COLOR: Color = Color.RED
const DEFAULT_OUT_PORT_COLOR: Color = Color.BLUE
const DEFAULT_PORT_TYPE: int = 0

var isLeftPortEnabled: bool
var isRightPortEnabled: bool

func _init(
    block_port_text: String,
    is_left_port_enabled: bool = true,
    is_right_port_enabled: bool = true,
    text_horizontal_alignment: HorizontalAlignment = HORIZONTAL_ALIGNMENT_FILL,
    ):
    text = block_port_text
    horizontal_alignment = text_horizontal_alignment
    uppercase = true
    isLeftPortEnabled = is_left_port_enabled
    isRightPortEnabled = is_right_port_enabled
    autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

static func new_from(flowchart_block_port: FlowchartBlockSlot):
    return FlowchartBlockSlot.new(
        flowchart_block_port.text,
        flowchart_block_port.isLeftPortEnabled,
        flowchart_block_port.isRightPortEnabled,
    )