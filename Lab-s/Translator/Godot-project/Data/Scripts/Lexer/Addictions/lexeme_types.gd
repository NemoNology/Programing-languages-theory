class_name LexemeTypes

## Console out
static var Cout: String = "вывод"
## Console in
static var Cin: String = "ввод"
## Assign (variable to value)
static var Assign: String = "будет"
## Open brackets
static var Obr: String = "("
## Close brackets
static var Cbr: String = ")"
## Separator - '.'
static var Separatop: String = "."
## If - conditional operator
static var If: String = "если"
## While - loop
static var While: String = "пока"
## Else - conditional operator second body
static var Else: String = "иначе"
## End - end of if/while
static var End: String = "конец"
## Adding - operator
static var Add: String = "плюс"
## Subtraction - operator
static var Sub: String = "минус"
## Multiplication - operator
static var Mul: String = "умножить"
## Division - operator
static var Div: String = "разделить"
## Boolean
static var Bool: String = "логическая переменная"
## False
static var False: String = "ложь"
## True
static var True: String = "правда"
## Not - logical operator
static var Not: String = "не"
## And - logical operator
static var And: String = "и"
## Or - logical operator
static var Or: String = "или"
## More (5 is more than 3)
static var More: String = "больше"
## Less (3 is less than 5)
static var Less: String = "меньше"
## Equals (4 is equal 2 + 2)
static var Equals: String = "равно"
## Variable - variable ID
static var Var: String = "переменная"
## Number
static var Num: String = "число"
## String
static var Str: String = "строка"
## Unknown lexeme type
static var Unknown: String = "неизвестно"

static var AllLexemes: PackedStringArray = [
	# TODO: this
	Cout,
	Cin,
	Assign,
	Obr,
	Cbr,
	Separatop,
	If,
	While,
	Else,
	End,
	Add,
	Sub,
	Mul,
	Div,
	Bool,
	False,
	True,
	Not,
	And,
	Or,
	More,
	Less,
	Equals,
	Var,
	Num,
	Str,
	Unknown,
]

# TODO: Remove this
static var lexeme_types_as_dictionary: Dictionary = {
	"вывод": Cout,
	"ввод": Cin,
	"будет": Assign,
	"(": Obr,
	")": Cbr,
	".": Separatop,
	"если": If,
	"пока": While,
	"иначе": Else,
	"конец": End,
	"плюс": Add,
	"минус": Sub,
	"умножить": Mul,
	"разделить": Div,
	"логическая переменная": Bool,
	"ложь": False,
	"правда": True,
	"не": Not,
	"и": And,
	"или": Or,
	"больше": More,
	"меньше": Less,
	"равно": Equals,
	"переменная": Var,
	"число": Num,
	"строка": Str,
	"неизвестно": Unknown,
}
