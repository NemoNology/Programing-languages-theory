using System.Collections.Generic;
using System.Windows;
using System.Windows.Controls;
using CSharp_console.Implementations.LexicalParser;
using CSharp_console.Implementations.LexicalParser.Tokens;
using System;

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

            lexer = new(templates);
        }

        Parser lexer;

        private void OnInputCodeFragmentTextChanged(object sender, TextChangedEventArgs e)
        {
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

                outputError.Content = "";
            }
            catch (Exception exc)
            {
                outputError.Content = exc.Message;
            }

        }
    }
}
