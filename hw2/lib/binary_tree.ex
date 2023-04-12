defmodule BinaryTree do
  @type empty_tree :: {nil}
  @type tree :: {key :: any, value :: any, left :: tree, right :: tree} | empty_tree

  def new(), do: {nil}

  def insert(tree, key, value) do
    do_insert(tree, key, value)
  catch
    {:error, :key_exists} ->
      {:error, :key_exists}
  end

  def lookup({nil}, _key), do: {:error, :not_found}
  def lookup({key, value, _, _}, key), do: {:ok, value}
  def lookup({node_key, _, l_tree, _}, key) when key < node_key, do: lookup(l_tree, key)
  def lookup({node_key, _, _, r_tree}, key) when key > node_key, do: lookup(r_tree, key)

  def isomorphic?(t1, t2), do: BinaryTree.Isomorphism.isomorphic?(t1, t2)

  # Private functions

  defp do_insert({nil}, key, value), do: {key, value, new(), new()}

  defp do_insert({key, value, l_tree, r_tree}, new_key, new_value) when new_key < key do
    {key, value, do_insert(l_tree, new_key, new_value), r_tree}
  end

  defp do_insert({key, value, l_tree, r_tree}, new_key, new_value) when new_key > key do
    {key, value, l_tree, do_insert(r_tree, new_key, new_value)}
  end

  defp do_insert({key, _old_value, _l_tree, _r_tree}, key, _new_value) do
    # Throws can also be used for non-local returns when in deep recursion
    # https://learnyousomeerlang.com/errors-and-exceptions
    # Throw here and catch it in `insert/3`. The recursive call is not fully
    # propagated to the top as the result of the recursive call is put as a value
    # in a tuple as third or fourth element. By throwing from deep in the
    # recursive call, we can return the error to the caller.
    # This is a niche use which not all people approve.

    # Alternative solutions:
    # - First run `lookup/2` and return the error without trying
    # to insert.
    # - Structure the recursion and tree structure in a way which allows for
    # returning from a deep recursion.
    throw({:error, :key_exists})
  end
end
