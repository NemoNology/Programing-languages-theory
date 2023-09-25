namespace Console_Project
{
    public class Gramatic
    {
        Dictionary<string, List<string>> Rules;
        Dictionary<string, List<string>> RulesReversed = null!;
        string StartChain;

        public Gramatic(Dictionary<string, List<string>> rules, string startChain)
        {
            Rules = rules;
            StartChain = startChain;
            Init();
        }

        public bool TryParseWord_Recursive(string word, bool isPrinted = true)
        {
            Stack<string> q = new();
            q.Push(word);
            string buffer = "";
            int counter = 0;

            if (isPrinted)
            {
                word.PrintColored(ConsoleColor.Magenta);
                " parsing:\n".PrintColored(ConsoleColor.Blue);
            }

            var keys = RulesReversed.Keys;

            while (q.Count > 0)
            {
                var q0 = q.Pop();
                counter++;

                if (isPrinted)
                    Console.Write($"\t{q0} --> [ ");

                foreach (var key in keys)
                {
                    var indices = q0.FindAllIndices(key);
                    counter++;

                    foreach (var index in indices)
                    {
                        var values = RulesReversed[key];
                        counter++;

                        foreach (var value in values)
                        {
                            buffer = q0.Remove(index, key.Length).Insert(index, value);
                            counter++;

                            if (buffer == StartChain)
                            {
                                if (isPrinted)
                                {
                                    buffer.PrintColored(ConsoleColor.Magenta);
                                    // Console.Write("\n]");
                                    $"\n{word} is possible [Iterations: {counter}]".PrintColored(
                                        ConsoleColor.Green
                                    );
                                }
                                return true;
                            }

                            if (isPrinted)
                                Console.Write(buffer + "; ");

                            q.Push(buffer);
                        }
                    }
                }

                if (isPrinted)
                    Console.Write("];");
            }

            if (isPrinted)
                $"\n{word} is not possible [Iterations: {counter}]".PrintColored(ConsoleColor.Red);
            return false;
        }

        public bool TryParseWord_Surf(string word, bool isPrinted = true)
        {
            var n = word.Length;
            Stack<string> q = new();
            q.Push(StartChain);
            string buffer = "";

            var keys = Rules.Keys;

            while (q.Count > 0)
            {
                var q0 = q.Pop();

                foreach (var key in keys)
                {
                    var indices = q0.FindAllIndices(key);

                    foreach (var index in indices)
                    {
                        var rules = Rules[key];

                        foreach (var value in rules)
                        {
                            var kLen = key.Length;

                            if (q0.Length - kLen + value.Length <= n)
                            {
                                buffer = q0.Remove(index, kLen).Insert(index, value);
                            }

                            if (buffer == word)
                            {
                                if (isPrinted)
                                {
                                    Console.Write(q0 + "; ");
                                    $"{word}\n{word} is possible".PrintColored(ConsoleColor.Green);
                                }
                                return true;
                            }
                            else if (!IsCompletedWord(buffer))
                            {
                                if (isPrinted)
                                    Console.Write(buffer + "; ");

                                q.Push(buffer);
                            }
                        }
                    }
                }
            }

            if (isPrinted)
                $"\n{word} is not possible".PrintColored(ConsoleColor.Red);
            return false;
        }

        bool IsCompletedWord(string word)
        {
            foreach (var key in Rules.Keys)
            {
                var indices = word.FindAllIndices(key);

                if (indices.Count > 0)
                {
                    return false;
                }
            }

            return false;
        }

        void Init()
        {
            var valuesBuffer = new List<(string key, string value)>();
            Dictionary<string, List<string>> res = new();

            foreach (var key in Rules.Keys)
            {
                foreach (var value in Rules[key])
                {
                    valuesBuffer.Add((key, value));
                }
            }

            var uniquesValues = valuesBuffer.Select(x => x.value).GroupBy(x => x).ToArray();

            foreach (var value in uniquesValues)
            {
                var key = value.Key;
                res.Add(key, valuesBuffer.Where(x => x.value == key).Select(x => x.key).ToList());
            }

            RulesReversed = res;
        }
    }
}
