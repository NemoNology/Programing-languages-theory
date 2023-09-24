using Console_Project;

List<(string, string)> rules =
    new()
    {
        ("S", "T"),
        ("S", "T+S"),
        ("S", "T-S"),
        ("T", "F"),
        ("T", "F*T"),
        ("F", "a"),
        ("F", "b")
    };
var endChain = "a-b*a+b";
var g = new Gramatic_Vlad(rules, "S");

beautyOutput(g, endChain);

// // // // // //

rules = new()
{
    ("S", "aSBC"),
    ("S", "abC"),
    ("CB", "BC"),
    ("bB", "bb"),
    ("bC", "bc"),
    ("cC", "cc")
};
endChain = "aaabbbccc";
g = new Gramatic_Vlad(rules, "S");

beautyOutput(g, endChain);

rules = new()
{
    ("S", "T"),
    ("S", "+T"),
    ("S", "-T"),
    ("T", "F"),
    ("T", "TF"),
    ("F", "0"),
    ("F", "1"),
    ("F", "2"),
    ("F", "3"),
    ("F", "4"),
    ("F", "5"),
    ("F", "6"),
    ("F", "7"),
    ("F", "8"),
    ("F", "9")
};

// g = new Gramatic(rules, "S");
// beautyOutput(g, "-147");


async void beautyOutput(Gramatic_Vlad g, string word)
{
    var line = Enumerable.Repeat("-", 50).ToArray().Aggregate((x, y) => x + y);
    line.PrintColored(ConsoleColor.White, isWriteLine: true);
    "Parsing word ".PrintColored(ConsoleColor.Blue);
    word.PrintColored(ConsoleColor.Green);
    "...\n".PrintColored(ConsoleColor.Blue);
    var res = (await g.TryParseWord_Vlad_Optimized(word, true)).TryResult;
    $"Is ".PrintColored(ConsoleColor.Blue);
    word.PrintColored(ConsoleColor.Green);
    $" is possible? - ".PrintColored(ConsoleColor.Blue);
    res.ToString().PrintColored(ConsoleColor.Red, isWriteLine: true);
    line.PrintColored(ConsoleColor.White, isWriteLine: true);
}
