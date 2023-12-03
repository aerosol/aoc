defmodule AdventOfCode.Day03Test do
  use ExUnit.Case

  import AdventOfCode.Day03

  describe "parse" do
    test "parse schematic" do
      input = """
      3..
      .$.
      127
      """

      assert [
               {:number, {1, 1}, [{1, 1}], 3},
               {:symbol, {2, 2}, [{2, 2}], '$'},
               {:number, {3, 1}, [{3, 3}, {3, 2}, {3, 1}], 127}
             ] = parse_schematic!(input)
    end

    test "matrix" do
      assert %{
               {1, 1} => [number: 3, id: {1, 0}],
               {2, 2} => [symbol: '$', id: {2, 0}],
               {3, 3} => [number: 127, id: {3, 0}],
               {3, 2} => [number: 127, id: {3, 0}],
               {3, 1} => [number: 127, id: {3, 0}]
             } =
               matrix([
                 {:number, {1, 0}, [{1, 1}], 3},
                 {:symbol, {2, 0}, [{2, 2}], '$'},
                 {:number, {3, 0}, [{3, 3}, {3, 2}, {3, 1}], 127}
               ])
    end

    test "symbol_adjacent?" do
      input = """
      3..
      .$.
      127
      1..
      """

      schematic = parse_schematic!(input)
      matrix = matrix(schematic)

      assert symbol_adjacent?([{1, 1}], matrix)
      assert symbol_adjacent?([{3, 1}], matrix)
      assert symbol_adjacent?([{3, 2}], matrix)
      assert symbol_adjacent?([{3, 3}], matrix)
      refute symbol_adjacent?([{4, 1}], matrix)
    end

    test "main unit" do
      input = """
      467..114..
      ...*......
      ..35..633.
      ......#...
      617*......
      .....+.58.
      ..592.....
      ......755.
      ...$.*....
      .664.598..
      """

      result = part1(input)

      assert result == 4361
    end
  end

  describe "part2" do
    test "main unit" do
      input = """
      467..114..
      ...*......
      ..35..633.
      ......#...
      617*......
      .....+.58.
      ..592.....
      ......755.
      ...$.*....
      .664.598..
      """

      result = part2(input)

      assert result == 467_835
    end
  end
end
