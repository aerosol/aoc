defmodule AdventOfCode.Day03 do
  defmodule Parser do
    import NimbleParsec

    number =
      integer(min: 1, max: 3)
      |> post_traverse({:emit, [:number]})

    dot = ascii_char([?.]) |> ignore()

    symbol =
      ascii_char([{:not, ?.}, {:not, ?\n}])
      |> post_traverse({:emit, [:symbol]})

    schematic =
      repeat(
        repeat(choice([number, dot, symbol]))
        |> ignore(ascii_char([?\n]))
      )

    def emit(rest, [number], context, {line, pos}, offset, :number = type) do
      points =
        for i <- 1..length(Integer.digits(number)) do
          {line, offset - pos - i + 1}
        end

      {rest, [{type, points, number}], context}
    end

    def emit(rest, args, context, {line, pos}, offset, :symbol = type) do
      {rest, [{type, [{line, offset - pos}], args}], context}
    end

    defparsec(:schematic, schematic)
  end

  def parse_schematic!(schematic) do
    {:ok, schematic, "", %{}, _, _} = Parser.schematic(schematic)
    schematic
  end

  def matrix(schematic) do
    Enum.reduce(schematic, %{}, fn
      {:symbol, [point], value}, matrix ->
        Map.put(matrix, point, [{:symbol, value}])

      {:number, points, value}, matrix ->
        Enum.reduce(points, matrix, fn point, matrix ->
          Map.put(matrix, point, [{:number, value}])
        end)
    end)
  end

  def symbol_adjacent?(points, matrix) do
    Enum.any?(points, fn {x, y} ->
      [
        {x - 1, y},
        {x, y - 1},
        {x - 1, y - 1},
        {x + 1, y},
        {x, y + 1},
        {x + 1, y + 1},
        {x + 1, y - 1},
        {x - 1, y + 1}
      ]
      |> Enum.reduce_while(false, fn point, _acc ->
        case matrix[point] do
          [symbol: _symbol] -> {:halt, true}
          _ -> {:cont, false}
        end
      end)
    end)
  end

  def part1(input) do
    schematic = parse_schematic!(input)
    matrix = matrix(schematic)

    Enum.reduce(schematic, 0, fn
      {:number, points, value}, acc ->
        if symbol_adjacent?(points, matrix), do: acc + value, else: acc

      _, acc ->
        acc
    end)
  end

  def part2(_args) do
  end
end
