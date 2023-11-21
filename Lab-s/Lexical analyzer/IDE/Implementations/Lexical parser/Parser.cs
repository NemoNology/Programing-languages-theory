using CSharp_console.Implementations.LexicalParser.Tokens;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;

namespace CSharp_console.Implementations.LexicalParser
{
    public partial class Parser
    {
        /// <summary>
        /// Available tokens
        /// </summary>
        readonly IEnumerable<TokenTemplate> TokenTemplates;

        public Parser(IEnumerable<TokenTemplate> tokenTemplates)
        {
            TokenTemplates = tokenTemplates;
        }

        /// <summary>
        /// Get tokens list for inputted code fragment;<br/>
        /// <i>Raice ArgumentException if code has lexical errors</i>
        /// </summary>
        /// <param name="appCode">Inputted code fragment</param>
        /// <returns>Getted tokens list</returns>
        /// <exception cref="ArgumentException"/>
        public List<Token> GetTokens(string appCode)
        {
            List<Token> tokens = new();
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

        public List<(string ID, string Value)> Parse(string appCode, IEnumerable<Token>? tokens = null)
        {
            List<(string ID, string Value)> variables = new();
            Stack<(Token CurrentToken, IEnumerable<TokenType> ExceptedTokens)> s = new();
            tokens ??= GetTokens(appCode);
            var tokensList = tokens.ToList();
            int counter = 1;
            s.Push((tokensList[counter], new List<TokenType> { TokenType.ID, TokenType.SEMICOLON }));

            while (s.Count > 0 && counter < tokensList.Count)
            {
                var tokenInfo = s.Pop();
                var currentTokenType = tokenInfo.CurrentToken.TokenType;
                var exceptedTokenTypes = tokenInfo.ExceptedTokens;
                if (!exceptedTokenTypes.Contains(currentTokenType))
                {
                    var excTTasStr = "";
                    foreach (var exceptedTokenType in exceptedTokenTypes)
                    {
                        excTTasStr += $" {Enum.GetName(exceptedTokenType)} or";
                    }
                    throw new ArgumentException($"After {Enum.GetName(currentTokenType)} at {tokenInfo.CurrentToken.Position} Excepted{excTTasStr[..^2]}\nbut got {Enum.GetName(currentTokenType)}");
                }

                s.Push((tokensList[counter], GetExceptedTokensTypes(currentTokenType)));
                counter += 1;
            }

            return variables;
        }

        IEnumerable<TokenType> GetExceptedTokensTypes(TokenType tokenType)
        {
            List<TokenType> exceptedTokens = new();

            switch (tokenType)
            {
                case TokenType.ID:
                    exceptedTokens.AddRange(new [] { TokenType.ASSIGN, TokenType.RPAR, TokenType.OR, TokenType.XOR, TokenType.AND, TokenType.SEMICOLON });
                    break;
                case TokenType.LPAR:
                    exceptedTokens.AddRange(new[] { TokenType.ID, TokenType.RPAR, TokenType.LPAR, TokenType.NOT });
                    break;
                case TokenType.RPAR:
                    exceptedTokens.AddRange(new[] { TokenType.OR, TokenType.XOR, TokenType.AND, TokenType.RPAR, TokenType.SEMICOLON });
                    break;
                case TokenType.ASSIGN:
                    exceptedTokens.AddRange(new[] { TokenType.ID, TokenType.LPAR, TokenType.NOT });
                    break;
                case TokenType.OR:
                    exceptedTokens.AddRange(new[] { TokenType.ID, TokenType.LPAR, TokenType.NOT });
                    break;
                case TokenType.XOR:
                    exceptedTokens.AddRange(new[] { TokenType.ID, TokenType.LPAR, TokenType.NOT });
                    break;
                case TokenType.AND:
                    exceptedTokens.AddRange(new[] { TokenType.ID, TokenType.LPAR, TokenType.NOT });
                    break;
                case TokenType.NOT:
                    exceptedTokens.AddRange(new[] { TokenType.ID, TokenType.LPAR });
                    break;
                case TokenType.ZERO:
                    exceptedTokens.AddRange(new[] { TokenType.SEMICOLON, TokenType.OR, TokenType.XOR, TokenType.AND });
                    break;
                case TokenType.ONE:
                    exceptedTokens.AddRange(new[] { TokenType.SEMICOLON, TokenType.OR, TokenType.XOR, TokenType.AND });
                    break;
                case TokenType.SEMICOLON:
                    exceptedTokens.AddRange(new[] { TokenType.ID });
                    break;
                default:
                    break;
            }

            return exceptedTokens;
        }
    }
}

