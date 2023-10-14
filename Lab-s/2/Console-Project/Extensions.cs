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

        public static void PrintAsTree1(this string str)
        {
            string res =
                @"
S
|
|--|
|  S
|  |
|  |--|
|  |  B
|  |  |
|  |  |--|
|  |  |  B
|  |  |  |
|  |  |  |--|
|  |  |  |  C
|  |  |  |  |
|  |  |  |  |--|
|  |  |  |  |  |
0  0  1  1  1  /";

            res.PrintColored(ConsoleColor.Cyan);
        }

        public static string GetCharsAsTreeNode(
            this string str,
            int height = 2,
            int width = 2,
            string verticalLine = "|",
            string horizontalLine = "-",
            int tabCount = 0,
            bool isOnlyLastHorizontalFill = false)
        {
            var res = @"";
            var nl = Environment.NewLine;
            var chars = str.ToArray();
            var tab = "\t".Mul(tabCount);
            var empty = " ".Mul(width);
            var hor = horizontalLine.Mul(width);
            var ver = (verticalLine + nl).Mul(height);
            var len = chars.Length;

            res += ver;
            res += verticalLine;



            for (int i = 0; i < len - 1; i++)
            {
                if (isOnlyLastHorizontalFill && i + 1 >= len)
                    res += empty;
                else
                    res += hor;

                res += verticalLine;
            }

            res += nl;

            for (int i = 0; i < chars.Length; i++)
                res += chars[i] + empty;

            return res;
        }

        public static string Mul(this string s, int repeatCount)
        {
            var res = "";

            for (int i = 0; i < repeatCount; i++)
            {
                res += s;
            }

            return res;
        }

    }
}
