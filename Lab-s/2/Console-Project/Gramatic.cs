namespace Console_Project
{
    public class Gramatic
    {
        public Dictionary<string, List<string>> Rules { get; private set; }
        public Dictionary<string, List<string>> RulesReversed { get; private set; } = null!;
        public List<string> Terminals { get; private set; } = null!;
        public List<string> Nonterminals { get; private set; } = null!;
        string StartChain;

        public Gramatic(Dictionary<string, List<string>> rules, string startChain)
        {
            Rules = rules;
            StartChain = startChain;
            Init();
        }

        public bool TryParseWord_Recursive(string word, string startChain, bool isPrinted = true)
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
                {
                    q0.PrintColored(ConsoleColor.Cyan);
                    Console.Write(" <-- [ ");
                }

                foreach (var key in keys)
                {
                    var indices = q0.FindAllIndices(key);
                    var lengthBuffer = indices.Count;
                    counter++;

                    foreach (var index in indices)
                    {
                        var values = RulesReversed[key];
                        counter++;

                        foreach (var value in values)
                        {
                            buffer = q0.Remove(index, key.Length).Insert(index, value);
                            counter++;

                            if (buffer == startChain)
                            {
                                buffer.PrintColored(ConsoleColor.Magenta);
                                if (isPrinted)
                                    Console.Write(" ]");
                                $"\n{word} is possible [Iterations: {counter}]\n".PrintColored(
                                    ConsoleColor.Green
                                );
                                return true;
                            }

                            if (isPrinted)
                            {
                                Console.Write(buffer + "; ");
                            }

                            q.Push(buffer);
                        }
                    }
                }

                if (isPrinted)
                    Console.Write("]\n");
            }

            if (isPrinted)
                $"\n{word} is not possible [Iterations: {counter}]".PrintColored(ConsoleColor.Red);
            return false;
        }

        public List<string> GetAllCompletedWordsByDepth(int depth)
        {
            List<string> words = new();
            Queue<string> q = new();
            q.Enqueue(StartChain);
            string buffer;

            Reduce();

            var keys = Rules.Keys;

            for (int i = 0; i <= depth; i++)
            {
                buffer = q.Dequeue();

                foreach (var key in keys)
                {
                    var indices = buffer.FindAllIndices(key);

                    foreach (var index in indices)
                    {
                        var rules = Rules[key];

                        foreach (var value in rules)
                        {
                            q.Enqueue(buffer.Remove(index, key.Length).Insert(index, value));
                        }
                    }
                }
            }

            while (q.Count > 0)
            {
                buffer = q.Dequeue();

                if (TryCompleteWord(buffer, out var list))
                {
                    words.Add(buffer);
                }
            }

            return words;
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
                if (word.Any(key))
                {
                    return false;
                }
            }

            return true;
        }

        bool TryCompleteWord(string word, out List<string> completedWords)
        {
            var keys = Rules.Keys;
            var res = new List<string>();

            do
            {
                foreach (var key in keys)
                {
                    var indices = word.FindAllIndices(key);

                    foreach (var index in indices)
                    {
                        foreach (var value in Rules[key])
                        {
                            var kl = key.Length;

                            if (value.Length <= kl)
                            {
                                res.Add(word.Remove(index, kl).Insert(index, value));
                            }
                        }
                    }
                }
            } while (res.Any(x => !IsCompletedWord(x)));

            completedWords = res;
            return false;
        }

        void Init()
        {
            var terminals = new List<string>();
            var nonterminals = new List<string>();
            var valuesBuffer = new List<(string key, string value)>();
            Dictionary<string, List<string>> res = new();

            var keys = Rules.Keys;

            foreach (var key in keys)
            {
                nonterminals.Add(key);

                foreach (var value in Rules[key])
                {
                    if (!terminals.Contains(value))
                    {
                        terminals.Add(value);
                    }

                    valuesBuffer.Add((key, value));
                }
            }

            var uniquesValues = valuesBuffer.Select(x => x.value).GroupBy(x => x).ToArray();

            foreach (var value in uniquesValues)
            {
                var key = value.Key;
                res.Add(key, valuesBuffer.Where(x => x.value == key).Select(x => x.key).ToList());
            }

            Terminals = terminals;
            Nonterminals = nonterminals;
            RulesReversed = res;
        }

        void Reduce()
        {
            foreach (var terminal in Terminals)
            {
                foreach (var nonterminal in Nonterminals)
                {
                    if (TryParseWord_Recursive(terminal, nonterminal))
                    {
                        List<string> buffer = new();

                        if (Rules.TryGetValue(nonterminal, out buffer!))
                        {
                            buffer.Add(terminal);
                        }

                        if (RulesReversed.TryGetValue(terminal, out buffer!))
                        {
                            buffer.Add(nonterminal);
                        }
                    }
                }
            }
        }
    }
}
