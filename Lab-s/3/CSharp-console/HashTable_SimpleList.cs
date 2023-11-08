class HashTable_SimpleList<KeyType, ValueType> where KeyType : notnull where ValueType : notnull
{
    List<List<(KeyType Key, ValueType Value)>> _values;
    Func<string, int> _hashFunction;
    public int Capacity => _values.Capacity;
    public int Size
    {
        get
        {
            var values = _values.Where(x => x is not null);
            int size = 0;
            foreach (var value in values)
                size += value.Count;

            return size;
        }
    }
    public List<ValueType> Values
    {
        get
        {
            var values = _values.Where(x => x is not null);
            var fullValues = new List<ValueType>(Size);
            foreach (var value in values)
                fullValues.AddRange(value.Select(x => x.Value));

            return fullValues;
        }
    }

    public HashTable_SimpleList(Func<string, int> hashFunction, int capacity = 10)
    {
        _hashFunction = hashFunction;
        _values = new List<List<(KeyType Key, ValueType Value)>>(capacity);
        for (int i = 0; i < capacity; i += 1)
            _values.Add(new List<(KeyType Key, ValueType Value)>(1));
    }

    /// <summary>
    /// Add values to table from file
    /// </summary>
    /// <param name="filePath">Path to file with values in format: Key Value;</br> Every value pair must be on single line</param>
    /// <param name="isRemovePreviousValues">If <c>true</c> - clear saved values</param>
    public void AddValuesFromFile(string filePath, bool isRemovePreviousValues = true)
    {
        using var file = new StreamReader(filePath);
        if (isRemovePreviousValues)
            Clear();
        while (!file.EndOfStream)
        {
            var pairBuffer = file.ReadLine()!.Split(" ");
            Add((KeyType)Convert.ChangeType(pairBuffer[0], typeof(KeyType)),
                (ValueType)Convert.ChangeType(pairBuffer[1], typeof(ValueType)));
        }
    }

    public void Add(KeyType key, ValueType value)
    {
        var capacity = _values.Capacity;
        var index = _hashFunction(key.ToString()!) % capacity;
        if (_values[index].Select(x => x.Key).Contains(key))
            throw new ArgumentException($"Key {key} already exists");
        else
            _values[index].Add((key, value));

        if ((float)Size / capacity >= 0.75)
            UpdateCapacity((int)(capacity * 1.5));
    }

    public bool Contains(KeyType key)
    {
        var capacity = _values.Capacity;
        int index = _hashFunction(key.ToString()!) % capacity;
        if (_values[index].Select(x => x.Key).Contains(key))
            return true;
        return false;
    }

    public void Remove(KeyType key)
    {
        var capacity = _values.Capacity;
        int index = _hashFunction(key.ToString()!) % capacity;
        int KeyIndex = _values[index].Select(x => x.Key).ToList().IndexOf(key);
        if (KeyIndex > -1)
            _values[index].RemoveAt(KeyIndex);

        if ((float)Size / capacity <= 0.25)
            UpdateCapacity((int)(capacity * 0.5));
    }

    public void UpdateValue(KeyType key, ValueType value)
    {
        var capacity = _values.Capacity;
        int index = _hashFunction(key.ToString()!) % capacity;
        int KeyIndex = _values[index].Select(x => x.Key).ToList().IndexOf(key);
        if (KeyIndex > -1)
            _values[index][KeyIndex] = (key, value);
    }

    public ValueType GetValue(KeyType key)
    {
        var capacity = _values.Capacity;
        int index = _hashFunction(key.ToString()!) % capacity;
        int KeyIndex = _values[index].Select(x => x.Key).ToList().IndexOf(key);
        if (KeyIndex > -1)
            return _values[index][KeyIndex].Value;
        else
            throw new IndexOutOfRangeException($"Key {key} does not exists in table");
    }

    public ValueType this[KeyType key]
    {
        get => GetValue(key);
        set => UpdateValue(key, value);
    }

    public void UpdateCapacity(int newCapacity)
    {
        var valuesLists = _values.Where(x => x is not null).ToList();
        _values = new List<List<(KeyType Key, ValueType Value)>>(newCapacity);
        GC.Collect();
        for (int i = 0; i < newCapacity; i += 1)
            _values.Add(new List<(KeyType Key, ValueType Value)>(1));
        foreach (var values in valuesLists)
            foreach (var (Key, Value) in values)
                Add(Key, Value);
    }

    public void Clear()
    {
        var capacity = _values.Capacity;
        for (int i = 0; i < capacity; i += 1)
            _values[i].Clear();
    }
}