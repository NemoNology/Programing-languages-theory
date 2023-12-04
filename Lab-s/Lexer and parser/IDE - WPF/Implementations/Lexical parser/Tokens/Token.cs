namespace CSharp_console.Implementations.LexicalParser.Tokens
{
    public class Token
    {
        public TokenType TokenType { get; set; }
        public string Text { get; set; }
        public int Position { get; set; }

        public Token(TokenType tokenType, string text, int position)
        {
            TokenType = tokenType;
            Text = text;
            Position = position;
        }

        public override string ToString() => $"(<{TokenType.GetName(typeof(TokenType), this.TokenType)}> : \"{Text}\" at {Position})";
    }
}