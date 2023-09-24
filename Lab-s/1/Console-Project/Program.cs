using Console_Project;

var (i1, i2) = (Fasade.endChain1, Fasade.endChain2);

// Fasade.BeautyOutput(Fasade.g_v1, i1);
// Fasade.BeautyOutput(Fasade.g_v2, i2);

var (g1, g2) = (Fasade.g1, Fasade.g2);

g1.TryParseWord("T");

class Fasade
{
    public static Dictionary<string, List<string>> rules1 =
        new()
        {
            {
                "S",
                new() { "T", "T+S", "T-S" }
            },
            {
                "T",
                new() { "F", "F*T" }
            },
            {
                "F",
                new() { "a", "b" }
            }
        };

    public static Dictionary<string, List<string>> rules2 =
        new()
        {
            {
                "S",
                new() { "aSBC", "abC" }
            },
            {
                "CB",
                new() { "BC" }
            },
            {
                "bB",
                new() { "bb" }
            },
            {
                "bC",
                new() { "bc" }
            },
            {
                "cC",
                new() { "cc" }
            }
        };

    public static List<(string, string)> rules_v1 =
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

    public static List<(string, string)> rules_v2 =
        new()
        {
            ("S", "aSBC"),
            ("S", "abC"),
            ("CB", "BC"),
            ("bB", "bb"),
            ("bC", "bc"),
            ("cC", "cc")
        };
    public static string endChain1 = "a-b*a+b";
    public static string endChain2 = "aaabbbccc";
    public static Gramatic_Vlad g_v1 = new(rules_v1, "S");
    public static Gramatic_Vlad g_v2 = new(rules_v2, "S");
    public static Gramatic g1 = new(rules1, "S");
    public static Gramatic g2 = new(rules2, "S");

    public async static void BeautyOutput(Gramatic_Vlad g, string word)
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
}
