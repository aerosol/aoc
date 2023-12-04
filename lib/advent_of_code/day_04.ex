defmodule AdventOfCode.Day04 do
  defmodule Parser do
    import NimbleParsec

    card_number =
      string("Card")
      |> ignore()
      |> ignore(repeat(ascii_char([?\s])))
      |> integer(min: 1, max: 3)
      |> ignore(string(":"))
      |> ignore(times(ascii_char([?\s]), min: 1, max: 3))
      |> unwrap_and_tag(:card_number)

    number =
      ignore(optional(repeat(ascii_char([?\s]))))
      |> integer(min: 1, max: 2)
      |> ignore(optional(repeat(ascii_char([?\s]))))

    winning_numbers =
      repeat(
        lookahead_not(ascii_char([?|]))
        |> concat(number)
      )
      |> tag(:winning_numbers)
      |> ignore(string("| "))

    your_numbers =
      repeat(number)
      |> tag(:your_numbers)

    card =
      card_number
      |> concat(winning_numbers)
      |> concat(your_numbers)
      |> ignore(optional(ascii_char([?\n])))
      |> wrap()

    defparsec(:cards, repeat(card))
  end

  def parse(input, parsec \\ :cards) do
    {:ok, result, "", %{}, _, _} = apply(Parser, parsec, [input])
    result
  end

  def card_points(card) do
    your_numbers = card[:your_numbers]
    winning_numbers = card[:winning_numbers]

    your_numbers
    |> Enum.reduce({0, 0}, fn number, {matches, score} ->
      if Enum.member?(winning_numbers, number) do
        matches = matches + 1
        score = if score == 0, do: 1, else: score
        multiplier = if matches > 1, do: 2, else: 1
        {matches, score * multiplier}
      else
        {matches, score}
      end
    end)
    |> elem(1)
  end

  def wins(card) do
    your = MapSet.new(card[:your_numbers])

    card
    |> Keyword.fetch!(:winning_numbers)
    |> MapSet.new()
    |> MapSet.intersection(your)
    |> Enum.count()
  end

  def part1(input) do
    input
    |> parse()
    |> Enum.reduce(0, fn card, total ->
      card_points(card) + total
    end)
  end

  def part2(input) do
    cards = input |> parse()

    cards
    |> Enum.map(&{1, wins(&1)})
    |> collect()
    |> Enum.sum()
  end

  defp collect([]), do: []

  defp collect([{copies, wins} | rest]) do
    acc =
      copies
      |> copy(wins, rest)
      |> collect()

    [copies | acc]
  end

  defp copy(_, 0, cards), do: cards
  defp copy(_, _, []), do: []

  defp copy(new, n, [{copies, wins} | rest]) do
    [{copies + new, wins} | copy(new, n - 1, rest)]
  end
end
