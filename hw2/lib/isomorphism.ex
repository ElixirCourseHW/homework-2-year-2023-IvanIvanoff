defmodule BinaryTree.Isomorphism do
  @doc ~s"""
  Implement Knuth Tuples algorithm.
  For simplification use canonical names instead of the knuth tuple
  representation of brackets and zeroes.
  https://logic.pdmi.ras.ru/~smal/files/smal_jass08.pdf
  """
  def isomorphic?(t1, t2) do
    canonical_name(t1) == canonical_name(t2)
  end

  # Private function
  defp canonical_name({nil}), do: ""
  defp canonical_name({_key, _value, {nil}, {nil}}), do: "10"

  # The canonical name of the tree is the concatenation of the canonical names
  # of the smaller and the bigger subtree, lexicographically sorted.
  defp canonical_name({_key, _value, l_tree, r_tree}) do
    [s, m] = Enum.sort([canonical_name(l_tree), canonical_name(r_tree)])
    "1" <> s <> m <> "0"
  end
end
