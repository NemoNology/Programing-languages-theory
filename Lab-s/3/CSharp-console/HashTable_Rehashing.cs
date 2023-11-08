class HashTable_Rehashing<KeyType, ValueType>
{
    List<(KeyType Key, ValueType Value)?> _values;
    Func<string, int> _hashFunction;
    public int Capacity => _values.Capacity;
    public int Size => _values.Where(x => x is not null).Count();
    public List<ValueType> Values => _values.Where(x => x is not null).Select(x => x!.Value.Value).ToList()!;

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

    public HashTable_Rehashing(Func<string, int> hashFunction, int capacity = 10)
    {
        _hashFunction = hashFunction;
        _values = new List<(KeyType Key, ValueType Value)?>(capacity);
        for (int i = 0; i < capacity; i += 1)
            _values.Add(null);
    }

    public void Add(KeyType key, ValueType value)
    {
        var capacity = _values.Capacity;
        int index = _hashFunction(key!.ToString()!) % capacity;
        while (_values[index] != null)
            index = (index + 1) % capacity;

        _values[index] = (key, value);

        if ((float)Size / capacity >= 0.75)
            UpdateCapacity((int)(capacity * 1.5));
    }

    public bool Contains(KeyType key)
    {
        var capacity = _values.Capacity;
        int index = _hashFunction(key!.ToString()!) % capacity;
        if (_values[index] != null
                && _values[index]!.Value.Key!.Equals(key))
            return true;
        else
        {
            var indexBuffer = index;
            do
                index = (index + 1) % capacity;
            while (_values[index] != null
                        && !_values[index]!.Value.Key!.Equals(key)
                        && index != indexBuffer);

            if (_values[index] == null
                || !_values[index]!.Value.Key!.Equals(key))
                return false;

            return true;
        }
    }

    public void Remove(KeyType key)
    {
        var capacity = _values.Capacity;
        int index = _hashFunction(key!.ToString()!) % capacity;
        if (_values[index] != null
                && _values[index]!.Value.Key!.Equals(key))
            _values[index] = null;
        else
        {
            var indexBuffer = index;
            do
                index = (index + 1) % capacity;
            while (_values[index] != null
                        && !_values[index]!.Value.Key!.Equals(key)
                        && index != indexBuffer);

            if (_values[index] == null
                || !_values[index]!.Value.Key!.Equals(key))
                return;

            _values[index] = null;
        }

        if ((float)Size / capacity <= 0.25)
            UpdateCapacity((int)(capacity * 0.5));
    }

    public void UpdateValue(KeyType key, ValueType value)
    {
        var capacity = _values.Capacity;
        int index = _hashFunction(key!.ToString()!) % capacity;
        if (_values[index] != null
                && _values[index]!.Value.Key!.Equals(key))
            _values[index] = (_values[index]!.Value.Key, value);
        else
        {
            var indexBuffer = index;
            do
                index = (index + 1) % capacity;
            while (_values[index] != null
                        && !_values[index]!.Value.Key!.Equals(key)
                        && index != indexBuffer);

            if (_values[index] == null
                || !_values[index]!.Value.Key!.Equals(key))
                throw new IndexOutOfRangeException($"Key {key} does not exists in table");

            _values[index] = (_values[index]!.Value.Key, value);
        }
    }

    public ValueType GetValue(KeyType key)
    {
        var capacity = _values.Capacity;
        int index = _hashFunction(key!.ToString()!) % capacity;
        if (_values[index] != null
                && _values[index]!.Value.Key!.Equals(key))
            return _values[index]!.Value.Value;
        else
        {
            var indexBuffer = index;
            do
                index = (index + 1) % capacity;
            while (_values[index] != null
                        && !_values[index]!.Value.Key!.Equals(key)
                        && index != indexBuffer);

            if (_values[index] == null
                || !_values[index]!.Value.Key!.Equals(key))
                throw new IndexOutOfRangeException($"Key {key} does not exists in table");

            return _values[index]!.Value.Value;
        }
    }

    public ValueType this[KeyType key]
    {
        get => GetValue(key);
        set => UpdateValue(key, value);
    }

    public void UpdateCapacity(int newCapacity)
    {
        var values = _values.Where(x => x is not null).ToList();
        _values = new List<(KeyType Key, ValueType Value)?>(newCapacity);
        for (int i = 0; i < newCapacity; i += 1)
            _values.Add(null);
        foreach (var valueInfo in values)
            Add(valueInfo!.Value.Key, valueInfo.Value.Value);
    }

    public void Clear()
    {
        var capacity = _values.Capacity;
        for (int i = 0; i < capacity; i += 1)
            if (_values[i] != null)
                _values[i] = null;
    }
}

class HashFunctions
{
    public static int MurMur3(string key)
    {
        int h1b, k1;

        int remainder = key.Length & 3;
        int bytes = key.Length - remainder;
        int h1 = 0;
        int c1 = 0xc9e2d51;
        int c2 = 0xb873593;
        int i = 0;

        while (i < bytes)
        {
            k1 =
                (key[i] & 0xff) |
                ((key[++i] & 0xff) << 8) |
                ((key[++i] & 0xff) << 16) |
                ((key[++i] & 0xff) << 24);
            ++i;

            k1 = (((k1 & 0xffff) * c1) + ((((k1 >> 16) * c1) & 0xffff) << 16)) & 0xfffffff;
            k1 = (k1 << 15) | (k1 >> 17);
            k1 = (((k1 & 0xffff) * c2) + ((((k1 >> 16) * c2) & 0xffff) << 16)) & 0xfffffff;

            h1 ^= k1;
            h1 = (h1 << 13) | (h1 >> 19);
            h1b = (((h1 & 0xffff) * 5) + ((((h1 >> 16) * 5) & 0xffff) << 16)) & 0xfffffff;
            h1 = (h1b & 0xffff) + 0x6b64 + ((((h1b >> 16) + 0xe654) & 0xffff) << 16);
        }

        k1 = 0;

        switch (remainder)
        {
            case 3: k1 ^= (key[i + 1] & 0xff) << 16; break;
            case 2: k1 ^= (key[i + 2] & 0xff) << 8; break;
            case 1:
                k1 ^= key[i] & 0xff;

                k1 = (((k1 & 0xffff) * c1) + ((((k1 >> 16) * c1) & 0xffff) << 16)) & 0xfffffff;
                k1 = (k1 << 15) | (k1 >> 17);
                k1 = (((k1 & 0xffff) * c2) + ((((k1 >> 16) * c2) & 0xffff) << 16)) & 0xfffffff;
                h1 ^= k1; break;
        }

        h1 ^= key.Length;

        h1 ^= h1 >> 16;
        h1 = (((h1 & 0xffff) * 0x5ebca6b) + ((((h1 >> 16) * 0x5ebca6b) & 0xffff) << 16)) & 0xfffffff;
        h1 ^= h1 >> 13;
        h1 = (((h1 & 0xffff) * 0x2b2ae35) + ((((h1 >> 16) * 0x2b2ae35) & 0xffff) << 16)) & 0xfffffff;
        h1 ^= h1 >> 16;

        return h1 >> 0;
    }

}