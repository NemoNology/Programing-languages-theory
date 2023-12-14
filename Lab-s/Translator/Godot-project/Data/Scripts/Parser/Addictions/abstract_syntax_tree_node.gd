class_name AbstractSyntaxTreeNode

var parsed_value = null
var parsed_value_type = null
var left: AbstractSyntaxTreeNode
var right: AbstractSyntaxTreeNode


func _init(left_node: AbstractSyntaxTreeNode = null, right_node: AbstractSyntaxTreeNode = null):
	left = left_node
	right = right_node
