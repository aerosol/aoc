defmodule AdventOfCode.Day04Test do
  use ExUnit.Case

  import AdventOfCode.Day04

  test "parse" do
    assert [
             [
               card_number: 1,
               winning_numbers: [75, 68, 35, 36, 86, 83, 30, 11, 14, 59],
               your_numbers: [
                 86,
                 25,
                 63,
                 57,
                 59,
                 91,
                 68,
                 14,
                 72,
                 32,
                 36,
                 74,
                 66,
                 44,
                 30,
                 28,
                 11,
                 35,
                 75,
                 34,
                 55,
                 83,
                 69,
                 56,
                 38
               ]
             ]
           ] =
             parse("""
             Card   1: 75 68 35 36 86 83 30 11 14 59 | 86 25 63 57 59 91 68 14 72 32 36 74 66 44 30 28 11 35 75 34 55 83 69 56 38
             """)
  end

  test "card points" do
    assert """
           Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
           """
           |> parse()
           |> List.first()
           |> card_points() == 8

    assert """
           Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
           """
           |> parse()
           |> List.first()
           |> card_points() == 2

    assert """
           Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
           """
           |> parse()
           |> List.first()
           |> card_points() == 2

    assert """
           Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
           """
           |> parse()
           |> List.first()
           |> card_points() == 1

    assert """
           Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
           """
           |> parse()
           |> List.first()
           |> card_points() == 0
  end

  test "part1" do
    input = """
    Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
    Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
    Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
    Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
    Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
    Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
    """

    result = part1(input)

    assert result == 13
  end

  test "part2" do
    input = """
    Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
    Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
    Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
    Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
    Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
    Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
    """

    assert input |> part2() == 30
  end
end
