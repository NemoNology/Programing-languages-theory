using Console_Project;

List<(string, string)> rules = new()
{
    new("S", "0S"),
    new("S", "0B"),
    new("B", "1B"),
    new("B", "1C"),
    new("C", "1C"),
    new("C", "/"),
};
"---------------TASK 11------------------\n".PrintColored(ConsoleColor.White);
"------------------A------------------".PrintColored(ConsoleColor.White);
var g = new GramaticNM(rules);
g.PrintRules();
var chain = g.Translate();
$"Chain: {chain}".PrintColored(ConsoleColor.Green);
$"\nChain as tree:".PrintColored(ConsoleColor.Magenta);
chain.PrintAsTree1();
"\n-----------------B------------------".PrintColored(ConsoleColor.White);
rules = new()
{
    ("S", "aA"), 
    ("S", "aB"), 
    ("S", "bA"), 
    ("A", "bS"),
    ("B", "aS"),
    ("B", "bB"),
    ("B", "/"),
};

g = new GramaticNM(rules);
g.PrintRules();
$"Chain: {g.Translate(maxRepetitionsCount: 7)}".PrintColored(ConsoleColor.Green);
"\n\n\n---------------TASK 12------------------\n".PrintColored(ConsoleColor.White);
"-----------------G1------------------".PrintColored(ConsoleColor.White);
rules = new()
{
    ("S", "S1"),
    ("S", "A0"),
    ("A", "A1"),
    ("A", "0"),
};
g = new GramaticNM(rules);
g.PrintRules();
$"Chain: {g.Translate()}".PrintColored(ConsoleColor.Green);
"\n-----------------G2------------------".PrintColored(ConsoleColor.White);
rules = new()
{
    ("S", "A1"),
    ("S", "B0"),
    ("S", "E1"),
    ("A", "S1"),
    ("B", "C1"),
    ("B", "D1"),
    ("C", "0"),
    ("D", "B1"),
    ("E", "E0"),
    ("E", "1"),
};
g = new GramaticNM(rules);
g.PrintRules();
$"Chain: {g.Translate(maxRepetitionsCount: 7)}".PrintColored(ConsoleColor.Green);
"\n----------G(L1 union L2)-------------".PrintColored(ConsoleColor.White);
rules = new()
{
    ("S", "S1"),
    ("S", "A0"),
    ("A", "A1"),
    ("A", "0"),
};
g = new GramaticNM(rules);
g.PrintRules();
$"Chain: 001".PrintColored(ConsoleColor.Green);
"\n---------------END----------------\n".PrintColored(ConsoleColor.White);
