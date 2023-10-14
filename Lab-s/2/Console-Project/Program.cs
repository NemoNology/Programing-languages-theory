using Console_Project;

List<(string, string)> rules =
    new()
    {
        new("S", "S0"),
        new("S", "S1"),
        new("S", "P0"),
        new("S", "P1"),
        new("P", "N."),
        new("N", "0"),
        new("N", "1"),
        new("N", "N0"),
        new("N", "N1"),
    };
"----------------LAB 2------------------\n".PrintColored(ConsoleColor.White);
"---------------TASK 1------------------\n".PrintColored(ConsoleColor.White);
var g = new GramaticNM(rules);
g.PrintRules();
string[] chains = { "11.010", "0.1", "01.", "100" };

foreach (var chain in chains)
{
    g.findChain(chain, out var res);
    $"\nIs ".PrintColored(ConsoleColor.Gray);
    chain.PrintColored(ConsoleColor.Blue);
    " is possible? - ".PrintColored(ConsoleColor.Gray);
    if (res)
    {
        g.findChain(chain, out _, true);
        "\nYes".PrintColored(ConsoleColor.Green);
    }
    else
        "No".PrintColored(ConsoleColor.Red);
}
"\nLanguage: ".PrintColored(ConsoleColor.DarkMagenta);
g.OutputLanguage();
"\n---------------END----------------\n".PrintColored(ConsoleColor.White);
