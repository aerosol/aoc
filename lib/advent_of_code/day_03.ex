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
      choice([number, dot, symbol])
      |> repeat()
      |> ignore(ascii_char([?\n]))
      |> repeat()

    def emit(rest, [number], context, {line, pos}, offset, :number = type) do
      int_len = length(Integer.digits(number))
      id = {line, offset - pos - int_len + 1}

      points =
        for i <- 1..int_len do
          {line, offset - pos - i + 1}
        end

      {rest, [{type, id, points, number}], context}
    end

    def emit(rest, args, context, {line, pos}, offset, :symbol = type) do
      id = {line, offset - pos}
      {rest, [{type, id, [{line, offset - pos}], args}], context}
    end

    defparsec(:schematic, schematic)
  end

  def parse_schematic!(schematic) do
    {:ok, schematic, "", %{}, _, _} = Parser.schematic(schematic)
    schematic
  end

  def matrix(schematic) do
    Enum.reduce(schematic, %{}, fn
      {:symbol, id, [point], value}, matrix ->
        Map.put(matrix, point, [{:symbol, value}, {:id, id}])

      {:number, id, points, value}, matrix ->
        Enum.reduce(points, matrix, fn point, matrix ->
          Map.put(matrix, point, [{:number, value}, {:id, id}])
        end)
    end)
  end

  def symbol_adjacent?(points, matrix) do
    Enum.any?(points, &(adjacent_values(&1, matrix, target: :symbol) != []))
  end

  defp adjacent_values({x, y}, matrix, opts) do
    target = Keyword.fetch!(opts, :target)

    candidates =
      for x2 <- (x - 1)..(x + 1),
          y2 <- (y - 1)..(y + 1),
          x2 != x or y2 != y,
          do: {x2, y2}

    candidates
    |> Enum.reduce(%{}, fn point, found ->
      case matrix[point] do
        [{^target, value}, {:id, id}] ->
          Map.put(found, id, value)

        _ ->
          found
      end
    end)
    |> Map.values()
  end

  def part1(input) do
    schematic = parse_schematic!(input)
    matrix = matrix(schematic)

    Enum.reduce(schematic, 0, fn
      {:number, _id, points, value}, acc ->
        if symbol_adjacent?(points, matrix), do: acc + value, else: acc

      _, acc ->
        acc
    end)
  end

  def part2(input) do
    schematic = parse_schematic!(input)
    matrix = matrix(schematic)

    Enum.reduce(schematic, 0, fn
      {:symbol, _id, [point], '*'}, acc ->
        case adjacent_values(point, matrix, target: :number) do
          [part1, part2] -> acc + part1 * part2
          _ -> acc
        end

      _, acc ->
        acc
    end)
  end
end
