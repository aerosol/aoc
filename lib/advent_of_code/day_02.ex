defmodule AdventOfCode.Day02 do
  defmodule Parser do
    import NimbleParsec

    game_id =
      string("Game ")
      |> ignore()
      |> integer(min: 1, max: 3)
      |> ignore(string(": "))

    cube_set =
      times(
        integer(min: 1, max: 3)
        |> ignore(ascii_char([?\s]))
        |> choice([string("red"), string("green"), string("blue")])
        |> ignore(optional(ascii_char([?,])))
        |> ignore(optional(ascii_char([?\s]))),
        min: 1,
        max: 3
      )
      |> reduce(:cube_set_reducer)
      |> ignore(optional(string("; ")))

    cube_sets = repeat(cube_set)

    game =
      game_id
      |> wrap(cube_sets)
      |> ignore(optional(ascii_char([?\n])))
      |> wrap()

    games = repeat(game)

    defparsec(:game_id, game_id)
    defparsec(:cube_set, cube_set)
    defparsec(:cube_sets, cube_sets)
    defparsec(:game, game)
    defparsec(:games, games)

    def cube_set_reducer(x) do
      for [k, v] <- Enum.chunk_every(x, 2), do: {v, k}, into: %{}
    end
  end

  def parse!(input, parsec \\ :games) do
    {:ok, result, "", %{}, _, _} = apply(Parser, parsec, [input])
    result
  end

  def part1(input, bag \\ %{}) do
    input
    |> parse!()
    |> Enum.filter(&game_possible?(&1, bag))
    |> Enum.map(fn [game_id, _] -> game_id end)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> parse!()
    |> Enum.map(&minimal_bag/1)
    |> Enum.map(&power/1)
    |> Enum.sum()
  end

  def power(minimal_bag) do
    minimal_bag
    |> Map.values()
    |> Enum.reduce(1, &(&1 * &2))
  end

  def minimal_bag([_game_id, cube_sets]) do
    Enum.reduce(cube_sets, %{"red" => 0, "green" => 0, "blue" => 0}, fn cube_set, acc ->
      Enum.map(acc, fn {k, v} ->
        case cube_set[k] do
          new when is_integer(new) and new > v -> {k, new}
          _ -> {k, v}
        end
      end)
      |> Enum.into(%{})
    end)
  end

  def game_possible?([_game_id, cube_sets], bag) do
    any_exceeding? =
      Enum.find(cube_sets, fn cube_set ->
        Enum.any?(cube_set, fn {k, v} -> is_nil(bag[k]) or bag[k] < v end)
      end)

    !any_exceeding?
  end
end
