namespace CSharp_console.Implementations.LexicalParser.Tokens
{
    public class Token(TokenType tokenType, string text, int position)
    {
        public TokenType TokenType { get; set; } = tokenType;
        public string Text { get; set; } = text;
        public int Position { get; set; } = position;

        public override string ToString() => $"(<{TokenType.GetName(typeof(TokenType), this.TokenType)}> : \"{Text}\" at {Position})";
    }
}