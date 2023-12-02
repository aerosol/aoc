defmodule AdventOfCode.Day02Test do
  use ExUnit.Case

  import AdventOfCode.Day02

  test "part1 - parse game id" do
    assert [129] = parse!("Game 129: ", :game_id)
    assert [1] = parse!("Game 1: ", :game_id)
  end

  test "part1 - parse cube set" do
    assert [%{"green" => 16, "red" => 14, "blue" => 1}] =
             parse!("16 green, 14 red, 1 blue", :cube_set)

    assert [%{"green" => 16, "red" => 14}] = parse!("16 green, 14 red", :cube_set)
  end

  test "part2 - parse cube sets" do
    assert [
             %{"green" => 16, "red" => 14, "blue" => 1},
             %{"green" => 16, "red" => 4}
           ] = parse!("16 green, 14 red, 1 blue; 16 green, 4 red", :cube_sets)
  end

  test "part1 - parse whole game" do
    assert [
             [
               1,
               [
                 %{"blue" => 3, "red" => 4},
                 %{"blue" => 6, "green" => 2, "red" => 1},
                 %{"green" => 2}
               ]
             ]
           ] = parse!("Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green\n", :game)

    assert [
             [
               1,
               [
                 %{"blue" => 3, "red" => 4},
                 %{"blue" => 6, "green" => 2, "red" => 1},
                 %{"green" => 2}
               ]
             ],
             [
               2,
               [
                 %{"blue" => 3, "red" => 4},
                 %{"blue" => 6, "green" => 2, "red" => 1},
                 %{"green" => 2}
               ]
             ]
           ] =
             parse!(
               """
               Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
               Game 2: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
               """,
               :games
             )
  end

  test "part1 - game possible?" do
    game = [1, [%{"blue" => 10, "red" => 4}, %{"blue" => 6, "green" => 2, "red" => 1}]]

    bag1 = %{"blue" => 10, "red" => 4, "green" => 2}
    bag2 = %{"blue" => 20, "red" => 8, "green" => 4}

    assert game_possible?(game, bag1)
    assert game_possible?(game, bag2)

    bag3 = %{"blue" => 9, "red" => 4, "green" => 2}
    bag4 = %{"blue" => 10, "red" => 3, "green" => 2}
    bag5 = %{"blue" => 10, "red" => 4, "green" => 1}

    refute game_possible?(game, bag3)
    refute game_possible?(game, bag4)
    refute game_possible?(game, bag5)
  end

  test "part1" do
    input = """
    Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
    Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
    Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
    Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    """

    bag = %{"red" => 12, "green" => 13, "blue" => 14}
    result = part1(input, bag)
    assert result == 8
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
