namespace CSharp_console.Implementations.LexicalParser.Tokens
{
    /// <summary>
    /// Token template 
    /// </summary>
    /// <param name="tokenType">Token type</param>
    /// <param name="regularExpressionTemplate">Token template as regular expression</param>
    public class TokenTemplate
    {
        public TokenType TokenType { get; set; }
        public string RegularExpressionTemplate { get; private set; }

        public TokenTemplate(TokenType tokenType, string regularExpressionTemplate)
        {
            TokenType = tokenType;
            RegularExpressionTemplate = regularExpressionTemplate;
        }
    }
}