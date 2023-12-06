extends Label

class_name FlowchartBlockSlot

const DEFAULT_IN_PORT_COLOR: Color = Color.RED
const DEFAULT_OUT_PORT_COLOR: Color = Color.BLUE
const DEFAULT_PORT_TYPE: int = 0

var isInputPortEnabled: bool
var isOutputPortEnabled: bool

func _init(
    block_port_text: String,
    is_left_port_enabled: bool = true,
    is_right_port_enabled: bool = true
    ):
    text = block_port_text
    uppercase = true
    isInputPortEnabled = is_left_port_enabled
    isOutputPortEnabled = is_right_port_enabled
    autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    add_theme_font_size_override("font_size", 8)

static func new_from(flowchart_block_port: FlowchartBlockSlot):
    return FlowchartBlockSlot.new(
        flowchart_block_port.text,
        flowchart_block_port.isInputPortEnabled,
        flowchart_block_port.isOutputPortEnabled,
    )