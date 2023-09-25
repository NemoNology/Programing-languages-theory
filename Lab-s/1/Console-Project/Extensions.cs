namespace Console_Project
{
    public static class Extensions
    {
        public static void PrintColored<T>(
            this IEnumerable<T> str,
            ConsoleColor foregrounColor = ConsoleColor.White,
            ConsoleColor backgroundColor = ConsoleColor.Black,
            bool isWriteLine = false
        )
        {
            Console.BackgroundColor = backgroundColor;
            Console.ForegroundColor = foregrounColor;
            var end = isWriteLine ? Environment.NewLine : "";
            Console.Write(str + end);
            Console.ResetColor();
        }

        public static List<int> FindAllIndices(this string str, string searchedValue)
        {
            List<int> indices = new();
            var n = searchedValue.Length;
            var len = str.Length - n;

            for (int i = 0; i <= len; i++)
            {
                if (str[i..].StartsWith(searchedValue))
                {
                    indices.Add(i);
                }
            }

            return indices;
        }

        public static List<int> FindAllIndexOf<T>(this IEnumerable<T> chain, T searchedValue)
        {
            List<int> indices = new();
            var entor = chain.GetEnumerator();
            var i = 0;

            while (entor.MoveNext())
            {
                if (entor.Current!.Equals(searchedValue))
                {
                    indices.Add(i);
                }

                i++;
            }

            return indices;
        }
    
        
    }
}
