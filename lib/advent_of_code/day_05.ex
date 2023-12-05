defmodule AdventOfCode.Day05 do
  defmodule Parser do
    import NimbleParsec

    seeds =
      string("seeds: ")
      |> ignore()
      |> repeat(
        integer(min: 1)
        |> ignore(optional(ascii_char([?\s])))
      )
      |> ignore(ascii_char([?\n]))
      |> tag(:seeds)

    component =
      choice([
        string("seed"),
        string("soil"),
        string("fertilizer"),
        string("water"),
        string("light"),
        string("temperature"),
        string("humidity"),
        string("location")
      ])

    conversion_header =
      component
      |> unwrap_and_tag(:source)
      |> concat(ignore(string("-to-")))
      |> concat(component |> unwrap_and_tag(:destination))
      |> ignore(string(" map:\n"))

    conversion =
      conversion_header
      |> concat(
        repeat(
          integer(min: 1)
          |> unwrap_and_tag(:dst_range_start)
          |> concat(
            ignore(ascii_char([?\s]))
            |> integer(min: 1)
            |> unwrap_and_tag(:src_range_start)
            |> ignore(ascii_char([?\s]))
            |> concat(
              integer(min: 1)
              |> unwrap_and_tag(:range_len)
            )
            |> ignore(optional(ascii_char([?\n])))
          )
          |> wrap()
        )
        |> tag(:meta)
      )
      |> ignore(optional(ascii_char([?\n])))

    conversions =
      repeat(conversion |> wrap())
      |> tag(:conversions)

    almanac =
      seeds
      |> ignore(ascii_char([?\n]))
      |> concat(conversions)

    defparsec(:seeds, seeds)
    defparsec(:conversion_header, conversion_header)
    defparsec(:conversion, conversion)
    defparsec(:almanac, almanac)
  end

  def parse(input, parsec \\ :almanac) do
    {:ok, result, "", %{}, _, _} = apply(Parser, parsec, [input])
    result
  end

  def find(source, src_c, dst_c, almanac) do
    meta =
      almanac[:conversions]
      |> Enum.find(&(&1[:source] == src_c and &1[:destination] == dst_c))
      |> Keyword.fetch!(:meta)
      |> Enum.find(&(source in &1[:src_range_start]..(&1[:src_range_start] + &1[:range_len] - 1)))

    if meta do
      offset = source - meta[:src_range_start]
      meta[:dst_range_start] + offset
    else
      source
    end
  end

  def find_till_location(seed, almanac) do
    seed
    |> find("seed", "soil", almanac)
    |> find("soil", "fertilizer", almanac)
    |> find("fertilizer", "water", almanac)
    |> find("water", "light", almanac)
    |> find("light", "temperature", almanac)
    |> find("temperature", "humidity", almanac)
    |> find("humidity", "location", almanac)
  end

  def part1(input) do
    almanac = input |> parse()

    almanac
    |> Keyword.fetch!(:seeds)
    |> Enum.reduce(nil, fn seed, lowest ->
      location = find_till_location(seed, almanac)

      if is_nil(lowest) or location < lowest do
        location
      else
        lowest
      end
    end)
  end

  def part2(_args) do
  end
end
