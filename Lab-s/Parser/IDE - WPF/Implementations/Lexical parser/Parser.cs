using CSharp_console.Implementations.LexicalParser.Tokens;
using IDE.Implementations.Lexical_parser;
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
        public IEnumerable<TokenTemplate> TokenTemplates { get; private set; }
        static readonly Dictionary<TokenType, IEnumerable<TokenType>> ExceptedTokenTypesForTokenType = new()
        {
            { TokenType.AND, new TokenType[] { TokenType.ID, TokenType.LPAR, TokenType.NOT, TokenType.ZERO, TokenType.ONE } },
            { TokenType.ASSIGN, new TokenType[] { TokenType.ID, TokenType.LPAR, TokenType.NOT, TokenType.ZERO, TokenType.ONE } },
            { TokenType.ID, new TokenType[] { TokenType.ASSIGN, TokenType.RPAR, TokenType.OR, TokenType.XOR, TokenType.AND, TokenType.SEMICOLON } },
            { TokenType.LPAR, new TokenType[] { TokenType.ID, TokenType.RPAR, TokenType.LPAR, TokenType.NOT, TokenType.ZERO, TokenType.ONE } },
            { TokenType.NOT, new TokenType[] { TokenType.ID, TokenType.LPAR, TokenType.ZERO, TokenType.ONE, TokenType.NOT } },
            { TokenType.ONE, new TokenType[] { TokenType.SEMICOLON, TokenType.OR, TokenType.XOR, TokenType.AND, TokenType.RPAR } },
            { TokenType.OR, new TokenType[] { TokenType.ID, TokenType.LPAR, TokenType.NOT, TokenType.ZERO, TokenType.ONE } },
            { TokenType.RPAR, new TokenType[] { TokenType.OR, TokenType.XOR, TokenType.AND, TokenType.RPAR, TokenType.SEMICOLON } },
            { TokenType.SEMICOLON, new TokenType[] { TokenType.ID, TokenType.SEMICOLON } },
            { TokenType.XOR, new TokenType[] { TokenType.ID, TokenType.LPAR, TokenType.NOT, TokenType.ZERO, TokenType.ONE } },
            { TokenType.ZERO, new TokenType[] { TokenType.SEMICOLON, TokenType.OR, TokenType.XOR, TokenType.AND, TokenType.RPAR } },
        };
        public Operation<TokenType, TokenType> Operation { get; private set; }

        public Parser(IEnumerable<TokenTemplate> tokenTemplates, Operation<TokenType, TokenType> operation)
        {
            TokenTemplates = tokenTemplates;
            Operation = operation;
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

        public void Anilize(string appCode, IEnumerable<Token>? tokens = null)
        {
            Stack<(Token CurrentToken, IEnumerable<TokenType> ExceptedTokens)> s = new();
            tokens ??= GetTokens(appCode);
            var tokensList = tokens.ToList();
            s.Push((tokensList[0], new List<TokenType> { TokenType.ID, TokenType.SEMICOLON }));
            int counter = 1;

            while (s.Count > 0 && counter < tokensList.Count)
            {
                var (CurrentToken, ExceptedTokens) = s.Pop();
                var currentTokenType = CurrentToken.TokenType;
                var exceptedTokenTypes = ExceptedTokens;
                if (!exceptedTokenTypes.Contains(currentTokenType))
                {
                    var excTTasStr = "";
                    foreach (var exceptedTokenType in exceptedTokenTypes)
                    {
                        excTTasStr += $" {Enum.GetName(exceptedTokenType)} or";
                    }
                    throw new ArgumentException($"Excepted{excTTasStr[..^2]} at {CurrentToken.Position}\nbut got {Enum.GetName(currentTokenType)}");
                }

                s.Push((tokensList[counter], ExceptedTokenTypesForTokenType[currentTokenType]));
                counter += 1;
            }
        }

        public List<(string ID, string Value)> Parse(string appCode, IEnumerable<Token>? tokens = null)
        {
            List<(string ID, string Value)> variables = new();
            tokens ??= GetTokens(appCode);
            if (tokens.Count() < 1)
                return variables;

            var exceptedTokenTypes = new TokenType[] { TokenType.ID, TokenType.SEMICOLON };
            var s = new Stack<Token>();
            var operands = new Stack<Token>();
            var operations = new Stack<TokenType>();
            var tokensList = tokens.ToList();
            TokenType tokenTypeBuffer;
            Token operandBuffer = null!;

            try
            {
                foreach (var token in tokensList)
                {
                    tokenTypeBuffer = token.TokenType;

                    if (!exceptedTokenTypes.Contains(tokenTypeBuffer))
                    {
                        var excTTasStr = "";
                        foreach (var exceptedTokenType in exceptedTokenTypes)
                        {
                            excTTasStr += $" {Enum.GetName(exceptedTokenType)} or";
                        }
                        throw new ArgumentException($"Excepted{excTTasStr[..^2]} at {token.Position} but got {Enum.GetName(tokenTypeBuffer)}");
                    }

                    if (tokenTypeBuffer is TokenType.ID || tokenTypeBuffer is TokenType.ZERO || tokenTypeBuffer is TokenType.ONE)
                        operands.Push(token);
                    else if (tokenTypeBuffer is TokenType.RPAR)
                    {
                        while (operations.Peek() is not TokenType.LPAR)
                        {
                            var variableBuffer = Calculate(ref operands, ref operations, variables);

                            if (variableBuffer is not null)
                                variables.Add(((string, string))variableBuffer);
                        }
                        operations.Pop();
                    }
                    else
                        operations.Push(tokenTypeBuffer);

                    exceptedTokenTypes = (TokenType[])ExceptedTokenTypesForTokenType[token.TokenType];
                }

                while (operations.Count > 0)
                {
                    var variableBuffer = Calculate(ref operands, ref operations, variables);

                    if (variableBuffer is not null)
                    {
                        var index = variables.FindIndex(x => x.ID == variableBuffer.Value.Item1);
                        if (index >= 0)
                            variables[index] = ((string, string))variableBuffer;
                        else
                            variables.Add(((string, string))variableBuffer);
                    }
                }
            }
            catch (InvalidOperationException ioe)
            {
                throw new InvalidOperationException(ioe.Message + $" at {(operandBuffer is null ? 0 : operandBuffer.Position)}");
            }

            return variables;
        }

        (string, string)? Calculate(
            ref Stack<Token> operands,
            ref Stack<TokenType> operations,
            IEnumerable<(string ID, string Value)> variables)
        {
            var isVariable = bool (Token token, IEnumerable<(string ID, string Value)> variables, out TokenType value) =>
            {
                if (token.TokenType == TokenType.ID)
                {
                    if (!variables.Any(x => x.ID == token.Text))
                        throw new ArgumentException($"Unknown variable {token.Text} at {token.Position}");

                    value =
                        variables.First(x => x.ID == token.Text)
                        .Value == Enum.GetName(TokenType.ZERO)
                        ? TokenType.ZERO : TokenType.ONE;
                    return true;
                }

                value = TokenType.ZERO;
                return false;
            };
            TokenType value;
            TokenType operandTypeBuffer;

            var tokenTypeBuffer = operations.Pop();
            switch (tokenTypeBuffer)
            {
                case TokenType.ASSIGN:
                    var operand1 = operands.Pop();
                    var varBuffer = operands.Pop();
                    if (varBuffer.TokenType is not TokenType.ID)
                        throw new ArgumentException($"Assignment can be applied only to variables ({varBuffer.Position})");
                    else if (isVariable(operand1, variables, out value))
                        return (varBuffer.Text, Enum.GetName(value)!);

                    return (varBuffer.Text, operand1.Text);

                case TokenType.OR or TokenType.XOR or TokenType.AND:
                    operand1 = operands.Pop();
                    operandTypeBuffer = operand1.TokenType;
                    if (isVariable(operand1, variables, out value))
                        operandTypeBuffer = value;
                    var result = Operation.Calculate(tokenTypeBuffer, operandTypeBuffer, operands.Pop().TokenType);
                    operands.Push(new Token(result, Enum.GetName(result)!, operand1.Position));
                    break;

                case TokenType.NOT:
                    operand1 = operands.Pop();
                    operandTypeBuffer = operand1.TokenType;
                    if (isVariable(operand1, variables, out value))
                        operandTypeBuffer = value;
                    result = Operation.Calculate(tokenTypeBuffer, operandTypeBuffer);
                    operands.Push(new Token(result, Enum.GetName(result)!, operand1.Position));
                    break;

                default:
                    break;
            }

            return null;
        }
    }
}

