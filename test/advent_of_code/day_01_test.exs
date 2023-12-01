defmodule AdventOfCode.Day01Test do
  use ExUnit.Case

  import AdventOfCode.Day01

  test "part1" do
    input = """
    1abc2
    pqr3stu8vwx
    a1b2c3d4e5f
    treb7uchet
    """

    result = part1(input)

    assert result == 142
  end

  test "part2" do
    input = """

    two1nine
    eightwothree

    abcone2threexyz
    xtwone3four
    4nineeightseven2
    zoneight234
    7pqrstsixteen

    """

    result = part2(input)

    assert result == 281

    input = """
    1abc2
    pqr3stu8vwx
    a1b2c3d4e5f
    treb7uchet
    """

    assert part2(input) == 142

    assert part2("one1") == 11
    assert part2("1one") == 11
    assert part2("two1") == 21
    assert part2("1two") == 12
    assert part2("1two") == 12

    assert part2("oneight") == 18
  end
end
