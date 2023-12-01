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

  def part2(_args) do
  end
end
