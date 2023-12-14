class_name ExpressionNode extends AbstractSyntaxTreeNode

static var ExpressionTypesLexemeTypes: Array[String] = [
	LexemeTypes.Int, LexemeTypes.StringType, LexemeTypes.True, LexemeTypes.False
]

var value
var value_type: int = -1


func _init():


func parse(expression: Array[Lexeme]) -> ExpressionNode:
	var the_least_operation: ExpressionOperationNode = find_the_least_operation(expression)
	while the_least_operation != null:
		the_least_operation.parse()

	return null



func find_the_least_operation(expression: Array[Lexeme]) -> ExpressionOperationNode:
	var res: ExpressionOperationNode = null
	for i in expression.size():
		if expression[i] in ExpressionOperationNode.ExpressionOperatiosLexemeTypes:
			var e: ExpressionOperationNode = ExpressionOperationNode.new(ExpressionOperationNode.get_priority_by_lexeme_type(expression[i].type), expression.slice(0, i), expression.slice(i + 1))
			if res == null:
				res = e
			elif res.priority > (e as ExpressionOperationNode).priority:
				res = e

	return res
