using System.Collections.Generic;

namespace Lab2
{
    class Program
    {

        class Rule
        {
            public string key;
            public string value;
            public bool isCycled;
            public Rule(string key, string value, bool isCycled)
            {
                this.key = key;
                this.value = value;
                this.isCycled = isCycled;
            }
            public Rule(string key, string value)
            {
                this.key = key;
                this.value = value;
                this.isCycled = false;
            }
        }
        class Language
        {
            private List<Rule> rules;
            public void setRules(List<Rule> rules)
            {
                this.rules = rules;
            }
            public Language(List<Rule> rules)
            {
                this.rules = rules;
            }

            public string getRules()
            {
                string str = "";
                foreach (Rule rule in rules)
                {
                    str += rule.key + "-->" + rule.value + "\n";
                }
                return str;
            }

            public String findChain(string word)
            {
                string newWord = word;
                for (int k = 1; k <= word.Length; k++)
                {
                    string termCharacter = "";
                    for (int i = word.Length - k; i >= 0; i--)
                    {
                        termCharacter = termCharacter.Insert(0, word[i].ToString());
                        for (int j = 0; j < rules.Count; j++)
                        {
                            if (rules[j].value.Equals(termCharacter))
                            {
                                newWord = word.Remove(i, termCharacter.Length);
                                newWord = newWord.Insert(i, rules[j].key);
                                string str = newWord;
                                newWord = findChain(newWord);
                                if (newWord == "S")
                                {
                                    Console.WriteLine(str + "\n" + rules[j].key + "-->" + rules[j].value);
                                    return newWord;
                                }
                            }
                        }
                    }
                }
                return newWord;
            }
            public void generateGrammar2()
            {
                string str = findGrammar();

                
                string output = "Грамматика ( ";
                Stack<string> characters = new Stack<string>();
                for (int i = 0; i < str.Length; i++)
                {
                    string ch = str;
                    if (!characters.Contains(ch))
                    {
                        characters.Push(ch);
                    }

                }
                output += "{";
                while (characters.Count > 1)
                    output += " " + characters.Pop() + ",";
                output += characters.Pop() + "} | ";

            }
            public void findLanguage()
            {
                string str = findGrammar(10);
                string str2 = findGrammar(20);
                Console.WriteLine(str);
                Console.WriteLine(str2);
                string output = "L = { ";
                int count = 0;
                List<(char, int)> list = new List<(char, int)>(str.Length);
                for (int i = 0; i < str.Length; i++)
                {
                    list.Add(new ());

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
                        list.Add(new (str[i], 0));
                    count = 0;
                }
                count= 0;
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
                    Console.WriteLine(count);
                    if (count == 1)
                    {
                        output += $"'{pair1.Item1}' ^n{count3}, ";
                        count = 0;
                        count3++;
                    }
                    else
                    {
                        output += $"'{pair1.Item1}' ^m{count2}, ";
                        count2++;
                    }
                    count= 0;
                }
                output += "|";
                if (count3 != 0)
                    output += " ni > 0";

                if (count2 != 0)
                    output += ", mi > 0";
                output += "}";
                Console.WriteLine(output);
            }

            public string findGrammar(int max = 30, string word = "S", int n = 0)
            {
                string newWord = word;
                for (int i = 0; i < word.Length; i++)
                {
                    string termCharacter = "";
                    for (int j = i; j < word.Length; j++)
                    {
                        termCharacter += word[j];
                        foreach (Rule rule in rules)
                        {
                            if (rule.key == termCharacter & n < max)
                            {
                                newWord = word.Remove(i, termCharacter.Length);
                                newWord = newWord.Insert(i, rule.value);
                                n++;
                                newWord = findGrammar(max, newWord, n);
                                int c = 0;
                                if (n == max - 1)
                                {
                                    foreach (Rule rule2 in rules)
                                    {

                                        if (newWord.Contains(rule2.key))
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
        }
        static void Main(string[] args)
        {
            List<Rule> rules1 = new List<Rule> {
                new Rule("S", "aaCFD"),
                new Rule("AD", "D"),
                new Rule("F", "AFB", true),
                new Rule("F", "AB"),
                new Rule("Cb", "bC"),
                new Rule("AB", "bBA"),
                new Rule("CB", "C"),
                new Rule("Ab", "bA"),
                new Rule("bCD","e"),
            };
            List<Rule> rules2 = new List<Rule> {
                new Rule("S","A/"),
                new Rule("S","B/"),
                new Rule("A","a"),
                new Rule("A","Ba"),
                new Rule("B","b"),
                new Rule("B","Bb"),
                new Rule("B","Ab"),
            };
            Language language1 = new Language(rules1);
            Language language2 = new Language(rules2);

            Console.WriteLine(language1.getRules());
            language1.findLanguage();
            Console.WriteLine();
            Console.WriteLine(language2.getRules());
            language2.findLanguage();
        }

    }
}