defmodule AdventOfCode.Day01 do
  def part1(input) do
    input
    |> String.split("\n")
    |> Enum.reduce(0, fn
      x, acc when byte_size(x) > 0 ->
        l = find_ints(x)
        acc + Integer.undigits([List.first(l), List.last(l)])

      _, acc ->
        acc
    end)
  end

  defp find_ints(s) do
    for <<x <- s>>, x in ?0..?9, do: x - 48
  end

  @number_words ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
  def(part2(input)) do
    input
    |> String.split("\n")
    |> Enum.reduce(0, fn
      x, acc when byte_size(x) > 0 ->
        l = find_ints2(x)

        acc + Integer.undigits(l)

      _, acc ->
        acc
    end)
  end

  def find_ints2(<<>>, acc) do
    [List.last(acc), List.first(acc)]
  end

  def find_ints2(<<x, rest::binary>>, acc) when x in ?0..?9 do
    find_ints2(rest, [x - 48 | acc])
  end

  for {clause, int} <-
        Enum.with_index(
          @number_words,
          1
        ) do
    def find_ints2(<<unquote(clause), rest::binary>>, acc),
      do: find_ints2(rest, [unquote(int) | acc])
  end

  def find_ints2(<<_x, rest::binary>>, acc) do
    find_ints2(rest, acc)
  end

  def find_ints2(x) do
    find_ints2(x, [])
  end
end
