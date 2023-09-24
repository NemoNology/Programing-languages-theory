namespace Console_Project
{
    public class Gramatic
    {
        Dictionary<string, List<string>> Rules;
        string StartChain;

        public Gramatic(Dictionary<string, List<string>> rules, string startChain)
        {
            Rules = rules;
            StartChain = startChain;
        }

        public bool TryParseWord(string word, bool isPrinted = true)
        {
            var n = word.Length;
            Queue<string> q = new();
            q.Enqueue(StartChain);

            var keys = Rules.Keys;

            while (q.Count > 0)
            {
                var q0 = q.Dequeue();

                if (q0 == word)
                {
                    if (isPrinted)
                        Console.WriteLine($"Is {word} possible ");
                    return true;
                }

                if (isPrinted)
                    Console.Write(q0 + "\t: [");

                foreach (var key in keys)
                {
                    if (isPrinted)
                        Console.Write("\t: [");

                    var indices = q0.FindAllIndexOf(key);

                    foreach (var index in indices)
                    {
                        if (isPrinted)
                            Console.Write("\t: [");

                        foreach (var value in Rules[key])
                        {
                            var buffer = q0.Remove(index, key.Length).Insert(index, value);

                            if (buffer.Length < n)
                            {
                                if (isPrinted)
                                    Console.Write(buffer + "; ");

                                q.Enqueue(buffer);
                            }
                        }

                        if (isPrinted)
                            Console.Write("]");
                    }

                    if (isPrinted)
                        Console.Write("]");
                }

                if (isPrinted)
                    Console.Write("]");
            }

            return false;
        }
    }
}
