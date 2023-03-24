defmodule HW2 do
  @type element :: any

  @doc ~s"""
  Return the min value from the provided list if the list is not empty.
  If the list is empty raise a custom HW2.EmptyError exception.

  ## Examples

    iex> HW2.min([1,2,3,4])
    1
    iex> HW2.min([5, -5])
    -5
  """
  @spec min([element]) :: element | no_return
  def min() do
  end

  @doc ~s"""
  Return the max value from the provided list if the list is not empty.
  If the list is empty raise a custom HW2.EmptyError exception.

  ## Examples

    iex> HW2.max([1,2,3,4])
    4
    iex> HW2.foldl([5, -5])
    5
  """
  @spec max([element]) :: element | no_return
  def max(list) do
  end

  @doc ~s"""
  Finds the min and max elements in a list **in a single pass**.
  If the list is empty raise a custom HW2.EmptyError exception.

  ## Examples

    iex> HW2.min_max([1,2,3,4])
    {1,4}
    iex> HW2.foldl([5, -5])
    {-5, 5}
  """
  @spec max([element]) :: {element, element} | no_return
  def min_max(list) do
  end

  @doc ~s"""
  Return a list, sorted in ascending order.

  ## Examples

    iex> HW2.sort([1,2,3,4])
    [1,2,3,4]
    iex> HW2.HW2.sort([4,2,1,3])
    [1,2,3,4]
  """
  @spec sort(list(element)) :: list(element)
  def sort(list) do
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
  def find_index(list, value) do
  end

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
  def foldl(list, acc, fun) do
  end

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
  def reduce(list, acc, fun) do
  end

  @doc ~s"""
  Returns a list where each element is the result of applying fun to
  the corresponding element in the input list.

  ## Examples
    iex> HW2.map([1,2,3], &(&1 * 2))
    [2,4,6]

    iex> HW2.map([1,2,3], fn _ -> 1 end)
    [1,1,1]
  """
  @spec map(list(any), (any -> any)) :: list(any)
  def map(list, fun) do
  end

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
  def foldr(list, acc, fun) do
  end

  @doc ~s"""
  Return the n-th fibonacchi number.
  The first (n=0) fibbonachi number is 0, the second (n=1) is 1.
  The n-th fibonacchi number is the sum of the previous two.

  ## Examples
    iex> HW2.fibbonachi(1000) |> rem(100_000)
    28875
  """
  @spec fibbonachi(non_negative_integer) :: non_negative_integer | {:error, :neg_value}
  def fibbonachi(n) do
  end

  @doc ~s"""
  Return the n-th lucas number.
  The first lucas number is 2, the second is 1.
  The n-th lucas number is the sum of the previous two.


  ## Examples
    iex> HW2.lucas(20) |> rem(100_000)
    78127
  """
  @spec lucas(non_negative_integer) :: non_negative_integer | {:error, :neg_value}
  def lucas(n) do
  end

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
  end

  @doc ~s"""
  Return the media format that a given binary represents.

  The follwing formats are supported:

  JPG: The binary file starts with bytes 0xFF, 0xD8, 0xFF
  PNG: The binary file starts with bytes 0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A
  GIF: The binary file starts with bytes 0x47, 0x49, 0x46
  BMP: The binary file starts with bytes 0x42, 0x4D
  """
  @spec extension_extractor(binary()) ::
          :jpg | :png | :gif | :bmp | :unknown
  def extension_extractor(binary) do
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
      0x66, 0x66,0x66 #  star of image
      3::size(32), # 3 bytes of payload
      0xAC, 0x47, 0x12, # the first part of payload
      0x66, 0x00, 0x00, 0x06, # 4 bytes of metadata, 1 byte 0x66, 3 bytes of payload size
      0xAC, 0x47, 0x12, 0xAB, 0x23, 0x33, # the second part of payload
      0x66, 0x00, 0x00, 0x03, # 4 bytes of metadata, 1 byte 0x66, 3 bytes of payload size
      0xBD, 0xEF, 0x44, # the third part of paylod
      0x66, # 1 byte
      3.14::float,
      ?a::size(7)
    >>)
    {:fmi, "3.14.a", << 0xAC, 0x47, 0x12, 0xAC, 0x47, 0x12, 0xAB, 0x23, 0x33, 0xBD, 0xEF, 0x44 >>}

  In that example example the payload is:
  << 0xAC, 0x47, 0x12, 0xAC, 0x47, 0x12, 0xAB, 0x23, 0x33, 0xBD, 0xEF, 0x44 >>
  and the version is: "3.14.a"
  """
  @spec fmi_image_decoder(binary()) :: {:fmi, version, payload} | :not_fmi
        when version: String.t(), payload: binary()
  def fmi_image_decoder(binary) do
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
    ["11"]

    iex> HW2.permutations("")
    [""]
  """
  @spec permutations(String.t()) :: list(String.t())
  def permutations(binary) do
  end

  @doc ~s"""
  Checks if two strings are anagrams of each other.

  An anagram is a word or phrase formed by rearranging the letters of
  a different word or phrase. A word is not an anagram of itself.
  Casing is not important. Example: Bar is an anagram of rab,
  but is not anagram of bar (same word). Spaces are not important.

  ## Examples

    iex> HW2.anagrams?("car", "rac")
    true
  """
  @spec anagrams?(String.t(), String.t()) :: boolean()
  def anagrams?(str1, str2) do
  end

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
  @spec binary_search(numbers) :: non_neg_integer() | nil when numbers: Tuple.t(number())
  def binary_search(numbers) when is_tuple(numbers) do
  end

  @doc ~s"""
  Find the permutation of vectors a and b where the scalar product is maximal.
  Return that scalar product as a float.

  ## Examples

    iex> HW2.max_scalar_product([1.0, 3.0], [3.0, 1.0])
    10.0
  """
  @spec max_scalar_product(vector, vector) :: float() when vector: [number()]
  def max_scalar_product(a, b) do
  end
end
