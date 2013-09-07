defmodule ExCoveralls.Local do
  @moduledoc """
  Locally displays the result to screen.
  """
  import ExPrintf

  def execute(stats) do
    IO.puts "----------------"
    IO.puts sprintf("%-6s %-40s %8s %8s %8s", ["COV", "FILE", "LINES", "RELEVANT", "COVERED"])
    format(stats) |> IO.puts
    IO.puts "----------------"
  end

  def format(stats) do
    Enum.map(stats, fn(stat) -> format_stat(stat) end)
      |> Enum.join("\n")
  end

  def format_stat(stat) do
    counts = calculate_count(stat[:coverage])
    coverage = (counts[:covered] / counts[:relevant]) * 100
    sprintf("%5.1f%% %-40s %8d %8d %8d",
      [coverage, stat[:name], counts[:lines], counts[:relevant], counts[:covered]])
  end

  def calculate_count(counts) do
    do_calculate_count(counts, 0, 0, 0)
  end

  def do_calculate_count([], lines, relevant, covered) do
    [lines: lines, relevant: relevant, covered: covered]
  end

  def do_calculate_count([h|t], lines, relevant, covered) do
    case h do
      nil -> do_calculate_count(t, lines + 1, relevant, covered)
      0   -> do_calculate_count(t, lines + 1, relevant + 1, covered)
      n when is_number(n)
          -> do_calculate_count(t, lines + 1, relevant + 1, covered + 1)
      _   -> raise "invalid data #{h}"
    end
  end
end