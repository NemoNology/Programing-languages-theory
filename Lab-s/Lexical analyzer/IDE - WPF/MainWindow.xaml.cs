using System.Collections.Generic;
using System.Windows;
using System.Windows.Controls;
using CSharp_console.Implementations.LexicalParser;
using CSharp_console.Implementations.LexicalParser.Tokens;
using System;
using System.Threading;
using IDE.Implementations.Lexical_parser;

namespace IDE
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();

            var templates = new List<TokenTemplate>()
            {
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
                new(TokenType.SEMICOLON, ";")
            };

            Func<TokenType, bool> IsNumber = new((TokenType tokenType) => !Enum.Equals(tokenType, TokenType.ZERO) || !Enum.Equals(tokenType, TokenType.ONE));

            lexer = new(templates,
                new Operation<TokenType, TokenType>(
                    new Dictionary<TokenType, Func<TokenType, TokenType>>()
                    {
                        { TokenType.NOT, (TokenType operand) =>
                        {
                            if (operand is TokenType.ONE)
                                return TokenType.ZERO;
                            else if (operand is TokenType.ZERO)
                                return TokenType.ONE;
                            else throw new ArgumentException($"Invalid operand ({nameof(operand)}) for {nameof(TokenType.NOT)} operation");
                        } }
                    },
                    new Dictionary<TokenType, Func<TokenType, TokenType, TokenType>>()
                    {
                        { TokenType.OR, (TokenType operand1, TokenType operand2) =>
                        {
                            if (!IsNumber(operand1) || !IsNumber(operand2))
                            {
                                throw new ArgumentException($"Invalid operand(s) for {nameof(TokenType.OR)} operation");
                            }
                            else if (operand1 is TokenType.ONE || operand2 is TokenType.ONE)
                            {
                                return TokenType.ONE;
                            }
                            else return TokenType.ZERO;
                        } },
                        { TokenType.XOR, (TokenType operand1, TokenType operand2) =>
                        {
                            if (!IsNumber(operand1) || !IsNumber(operand2))
                            {
                                throw new ArgumentException($"Invalid operand(s) for {nameof(TokenType.XOR)} operation");
                            }
                            else if (Enum.Equals(operand1, operand2))
                            {
                                return TokenType.ZERO;
                            }
                            else return TokenType.ONE;
                        } },
                        { TokenType.AND, (TokenType operand1, TokenType operand2) =>
                        {
                            if (!IsNumber(operand1) || !IsNumber(operand2))
                            {
                                throw new ArgumentException($"Invalid operand(s) for {nameof(TokenType.AND)} operation");
                            }
                            else if (operand1 is TokenType.ONE && operand2 is TokenType.ONE)
                            {
                                return TokenType.ONE;
                            }
                            else return TokenType.ZERO;
                        } }
                    }
                ));
        }

        Parser lexer;

        private void OnCodeInputTextChanged(object sender, TextChangedEventArgs args)
        {
            Analize();
        }

        void Analize()
        {
            Dispatcher.Invoke(() =>
            {
                if (inputCodeFragment.Text.Trim() == "")
                    return;

                try
                {
                    outputTokenTable.Items.Clear();
                    outputParseResult.Items.Clear();
                    var codeFragment = inputCodeFragment.Text;
                    var tokens = lexer.GetTokens(codeFragment);
                    var variables = lexer.Parse(codeFragment, tokens);

                    foreach (var token in tokens)
                    {
                        outputTokenTable.Items.Add(token);
                    }

                    foreach (var variable in variables)
                    {
                        outputParseResult.Items.Add(variable);
                    }

                    outputError.Text = "";
                }
                catch (Exception exc)
                {
                    outputError.Text = exc.Message;
                }
            });
        }
    }
}
