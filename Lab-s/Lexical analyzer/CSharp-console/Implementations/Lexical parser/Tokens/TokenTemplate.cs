namespace CSharp_console.Implementations.LexicalParser.Tokens
{
    /// <summary>
    /// Token template 
    /// </summary>
    /// <param name="tokenType">Token type</param>
    /// <param name="regularExpressionTemplate">Token template as regular expression</param>
    public class TokenTemplate(TokenType tokenType, string regularExpressionTemplate)
    {
        public TokenType TokenType { get; set; } = tokenType;
    public string RegularExpressionTemplate { get; private set; } = regularExpressionTemplate;
}
}