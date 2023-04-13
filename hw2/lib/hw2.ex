defmodule HW2 do
  defmodule EmptyError do
    defexception message: "empty error"
  end

  @type element :: any

  @doc ~s"""
  Return the min value from the provided list if the list is not empty.
  If the list is empty raise a custom HW2.EmptyError exception

  ## Examples

    iex> HW2.min([1,2,3,4])
    1
    iex> HW2.min([5, -5])
    -5
  """
  @spec min([element]) :: element | no_return
  def min([]), do: raise(EmptyError, message: "Empty list provided")
  def min([first | rest]), do: do_min(rest, first)

  # Implement with reduce
  # def min([h | t]) do
  #   # An example using reduce with fn -> end syntax and capture & syntax
  #   reduce(t, h, fn elem, acc -> if elem < acc, do: elem, else: acc end)
  #   reduce(t, h, &if(&1 < &2, do: &1, else: &2))
  # end

  @doc ~s"""
  Return the max value from the provided list if the list is not empty.
  If the list is empty raise a custom HW2.EmptyError exception

  ## Examples

    iex> HW2.max([1,2,3,4])
    4
    iex> HW2.max([5, -5])
    5
  """
  @spec max([element]) :: element | no_return
  def max([]), do: raise(EmptyError, message: "Empty list provided")
  def max([first | rest]), do: do_max(rest, first)

  @spec min_max([element]) :: {element, element} | no_return
  def min_max([]), do: raise(EmptyError, message: "Empty list provided")

  def min_max([h | t]) do
    # min/1 и max/2 примерните решения са с директна рекурсия.
    # min_max/1 илюстрира примерно решение с reduce/3
    reduce(t, {h, h}, fn elem, {min, max} ->
      min = if elem < min, do: elem, else: min
      max = if elem > max, do: elem, else: max
      {min, max}
    end)
  end

  @doc ~s"""
  Return a list, sorted in ascending order.

  ## Examples

    iex> HW2.sort([1,2,3,4])
    [1,2,3,4]
    iex> HW2.sort([4,2,1,3])
    [1,2,3,4]
  """
  @spec sort(list(element)) :: list(element)
  def sort([]), do: []

  def sort([pivot | rest]) do
    # Имплементацията на sort/1 е с quicksort
    {smaller, equal, larger} = partition(rest, pivot)
    sort(smaller) ++ [pivot | equal] ++ sort(larger)
  end

  @doc ~s"""
  Return the index of the first element in the list whose value
  equals `value`.

  ## Examples

    iex> HW2.find_index([1,2,3,4], 0)
    nil

    iex> HW2.find_index([1,2,3,4], 3)
    2
  """
  @spec find_index(list(element), element) :: non_neg_integer | nil
  def find_index(list, value), do: do_find_index(list, value, 0)

  @doc ~s"""
  Return the n-th fibonacchi number.
  The first (n=0) fibbonachi number is 0, the second (n=1) is 1.
  The n-th fibonacchi number is the sum of the previous two.

  ## Examples
    iex> HW2.fibbonachi(1000) |> rem(100_000)
    28875
  """
  @spec fibbonachi(non_neg_integer) :: non_neg_integer | {:error, :neg_value}
  def fibbonachi(num) when num < 0, do: {:error, :neg_value}
  def fibbonachi(num), do: do_sum_prev(0, 1, num)

  # def fibbonachi(num) do
  #   # Implementation using Stream and Enum functions
  #   Stream.unfold({0, 1}, fn {fst, snd} -> {fst, {snd, fst + snd}} end)
  #   |> Enum.at(num)
  # end

  @doc ~s"""
  Return the n-th lucas number.
  The first lucas number is 2, the second is 1.
  The n-th lucas number is the sum of the previous two.
  ## Examples
    iex> HW2.lucas(20)
    15127
  """
  @spec lucas(non_neg_integer) :: non_neg_integer | {:error, :neg_value}
  def lucas(num) when num < 0, do: {:error, :neg_value}
  def lucas(num), do: do_sum_prev(2, 1, num)

  @doc ~s"""
  Folds (reduces) the given list from the left with a function.
  Requires an accumulator, which can be any value

  ## Examples

    iex> HW2.foldl([1,2,3,4], 0, &Kernel.-/2)
    (4 - (3 - (2 - (1 - 0)))) # equals 2

    iex> HW2.foldl([1,2,3,4,5], "", fn num, acc -> to_string(num) <> acc end)
    "54321"
  """
  @spec foldl([element], acc, (element, acc -> acc)) :: acc when acc: any
  def foldl([], acc, _fun), do: acc
  def foldl([elem | rest], acc, fun), do: foldl(rest, fun.(elem, acc), fun)

  @doc ~s"""
  Folds (reduces) the given list from the right with a function.
  Requires an accumulator, which can be any value

  ## Examples

    iex> HW2.foldr([1,2,3,4], 0, &Kernel.-/2)
    (1 - (2 - (3 - (4 - 0)))) # equals -2

    iex> HW2.foldr([1,2,3,4,5], "", fn num, acc -> to_string(num) <> acc end)
    "12345"
  """
  @spec foldr([element], acc, (element, acc -> acc)) :: acc when acc: any
  def foldr([], acc, _fun), do: acc
  def foldr([elem | rest], acc, fun), do: fun.(elem, foldr(rest, acc, fun))

  @doc ~s"""
  Reduce accumulates the result of each call to fun into an accumulator and
  returns the accumulator.

  ## Examples
    iex> HW2.reduce([1,2,3,4], 0, &Kernel.+/2)
    10

    iex> HW2.reduce([1,2,3,4], %{}, fn num, acc -> Map.put(acc, num, num) end)
    %{1 => 1, 2 => 2, 3 => 3, 4 => 4}
  """
  @spec reduce(list(any), acc, (any, acc -> acc)) :: acc when acc: any
  def reduce([], acc, _fun), do: acc
  def reduce([h | t], acc, fun), do: reduce(t, fun.(h, acc), fun)

  @doc ~s"""
  Returns a list where each element is the result of applying fun to
  the corresponding element in the input list.

  ## Examples
    iex> HW2.map([1,2,3], &(&1 * 2))
    [2,4,6]

    iex> HW2.map([1,2,3], fn _ -> 1 end)
    [1,1,1]
  """
  # NOTE: Elixir does **not** have tail recursion modulo cons like some
  # other languages. This implementation is not tail recursive. In some languages
  # if the last operation done is the cons operator (`|`) for building lists,
  # then the recursive call is still tail recursive.
  @spec map(list(any), (any -> any)) :: list(any)
  def map([], _fun), do: []
  def map([h | t], fun), do: [fun.(h) | map(t, fun)]

  # Implement with reduce. This is tail recursive
  # def map(list, fun), do: reduce(list, [], &[fun.(&1) | &2]) |> Enum.reverse()

  @doc ~s"""
  Summing a lot of floating point numbers is not precise as the error
  accumulates.
  For example: 0.1 + 0.1 + 0.1 + 0.1 + 0.1 + 0.1 + 0.1 + 0.1 + 0.1 + 0.1 = 0.9999999
  It woudld be better if summing 0.1 ten times gives 1.0 instead.

  Implement the Kahan summation algorithm to sum a list of numbers.
  Source: https://en.wikipedia.org/wiki/Kahan_summation_algorithm

  Examples:

    iex> HW2.sum_kahan(for _ <- 1..10, do: 0.1)
    1.0
  """
  @spec sum_kahan(list(number())) :: number()
  def sum_kahan(list) do
    %{sum: sum} =
      reduce(list, %{sum: 0.0, c: 0.0}, fn el, acc ->
        y = el - acc.c
        t = acc.sum + y
        c = t - acc.sum - y

        %{sum: t, c: c}
      end)

    sum
  end

  @doc ~s"""
  Return a list of all the permitations of a string in no particular order.

  Hint: If you have a list ["1", "2", "3"], you can use `to_string(list)`
  to transform it to the string "123".

  ## Examples

    iex> HW2.permutations("123")
    ["123", "132", "213", "231", "312", "321"]

    iex> HW2.permutations("11")
    ["11"]

    iex> HW2.permutations("55555")
    ["55555"]

    iex> HW2.permutations("")
    [""]
  """
  @spec permutations(String.t()) :: list(String.t())
  def permutations(""), do: [""]

  # Use our versions of Enum.map/2 and Enum.uniq/1
  def permutations(binary) do
    do_permutations(String.graphemes(binary))
    |> map(&to_string/1)
    |> list_uniq()
  end

  @doc ~s"""
  Checks if two strings are anagrams of each other.

  An anagram is a word or phrase formed by rearranging the letters of
  a different word or phrase. A word is not an anagram of itself.
  Casing is not important. Spaces are not important.

  ## Examples

    iex> HW2.anagrams?("car", "rac")
    true
    iex> HW2.anagrams?("I am Lord Voldemort", "Tom Marvolo Riddle")
    true
  """
  @spec anagrams?(String.t(), String.t()) :: boolean()
  def anagrams?(str, str), do: false

  def anagrams?(str1, str2) do
    fun = fn str ->
      # Alternative way without using reject. It also removes tabs, not only spaces
      # str |> String.replace(~r|[\s\t]+|, "") |> String.downcase() |> String.graphemes() |> sort()
      str |> String.downcase() |> String.graphemes() |> reject(&(&1 == " ")) |> sort()
    end

    fun.(str1) == fun.(str2)
  end

  @doc ~s"""
  Return the media format that a given binary represents.

  The follwing formats are supported:

  JPG: The binary file starts with bytes 0xFF, 0xD8, 0xFF
  PNG: The binary file starts with bytes 0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A
  GIF: The binary file starts with bytes 0x47, 0x49, 0x46
  BMP: The binary file starts with bytes 0x42, 0x4D
  """
  @spec extension_extractor(binary()) :: :jpg | :png | :gif | :bmp
  def extension_extractor(binary) do
    case binary do
      <<0xFF, 0xD8, 0xFF, _rest::binary>> -> :jpg
      <<0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, _rest::binary>> -> :png
      <<0x47, 0x49, 0x46, _rest::binary>> -> :gif
      <<0x42, 0x4D, _rest::binary>> -> :bmp
      # Not specified by the requirements
      _ -> :unknown
    end
  end

  @doc ~s"""
  There exists a special FMI image format, which is not supported by any
  image viewer application.

  It is a binary image format, designed by first year students at FMI
  with zero knowledge of what is optimal for parsing.

  The format of the image is described as follows, in that order of bytes:
  - Starts with 3 bytes: 0x66, 0x66, 0x66
  - 4 bytes of metadata: A 32 bit integer `size1`, representing the number of bytes
    that hold the first part of the payload.
  - `size1` bytes - the first part of the payload.
  - 4 bytes of metadata: The byte 0x66, followed by 24 bit integer `size2,
    representing the number of bytes that hold the second part of the payload.
  - `size2` bytes - the second part of the payload
  - 4 bytes of metadata: The byte 0x66, followed by 24 bit integer `size3`,
    representing the number of bytes that hold the third part of the payload.
  - `size3` bytes - the third part of the payload
  - 1 byte - 0x66
  - 1 float - the first part of the version of the format
  - 7 bits - the second part of the vrsion of the format.

  When the binary is parsed, the result is a 3-element tuple: {:fmi, version, payload}
  where:
    - `version` is a string, representing the version of the format, in the form
      "<float rounded to 2 decimals>.<ASCII representation of the number represented in 7 bits>"
    - `payload` is a binary, created by concatenating the three parts of the payload in order

  ## Examples:
    iex> HW2.fmi_image_decoder(<<
    ...> 0x66, 0x66,0x66, #  star of image
    ...> 3::size(32), # 3 bytes of payload
    ...> 0xAC, 0x47, 0x12, # the first part of payload
    ...> 0x66, 0x00, 0x00, 0x06, # 4 bytes of metadata, 1 byte 0x66, 3 bytes of payload size
    ...> 0xAC, 0x47, 0x12, 0xAB, 0x23, 0x33, # the second part of payload
    ...> 0x66, 0x00, 0x00, 0x03, # 4 bytes of metadata, 1 byte 0x66, 3 bytes of payload size
    ...> 0xBD, 0xEF, 0x44, # the third part of paylod
    ...> 0x66, # 1 byte
    ...> 3.14::float,
    ...> ?a::size(7)
    ...> >>)
    {:fmi, "3.14.a", << 0xAC, 0x47, 0x12, 0xAC, 0x47, 0x12, 0xAB, 0x23, 0x33, 0xBD, 0xEF, 0x44 >>}

  In that example example the payload is:
  << 0xAC, 0x47, 0x12, 0xAC, 0x47, 0x12, 0xAB, 0x23, 0x33, 0xBD, 0xEF, 0x44 >>
  and the version is: "3.14.a"
  """
  @spec fmi_image_decoder(binary()) :: {:fmi, version, payload} | :not_fmi
        when version: String.t(), payload: binary()
  def fmi_image_decoder(<<
        0x66,
        0x66,
        0x66,
        size1::size(32),
        payload1::binary-size(size1),
        0x66,
        size2::size(24),
        payload2::binary-size(size2),
        0x66,
        size3::size(24),
        payload3::binary-size(size3),
        0x66,
        v1::float,
        v2::size(7)
      >>) do
    payload = payload1 <> payload2 <> payload3
    version = :erlang.float_to_binary(v1, decimals: 2) <> "." <> <<v2>>

    {:fmi, version, payload}
  end

  def fmi_image_decoder(_), do: :not_fmi

  @doc ~s"""
  Return the position (or nil) of the element in the tuple. In case
  of duplicate values, return the position of *any* of the values.

  ## Examples

    iex> HW2.binary_search({1,2,3}, 1)
    0
    iex> HW2.binary_search({1,2,3}, 3)
    2
    iex> HW2.binary_search({1,2,3}, 15)
    nil
  """
  @spec binary_search(values :: Tuple.t(number()), key :: any()) :: non_neg_integer() | nil
  def binary_search(values, key) do
    do_binary_search(values, key, 0, tuple_size(values))
  end

  @doc ~s"""
  Find the permutation of vectors a and b where the scalar product is maximal.
  Return that scalar product as a float.

  ## Examples

    iex> HW2.max_scalar_product([1.0, 3.0], [3.0, 1.0])
    10.0
  """
  @spec max_scalar_product(list(number()), list(number)) :: float()
  def max_scalar_product(a, b) do
    [sort(a), sort(b)]
    |> zip()
    |> map(fn {a, b} -> a * b end)
    |> sum_kahan()
  end

  # Private functions

  defp reject([], _fun), do: []
  defp reject([h | t], fun), do: if(fun.(h), do: reject(t, fun), else: [h | reject(t, fun)])

  defp zip([[], []]), do: []
  defp zip([[h1 | t1], [h2 | t2]]), do: [{h1, h2} | zip([t1, t2])]
  defp zip(_), do: raise(ArgumentError, message: "Lists must be of equal length")

  defp do_min([], min), do: min
  defp do_min([elem | rest], min), do: do_min(rest, Kernel.min(min, elem))

  defp do_max([], max), do: max
  defp do_max([elem | rest], max), do: do_max(rest, Kernel.max(max, elem))

  defp do_find_index([], _value, _pos), do: nil
  defp do_find_index([value | _rest], value, pos), do: pos
  defp do_find_index([_ | rest], value, pos), do: do_find_index(rest, value, pos + 1)

  defp list_uniq(list) when is_list(list) do
    # Use foldr or foldl/reduce + reverse to preserve the order.
    # Use a MapSet for uniqueness check as `in list` is O(n), so the whole
    # function will be O(n^2) in that case. `in mapset` is O(log n), so
    # the whole function is O(n*log n). For 10000 elements, O(n^2) is ~50 million
    # and O(n*log n) is ~40 thousand, so the latter is 250 times faster.
    {list, _} =
      list
      |> foldr({[], MapSet.new()}, fn elem, {acc_list, acc_mapset} ->
        case elem in acc_mapset do
          true -> {acc_list, acc_mapset}
          false -> {[elem | acc_list], MapSet.put(acc_mapset, elem)}
        end
      end)

    list
  end

  defp do_binary_search(_values, _key, left, right) when left == right, do: nil

  defp do_binary_search(values, key, left, right) do
    mid = div(right + left, 2)

    case elem(values, mid) do
      ^key -> mid
      value when key > value -> do_binary_search(values, key, mid + 1, right)
      value when key < value -> do_binary_search(values, key, left, mid)
    end
  end

  defp do_permutations([]), do: [[]]

  defp do_permutations(list) do
    # This line help avoid repeating the same work, producing the same
    # permutations that will later be rejected. Without it
    # permutations("1111111111") will do a ton of work and still
    # yield a list with 1 element. Without this, having just 10 equal graphemes, the
    # do_permutations function will be called over 60 *million* times.
    # The complexity is (probably) (O(n*(n!))) (that's n times factorial) with a
    # constant of ~2 (Bonus points to whomever can proove the complexity)
    uniq = list_uniq(list)

    for h <- uniq, t <- do_permutations(list -- [h]) do
      [h | t]
    end
  end

  defp partition(list, pivot) do
    list
    |> foldl({_smaller = [], _equal = [], _larger = []}, fn
      elem, {s, e, l} when elem < pivot -> {[elem | s], e, l}
      elem, {s, e, l} when elem > pivot -> {s, e, [elem | l]}
      elem, {s, e, l} when elem == pivot -> {s, [elem | e], l}
    end)
  end

  defp do_sum_prev(result, _, 0), do: result
  defp do_sum_prev(a, b, limit), do: do_sum_prev(b, a + b, limit - 1)
end
