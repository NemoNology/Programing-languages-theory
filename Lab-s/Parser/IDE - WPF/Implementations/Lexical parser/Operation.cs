using CSharp_console.Implementations.LexicalParser.Tokens;
using System;
using System.Collections.Generic;

namespace IDE.Implementations.Lexical_parser
{
    public class Operation<OperationType, OperandType> where OperationType : notnull where OperandType : notnull
    {
        public Dictionary<OperationType, Func<OperandType, OperandType>> UnaryOperations { get; private set; }
        public Dictionary<OperationType, Func<OperandType, OperandType, OperandType>> BinaryOperations { get; private set; }

        public Operation(
            Dictionary<OperationType, Func<OperandType, OperandType>> unaryOperations,
            Dictionary<OperationType, Func<OperandType, OperandType, OperandType>> binaryOperations)
        {
            UnaryOperations = unaryOperations ?? throw new ArgumentNullException(nameof(unaryOperations));
            BinaryOperations = binaryOperations ?? throw new ArgumentNullException(nameof(binaryOperations));
        }

        public OperandType Calculate(OperationType operation, OperandType operand)
        {
            if (UnaryOperations.TryGetValue(operation, out var func))
            {
                return func(operand);
            }

            throw new ArgumentException($"Invalid operation: Unary operations does not contains {operation}");
        }

        public OperandType Calculate(OperationType operation, OperandType operand1, OperandType operand2)
        {
            if (BinaryOperations.TryGetValue(operation, out var func))
            {
                return func(operand1, operand2);
            }

            throw new ArgumentException($"Invalid operation: Binary operations does not contains {operation}");
        }
    }
}
