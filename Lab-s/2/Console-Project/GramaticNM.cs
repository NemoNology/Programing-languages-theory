namespace Console_Project
{
    public class GramaticNM
    {
        #region Not enteresting...
        public List<(string Key, string Value)> Rules;
        public string StartChain;
        public List<string> Terminals;
        public List<string> Nonterminals;

        public GramaticNM(List<(string, string)> rules, string startChain = "S")
        {
            Rules = rules;
            StartChain = startChain;
        }
        #endregion

        public GramaticNM(
            List<string> vn,
            List<string> vt,
            List<(string, string)> rules,
            string startChain = "S"
        )
        {
            Nonterminals = vn;
            Terminals = vt;
            Rules = rules;
            StartChain = startChain;
        }

        public async Task<(bool TryResult, string ParsedWord)> TryParseWordNM(
            string parsingWord,
            bool isPrinted = true
        )
        {
            var parsedWord = parsingWord;
            for (int k = 1; k <= parsingWord.Length; k++)
            {
                string termCharacter = "";
                for (int i = parsingWord.Length - k; i >= 0; i--)
                {
                    termCharacter = termCharacter.Insert(0, parsingWord[i].ToString());
                    for (int j = 0; j < Rules.Count; j++)
                    {
                        var (Key, Value) = Rules[j];

                        if (Value == termCharacter)
                        {
                            parsedWord = parsingWord.Remove(i, termCharacter.Length);
                            parsedWord = parsedWord.Insert(i, Key);
                            var buffer = parsedWord;
                            parsedWord = (await TryParseWordNM(parsedWord)).ParsedWord;
                            if (parsedWord == StartChain)
                            {
                                if (isPrinted)
                                {
                                    var index = buffer.IndexOf(Key);
                                    buffer[..index].PrintColored(ConsoleColor.DarkMagenta);
                                    buffer
                                        .Substring(index, Key.Length)
                                        .PrintColored(ConsoleColor.Cyan);
                                    buffer[(index + 1)..].PrintColored(ConsoleColor.DarkMagenta);
                                    Console.Write("\t\t");
                                    $"{Key} --> {Value}".PrintColored(
                                        ConsoleColor.DarkCyan,
                                        isWriteLine: true
                                    );
                                }

                                return (true, parsedWord);
                            }
                        }
                    }
                }
            }

            return (false, parsedWord);
        }

        public void OutputLanguage(
            int strDepth = 10,
            int str2Depth = 20,
            string word = "S",
            int n = 0
        )
        {
            string str = OutputGramatic(strDepth, word, n);
            string str2 = OutputGramatic(str2Depth, word, n);
            // str.PrintColored(ConsoleColor.Blue, isWriteLine: true);
            // str2.PrintColored(ConsoleColor.Blue, isWriteLine: true);
            "L = { ".PrintColored(ConsoleColor.Green);
            int count = 0;
            List<(char, int)> list = new List<(char, int)>(str.Length);
            for (int i = 0; i < str.Length; i++)
            {
                list.Add(new());

                for (int j = 0; j < list.Count; j++)
                {
                    if (list[j].Item1 == str[i])
                    {
                        list[j] = (list[j].Item1, list[j].Item2 + 1);
                        count++;
                    }
                }

                //foreach (var pair in list)
                //{
                //    if (pair.First == str[i])
                //    {
                //        pair.Second += 1;
                //        count++;
                //    }
                //}
                if (count == 0)
                    list.Add(new(str[i], 0));
                count = 0;
            }
            count = 0;
            int count2 = 0;
            int count3 = 0;
            //foreach (Pair<char, int> pair1 in list)

            foreach (var pair1 in list)
            {
                foreach (var pair2 in list)
                {
                    if (pair1.Item2 == pair2.Item2)
                    {
                        count++;
                    }
                }
                //Console.WriteLine(count);
                if (pair1.Item1 != '\0')
                {
                    if (count == 1)
                    {
                        $"'{pair1.Item1}'^n{count3}; ".PrintColored(ConsoleColor.Blue);
                        count = 0;
                        count3++;
                    }
                    else if (count > 1)
                    {
                        $"'{pair1.Item1}'^m{count2}; ".PrintColored(ConsoleColor.Blue);
                        count2++;
                    }
                }
                count = 0;
            }
            "(Where:".PrintColored(ConsoleColor.Magenta);
            if (count3 != 0)
                " ni > 0".PrintColored(ConsoleColor.Magenta);

            if (count2 != 0)
                ", mi > 0".PrintColored(ConsoleColor.Magenta);
            ")".PrintColored(ConsoleColor.Magenta);
            "}".PrintColored(ConsoleColor.Green, isWriteLine: true);
        }

        public string OutputGramatic(int max = 30, string word = "S", int n = 0)
        {
            string newWord = word;
            for (int i = 0; i < word.Length; i++)
            {
                string termCharacter = "";
                for (int j = i; j < word.Length; j++)
                {
                    termCharacter += word[j];
                    foreach (var rule in Rules)
                    {
                        if (rule.Key == termCharacter & n < max)
                        {
                            newWord = word.Remove(i, termCharacter.Length);
                            newWord = newWord.Insert(i, rule.Value);
                            n++;
                            newWord = OutputGramatic(max, newWord, n);
                            int c = 0;
                            if (n == max - 1)
                            {
                                foreach (var rule2 in Rules)
                                {
                                    if (newWord.Contains(rule2.Key))
                                    {
                                        c++;
                                    }
                                }
                                if (c == 0)
                                {
                                    return newWord;
                                }
                            }
                        }
                    }
                }
            }
            return newWord;
        }

        public void PrintRules()
        {
            "\nRules:\n".PrintColored(ConsoleColor.DarkMagenta);
            foreach (var rule in Rules)
            {
                $"'{rule.Key}' --> '{rule.Value}';\n".PrintColored(ConsoleColor.Blue);
            }
        }

        /// <summary>
        /// ��������� ������ �� ���������� ����
        /// </summary>
        /// <param name="text">������ ��� ��������</param>
        /// <returns>������ �� ���������� �����</returns>
        public string Translate(
            string text = "S",
            int maxRepetitionsCount = 1000,
            bool isTreePrinted = false
        )
        {
            int count = 0;
            bool isEnd = false; // true - ���� �� ���� �� ������ �����������
            List<string> buffer = new();

            while (count < maxRepetitionsCount)
            {
                if (isEnd)
                    break;

                count++;
                isEnd = true;
                // ��������� �� ������� ������ ������� ����� � ������
                foreach (var rule in Rules)
                {
                    string key = rule.Key;
                    string value = rule.Value;

                    int pos = text.IndexOf(key);

                    if (pos != -1) // ���� ���� ������
                    {
                        if (isTreePrinted)
                        {
                            buffer.Add(text);
                        }

                        text = text.Remove(pos, key.Length);
                        text = text.Insert(pos, value);

                        isEnd = false;
                    }
                }
            }

            if (isTreePrinted)
            {
                int i = 1;
                var len = buffer.Count;

                var color = ConsoleColor.Cyan;

                if (len > 0)
                    buffer[0].PrintColored(color);

                while (i + 1 < len)
                {
                    var t = buffer[i];
                    var tn = i + 1 >= len ? t : buffer[i + 1];
                    string res = "";
                    int j = 0;

                    while (j < t.Length)
                    {
                        if (i + 1 == len - 1 || t[j] != tn[j])
                        {
                            res += t[j];
                        }
                        else
                        {
                            res += '|';
                        }

                        j++;
                    }

                    res.GetCharsAsTreeNode(tabCount: i - 1, isOnlyLastHorizontalFill: true)
                        .PrintColored(color, isWriteLine: true);

                    i++;
                }

                text.GetCharsAsTreeNode(tabCount: i - 1).PrintColored(color, isWriteLine: true);
            }

            return text;
        }

        /// <summary>
        /// ���������� ��� ����������
        /// </summary>
        /// <returns></returns>
        public string GetTypeGrammar()
        {
            bool isTypeOne = true;
            bool isTypeTwo = true;
            bool isTypeThree = true;

            bool isEachTermPosBigger = true;
            bool isEachTermPosSmaller = true;
            foreach (var r in Rules)
            {
                // �������� ��������������� ������� ���� ����������
                isTypeOne &= r.Key.Length <= r.Value.Length;

                // �������� �������������� ������� ����
                foreach (var vt in Terminals)
                {
                    isTypeTwo &= !r.Key.Contains(vt);
                }

                if (isEachTermPosBigger || isEachTermPosSmaller)
                {
                    List<int> terminlPositions = new();
                    List<int> nonTerminlPositions = new();
                    foreach (var vn in Nonterminals)
                    {
                        int TEMP = r.Value.IndexOf(vn);
                        if (TEMP != -1)
                        {
                            nonTerminlPositions.Add(TEMP);
                        }
                    }
                    foreach (var vt in Terminals)
                    {
                        int TEMP = r.Value.IndexOf(vt);
                        if (TEMP != -1)
                        {
                            terminlPositions.Add(TEMP);
                        }
                    }
                    foreach (int pos in terminlPositions)
                    {
                        foreach (int posNonTerm in nonTerminlPositions)
                        {
                            isEachTermPosBigger &= pos > posNonTerm;
                            isEachTermPosSmaller &= pos < posNonTerm;
                        }
                    }
                    if ((isEachTermPosBigger == false) && (isEachTermPosSmaller == false))
                    {
                        isTypeThree = false;
                    }
                }
            }
            Console.WriteLine("Is gramatic is related to next types of Khomskiy gramar:");
            string res = "0;";
            if (isTypeOne)
                res += " 1;";
            if (isTypeTwo)
                res += " 2;";
            if (isTypeThree)
                res += " 3;";
            return res;
        }

        public string findChain(string word, out bool isFoundable, bool isPrinted = false)
        {
            string newWord = word;
            for (int k = 1; k <= word.Length; k++)
            {
                string termCharacter = "";
                for (int i = word.Length - k; i >= 0; i--)
                {
                    termCharacter = termCharacter.Insert(0, word[i].ToString());
                    for (int j = 0; j < Rules.Count; j++)
                    {
                        if (Rules[j].Value == termCharacter)
                        {
                            newWord = word.Remove(i, termCharacter.Length);
                            newWord = newWord.Insert(i, Rules[j].Key);
                            string str = newWord;
                            newWord = findChain(newWord, out _, isPrinted);
                            if (newWord == "S")
                            {
                                if (isPrinted)
                                {
                                    $"\n{str}\t[{Rules[j].Key} --> {Rules[j].Value}]".PrintColored(
                                        ConsoleColor.DarkCyan
                                    );
                                }
                                isFoundable = true;
                                return newWord;
                            }
                        }
                    }
                }
            }
            isFoundable = false;
            return newWord;
        }
    }
}
