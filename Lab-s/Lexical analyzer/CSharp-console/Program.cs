using CSharp_console.Implementations.LexicalParser;
using CSharp_console.Implementations.LexicalParser.Tokens;

IEnumerable<TokenTemplate> Templates =
[
    new(TokenType.LPAR, @"\("),
    new(TokenType.RPAR, @"\)"),
    new(TokenType.ASSIGN, ":="),
    new(TokenType.OR, "OR"),
    new(TokenType.XOR, "XOR"),
    new(TokenType.AND, "AND"),
    new(TokenType.NOT, "NOT"),
    new(TokenType.ZERO, "0"),
    new(TokenType.ONE, "1"),
    new(TokenType.ID, @"([A-z_])(\w*)"),
    new(TokenType.SEMICOLON, ";"),
];

Lexer lexer = new(Templates);
var code = @"
x := 0;
y := 1;
x_or_y := x OR y;
x_and_y := x AND y;
";
try
{
    var tokens = lexer.GetTokens(code);
    Console.WriteLine($"Tokens ({tokens.Count}):");
    // foreach (var token in tokens)
    // {
    //     Console.WriteLine(token);
    // }
}
catch (Exception e)
{
    Console.WriteLine(e.Message);
}
