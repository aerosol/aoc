defmodule Mix.Tasks.D02.P1 do
  use Mix.Task

  import AdventOfCode.Day02

  @shortdoc "Day 02 Part 1"
  def run(args) do
    input = AdventOfCode.Input.get!(2)

    bag = %{"red" => 12, "green" => 13, "blue" => 14}

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1() end}, profile_after: true),
      else:
        input
        |> part1(bag)
        |> IO.inspect(label: "Part 1 Results")
  end
end
