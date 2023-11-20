using CSharp_console.Implementations.LexicalParser.Tokens;
using System.Text.RegularExpressions;

namespace CSharp_console.Implementations.LexicalParser
{
    public partial class Lexer(IEnumerable<TokenTemplate> tokenTemplates)
    {
        /// <summary>
        /// Available tokens
        /// </summary>
        readonly IEnumerable<TokenTemplate> TokenTemplates = tokenTemplates;

        /// <summary>
        /// Get tokens list for inputted code fragment;<br/>
        /// <i>Raice ArgumentException if code has lexical errors</i>
        /// </summary>
        /// <param name="appCode">Inputted code fragment</param>
        /// <returns>Getted tokens list</returns>
        /// <exception cref="ArgumentException"/>
        public List<Token> GetTokens(string appCode)
        {
            List<Token> tokens = [];
            TokenType tokenTypeBuffer;
            string valueBaffer;
            ReadOnlySpan<char> codeFragment = appCode;
            int position = 0;

            try
            {
                while (position < codeFragment.Length)
                {
                    var codeFragmentPart = codeFragment[position..].ToString();
                    if (string.IsNullOrWhiteSpace(codeFragmentPart))
                        break;

                    (tokenTypeBuffer, valueBaffer) =
                        GetNextToken(codeFragmentPart);

                    tokens.Add(new(tokenTypeBuffer, valueBaffer.Trim(), position));
                    position += valueBaffer.Length;
                }
            }
            catch (ArgumentException ae)
            {
                throw new ArgumentException(ae.Message + $" at {position}");
            }

            return tokens;
        }

        (TokenType Token, string Value) GetNextToken(string codeFragment)
        {
            foreach (var tokenTemplate in TokenTemplates)
            {
                var match = new Regex(@"^(\s*)" + tokenTemplate.RegularExpressionTemplate).Match(codeFragment);
                if (match.Success)
                {
                    return (tokenTemplate.TokenType, match.Value);
                }
            }

            string details = codeFragment.Trim();
            if (details.Length > 5)
                details = details[..5] + "...";
            throw new ArgumentException($"Unknown token in \"{details}\"");
        }

        public List<(Token Token, dynamic Value)> Parse(string appCode)
        {
            List<(Token Token, dynamic Value)> variables = [];



            return variables;
        }
    }
}

