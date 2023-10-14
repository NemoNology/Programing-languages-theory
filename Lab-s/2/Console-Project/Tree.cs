using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Console_Project
{
    public class Tree<T>
    {
        public TreeNode<T> Root;

        public Tree(TreeNode<T> root)
        {
            Root = root;
        }

        //public string GetAsLefthandedTree(
        //    int height = 2,
        //    int width = 2,
        //    string verticalLine = "|",
        //    string horizontalLine = "-")
        //{
        //    var res = "";
        //    var nl = Environment.NewLine;
        //    var chars = Root.Value.ToString().ToArray();
        //    var empty = " ".Mul(width);
        //    var hor = horizontalLine.Mul(width);
        //    var ver = (verticalLine + nl).Mul(height);
        //    var len = chars.Length;

            

        //    return res;
        //}
    }

    public class TreeNode<T>
    {
        public T Value;
        public List<TreeNode<T>> Children;

        public TreeNode(T value, List<TreeNode<T>> children)
        {
            Value = value;
            Children = children;
        }
    }
}
