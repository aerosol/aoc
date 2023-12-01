defmodule AdventOfCode.Day01 do
  def part1(input) do
    sum(input, &find_ints/1)
  end

  def part2(input) do
    sum(input, &find_ints2/1)
  end

  defp sum(input, finder) do
    input
    |> String.split("\n")
    |> Enum.reduce(0, fn
      x, acc when byte_size(x) > 0 ->
        l = finder.(x)
        acc + Integer.undigits(l)

      _, acc ->
        acc
    end)
  end

  defp find_ints(s) do
    l = for <<x <- s>>, x in ?0..?9, do: x - 48

    [List.first(l), List.last(l)]
  end

  @numerals ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
  @indexed Enum.with_index(@numerals, 1) |> Enum.into(%{})

  @clauses @numerals
           |> Enum.map(fn numeral ->
             {numeral,
              Enum.filter(
                @numerals,
                &(&1 != numeral and String.starts_with?(&1, String.last(numeral)))
              )}
           end)

  defp find_ints2(<<>>, acc), do: [List.last(acc), List.first(acc)]

  defp find_ints2(<<x, rest::binary>>, acc) when x in ?0..?9 do
    find_ints2(rest, [x - 48 | acc])
  end

  for {word, adjacent_words} <- @clauses do
    for <<_, suffix::binary>> = adjacent <- adjacent_words do
      defp find_ints2(<<unquote(word <> suffix), rest::binary>>, acc) do
        find_ints2(rest, [
          unquote(@indexed[adjacent]),
          unquote(@indexed[word]) | acc
        ])
      end
    end

    defp find_ints2(<<unquote(word), rest::binary>>, acc) do
      find_ints2(rest, [unquote(@indexed[word]) | acc])
    end
  end

  defp find_ints2(<<_x, rest::binary>>, acc), do: find_ints2(rest, acc)
  defp find_ints2(x), do: find_ints2(x, [])
end
