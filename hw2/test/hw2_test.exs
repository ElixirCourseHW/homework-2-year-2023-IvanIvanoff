defmodule HW2Test do
  use ExUnit.Case
  use ExUnitProperties

  @moduletag timeout: 5000
  @moduletag max_points: 15

  doctest HW2

  @tag task: :sort
  test "sort example" do
    assert [] == HW2.sort([])
    assert [1] == HW2.sort([1])
    assert [1, 2] == HW2.sort([1, 2])
    assert [1, 2] == HW2.sort([2, 1])
    assert [2, 2, 2, 2] == HW2.sort([2, 2, 2, 2])
    assert [1, 2, 3, 4] == HW2.sort([3, 1, 4, 2])

    # Partial order of all terms
    pid = self()
    ref = make_ref()

    # Sort works with all types
    assert [3.14, :a, %{a: 2}, "asd", 2, pid, %{a: 1, b: 2}, {5}, [1], ref] |> HW2.sort() ==
             [2, 3.14, :a, ref, pid, {5}, %{a: 2}, %{a: 1, b: 2}, [1], "asd"]

    # Sort is fast
    list = for _ <- 0..20_000, do: :rand.uniform(20_000)
    assert Enum.sort(list) == HW2.sort(list)
  end

  @tag task: :sort
  property "sort property" do
    check all(list <- list_of(integer())) do
      sorted_list = HW2.sort(list)

      assert length(list) == length(sorted_list)
      # Assert that the same elements appear in both lists with
      # the same frequencies.
      assert Enum.frequencies(list) == Enum.frequencies(sorted_list)
      # Assert that for each pair of adjacent elements in the sorted list i and j
      # it is true that i <= j.
      assert sorted?(sorted_list)
    end
  end

  defp sorted?([f, s | rest]), do: f <= s and sorted?([s | rest])
  defp sorted?(_other), do: true

  @tag task: :fib
  @tag timeout: 1000
  test "fibbonachi" do
    first_10 = [0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55]

    for i <- 0..10 do
      assert HW2.fibbonachi(i) == Enum.at(first_10, i)
    end

    fib_581_rem_1_million = 123_781
    assert HW2.fibbonachi(581) |> rem(1_000_000) == fib_581_rem_1_million

    fib_1000_rem_1_million = 228_875
    assert HW2.fibbonachi(1000) |> rem(1_000_000) == fib_1000_rem_1_million
  end

  @tag task: :lucas
  @tag timeout: 1000
  test "lucas" do
    first_10 = [2, 1, 3, 4, 7, 11, 18, 29, 47, 76, 123]

    for i <- 1..10 do
      assert HW2.lucas(i) == Enum.at(first_10, i)
    end

    luc_581_rem_1_million = 928_651
    assert HW2.lucas(581) |> rem(1_000_000) == luc_581_rem_1_million

    luc_1000_rem_1_million = 578_127
    assert HW2.lucas(1000) |> rem(1_000_000) == luc_1000_rem_1_million
  end

  @tag task: :min
  test "min with empty list" do
    assert_raise HW2.EmptyError, fn -> HW2.min([]) end
  end

  @tag task: :min
  property "min" do
    check all(list <- list_of(integer(), min_length: 1)) do
      min = HW2.min(list)
      assert min in list
      refute Enum.any?(list, fn elem -> elem < min end)
    end
  end

  @tag task: :max
  test "max with empty list" do
    assert_raise HW2.EmptyError, fn -> HW2.max([]) end
  end

  @tag task: :max
  property "max" do
    check all(list <- list_of(integer(), min_length: 1)) do
      max = HW2.max(list)
      assert max in list
      refute Enum.any?(list, fn elem -> elem > max end)
    end
  end

  @tag task: :find_index
  property "find_index" do
    check all(list <- list_of(integer(), min_length: 1)) do
      pos = Enum.random(0..(length(list) - 1))
      value = Enum.at(list, pos)

      index = HW2.find_index(list, value)

      # Assert that `value` is found at that position
      assert Enum.at(list, index) == value

      # find_index finds the first matching position
      # value is not seen before `index` position
      refute value in Enum.take(list, index)
    end
  end

  @tag task: :foldl
  test "foldl" do
    assert HW2.foldl([], 12, &Kernel.+/2) == 12
    assert HW2.foldl([1, 2, 3, 4], 0, &Kernel.+/2) == 10
    assert HW2.foldl([1, 2, 3, 4], -10, &Kernel.+/2) == 0
    assert HW2.foldl([1, 2, 3, 4], 0, &Kernel.-/2) == 2
    assert HW2.foldl([1, 2, 3, 4, 5], [], &[&1 | &2]) == [5, 4, 3, 2, 1]
    assert HW2.foldl([1, 2, 3, 4, 5], [], &[&2 | &1]) == [[[[[[] | 1] | 2] | 3] | 4] | 5]
  end

  @tag task: :foldl
  property "foldl" do
    check all(list <- list_of(integer())) do
      fun1 = fn elem, acc -> [elem | acc] end
      fun2 = fn elem, acc -> if elem < 5, do: acc, else: acc + 1 end
      fun3 = fn elem, acc -> to_string(elem) <> acc end

      assert List.foldl(list, [], fun1) == HW2.foldl(list, [], fun1)
      assert List.foldl(list, 0, fun2) == HW2.foldl(list, 0, fun2)
      assert List.foldl(list, "", fun3) == HW2.foldl(list, "", fun3)
    end
  end

  @tag task: :foldr
  test "foldr" do
    assert HW2.foldr([], 12, &Kernel.+/2) == 12
    assert HW2.foldr([1, 2, 3, 4], 0, &Kernel.+/2) == 10
    assert HW2.foldr([1, 2, 3, 4], -10, &Kernel.+/2) == 0
    assert HW2.foldr([1, 2, 3, 4], 0, &Kernel.-/2) == -2
    assert HW2.foldr([1, 2, 3, 4, 5], [], &[&1 | &2]) == [1, 2, 3, 4, 5]
    assert HW2.foldr([1, 2, 3, 4, 5], [], &[&2 | &1]) == [[[[[[] | 5] | 4] | 3] | 2] | 1]
  end

  @tag task: :foldr
  property "foldr" do
    check all(list <- list_of(integer())) do
      fun1 = fn elem, acc -> [elem | acc] end
      fun2 = fn elem, acc -> if elem < 5, do: acc, else: acc + 1 end
      fun3 = fn elem, acc -> to_string(elem) <> acc end

      assert List.foldr(list, [], fun1) == HW2.foldr(list, [], fun1)
      assert List.foldr(list, 0, fun2) == HW2.foldr(list, 0, fun2)
      assert List.foldr(list, "", fun3) == HW2.foldr(list, "", fun3)
    end
  end

  @tag task: :reduce
  property "reduce" do
    check all(list <- list_of(integer())) do
      fun1 = fn elem, acc -> [elem | acc] end
      fun2 = fn elem, acc -> if elem < 5, do: acc, else: acc + 1 end
      fun3 = fn elem, acc -> to_string(elem) <> acc end

      assert Enum.reduce(list, [], fun1) == HW2.reduce(list, [], fun1)
      assert Enum.reduce(list, 0, fun2) == HW2.reduce(list, 0, fun2)
      assert Enum.reduce(list, "", fun3) == HW2.reduce(list, "", fun3)
    end
  end

  @tag task: :map
  property "map" do
    check all(list <- list_of(integer())) do
      fun1 = fn elem -> elem ** 2 + 5 end
      fun2 = fn elem -> if elem < 5, do: 10, else: 2 end
      fun3 = fn elem -> elem end

      assert Enum.map(list, fun1) == HW2.map(list, fun1)
      assert Enum.map(list, fun2) == HW2.map(list, fun2)
      assert Enum.map(list, fun3) == HW2.map(list, fun3)
    end
  end

  @tag task: :permutations
  test "permutations are fast" do
    # Unoptimized solutions will timeout on such output
    bin = String.duplicate("1", 200)
    assert HW2.permutations(bin) == [bin]

    # A check if all grpahmes are equal is not really an optimiztion
    bin = String.duplicate("1", 50) <> "2"
    permutations = HW2.permutations(bin)
    assert length(permutations) == 51
    assert permutations == Enum.uniq(permutations)

    assert Enum.all?(permutations, fn perm ->
             String.graphemes(perm) |> Enum.frequencies() == %{"1" => 50, "2" => 1}
           end)
  end

  @tag task: :permutations
  test "permutations" do
    # 1 element, no sort needed
    assert HW2.permutations("") == [""]
    assert HW2.permutations("1") == ["1"]
    assert HW2.permutations("11") == ["11"]
    assert HW2.permutations("111") == ["111"]
    assert HW2.permutations("aaaa") == ["aaaa"]

    # Sort needed as the order is not important
    assert HW2.permutations("aA") |> Enum.sort() ==
             ["aA", "Aa"] |> Enum.sort()

    assert HW2.permutations("a1") |> Enum.sort() ==
             ["a1", "1a"] |> Enum.sort()

    assert HW2.permutations("yk") |> Enum.sort() ==
             ["yk", "ky"] |> Enum.sort()

    assert HW2.permutations("1112") |> Enum.sort() ==
             ["1112", "1121", "1211", "2111"] |> Enum.sort()

    assert HW2.permutations("123") |> Enum.sort() ==
             ["123", "132", "213", "231", "312", "321"] |> Enum.sort()

    assert HW2.permutations("113") |> Enum.sort() ==
             ["113", "131", "311"] |> Enum.sort()

    assert HW2.permutations("NeNe") |> Enum.sort() ==
             ["eeNN", "eNeN", "eNNe", "NeeN", "NeNe", "NNee"] |> Enum.sort()

    assert HW2.permutations("1234") |> Enum.sort() ==
             ~w( 1234 1243 1324 1342 1423 1432
                 2134 2143 2314 2341 2413 2431
                 3124 3142 3214 3241 3412 3421
                 4123 4132 4213 4231 4312 4321 )
             |> Enum.sort()

    abcdefg_permutations = HW2.permutations("abcdefg") |> Enum.sort()

    abcdefg_expected_permutations =
      File.read!(Path.join([__DIR__, "abcdefg_permutations.txt"]))
      |> String.split("\n", trim: true)
      |> Enum.sort()

    assert abcdefg_permutations == abcdefg_expected_permutations
  end

  @tag task: :permutations
  property "permutations" do
    check all(
            # Generate a list with length between 1 and 6 with random letters and numbers
            list <-
              list_of(StreamData.string([?a..?z, ?A..?Z, ?0..?9], min_length: 1, max_length: 1),
                min_length: 1,
                max_length: 6
              )
          ) do
      bin = to_string(list)

      permutations = HW2.permutations(bin)

      # No duplicates
      assert permutations |> Enum.sort() == Enum.uniq(permutations) |> Enum.sort()

      num_graphemes = String.graphemes(bin) |> Enum.count()
      grapheme_frequencies = String.graphemes(bin) |> Enum.frequencies() |> Map.values()

      factorial = fn
        0 -> 1
        n -> 1..n |> Enum.reduce(1, &*/2)
      end

      # The number of permutations in a list with repetitions n!/a1!a2!...ak!
      # where a1..ak are the number of repetitions of each grapheme
      # where n is the number of graphemes and k is the number of unique graphemes
      # https://math.stackexchange.com/a/821069
      nominator = factorial.(num_graphemes)
      denominator = Enum.map(grapheme_frequencies, &factorial.(&1)) |> Enum.reduce(&*/2)

      expected_permutations_count = div(nominator, denominator)

      assert length(permutations) == expected_permutations_count

      # Check that the graphemes in the input are the same as in each of the permutations
      sorted_graphemes_in_input = String.graphemes(bin) |> Enum.sort()

      assert Enum.all?(permutations, fn perm ->
               assert sorted_graphemes_in_input == String.graphemes(perm) |> Enum.sort()
             end)
    end
  end

  @tag task: :anagrams
  property "anagrams" do
    check all(
            # Generate a list with length between 1 and 6 with random letters and numbers
            list <-
              list_of(
                StreamData.string([?a..?z, ?A..?Z, ?0..?9, ?\s], min_length: 1, max_length: 4),
                min_length: 20,
                max_length: 100
              )
          ) do
      bin = to_string(list)
      bin_length = String.length(bin)
      {left, right} = String.split_at(bin, Enum.random(10..(bin_length - 1)))

      if String.downcase(left) != String.downcase(right) do
        {l1, l2} = String.split_at(left, Enum.random(2..(String.length(left) - 1)))
        {r1, r2} = String.split_at(right, Enum.random(2..(String.length(right) - 1)))

        # Create some variant where the strings have also different casing
        # and intervals
        str1 = String.upcase(l1) <> " " <> l2 <> right
        str2 = r1 <> " " <> r2 <> String.upcase(l2) <> String.downcase(l1) <> " "

        assert HW2.anagrams?(str1, str2) == true
      end
    end
  end

  @tag task: :binary_search
  property "binary_search always finds an index if present or nil if not" do
    num = 1000

    check all(list <- list_of(StreamData.integer(-num..num), min_length: 1, max_length: 100)) do
      tuple = list |> Enum.sort() |> List.to_tuple()

      value = Enum.random(list)
      value_not_in = Enum.random([-(num + 1), num + 1])

      pos_in = HW2.binary_search(tuple, value)
      assert is_integer(pos_in)
      assert elem(tuple, pos_in) == value

      pos_not_in = HW2.binary_search(tuple, value_not_in)
      assert pos_not_in == nil
    end
  end

  @jpg_prefix <<0xFF, 0xD8, 0xFF>>
  @png_prefix <<0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A>>
  @gif_prefix <<0x47, 0x49, 0x46>>
  @bmp_prefix <<0x42, 0x4D>>

  @tag task: :extension_extractor
  property "extension_extractor" do
    check all(bin <- binary(min_length: 0, max_length: 20)) do
      assert <<@jpg_prefix, bin::binary>> |> HW2.extension_extractor() == :jpg
      assert <<@png_prefix, bin::binary>> |> HW2.extension_extractor() == :png
      assert <<@gif_prefix, bin::binary>> |> HW2.extension_extractor() == :gif
      assert <<@bmp_prefix, bin::binary>> |> HW2.extension_extractor() == :bmp

      # If tests for all unknown is needed.
      # case :binary.match(bin, [@jpg_prefix, @png_prefix, @gif_prefix, @bmp_prefix]) do
      #   # Do not check if `bin` by chance starts with one of the prefixes
      #   {0, _} -> :ok
      #   _ -> assert HW2.extension_extractor(bin) == :unknown
      # end
    end
  end

  @tag task: :binary_search
  test "binary_search example" do
    assert HW2.binary_search({1, 2, 3}, 5) == nil
    assert HW2.binary_search({1, 2, 3}, 1) == 0
    assert HW2.binary_search({1, 2, 3}, 2) == 1
    assert HW2.binary_search({1, 2, 3}, 3) == 2
    assert HW2.binary_search({1}, 1) == 0
    assert HW2.binary_search({}, 1) == nil

    with_duplicates =
      [1, 2, 3, 4, 5]
      |> List.duplicate(10)
      |> List.flatten()
      |> Enum.sort()
      |> List.to_tuple()

    pos = HW2.binary_search(with_duplicates, 3)
    assert elem(with_duplicates, pos) == 3
  end

  @tag task: :binary_search
  property "binary_search property" do
    check all(list <- list_of(integer(), min_length: 1)) do
      tuple = list |> Enum.sort() |> List.to_tuple()

      rand_elem = elem(tuple, Enum.random(0..(tuple_size(tuple) - 1)))
      pos = HW2.binary_search(tuple, rand_elem)

      assert pos != nil

      assert elem(tuple, pos) == rand_elem

      {min, max} = Enum.min_max(list)

      assert HW2.binary_search(tuple, min - 1) == nil
      assert HW2.binary_search(tuple, max + 1) == nil
    end
  end

  @tag task: :max_scalar_product
  test "max_scalar_product" do
    list1 = [1, 2, 3, 4, 5, 6]
    list2 = [6, 5, 4, 3, 2, 1]

    assert HW2.max_scalar_product(list1, list2) ==
             (6 * 6 + 5 * 5 + 4 * 4 + 3 * 3 + 2 * 2 + 1 * 1) * 1.0

    list1 = [-1, 2, 3]
    list2 = [-5, 4, -2]

    assert HW2.max_scalar_product(list1, list2) ==
             (-1 * -5 + 2 * -2 + 3 * 4) * 1.0

    list1 = for _ <- 1..1000, do: 0.1
    list2 = for _ <- 1..1000, do: 1

    # Test that `sum_kahan` is used for the sum. Also checks that the
    # task is not computed with permutations
    assert HW2.max_scalar_product(list1, list2) ==
             100.0

    assert HW2.max_scalar_product([1], [3.141592]) == 3.141592
  end
end
