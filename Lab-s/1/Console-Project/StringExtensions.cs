namespace Console_Project
{
    public static class StringExtensions
    {
        public static void PrintColored(
            this string str,
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
    }
}