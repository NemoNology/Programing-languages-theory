class_name FlowchartBlockSlot

const DEFAULT_IN_PORT_COLOR: Color = Color.RED
const DEFAULT_OUT_PORT_COLOR: Color = Color.BLUE
const DEFAULT_PORT_TYPE: int = 0
static var DefautSlot: FlowchartBlockSlot = FlowchartBlockSlot.new()

var text: String
var input_port_enabled: bool
var output_port_enabled: bool


func _init(
	is_input_port_enabled: bool = true,
	is_output_port_enabled: bool = true,
	block_port_text: String = "",
):
	text = block_port_text
	input_port_enabled = is_input_port_enabled
	output_port_enabled = is_output_port_enabled
