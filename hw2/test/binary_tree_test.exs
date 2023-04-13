defmodule BinaryTreeTest do
  use ExUnit.Case

  alias BinaryTree, as: BT

  @moduletag timeout: 10000
  @moduletag max_points: 5

  describe "Basic tree operations" do
    @tag task: :tree_basic_operations
    test "can create empty tree and add elements" do
      t = BT.new()
      t = t |> BT.insert(:a, 1) |> BT.insert(:b, 2) |> BT.insert(:c, -3)

      assert BT.lookup(t, :a) == {:ok, 1}
      assert BT.lookup(t, :b) == {:ok, 2}
      assert BT.lookup(t, :c) == {:ok, -3}
      assert BT.lookup(t, :d) == {:error, :not_found}
    end

    @tag task: :tree_basic_operations
    test "lookup on big trees" do
      keys_range = 1..500
      keys = keys_range |> Enum.shuffle()

      bt =
        for key <- keys, reduce: BT.new() do
          bt -> BT.insert(bt, key, key)
        end

      for key <- keys_range do
        # The key and the value are the same
        assert BT.lookup(bt, key) == {:ok, key}
      end

      for key <- Range.shift(keys_range, 1000) do
        assert BT.lookup(bt, key) == {:error, :not_found}
      end
    end

    @tag task: :tree_insert_existing_key
    test "insert existing key" do
      bt = BT.new()
      bt = bt |> BT.insert(:a, 1) |> BT.insert(:b, 2) |> BT.insert(:c, -3)

      assert BT.insert(bt, :a, 2) == {:error, :key_exists}

      bt2 = BT.new() |> BT.insert(:a1, 2) |> BT.insert(:b2, 3) |> BT.insert(:a0, 3)

      assert BT.insert(bt2, :b2, 34) == {:error, :key_exists}

      keys = 1..100 |> Enum.shuffle()

      bt3 =
        for key <- keys, reduce: BT.new() do
          bt -> BT.insert(bt, key, key)
        end

      assert BT.insert(bt3, 43, 100) == {:error, :key_exists}
    end
  end

  describe "Isomorphic" do
    @tag task: :tree_isomorphism
    test "empty trees are isomorphic" do
      t1 = BT.new()
      t2 = BT.new()

      assert true == BT.isomorphic?(t1, t2)
    end

    @tag task: :tree_isomorphism
    test "single node trees are isomorphic" do
      t1 = BT.new() |> BT.insert(:key, 2)
      t2 = BT.new() |> BT.insert(:key, 3)

      assert true == BT.isomorphic?(t1, t2)
    end

    @tag task: :tree_isomorphism
    test "multiple node trees are isomorphic" do
      t1 = Enum.reduce([5, 1, 10, 9, 15], BT.new(), &BT.insert(&2, &1, &1))
      t2 = Enum.reduce([5, 2, 1, 3, 100], BT.new(), &BT.insert(&2, &1, &1))

      assert true == BT.isomorphic?(t1, t2)
    end

    @tag task: :tree_isomorphism
    test "same big trees are isomorphic" do
      for _ <- 1..100 do
        # The chances that two such randomly built trees are isomorphic is very low
        length = Enum.random(10..1000)
        vertices1 = 1..length |> Enum.shuffle()
        values1 = Enum.map(vertices1, fn _ -> :rand.uniform(1000) end)

        bt =
          for {key, value} <- Enum.zip(vertices1, values1), reduce: BinaryTree.new() do
            bt -> BinaryTree.insert(bt, key, value)
          end

        assert BinaryTree.isomorphic?(bt, bt) == true
      end
    end

    @tag task: :tree_isomorphism
    test "big trees are isomorphic" do
      order1 = [100, 50, 150, 40, 90, 80, 70, 60, 75]
      bt1 = Enum.reduce(order1, BT.new(), fn num, tree -> BT.insert(tree, num, num) end)

      order2 = [100, 50, 150, 160, 140, 130, 120, 110, 125]
      bt2 = Enum.reduce(order2, BT.new(), fn num, tree -> BT.insert(tree, num, num) end)

      assert BT.isomorphic?(bt1, bt2) == true
    end
  end

  describe "Not isomorphic" do
    @tag task: :tree_isomorphism
    test "not isomorphic - 1" do
      t1 = BT.new() |> BT.insert(:a, 3)
      t2 = BT.new()

      assert false == BT.isomorphic?(t1, t2)
    end

    @tag task: :tree_isomorphism
    test "not isomorphic - 2" do
      t1 = BT.new() |> BT.insert(1, :a) |> BT.insert(2, :b) |> BT.insert(3, :c)
      t2 = BT.new() |> BT.insert(1, :a) |> BT.insert(0, :b) |> BT.insert(3, :c)

      assert BT.isomorphic?(t1, t2) == false
    end

    @tag task: :tree_isomorphism
    test "big random trees are not isomorphic" do
      for _ <- 1..100 do
        # The chances that two such randomly built trees are isomorphic is very low
        vertices1 = 1..1000 |> Enum.shuffle()
        values1 = Enum.map(vertices1, fn _ -> :rand.uniform(1000) end)

        vertices2 = ?a..?z |> Enum.shuffle()
        values2 = Enum.map(vertices2, fn _ -> :rand.uniform(1000) end)

        bt1 =
          for {key, value} <- Enum.zip(vertices1, values1), reduce: BinaryTree.new() do
            bt -> BinaryTree.insert(bt, key, value)
          end

        bt2 =
          for {key, value} <- Enum.zip(vertices2, values2), reduce: BinaryTree.new() do
            bt -> BinaryTree.insert(bt, key, value)
          end

        assert BinaryTree.isomorphic?(bt1, bt2) == false
      end
    end
  end

  # Generate a tree (that is no longer ordered, though)
  # that is isomophic to the provided tree. Sadly, this cannot
  # be used in the tests as the tree structure was not specified
  # and a generic function for swapping the left and right subtree
  # cannot be written. The function swaps the left and right
  # subtrees with a given probability. To test this, create a random
  # big tree `bt` and then check that `bt` and `transform_isomorphic(bt)`
  # are isomorphic.

  # defp transform_isomorphic({nil}), do: {nil}

  # defp transform_isomorphic({key, value, l_tree, r_tree} = tree) do
  #   if :rand.uniform() > 0.5 do
  #     tree
  #   else
  #     {key, value, transform_isomorphic(r_tree), transform_isomorphic(l_tree)}
  #   end
  # end
end
