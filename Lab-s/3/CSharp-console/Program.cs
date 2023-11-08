HashTable_Rehashing<char, string> ht = new(HashFunctions.MurMur3, 50);
// HashTable_SimpleList<char, string> ht = new(HashFunctions.MurMur3, 50);

ht.AddValuesFromFile("D:\\_PROGRAMMING_\\MY\\_VII\\Programing-languages-theory\\Lab-s\\3\\CSharp-console\\Values.txt");

string DoCommand(string line)
{
    try
    {
        var args = line.Split(" ");
        char key = ' ';
        if (args.Length > 1)
            key = Char.Parse(args[1]);

        switch (args[0].ToLower())
        {
            case "help":
                return "\'help\' - help\n"
                + "\'get [key: symbol]\' - get value by key\n"
                + "\'add [key: symbol] [value: word]\' - add pair (key, value) to table\n"
                + "\'update [key: symbol] [value: word]\' - update value by key\n"
                + "\'remove [key: symbol]\' - remove table row by key\n"
                + "\'q\' - exit";
            case "get":
                return ht[key];
            case "add":
                ht.Add(key, args[2]);
                return "Adding was succsesfull";
            case "update":
                ht[key] = args[2];
                return "Updating was succsesfull";
            case "remove":
                ht.Remove(key);
                return "Removing was succsesfull";
            case "q":
                Environment.Exit(0);
                return "";
            default: return "Unknown command; Try \'help\' to help";
        }
    }
    catch (Exception e)
    {
        return e.Message;
    }
}

while (true)
    Console.WriteLine(DoCommand(Console.ReadLine()!));