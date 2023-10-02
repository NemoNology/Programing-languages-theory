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

        public static bool Any(this string str, string searchedValue)
        {
            int n = str.Length, l = searchedValue.Length;

            for (int i = 0; i < n - l; i++)
            {
                if (str.Substring(i, l) == searchedValue)
                {
                    return true;
                }
            }

            return false;
        }

        public static void Print<T>(this IEnumerable<T> list, string separator = "; ")
        {
            foreach (var item in list)
            {
                Console.Write(item!.ToString() + separator);
            }

            Console.WriteLine();
        }
    
        
    }
}
