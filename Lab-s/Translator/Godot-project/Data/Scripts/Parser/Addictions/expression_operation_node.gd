class_name ExpressionOperationNode extends AbstractSyntaxTreeNode

var priority: int = 0

static var ExpressionOperatiosLexemeTypes: Array[String] = [
	LexemeTypes.Add,
	LexemeTypes.Sub,
	LexemeTypes.Mul,
	LexemeTypes.Div,
	LexemeTypes.Not,
	LexemeTypes.And,
	LexemeTypes.Or,
	LexemeTypes.More,
	LexemeTypes.Less,
	LexemeTypes.Equals,
]


static func get_priority_by_lexeme_type(lexeme_type: String) -> int:
	if lexeme_type in [LexemeTypes.Obr, LexemeTypes.Cbr]:
		return 0
	elif lexeme_type in [LexemeTypes.Not]:
		return 1
	elif lexeme_type in [LexemeTypes.Mul, LexemeTypes.Div, LexemeTypes.And, LexemeTypes.Or]:
		return 2
	elif (
		lexeme_type
		in [
			LexemeTypes.Add, LexemeTypes.Sub, LexemeTypes.More, LexemeTypes.Less, LexemeTypes.Equals
		]
	):
		return 3
	return -1


func _init(
	operator_priority: int,
	left_node: AbstractSyntaxTreeNode = null,
	right_node: AbstractSyntaxTreeNode = null
):
	priority = operator_priority
	left = left_node
	right = right_node


func parse() -> ExpressionNode:
	
	
	return null
