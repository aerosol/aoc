defmodule AdventOfCode.Day01 do
  def part1(input) do
    input
    |> String.split("\n")
    |> Enum.reduce(0, fn
      x, acc when byte_size(x) > 0 ->
        {first, last} =
          case find_ints(x) do
            [single] ->
              {single, single}

            [first | rest] ->
              {first, List.last(rest)}
          end

        acc + String.to_integer(<<first, last>>)

      _, acc ->
        acc
    end)
  end

  defp find_ints(s) do
    for <<x <- s>>, x >= ?0 and x <= ?9 do
      x
    end
  end

  def part2(_args) do
  end
end
