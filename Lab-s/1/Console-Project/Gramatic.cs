using System.ComponentModel;

namespace Console_Project
{
    public class Gramatic_Vlad
    {
        #region Not enteresting...
        public List<(string Key, string Value)> Rules;
        public string StartChain;

        public Gramatic_Vlad(List<(string, string)> rules, string startChain)
        {
            Rules = rules;
            StartChain = startChain;
        }
        #endregion

        public async Task<(bool TryResult, string ParsedWord)> TryParseWord_Vlad_Optimized(
            string parsingWord,
            bool isPrinted = false
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
                            parsedWord = (
                                await TryParseWord_Vlad_Optimized(parsedWord, isPrinted)
                            ).ParsedWord;
                            if (parsedWord == StartChain)
                            {
                                if (isPrinted)
                                {
                                    var index = buffer.IndexOf(Key);
                                    buffer[..index].PrintColored(ConsoleColor.DarkMagenta);
                                    buffer.Substring(index, Key.Length)
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
    }
}
