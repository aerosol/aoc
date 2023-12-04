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

    defparsec(:card, card)
    defparsec(:cards, repeat(card))
  end

  def parse(input, parsec \\ :cards) do
    {:ok, result, "", %{}, _, _} = apply(Parser, parsec, [input])
    result
  end

  def card_points(card) do
    your_numbers = card[:your_numbers]
    winning_numbers = card[:winning_numbers]

    Enum.reduce(your_numbers, {0, 0}, fn number, {matches, score} ->
      if Enum.member?(winning_numbers, number) do
        matches = matches + 1
        score = if score == 0, do: 1, else: score
        multiplier = if matches > 1, do: 2, else: 1
        {matches, score * multiplier}
      else
        {matches, score}
      end
    end)
  end

  def part1(input) do
    input
    |> parse()
    |> Enum.reduce(0, fn card, total ->
      {_matches, score} = card_points(card)
      total + score
    end)
  end

  def part2(_args) do
  end
end
