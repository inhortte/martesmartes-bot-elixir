defmodule App.Aphorisms.Quotes do
  @quote_regex ~r/"[\w\s,;:'\.\?!\(\)]+"/
  @human_regex ~r/-[\w\s]+[\("]/
  @date_regex ~r/\(([0-9]+\/){0,1}([0-9]+\/){0,1}([0-9]+)\)/

  def is_line_empty?(line), do: String.trim(line) |> (fn(s) -> String.length(s) == 0 end).()

  def eval_line(line, acc) when length(acc) == 0, do: [line]
  def eval_line(line, acc = [q | qs]) do
    if is_line_empty?(line) do
      ["" | acc]
    else
      ["#{line} #{q}" | qs]
    end
  end

  def split_into_quote_blocks(lines) do
    lines |> List.foldr([], &eval_line/2)
  end

  def quotebook_to_quotes() do
    Application.get_env(:app, :quote_file) |> File.read! |> String.split(~r/\n/) |> split_into_quote_blocks
  end
end
